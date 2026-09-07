---
name: testing-guidelines
description: Standards and naming conventions for unit, integration, and Slint UI testing in Rust desktop projects.
---

## When to use this skill

Use this skill when writing or updating unit tests, domain logic tests, or Slint UI integration tests in Rust.

## How to use it

1. **Unit Testing:** Write unit tests close to the code using `#[cfg(test)] mod tests { ... }` or in the top-level `tests/` directory.
2. **Async Tests:** Use `#[tokio::test]` for functions requiring the Tokio runtime.
3. **Mocking & Isolation:** Use Rust trait stubs or `mockall` to mock repository dependencies.
4. **Naming Convention:** Follow `test_function_name_condition_expected_result` pattern for test functions.
5. **Slint UI Testing:** Use `slint-testing` with `ElementHandle` to simulate actions and assert UI states headlessly.

---

## Testing Standards

### Test Function Naming

Use the following snake_case naming convention for all test functions:

`test_<function_name>_<condition>_<expected_result>`

**Example:**
For a function `get_time_slots_list`, the test should be named:
`test_get_time_slots_list_unsorted_input_returns_sorted_list()`

---

### Rust Unit & Integration Tests

- Place feature-specific domain tests under `src/features/<feature>/domain/...` inside `#[cfg(test)]` blocks.
- Place cross-cutting integration tests in `tests/`.
- Ensure each test is independent and idempotent (FIRST principles).

---

### Slint Headless UI Testing

When testing Slint UI components:
- Instantiate the window or component headlessly via `AppWindow::new().unwrap()`.
- Use `slint_testing::ElementHandle` to query elements by `id` or accessible text.
- Do NOT sleep real OS threads for timers; use `slint_testing::mock_elapsed_time(...)`.
- Refer to the `slint-testing-pitfalls` skill for troubleshooting timing, event pumping, and assertion issues.
