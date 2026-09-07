---
trigger: always_on
---
# Screens and Components

## Screens

When in instructions for you I use the word "screen", I mean the following files:
1. `<ScreenName>.slint` — The Slint markup defining the screen's UI layout, properties, and callback declarations.
2. `controller.rs` (or `<screen_name>_controller.rs`) — The Rust module wiring callbacks, domain use cases, and UI state updates.
3. `Screen.md` — The documentation file detailing the screen's purpose, capabilities, and navigation flow.

For example, when I say "screen malpa", it means `MalpaScreen.slint`, `malpa_controller.rs`, and `Screen.md`, located in `src/features/malpa/ui/screens/malpa/`.

Before starting any work on a screen, you MUST read the documentation in `Screen.md` and the header comment of the `.slint` file to understand its purpose, functionalities, and context.

Inside a screen folder there may be a folder `ScreenComponents` where you can put components used exclusively by this screen.

### Models for Screens and Components

Files defining domain models can ONLY reside in `domain/models/` at the feature level or within `src/core/domain/models/`. You MUST NOT place Rust domain models in UI or screen directories. If a component is shared globally, any associated domain model belongs to `src/core/domain/models/`.

## Components

Components are reusable, isolated UI elements declared in `.slint` files (using `export component <ComponentName> { ... }`).

Every component MUST contain documentation in a comment at the top of its `.slint` file describing its purpose, inputs (`in property`), outputs (`out property`), two-way bindings (`in-out property`), and callbacks (`callback`).

### Custom Components Location

Custom components should by default be placed in `ScreenComponents` inside the screen's folder. You may place them in `FeatureComponents` (within the feature's `ui/` directory) or `GlobalComponents` (in `src/shared/ui/`) only when explicitly instructed or when reused across multiple screens/features.

### Component Types

You must distinguish two types of components:

1. **Smart Components / Screens:**
   - Possess business callbacks or interact with domain services and asynchronous tasks.
   - Wired via a Rust controller that registers callbacks on the Slint handle (`ui.on_<callback>(...)`) and coordinates state.
   
2. **Dumb Components (Stateless / Presentational):**
   - Pure Slint widgets that only render visual elements and emit events.
   - Do NOT have a dedicated Rust controller.
   - Receive data via `in property` or `in-out property`, and report user interactions via `callback name();`.

### Component Communication Rules

1. **Hierarchy Isolation (Parent-Child):**
   - A Child component MUST NOT reference or know about its Parent.
   - Parents pass data to children via properties:
     ```slint
     MyCard {
         title: root.card_title;
         is_active: root.card_active;
         card_clicked => { root.handle_card_click(); }
     }
     ```
   - Children inform parents of actions strictly through callbacks (`callback clicked();`).

2. **No Global State Hacking:**
   - Never use global hacks or circular dependencies between unrelated components.
   - If two sibling components need to communicate, elevate the state to their common parent or route through the Rust feature controller.

3. **Transition from Dumb to Smart Component:**
   - If a presentational component requires asynchronous tasks, database queries, or interaction with backend domain services, it MUST be wired to a Rust controller.
   - Purely visual state changes (e.g. hover animations, tab toggling, visual dropdown expansions) should be handled directly in Slint markup using Slint properties and states, without involving the Rust backend.
