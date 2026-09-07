---
name: testing-guidelines
description: Provides standards for unit and UI-integrated testing in Avalonia projects, including naming conventions and headless testing setup.
---

## When to use this skill

Use this skill when writing or updating unit tests or UI-integrated tests for Avalonia applications.

## How to use it

1. **Headless Testing:** Use `Avalonia.Headless.XUnit` and `Avalonia.Themes.Fluent` for UI-integrated testing.
2. **Bootstrapping:** Utilize the pre-configured `TestAppBuilder` for headless Avalonia application bootstrapping.
3. **Mocking:** Use `xUnit` and `Moq` for standard unit testing and dependency mocking.
4. **Naming Convention:** Follow the `NameOfTestedFunction_testCondition_expectedResult` pattern for all test methods.

## Testing Standards

### Avalonia.Headless

The project is equipped with `Avalonia.Headless.XUnit` and `Avalonia.Themes.Fluent`. You are encouraged to use these for UI-integrated testing and functional verification. 

*Note: A `TestAppBuilder` has been pre-configured for this library to facilitate headless Avalonia application bootstrapping within the test suite.*

### Test Function Naming

When creating test functions, use the following naming convention:

`NameOfTestedFunction_testCondition_expectedResult`

**Example:**
For a function `GetTimeSlotsList`, a test method should be named:
`GetTimeSlotsList_ForDataWhichArenTSorted_ReturnsSortedTimeSlotList`

## Avalonia & ReactiveUI in tests

When writing UI tests for Avalonia and ReactiveUI in a headless environment, you MUST adhere to the following rules to ensure test stability, complete isolation (FIRST principles), and proper framework initialization.



# Headless UI Testing Guidelines (Avalonia & ReactiveUI)

When writing UI tests for Avalonia and ReactiveUI in a headless environment, you MUST adhere to the following rules to ensure test stability, complete isolation (FIRST principles), and proper framework initialization:

* **View Activation & Test Isolation:** Controls in Avalonia do not fire lifecycle events until they are placed in a Window. Tests must never pollute the global state or leave lingering Window instances, which causes memory leaks and flaky tests.
  * You MUST use a `try...finally` block for every View test.
  * In the `try` block: Wrap your `View` inside a `Window`, call `window.Show()`, run `Act`, and run `Assert`.
  * In the `finally` block: Restore any modified global state (e.g., `Application.Current.RequestedThemeVariant`) to its original value, and explicitly call `window.Close()`.
* **The Layout Pass & Thread Synchronization:** Avalonia needs explicit instructions in a headless environment to calculate layouts and process the UI thread queue.
  * Always call `window.LayoutManager.ExecuteInitialLayoutPass()` immediately after `window.Show()` and before interacting with UI elements.
  * Always call `Dispatcher.UIThread.RunJobs()` after showing the window and after every simulated user interaction.
* **Simulating Button Clicks:** In Avalonia 11, manually calling `RaiseEvent(new RoutedEventArgs(Button.ClickEvent))` does NOT execute the bound ReactiveUI `Command`. 
  * NEVER call `button.Command.Execute(null)` directly inside the test body, as it breaks encapsulation.
  * NEVER rely only on `RaiseEvent(Button.ClickEvent)`. 
  * You MUST use the provided extension method `SimulateClick()`. 
* **Troubleshooting Pitfalls:** Refer to `avalonia-headless-testing-pitfalls` skill for diagnosing `fonts:SystemFonts KeyNotFoundException` (caused by unclosed `Window` instances), UI dispatcher starvation, and CLI runner hangs. 
