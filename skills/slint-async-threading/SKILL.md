---
name: slint-async-threading
description: Diagnoses and prevents threading issues, UI lockups, and cross-thread access bugs in Slint + Tokio applications. Use when bridging background tasks, async I/O, or channels to the Slint UI thread.
---

# Slint & Tokio Asynchronous Threading

## When to use this skill

Use this skill whenever you are:
- Running background tasks (database operations, HTTP requests, file I/O, heavy computation) that need to update the Slint UI.
- Fixing compiler errors about `Send` / `Sync` bounds on Slint UI components.
- Fixing UI freezes or event loop starvation caused by blocking work in Slint callbacks.
- Implementing Tokio channels (`mpsc`, `broadcast`) communicating with Slint.

---

## Core Rules of Slint Thread Safety

### 1. Slint Handles are Thread-Bound
The generated Slint component struct (e.g. `AppWindow`) is bound to the thread running the Slint event loop. You **CANNOT** pass `AppWindow` directly across thread boundaries into `tokio::spawn`.

### 2. The Weak Handle Pattern
To communicate with the UI from another thread or an async task:
1. Call `.as_weak()` on the `AppWindow` instance to obtain a `slint::Weak<AppWindow>`.
2. Move the `Weak` handle into the background task (`move`).
3. Dispatch the UI update back to the main thread via `weak.upgrade_in_event_loop(...)` or `slint::invoke_from_event_loop(...)`.

```rust
let ui_weak = ui.as_weak();

tokio::spawn(async move {
    // 1. Perform background work without blocking the UI
    let data = fetch_data_from_database().await;

    // 2. Safely dispatch UI property updates to the Slint event loop
    let _ = ui_weak.upgrade_in_event_loop(move |ui| {
        ui.set_data_summary(data.into());
    });
});
```

### 3. Never Block in Callbacks
Slint callbacks (`ui.on_some_event(...)`) run directly on the UI event loop thread.
- **NEVER** use `tokio::task::block_in_place`, `futures::executor::block_on`, or synchronous blocking I/O (`std::thread::sleep`, synchronous HTTP or DB queries) inside a callback.
- Instead, spawn the future onto the Tokio runtime using `tokio::spawn`.

---

## Common Patterns

### Pattern A: Streaming Updates with Channels (MPSC)
When a long-running background process emits progress updates:

```rust
let (tx, mut rx) = tokio::sync::mpsc::channel::<ProgressUpdate>(32);
let ui_weak = ui.as_weak();

// Background worker
tokio::spawn(async move {
    for step in 1..=100 {
        tokio::time::sleep(tokio::time::Duration::from_millis(50)).await;
        let _ = tx.send(ProgressUpdate { percent: step }).await;
    }
});

// UI forwarder
tokio::spawn(async move {
    while let Some(update) = rx.recv().await {
        let _ = ui_weak.upgrade_in_event_loop(move |ui| {
            ui.set_progress_percent(update.percent as f32);
        });
    }
});
```

### Pattern B: Preventing Reference Cycles in Callbacks
Never move a strong `ui: AppWindow` into its own callback closure. That creates a circular reference and leaks memory:

```rust
// ❌ WRONG: Leaks memory due to reference cycle
// ui.on_click(move || { ui.set_clicked(true); });

// ✅ CORRECT:
let ui_weak = ui.as_weak();
ui.on_click(move || {
    if let Some(ui) = ui_weak.upgrade() {
        ui.set_clicked(true);
    }
});
```

---

## Decision Checklist

- Does the operation take more than ~5ms? -> **Spawn on Tokio**.
- Are you calling async functions (`.await`)? -> **Spawn on Tokio**.
- Do you need to update Slint properties from an async block? -> **Use `ui_weak.upgrade_in_event_loop(move |ui| { ... })`**.
- Did the compiler complain about `Rc` or `!Send` in `tokio::spawn`? -> **You accidentally passed a strong UI handle or non-Send model into the task; pass `ui.as_weak()` and plain Rust data types instead**.