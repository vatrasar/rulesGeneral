---
name: avalonia-headless-testing-pitfalls
description: Diagnoses and prevents common Avalonia Headless test pitfalls including unclosed Window leaks (fonts:SystemFonts KeyNotFoundException), UI dispatcher starvation (calling Dispatcher.UIThread.RunJobs()), and VSTest runner hangs. Use when writing or troubleshooting Avalonia headless unit and integration tests.
---

# Avalonia Headless Testing Pitfalls & Diagnostics

## When to use this skill

Use this skill whenever you are:
- Writing new unit or integration tests that instantiate Avalonia controls (`Window`, `SelectableTextBlock`, `TextEditor`, `ItemsControl`, etc.).
- Encountering test failures with `KeyNotFoundException: The given key 'fonts:SystemFonts' was not present in the dictionary`.
- Investigating tests where assertions fail because UI or reactive properties (e.g., `PreviewBlocks`, text updates) remain empty despite `Task.Delay`.
- Troubleshooting hanging tests or timeouts during `dotnet test`.

---

## Symptoms and Root Causes

### 1. `KeyNotFoundException: The given key 'fonts:SystemFonts'`
- **Symptom:**
  ```text
  System.Collections.Generic.KeyNotFoundException : The given key 'fonts:SystemFonts' was not present in the dictionary.
     at Avalonia.Media.FontManager.get_SystemFonts()
     at AvaloniaEdit.Rendering.TextView.CalculateDefaultTextMetrics()
  ```
- **Root Cause:**
  1. Avalonia Headless by default uses `PerTest` isolation, tearing down and recreating the `Application` and `Dispatcher` between tests. On platforms like Linux/Skia, static font tables in `FontManager` become detached or corrupted after the first test shuts down, leading to `KeyNotFoundException: The given key 'fonts:SystemFonts' was not present in the dictionary`.
  2. Additionally, an earlier test that created a `Window` without closing it in a `finally` block or without setting font family can leave dangling references.
- **Fix:**
  1. Add `[assembly: AvaloniaTestIsolation(AvaloniaTestIsolationLevel.PerAssembly)]` to your test bootstrap (e.g. `TestApp.cs`), referencing `Avalonia.Headless.XUnit`.
  2. Every test that creates or shows a `Window` **MUST** wrap all layout/measurement logic in a `try...finally` block that invokes `window.Close()` and `Dispatcher.UIThread.RunJobs()`.

  ```csharp
  // In TestApp.cs:
  [assembly: AvaloniaTestApplication(typeof(Valeria.Tests.TestApp))]
  [assembly: AvaloniaTestIsolation(AvaloniaTestIsolationLevel.PerAssembly)]
  [assembly: CollectionBehavior(DisableTestParallelization = true)]

  // In tests:
  Window window = new() { Content = control };
  try
  {
      window.Show();
      control.Measure(new Size(800, 600));
      control.Arrange(new Rect(0, 0, 800, 600));
      // Act and Assert
  }
  finally
  {
      window.Close();
      Dispatcher.UIThread.RunJobs();
  }
  ```

---

### 2. State/Preview Empty or Not Updated Despite `Task.Delay`
- **Symptom:**
  `Assert.True(previewCount > 0)` fails after editing text, even though `await Task.Delay(...)` was awaited.
- **Root Cause:**
  In headless test execution, background tasks (such as markdown parsing or background thread operations) schedule their UI updates onto `RxApp.MainThreadScheduler` / `Dispatcher.UIThread`. However, in a headless environment, the UI dispatcher does not automatically pump jobs while background tasks run.
- **Fix:**
  Always invoke `Dispatcher.UIThread.RunJobs()` on the UI thread before asserting properties that depend on dispatcher-scheduled callbacks:

  ```csharp
  await Task.Delay(PreviewWaitMilliseconds);

  (string text, int count) = await session.Dispatch(() =>
  {
      Dispatcher.UIThread.RunJobs();
      return (editor.State.MarkdownText, editor.State.PreviewBlocks.Count);
  }, CancellationToken.None);
  ```

---

### 3. `dotnet test` Hangs or Timeouts
- **Symptom:**
  Running `dotnet test` hangs indefinitely or hits the timeout limit.
- **Root Cause:**
  Attempting to pass VSTest arguments like `-- RunConfiguration.DisableParallelization=true` on the command line can lock the Avalonia headless message loop. xUnit does not support configuring test execution in this manner.
- **Fix:**
  Run `dotnet test` cleanly without invalid CLI runner overrides:
  ```bash
  dotnet test
  ```
  To target specific tests, use filter by name:
  ```bash
  dotnet test --filter MarkdownPreviewBuilderTests
  dotnet test --filter EditorScreenIntegrationTests
  ```

---

## Mandatory Testing Rules

1. **Always clean up `Window` instances**:
   Never leave a `window.Show()` without a matching `try...finally { window.Close(); }`.
2. **Always pump UI dispatcher queue**:
   Call `Dispatcher.UIThread.RunJobs()` after simulated user inputs and before reading UI or reactive state.
3. **Keep test methods focused and flat**:
   Extract complex test setups to helper methods.
