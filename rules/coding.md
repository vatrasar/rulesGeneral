---
trigger: always_on

---

# Code Rules

## Technologies used in project

The application is to be written in C# using the following frameworks:

{

1. AvaloniaUi

2. ReactiveUI

3. xUnit

}

It is meant to use routing from ReactiveUI and a feature-oriented folder architecture.

## Coding rules

1. You are a highly skilled software engineer who prioritizes clean code.

2. You pay particular attention to keeping functions short. Your primary goal is to write flat code. Instead of building deeply nested structures so if you find that logic cannot be simplified without nesting try extract the inner block into a separate, dedicated function/method.

3. Names should be self-explanatory and communicate intent. Prioritize clarity over brevity, but avoid redundancy and noise words. A name should be as short as possible, but not shorter than what is required to understand its purpose at a glance. For example, numberOfRemainingFreeHours is far superior to h. It is better to have a descriptive, long name than an ambiguous one that fails to communicate intent.

4. Services should remain lean. If a service is unlikely to maintain high cohesion, prefer Use Cases over generic Services

5. Language Requirements
   All naming conventions (variables, functions, classes) and comments within the code must be in English.

6. **Prefer Enums over Constants/Strings:** Whenever a variable can hold a limited set of predefined values (e.g., ShiftType, EmployeeRole, DayOfWeek), **always** use a strongly-typed `enum`. Do not use `string` or `int` constants for these purposes.

7. There must be two blank lines separating the last property (or backing field) from the constructor or the first method. This creates a clear visual boundary between the class state and its behavior.

8. Avoid Legacy Patterns. Never suggest deprecated patterns or "old-school" boilerplate if a modern, cleaner alternative exists (e.g., use `ReactiveUI.Fody` instead of manual `RaiseAndSetIfChanged`).

9. Use suffix DTO only for models which are used for network communication

10. Models shouldn't use suffix "model". Better to name model Malpa than MalpaModel

11. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

## Documentation & Commenting Standards

**1. NO INLINE COMMENTS**

- Adding comments within a function or method body is STRICTLY FORBIDDEN. 
- Logic should be so clear and names so expressive that internal comments are redundant. 
- Code MUST be self-documenting through expressive naming and clear structure.
- You still can use XML Documentation comments (///) on top of fucntion/method, but even then, prioritize making the code self-documenting through better naming and structure.

**2. ALWAYS KEEP DOCS IN SYNC**

- CRITICAL: Whenever you modify a component, screen, service (logic, UI, navigation, or usages) or usecase, you MUST update its corresponding header/XML documentation.

**3. UI DOCUMENTATION (Screens & Components)**

- Every Screen and Component MUST have a descriptive header comment at the top of its `.axaml.cs` file.
- **Components** (Default location: `ScreenComponents`, unless explicitly instructed to use `FeatureComponents` or `GlobalComponents`):
  - Include: Purpose, Usage (Inputs/Outputs/Bindings), Key UI elements, and `Used In` (list of screens/components referencing it).
- **Screens**:
  - Include: Purpose, Available Functionalities, Key UI elements, and Navigation (`Navigate From` and `Navigate To` paths).

**4. SERVICES & REPOSITORIES & UseCases**

- All public methods of services and repositories need to have documentation comment
- Use XML Documentation (`///`) ONLY for `public` methods. Do NOT add XML docs to `private` methods.
- All UseCases also need to have documentation comment on top of its class
- Include: The purpose of the method and a list of classes/components that invoke it.

## Threads and Asynchrony

### Task Cancellation

Always use the `CancellationToken` pattern for canceling asynchronous operations or long-running tasks.
Avoid useing boolean flags or direct `Task` disposal to stop asynchronous operations. Pass a `CancellationToken` to methods that support it.

## Binding strategy

* **Strict Prohibition**: Do not use `{Binding ...}` syntax in XAML (`.axaml`) files for dynamic data. - 

* **Code-Behind Bindings**: All data bindings, command bindings, and event-to-command mappings must be implemented in the View's Code-Behind (`.axaml.cs`) using ReactiveUI's type-safe binding methods. -

* **Required Pattern**: Use `this.Bind()`, `this.OneWayBind()`, and `this.BindCommand()` inside a `this.WhenActivated()` block. - 

* **Memory Management**: Every binding must be followed by `.DisposeWith(disposables)` to ensure proper cleanup and prevent memory leaks.

## Anti legacy rules

### reactive UI

- **ReactiveUI Source Generators (Fody/Generation):** Direct implementation of `INotifyPropertyChanged`, manual `RaiseAndSetIfChanged`, or manual `ReactiveCommand` instantiation is strictly forbidden.
  - **Property Declaration:** Use the `[Reactive]` attribute on private fields.
  - **ReadOnly Properties (OAPH):** Use the `[ObservableAsProperty]` attribute.
  - **Commands:** Use the `[ReactiveCommand]` attribute on private methods. This automatically generates a `ReactiveCommand` property with the appropriate name

Correct Pattern:

```csharp
//...
using System.Reactive.Linq;
using ReactiveUI;
using ReactiveUI.SourceGenerators;

//...

public partial class ExampleViewModel : ViewModelBase
{
    [Reactive]
    private string _firstName = string.Empty;

    [ObservableAsProperty]
    private string? _fullName;

    // ✅ The generator creates "public IReactiveCommand SaveCommand"
    [ReactiveCommand]
    private async Task Save()
    {
        // Business logic for McDonald's Roster
        await Task.Delay(100); 
    }

    public ExampleViewModel()
    {
        this.WhenAnyValue(x => x.FirstName)
            .Select(name => $"User: {name}")
            .ToProperty(this, x => x.FullName);
    }
}
```

### ReactiveUI 20.x Binding Lifecycle



- **NO `.DisposeWith()` on Bind/OneWayBind/BindCommand:** In ReactiveUI 20.x, these methods return `IReactiveBinding<T>` which does NOT implement `IDisposable`. Do NOT chain `.DisposeWith(disposables)`. Bindings are automatically cleaned up when the view deactivates via `WhenActivated`.

- **`.DisposeWith()` ONLY for `IDisposable`:** Use `.DisposeWith(disposables)` only on `IDisposable` results (e.g., `Subscribe()` on `IObservable<T>`). Requires `using System.Reactive.Disposables;`.

### Subscribe in View Code-Behind

- **Use `Observer.Create<T>(action)` instead of bare lambda in `.Subscribe()`:** When subscribing to `IObservable<T>` inside a View's `WhenActivated` block, use `Observer.Create<T>(lambda)` instead of passing a bare lambda. The `Subscribe(Action<T>)` extension method may not resolve correctly in View code-behind files.

```csharp
this.WhenAnyValue(x => x.ViewModel!.MyProperty)
    .Subscribe(Observer.Create<bool>(value => MyControl.Classes.Set("my-class", value)))
    .DisposeWith(disposables);
```



### Avalonia Source Generators & InitializeComponent

- **NEVER write a manual `InitializeComponent()` method.** In Avalonia 11.x, source generators automatically create the `InitializeComponent()` method that initializes all `x:Name` fields, wire up event handlers, and load controls. A hand-written `InitializeComponent()` will SHADOW the generated one, causing all `x:Name` fields to remain `null`at runtime. The `.axaml.cs` constructor just calls `InitializeComponent()` — nothing more.

- **NEVER call `AvaloniaXamlLoader.Load(this)` manually.** This is a legacy pattern from older Avalonia versions. It's incompatible with source-generated initialization.

## Databases

If you are going to perform a database migration that could lead to data loss, you MUST explicitly ask me for permission beforehand.

