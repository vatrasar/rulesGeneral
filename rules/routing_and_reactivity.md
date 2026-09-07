---
trigger: always_on
---
# Routing and Reactivity

## Routing in Slint

In Slint, view routing is declarative and driven by top-level state or enums declared in Slint markup, coordinated by Rust controllers.

### 1. Screen Enum and View Host in Slint

The root window (`AppWindow` in `ui/app_window.slint`) hosts the screen views and switches them conditionally based on an `active_screen` property:

```slint
export enum Screen {
    Home,
    EmployeeList,
    EmployeeDetails,
}

export component AppWindow inherits Window {
    in-out property <Screen> active_screen: Screen.Home;

    // View Host
    if root.active_screen == Screen.Home : HomeScreen {}
    if root.active_screen == Screen.EmployeeList : EmployeeListScreen {}
    if root.active_screen == Screen.EmployeeDetails : EmployeeDetailsScreen {}
}
```

### 2. Navigation Coordinator in Rust

In Rust (`src/infrastructure/navigation/mod.rs`), a navigation coordinator manages the active screen and navigation history (back-stack):

```rust
use std::sync::Mutex;
use crate::ui::{AppWindow, Screen};

pub struct NavigationCoordinator {
    history: Mutex<Vec<Screen>>,
}

impl NavigationCoordinator {
    pub fn new() -> Self {
        Self { history: Mutex::new(Vec::new()) }
    }

    pub fn navigate_to(&self, ui: &AppWindow, target: Screen) {
        if let Ok(mut stack) = self.history.lock() {
            stack.push(ui.get_active_screen());
        }
        ui.set_active_screen(target);
    }

    pub fn go_back(&self, ui: &AppWindow) -> bool {
        if let Ok(mut stack) = self.history.lock() {
            if let Some(prev) = stack.pop() {
                ui.set_active_screen(prev);
                return true;
            }
        }
        false
    }
}
```

### 3. Feature Setup and Route Registration

Each feature module provides a `setup` function in its `controller.rs` (or `mod.rs`) that binds callbacks and wires navigation:

```rust
pub struct MalpaController;

impl MalpaController {
    pub fn setup(ui: &AppWindow, nav: Arc<NavigationCoordinator>) {
        let ui_weak = ui.as_weak();
        let nav = nav.clone();

        ui.on_open_pies_screen(move || {
            if let Some(ui) = ui_weak.upgrade() {
                nav.navigate_to(&ui, Screen::Pies);
            }
        });
    }
}
```

---

## Reactive State Management in Slint

### 1. Slint's Native Reactivity

- Slint properties are **automatically reactive**. Any expression or layout depending on property `X` automatically recalculates and repaints whenever `X` changes.
- **Property Types**:
  - `in property <type> name`: Read-only for the component, passed in by the parent.
  - `out property <type> name`: Write-only / emitted by the component.
  - `in-out property <type> name`: Two-way bindable property (can be bound with `<=>` between parent and child).
  - `private property <type> name`: Internal component state.

### 2. State Encapsulation Pattern (Domain -> UI)

When managing complex screen state:
- Model domain state in clean Rust structs.
- Reflect state into Slint by updating properties on the `AppWindow` or component handle.
- Avoid loose, untyped property updates. Group related screen state properties logically in the `.slint` file:

```slint
export struct EmployeeListState {
    is_loading: bool,
    error_message: string,
    total_count: int,
}

export component EmployeeListScreen inherits Rectangle {
    in-out property <EmployeeListState> state;
    // ...
}
```

### 3. Dynamic Lists and Collections

- Never attempt to push raw Rust `Vec<T>` directly into Slint.
- Dynamic lists in Slint require a `ModelRc<T>` wrapping a `VecModel<T>`:
  ```rust
  use slint::{ModelRc, VecModel};
  use std::rc::Rc;

  let items = vec![item1, item2, item3];
  let model = ModelRc::new(VecModel::from(items));
  ui.set_employee_items(model);
  ```
- To update individual items in a list without recreating the model, mutate the `VecModel` via `.set_row_data(index, new_value)`.

### 4. Asynchronous State Updates & Tokio Integration

Slint's UI is single-threaded and runs on the main event loop. Background operations must run on Tokio:

- **Strict Rule:** NEVER perform file I/O, network requests, database calls, or heavy CPU computations inside a Slint callback closure.
- **Weak Handle Pattern:** Always create a weak handle before moving into asynchronous blocks:
  ```rust
  let ui_weak = ui.as_weak();
  tokio::spawn(async move {
      let result = background_work().await;
      
      // Dispatch update to Slint event loop
      let _ = slint::invoke_from_event_loop(move || {
          if let Some(ui) = ui_weak.upgrade() {
              ui.set_status_text(result.into());
          }
      });
  });
  ```
- Using `weak.upgrade_in_event_loop(...)` is also supported:
  ```rust
  let _ = ui_weak.upgrade_in_event_loop(move |ui| {
      ui.set_status_text(result.into());
  });
  ```
