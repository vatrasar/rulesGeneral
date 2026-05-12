---
name: testing-guidelines
description: MANDATORY. Provides standards for unit and integration testing. You MUST read this file whenever you are writing, updating, or running tests.
---

## When to use this skill

You MUST read and follow this skill every time you are writing, updating, or running unit tests, integration tests, or UI-automated tests.

## How to use it

1. **Framework Selection:** Use `pytest` for all testing.
2. **Bootstrapping:** Follow the project's standard pattern for initializing the application state or test environment. Utilize `pytest.fixture` for setup and teardown.
3. **Mocking:** Use `unittest.mock` for dependency isolation.
4. **Naming Convention:** Follow the `test_<name_of_tested_function>_<condition>_<expected_result>` pattern for all test methods (snake_case).

## Testing Standards

### FIRST Principles
Ensure tests follow the FIRST principles:
- **Fast:** Tests should run quickly.
- **Independent:** Tests should not depend on each other.
- **Repeatable:** Tests should yield the same results every time.
- **Self-validating:** Tests should have clear pass/fail criteria.
- **Timely:** Tests should be written alongside the code.

### Test Function Naming

When creating test functions, use the following naming convention (in snake_case):

`test_<name_of_tested_function>_<condition>_<expected_result>`

**Example:**
For a function `get_sorted_list`, a test method should be named:
`test_get_sorted_list_for_unsorted_data_returns_sorted_list`

### Test Isolation and Stability

When writing tests, especially those involving Flet UI or shared state, you MUST adhere to the following rules to ensure stability and complete isolation:

- **State Management & Test Isolation:** Tests must never pollute the global state or leave lingering instances of heavy objects (like database connections, Flet pages, or global observers).
  - Use appropriate `pytest` fixtures with `yield` for teardown.
  - Always restore any modified global state to its original value after the test completes.
  - Ensure that resources (files, sockets, memory-intensive objects) are explicitly closed or disposed of.
  - **Database Testing:** When a test requires database access, you MUST use an **in-memory database** (e.g., `sqlite:///:memory:`) to ensure total isolation and speed. Never run tests against a persistent local database file.
- **Handling Asynchrony:** If testing async Flet operations, ensure tests explicitly wait for operations to complete.
  - Use `pytest.mark.asyncio` and `async/await` patterns correctly.
  - Wait for UI rendering or state propagation before making assertions.
- **Simulating User Interaction:** When testing UI logic, verify that the event handlers trigger the correct state changes. Since Flet is server-driven, you can often test the component classes and their event handlers directly without needing a full browser context, or use headless Flet testing if available.
