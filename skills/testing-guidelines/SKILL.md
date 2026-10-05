---
name: testing-guidelines
description: Provides standards for unit and UI testing in Android projects, including JUnit, MockK, Coroutines runTest, Turbine for Flows, Compose Test rules, and naming conventions.
---

## When to use this skill

Use this skill when writing or updating unit tests, ViewModel tests, repository tests, or Jetpack Compose UI tests.

## How to use it

1. **Framework Selection:**
   - **Unit Testing:** JUnit 4/JUnit 5, MockK (mocking in Kotlin), and Turbine (Flow assertions).
   - **Coroutines:** `kotlinx-coroutines-test` with `runTest` and `StandardTestDispatcher` / `UnconfinedTestDispatcher`.
   - **UI Testing:** Jetpack Compose testing library (`createComposeRule()` / `createAndroidComposeRule()`).
2. **Naming Convention:** Follow the `NameOfTestedFunction_testCondition_expectedResult` pattern for all test methods.
3. **Isolation & Teardown:** Tests must be isolated, never pollute shared state, and cleanly reset dispatchers or test databases.

## Testing Standards

### FIRST Principles
Ensure all tests adhere to the FIRST principles:
- **Fast:** Tests should run quickly; never use `Thread.sleep()`.
- **Independent:** Tests must not depend on the execution order or results of other tests.
- **Repeatable:** Tests must produce the same result every run (deterministic).
- **Self-validating:** Clear assertions (pass/fail without manual inspection).
- **Timely:** Written alongside feature development and bug fixes.

### Test Method Naming

When creating test functions, use the following naming convention:

`NameOfTestedFunction_testCondition_expectedResult`

**Examples:**
- `calculateRemainingHours_withEmptyShiftList_returnsFullAllocation`
- `onAddCategoryClicked_whenNameIsValid_emitsSuccessNavEffect`

## Android Unit Testing (ViewModels, UseCases, Repositories)

### Testing Coroutines & Flows
- **`runTest`:** Always wrap coroutine tests inside `runTest` rather than `runBlocking`. This provides virtual time control via `advanceUntilIdle()` and skips delays.
- **Main Dispatcher Swap:** When testing ViewModels using `viewModelScope` (which defaults to `Dispatchers.Main`), register a JUnit test rule or `@Before`/`@After` hook to call `Dispatchers.setMain(testDispatcher)` and `Dispatchers.resetMain()`.
- **Turbine for Flow Testing:** Use Turbine's `test` extension to verify `Flow` / `StateFlow` emissions sequentially:
  ```kotlin
  viewModel.state.test {
      val initial = awaitItem()
      assertThat(initial.isLoading).isFalse()

      viewModel.onEvent(CategoryEvent.OnLoad)
      val loading = awaitItem()
      assertThat(loading.isLoading).isTrue()

      val success = awaitItem()
      assertThat(success.isLoading).isFalse()
  }
  ```

### Mocking with MockK
- Use `mockk<T>()`, `coEvery { ... } returns ...` for suspending functions, and `coVerify` for verifying suspending interactions.
- Avoid mocking value classes or pure data objects; instantiate real domain models directly.

## Jetpack Compose UI Testing

When testing Compose screens and components:
- **Rule Setup:** Use `createComposeRule()` for isolated Composable tests, or `createAndroidComposeRule<MainActivity>()` for activity-level tests.
- **Locating Elements via `testTag`:** Locate interactive components using the mandatory `testTag` modifier defined in the UI rules:
  ```kotlin
  composeTestRule.onNodeWithTag("submitButton").assertIsDisplayed().performClick()
  ```
- **Simulating Real Interactions:** Always use high-level Compose testing APIs (`performClick()`, `performTextInput()`, `performScrollTo()`) instead of manually invoking event callbacks directly. This validates the full binding, modifier, and event propagation chain.
- **Async & State Propagation:** Compose tests automatically synchronize with the Compose clock. If awaiting asynchronous effects or animations, use `composeTestRule.waitForIdle()` or `composeTestRule.waitUntil { ... }`.
