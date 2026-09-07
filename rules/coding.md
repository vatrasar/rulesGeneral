---
trigger: always_on
---

# Code Rules

## Technologies used in project

The application is written in **Rust** using the following frameworks and libraries:

1. **Slint** (UI framework)
2. **Tokio** (Asynchronous runtime)
3. **SQLite** (via `sqlx` or `rusqlite` for database persistence)
4. **Built-in `cargo test`** (with optional `slint-testing` for UI integration tests)

It is structured with a feature-oriented folder architecture, trait-based repository contracts, and event-driven Slint reactive properties and callbacks.

## Coding rules

1. You are a highly skilled software engineer who prioritizes clean, idiomatic Rust code.

2. You pay particular attention to keeping functions short. Your primary goal is to write flat code.
   - **Nesting implies complexity:** Remember that blocks like `match`, `if let`, `let ... else`, `for`, `while`, and closures ALL count as levels of nesting.
   - **Early returns and guards:** Prefer using `let ... else { return ... }`, the `?` operator for error propagation, and early returns to avoid deeply nested blocks.
   - **Extract inner blocks:** If you find yourself nesting structures (e.g., a loop inside a conditional, or multiple nested `match`/`if let` statements), you MUST extract the inner logic into a dedicated private helper function. The body or content of these blocks must remain flat.

3. Names should be self-explanatory and communicate intent. Prioritize clarity over brevity, but avoid redundancy and noise words:
   - Types, Structs, Enums, Traits: `PascalCase`
   - Functions, Methods, Variables, Modules: `snake_case`
   - Constants, Statics: `SCREAMING_SNAKE_CASE`
   - A descriptive name is far superior to single-letter abbreviations (e.g. `remaining_free_hours` instead of `h`).

4. Services should remain lean. If a service is unlikely to maintain high cohesion, prefer Use Cases over generic Services.

5. **Language Requirements:**
   All naming conventions (variables, functions, structs, traits) and comments within the code must be in English.

6. **Prefer Strongly-Typed Enums over Constants/Strings/Integers:** Whenever a variable can hold a limited set of predefined values (e.g., `ShiftType`, `UserRole`, `DayOfWeek`), **always** use a strongly-typed `enum` (with `#[derive(Debug, Clone, PartialEq, Eq)]` and `serde` if serialized). Do not use bare `String`, `&str`, or integer constants for these purposes.

7. Organize code with clear visual boundaries: separate struct fields, trait implementations (`impl Trait for Struct`), and helper functions with blank lines.

8. **Avoid Anti-Patterns & Idiomatic Error Handling:**
   - **NO bare `.unwrap()` or `.expect()`** in production code or business logic. Always propagate errors using `Result<T, E>` and `?`, or handle them explicitly. Use `thiserror` for domain/library errors and `anyhow` for top-level application error context if appropriate.
   - Never suggest deprecated or old-school patterns if a modern, idiomatic Rust alternative exists.

9. Use the suffix `Dto` only for models that are used for network or external serialization.

10. Domain models should NOT use the suffix `Model`. Better to name a model `Malpa` than `MalpaModel`.

11. **Surgical Changes:**
    **Touch only what you must. Clean up only your own mess.**
    When editing existing code:
    - Don't "improve" adjacent code, comments, or formatting.
    - Don't refactor things that aren't broken.
    - Match existing style, even if you'd do it differently.
    - If you notice unrelated dead code or compiler warnings, mention it - don't delete it unasked.
    When your changes create orphans:
    - Remove imports, variables, and functions that YOUR changes made unused.
    - Don't remove pre-existing dead code unless asked.

12. **Entities:** Database entity struct names MUST end with the suffix `Entity` (e.g., `UserEntity`).

13. **Loop Flatness:**
    To prevent deep indentation and maintain flatness, the body of `for`/`while` loops must remain flat (e.g., no nested `match`, `if-else`, or nested loops inside). If condition checking or branching is required, extract that logic into a dedicated helper function and invoke it inside the loop body.

## Documentation & Commenting Standards

**1. NO INLINE COMMENTS**
- Adding comments within a function or method body is STRICTLY FORBIDDEN.
- Logic should be so clear and names so expressive that internal comments are redundant.
- Code MUST be self-documenting through expressive naming and clear structure.
- You should use Rustdoc comments (`///`) on top of functions, structs, traits, and modules, but prioritize making the code self-documenting.

**2. ALWAYS KEEP DOCS IN SYNC**
- CRITICAL: Whenever you modify a component, screen, service (logic, UI, navigation, or usages) or use case, you MUST update its corresponding documentation.

**3. UI DOCUMENTATION (Screens & Components)**
- Every Screen and Component MUST have a descriptive header comment at the top of its `.slint` file or corresponding Rust controller.
- **Components** (Location: `ScreenComponents`, `FeatureComponents`, or `GlobalComponents`):
  - Include: Purpose, Properties (Inputs/Outputs), Callbacks, and `Used In` (list of screens/components referencing it).
- **Screens**:
  - Include: Purpose, Available Functionalities, Key UI elements, and Navigation (`Navigate From` and `Navigate To` paths).

**4. SERVICES & REPOSITORIES & UseCases**
- All `pub` methods of services and repositories need to have a documentation comment (`///`) (EXCEPT for the `execute` method in UseCases; use cases should have a doc comment on top of their struct).
- Use Rustdoc (`///`) ONLY for public items (`pub`). Do NOT add doc comments to private helper functions unless complex algorithms require explanation.
- Include: The purpose of the method and callers/components that invoke it.

**5. DOCUMENT CURRENT STATE ONLY**
- When documenting usages (e.g., `Used In` sections or invocation lists for services/components), you MUST ONLY list actual, currently implemented usages.
- DO NOT list anticipated or planned future usages. Documentation must strictly represent the factual, present state of the codebase.

## Threads and Asynchrony

### Task Cancellation
Always use `tokio_util::sync::CancellationToken` for canceling asynchronous operations or long-running background tasks. Pass a `CancellationToken` to functions that perform background loops or long I/O.

### Slint UI Thread Safety
- **Never block the Slint event loop:** Heavy computations, file I/O, network requests, and database queries MUST run on Tokio background threads (`tokio::spawn`), never directly in Slint callbacks.
- **UI Updates from Background Threads:** Never access UI properties directly from background threads. Always obtain a `slint::Weak<AppWindow>` using `.as_weak()` and dispatch updates to the UI thread via `weak.upgrade_in_event_loop(move |ui| { ... })`.

## Anti-Legacy & Slint Traps

- **Circular Reference in Callbacks:** Never capture a strong `AppWindow` or UI handle inside its own callback closures. Always create a weak handle (`let ui_weak = ui.as_weak();`) before moving into closures or asynchronous blocks.
- **Strings in Slint:** Slint uses `slint::SharedString`. When passing strings between Rust logic and Slint, convert explicitly using `.into()` or `slint::SharedString::from(...)`.
- **List Models in Slint:** When binding dynamic lists in Slint, use `slint::ModelRc` wrapping a `slint::VecModel<T>` (e.g. `std::rc::Rc::new(slint::VecModel::from(items))`). Do not attempt to pass raw Rust `Vec<T>` directly to dynamic list properties.

## Databases

If you are going to perform a database migration or schema modification that could lead to data loss, you MUST explicitly ask me for permission beforehand.

