---
trigger: always_on
---

# Slint Framework Specific Rules

## Slint Compilation & Build Setup

1. **Build Script (`build.rs`):**
   - Slint files are compiled at build time using `slint_build::compile("ui/app_window.slint").expect("slint compilation failed");`.
   - Ensure the entry point `.slint` file path in `build.rs` is correct.

2. **Generated Code Inclusion:**
   - In Rust, include the compiled Slint UI modules using `slint::include_modules!();` at the appropriate module boundary (typically in `src/ui.rs` or `src/main.rs`).

## Slint Data Types & Conversions

- **Strings:**
  - Slint uses `slint::SharedString` instead of Rust's `String` or `&str`.
  - Use `.into()` or `slint::SharedString::from(...)` when passing strings to Slint properties.
  - To convert from Slint string to Rust: `.as_str()` or `.to_string()`.

- **Lists & Models:**
  - Dynamic lists in Slint require `slint::ModelRc<T>`.
  - For mutable list models, construct with `std::rc::Rc::new(slint::VecModel::from(vec))` and pass as `slint::ModelRc::from(rc_vec_model)`.
  - Never attempt to convert a standard `Vec<T>` directly to a Slint property without wrapping it in a `ModelRc`.

- **Colors & Brushes:**
  - In `.slint` files, specify colors as `#RRGGBB` or `#RRGGBBAA`.
  - In Rust, use `slint::Color::from_rgb_u8(r, g, b)` or `slint::Brush`.

## Callback Memory Safety & Threading

1. **Weak Handles in Callbacks:**
   - NEVER capture a strong `AppWindow` reference inside its own callback closure.
   - Always do:
     ```rust
     let ui_weak = ui.as_weak();
     ui.on_submit(move || {
         if let Some(ui) = ui_weak.upgrade() {
             // access UI properties safely
         }
     });
     ```

2. **Async Operations from Callbacks:**
   - If a callback triggers async work (e.g., API call, SQLite query), spawn it on Tokio:
     ```rust
     let ui_weak = ui.as_weak();
     let service = service.clone();
     ui.on_action(move || {
         let ui_weak = ui_weak.clone();
         let service = service.clone();
         tokio::spawn(async move {
             let res = service.perform().await;
             let _ = slint::invoke_from_event_loop(move || {
                 if let Some(ui) = ui_weak.upgrade() {
                     ui.set_result(res.into());
                 }
             });
         });
     });
     ```
