---
name: testing-guidelines
description: Provides standards for unit and integration testing, including naming conventions and best practices for test isolation and stability.
---

## When to use this skill

Use this skill when writing or updating unit tests, integration tests, or UI-automated tests.

## How to use it

1. **Framework Selection:** Use the established testing framework (e.g., Jest, xUnit, Pytest) and assertion libraries for the project stack.
2. **Bootstrapping:** Follow the project's standard pattern for initializing the application state or test environment.
3. **Mocking:** Use standard mocking libraries for dependency isolation.
4. **Naming Convention:** Follow the `NameOfTestedFunction_testCondition_expectedResult` pattern for all test methods.

## Testing Standards

### FIRST Principles
Ensure tests follow the FIRST principles:
- **Fast:** Tests should run quickly.
- **Independent:** Tests should not depend on each other.
- **Repeatable:** Tests should yield the same results every time.
- **Self-validating:** Tests should have clear pass/fail criteria.
- **Timely:** Tests should be written alongside the code.

### Test Function Naming

When creating test functions, use the following naming convention:

`NameOfTestedFunction_testCondition_expectedResult`

**Example:**
For a function `GetSortedList`, a test method should be named:
`GetSortedList_ForUnsortedData_ReturnsSortedList`

### Test Isolation and Stability

When writing tests, especially those involving UI or shared state, you MUST adhere to the following rules to ensure stability and complete isolation:

- **State Management & Test Isolation:** Tests must never pollute the global state or leave lingering instances of heavy objects (like database connections, windows, or global observers).
  - Use appropriate setup and teardown hooks (e.g., `beforeEach`/`afterEach`).
  - Always restore any modified global state to its original value after the test completes.
  - Ensure that resources (files, sockets, memory-intensive objects) are explicitly closed or disposed of.
- **Handling Asynchrony:** If the framework uses an event loop or asynchronous processing, ensure tests explicitly wait for operations to complete.
  - Use `async/await` patterns correctly.
  - Wait for UI rendering or state propagation before making assertions.
- **Simulating User Interaction:** When testing UI, always use the framework's recommended high-level interaction APIs rather than low-level event firing or direct logic execution.
  - Prefer simulating the user action (e.g., clicking a button via a testing utility) over calling the underlying command or function directly. This ensures the full binding and event chain is tested.
