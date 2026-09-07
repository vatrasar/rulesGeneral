---
trigger: always_on
---

# Project Architecture

## Folders architecture

**Important Note on Project Root:**
The actual project is located inside a folder named `project`. The folders described below, such as `src`, `assets`, etc., are located *inside* this `project` folder. For the AI agent, the "root" folder is located "above" the `project` folder itself.

### Src

In this folder, you can find the primary code modules:

- **Features (`src/features`):** Here we keep modules related to specific features. Each feature must have a separate directory (e.g., `src/features/employee_list/`). Inside each feature directory:
  - `ui/`: Contains the `.slint` files for feature screens and components (`ScreenComponents`, `FeatureComponents`, `styles.slint`).
  - `domain/`: Domain logic for the feature (services, models, use cases, enums).
  - `controller.rs` (or `mod.rs`): Coordinates the feature logic with Slint callbacks, binds models to the UI, and dispatches domain actions.
  - All features must expose a registration/setup function (e.g., `setup_feature(&ui_handle, &app_state)`) to wire callbacks and state to the main Slint window.

- **Infrastructure (`src/infrastructure`):**
  - `navigation/`: Router state and screen transition coordinators.
  - `data/`:
    - `repositories/`: Concrete implementations of repository traits.
    - `migrations/`: Database schema migration scripts or functions.
    - `db.rs`: SQLite connection pool setup and lifecycle management.

- **Shared (`src/shared`):**
  - Reusable UI elements, components, and styling shared across multiple features:
    - `ui/`: Custom reusable Slint components (`GlobalComponents.slint`).
    - `styles/`: Shared theme palettes and styles (`palette.slint`, `global_styles.slint`).

- **Core (`src/core`):**
  - Shared domain models, enums, cross-cutting services, and traits.
  - `domain/repository_contracts/`: Trait definitions for all repositories.
  - `config/`: Strongly-typed configuration structs (`app_config.rs`).

### Assets

Here we store static assets such as icons (SVGs/PNGs), images, and custom fonts.

### Tests

All automated tests are placed here:
- `core_tests/`: Tests related to code in `src/core`.
- `features_tests/`: Subfolders with tests for each feature (e.g., `features_tests/reporting_tests/service_tests.rs`).

## Slint Screens & Controllers

In Slint + Rust, the UI presentation and business logic are cleanly separated:

1. **Slint Markup (`.slint`):** Defines visual hierarchy, layout, reactive properties (`in-out property <...>`), and callback signatures (`callback save_clicked();`).
2. **Feature Controller (`controller.rs`):** Wires the generated Slint window component to the Rust domain layer:
   - Receives a weak UI handle (`slint::Weak<AppWindow>`).
   - Registers callback handlers (`ui.on_save_clicked(move || { ... })`).
   - Populates Slint properties and list models (`slint::ModelRc`).

Example Controller pattern in Rust:

```rust
use std::rc::Rc;
use slint::{ComponentHandle, ModelRc, VecModel};
use crate::ui::AppWindow;

pub struct EmployeeListController;

impl EmployeeListController {
    pub fn setup(ui: &AppWindow, app_state: AppState) {
        let ui_weak = ui.as_weak();
        let state = app_state.clone();

        ui.on_load_employees(move || {
            let ui_weak = ui_weak.clone();
            let state = state.clone();

            tokio::spawn(async move {
                let employees = state.employee_service.get_all().await;
                let _ = slint::invoke_from_event_loop(move || {
                    if let Some(ui) = ui_weak.upgrade() {
                        let models: Vec<SlintEmployee> = employees.into_iter().map(Into::into).collect();
                        ui.set_employees(ModelRc::new(VecModel::from(models)));
                    }
                });
            });
        });
    }
}
```

## Navigation and Routing

- Screen switching is managed using a top-level state property or enum in Slint (e.g., `in-out property <Screen> active_screen: Screen.Home;`).
- The `AppWindow` switches views based on `active_screen`:
  ```slint
  export enum Screen { Home, EmployeeList, Settings }
  
  export component AppWindow inherits Window {
      in-out property <Screen> active_screen: Screen.Home;
      
      if root.active_screen == Screen.Home : HomeScreen {}
      if root.active_screen == Screen.EmployeeList : EmployeeListScreen {}
      if root.active_screen == Screen.Settings : SettingsScreen {}
  }
  ```
- Rust navigation controllers trigger navigation by setting `active_screen` on the UI handle and maintaining history stacks if back-navigation is required.

## Strings & Localization

1. UI strings must NOT be hardcoded inline as magic strings.
2. Use Slint's native `@tr("...")` syntax for localized text in `.slint` files or a dedicated i18n/fluent catalog.
3. Feature-specific strings belong to the feature's UI components.
4. Shared/common strings (e.g., "Save", "Cancel", "Error") belong to shared UI modules.
5. Internal logic strings (cache keys, DB column names, event identifiers) must NOT be localized; define them as `const &str` in Rust.

## Enums

Strongly-typed enums belong in the `enums/` folder within `src/core/` or `src/features/<feature>/domain/enums/`.
If the enum is shared with Slint, declare the equivalent `export enum ...` in `.slint` and map between them cleanly.

## Database & Repositories

### SQLite & Connection Pool
- We use SQLite for local persistence (via `sqlx` or `rusqlite`).
- Database migrations and connection initialization belong to `src/infrastructure/data/`.

### Repositories (Contract-Based)
- **Mandatory Traits:** Every repository MUST have a dedicated trait defined in `src/core/domain/repository_contracts/`.
- **Placement Restriction:** Repositories MUST NOT be placed in the `features/` directory. Implementations belong to `src/infrastructure/data/repositories/`.

### Entities
- The Repository is the **only** place where we operate on an `Entity` struct.
- An entity struct name MUST end with the suffix `Entity` (e.g., `UserEntity`).
- Repositories take domain models (or primitives) as input, convert them into `Entity` structs if needed, and execute database operations.
- **NEVER return an `Entity` from a public repository method.** Always convert `Entity` records into clean domain models or primitive types before returning.

### Database File Location
The SQLite database file MUST be stored in the per-user data directory (`~/.local/share/<app_name>` on Linux, resolved using `dirs::data_local_dir()`), NOT next to the executable. In release mode (e.g., installed via `.deb`), the executable resides in `/opt/<app_name>`, which is root-owned and read-only. Any writable database or log file MUST go to the user data directory.

## Dependency Injection / Composition in Rust

In Rust, avoid heavyweight reflection-based DI containers. Use explicit struct composition:
- Define an `AppState` struct (containing `Arc<dyn RepositoryTrait>`, services, and Tokio channel senders).
- Pass `AppState` or dedicated service references to feature controllers during startup in `src/main.rs`.

## Global Configuration

- Configuration is strongly typed via an `AppConfig` struct in `src/core/config/app_config.rs` with `#[derive(Serialize, Deserialize, Clone)]`.
- The configuration file (`config.toml` or `config.json`) is stored in the per-user configuration directory (`~/.config/<app_name>/` or `~/.local/share/<app_name>/`).
- Default values must be provided using `#[serde(default)]` or `Default::default()`.