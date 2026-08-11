---
name: reactiveui-thread-scheduler
description: Diagnoses and fixes "Call from invalid thread" / cross-thread crashes (Call from invalid thread, Call from invalid thread in Avalonia, ReactiveUI invalid thread scheduler, RxApp.MainThreadScheduler DefaultScheduler, exposes OpenTemplates hostHostedScheduler) in ReactiveUI/Avalonia apps where RxApp.MainThreadScheduler is accidentally reset to the thread-pool scheduler instead of the Avalonia UI scheduler.
---

# ReactiveUI Thread Scheduler Diagnostic Skill

## When to use this skill

Use this skill whenever you encounter a **cross-thread / "invalid thread" crash** in a
ReactiveUI + Avalonia (or ReactiveUI + WPF/Maui) application, signalled by signatures such as:

- `System.InvalidOperationException: Call from invalid thread`
- `Avalonia.Threading.Dispatcher.VerifyAccess / ThrowVerifyAccess` failing
- `Button.get_Command()` failing inside `ReactiveCommandBase.OnCanExecuteChanged`
- A stack trace ending on a **thread pool thread** (`System.Threading.Thread.StartHelper`,
  `ThreadPoolWorkQueue`, `ObserveOnObserverLongRunning`, `DefaultScheduler`) while a UI
  control (Button, TextBox, etc.) is being touched.

Essentially: any crash where "UI framework code runs on a non-UI thread" even though your own
code never explicitly starts a background task (`Task.Run`, `Observable.Start`, `async`).

## Why this happens in this project

ReactiveUI schedules UI-observable work (e.g. `CanExecuteChanged` for commands, `IsExecuting`)
onto `RxApp.MainThreadScheduler`. In Avalonia, the correct value is:

```csharp
ReactiveUI.RxApp.MainThreadScheduler = Avalonia.ReactiveUI.AvaloniaScheduler.Instance;
```

**The default value of `RxApp.MainThreadScheduler` is the thread-pool scheduler
(`DefaultScheduler.Instance`).** Anything that triggers ReactiveUI's *platform registrations
call-back* can silently overwrite it back to `DefaultScheduler`:

1. `AppBuilder.UseReactiveUI()` sets `MainThreadScheduler = AvaloniaScheduler` at startup.
2. `AppBootstrapper.Initialize(...)` calls `Splat.Locator.SetLocator(...)`.
3. `Locator.SetLocator` fires ReactiveUI's resolver-change callback (`InitializeReactiveUI`).
4. `PlatformRegistrations.Register` UNCONDITIONALLY sets `RxApp.MainThreadScheduler = DefaultScheduler.Instance`
   (see ReactiveUI source: `ReactiveUI/PlatformRegistrations.cs`).
5. Every `ReactiveCommand` created AFTER this reset gets `outputScheduler = DefaultScheduler`
   (thread pool), so its `CanExecuteChanged`/`IsExecuting` events fire on a background thread.
6. The bound control (e.g. a Button) is then read from that background thread -> `Call from invalid thread`.

The app is typically **synchronous and simple**; the thread pool is unnecessary overhead that
ReactiveUI introduces as a safety default, not a requirement. The fix restores the correct
scheduler after bootstrapping.

## How to use it

### Step 1 - Confirm the root cause (don't guess)

Do NOT patch the ViewModel or sprinkle `.ObserveOn` / `.InvokeOnMainThread` around. First prove
the scheduler is the culprit.

1. Find where the app boots (`App.axaml.cs` -> `OnFrameworkInitializationCompleted`, and
   `AppBootstrapper.Initialize` / `Locator.SetLocator`).
2. Print the effective scheduler at startup (use a file, NOT `Console.WriteLine`, because stdout
   to a redirected file is often line-buffered and lost on non-crash):

```csharp
Splat.Locator.RegisterResolverCallbackChanged(() =>
    System.IO.File.AppendAllText("/tmp/diag.log",
        $"scheduler={ReactiveUI.RxApp.MainThreadScheduler.GetType().Name} " +
        $"mutable={(Splat.Locator.CurrentMutable?.GetType().Name ?? "null")}\n"));
```

Observe the sequence. The buggy signature is:

```
scheduler=AvaloniaScheduler                         // UseReactiveUI set it
scheduler=DefaultScheduler  mutable=CompositeDependencyResolver  // SetLocator reset it  <-- BUG
```

`DefaultScheduler` here means the ReactiveUI command pipeline is running on the thread pool.

### Step 2 - Apply the fix

Wherever `AppBootstrapper.Initialize(_services)` (or any `Locator.SetLocator(...)`) is called,
**immediately afterwards** restore the Avalonia scheduler, BEFORE any ViewModel/View/command is
constructed and bound:

```csharp
_services = DependencyInjection.BuildServiceProvider();
AppBootstrapper.Initialize(_services);
ReactiveUI.RxApp.MainThreadScheduler = Avalonia.ReactiveUI.AvaloniaScheduler.Instance;
desktop.MainWindow = _services.GetRequiredService<MainWindow>();
```

Notes:
- `AvaloniaScheduler` is in namespace `Avalonia.ReactiveUI` (NOT `Avalonia.Threading`).
- Placing the override after `SetLocator` and before constructing the MainWindow guarantees
  every subsequent command is created with the correct scheduler.
- Do NOT comment out or remove `AppBootstrapper.Initialize(...)` — it is required for module/view
  registration. The bug is only the scheduler being clobbered, so override right after it.

### Step 3 - Verify

Run the app and exercise the UI path that previously crashed (e.g. click the button / open the
screen). Confirm there are no `Call from invalid thread` exceptions and the app stays alive.
Remove any temporary diagnostic logging you added in Step 1.

## Decision tree

- Does the stack trace show a UI control accessed from a **thread-pool thread**
  (`DefaultScheduler`, `ThreadPool`, `ObserveOnObserverLongRunning`)?
  → Yes: this skill applies; follow Steps 1-3.
- Does the stack trace show a UI control accessed from a **user task you started yourself**
  (came from `Task.Run`, `async` without await on UI, `Observable.Start`, a service on a thread)?
  → No: the crash is YOUR own background work touching UI. Fix your code, do NOT apply the
    scheduler override to mask it. Move the result back to the UI thread or await properly.
- Is the crash a completely different error (null reference, DB, layout)?
  → No: this skill does not apply.

## Gotchas learned from this codebase

- `AvaloniaScheduler` class: namespace is `Avalonia.ReactiveUI`.
- `System.Console.WriteLine` to a redirected stdout is unreliable for diagnostics (buffered).
  Use `System.IO.File.AppendAllText` to a temp file instead.
- `Splat` (not `Microsoft.Extensions.DependencyInjection`) is the resolver layer ReactiveUI uses
  for schedulers; the custom `CompositeDependencyResolver` is a valid `IMutableDependencyResolver`
  (it implements `IDependencyResolver` which derives from `IMutableDependencyResolver`), so the
  callback DOES fire on `SetLocator`.
- The fix is intentionally a plain imperative override — it does not fight the framework, it
  restores what the framework clobbered at exactly the right moment.