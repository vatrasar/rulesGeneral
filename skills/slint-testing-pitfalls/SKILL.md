---
name: slint-testing-pitfalls
description: Diagnoses and prevents common Slint UI testing pitfalls, including headless test execution, advancing timers with mock_elapsed_time, finding elements, and isolating business logic. Use when writing or troubleshooting Rust Slint tests.
---

# Slint Testing Pitfalls & Diagnostics

## When to use this skill

Use this skill whenever you are:
- Writing or troubleshooting tests for Slint UI components using `slint-testing`.
- Testing timers, animations, or delayed state changes in Slint.
- Simulating clicks, text input, and accessible actions on Slint elements.
- Troubleshooting hanging tests or unasserted reactive state in `cargo test`.

---

## Symptoms and Solutions

### 1. Timers or Delayed State Not Updating in Tests
- **Symptom:** Properties set by `slint::Timer` or animations do not update in unit tests, even after waiting.
- **Root Cause:** In test environments, the real-time event loop clock doesn't automatically step forward for fast assertions.
- **Fix:** Use `slint_testing::mock_elapsed_time` to explicitly advance the mock clock:
  ```rust
  // Fast-forward mock timer by 250 milliseconds
  slint_testing::mock_elapsed_time(std::time::Duration::from_millis(250));
  ```

### 2. Simulating User Clicks & Input
- **Symptom:** Direct property assignment doesn't trigger UI callbacks or event handlers.
- **Fix:** Use `slint_testing::ElementHandle` to locate elements and simulate user actions:
  ```rust
  use slint_testing::ElementHandle;

  let ui = AppWindow::new().unwrap();
  
  // Find button by accessible role, label, or element ID
  let button = ElementHandle::find_by_element_id(&ui, "save_user_btn").expect("button found");
  button.invoke_accessible_default_action();
  ```

### 3. Separation of Domain Logic and UI Testing
- **Best Practice:** Do NOT instantiate full Slint windows to test business logic or database queries.
- Write pure unit tests for domain services, models, and use cases using standard Rust `#[test]` functions:
  ```rust
  #[tokio::test]
  async fn test_calculate_hours_valid_input_returns_expected() {
      let service = EmployeeService::new(mock_repo);
      let result = service.calculate_hours(40).await.unwrap();
      assert_eq!(result, 40);
  }
  ```

---

## Mandatory Testing Rules

1. **Keep UI Tests Fast:** Never use `std::thread::sleep` in Slint UI tests. Use `slint_testing::mock_elapsed_time`.
2. **Assign IDs to Test Targets:** Always set `id: [element_id];` in `.slint` files for elements that tests will inspect or click.
3. **Flat Test Structure:** Keep test setups flat, extract reusable helpers, and avoid nested assertion logic.

