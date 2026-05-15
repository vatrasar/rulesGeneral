---
trigger: always_on
---

# Routing and Reactivity Rules

This project uses Flet's declarative **`ft.Router`** system for all navigation and view management, completely replacing manual `page.views` manipulation. The router handles nested route matching, dynamic segments, view-stack management, and transitions natively.

## Declarative UI & Reactivity

This project strictly follows the **Declarative UI (UI = f(state))** approach instead of the imperative approach. We do not manually mutate controls (e.g., toggling `visible`, setting `value`) or call `page.update()`. Instead, we change the state, and Flet automatically updates the UI.

### 1. Mindset shift: UI = f(state)

- **Handle event → update state:** Event handlers change *data only*. They NEVER hide/show controls directly or call `page.update()`.
- **Render → derive UI from state:** The component *returns* controls based on the current state snapshot.

### 2. Observables (Domain State)

Use the `@ft.observable` decorator on `@dataclass` objects to hold your application's domain/persisted data. Assigning to their attributes automatically triggers re-rendering for components reading those fields.

#### Reactivity Matrix

| Property Type | Action | Re-render Triggered? |
| :--- | :--- | :--- |
| **Simple Field** (str, int, bool) | Assignment of new value | **YES** |
| **Collection** (list, dict) | In-place modification (append, update) | **YES** (Flet auto-wraps these) |
| **Custom Object** | Assignment of a **new** instance | **YES** |
| **Custom Object** | Modification of a field **inside** the object | **NO** |

#### Implementation Rules:
1. **Prefer Primitives:** Keep the state as flat as possible using primitive types.
2. **Collections are Safe:** Flet's `@ft.observable` automatically wraps lists and dictionaries, so standard methods like `list.append()` or `dict.update()` will trigger re-renders.
3. **Immutable Custom Objects:** If you must use custom objects within the state, you **MUST** treat them as immutable. To update a nested object's property, create a new instance of that object and assign it back to the state field.
   - *Example:* `state.user = UserEntity(name="New Name", id=state.user.id)` instead of `state.user.name = "New Name"`.

```python
@ft.observable
@dataclass
class AppState:
    is_loading: bool = False
    items: list[str] = field(default_factory=list) # Collections work fine
    current_user: UserEntity | None = None         # Custom objects require replacement
```

**Reactivity in Functional Components:**
To ensure a `@ft.component` reliably re-renders when an observable object changes (especially when the object is managed by a ViewModel), you MUST register it using the `ft.use_state()` hook, even if you don't use the setter. This ensures the component is properly subscribed to the observable's lifecycle.

```python
@ft.component
def MyScreen():
    vm = ft.use_memo(di.build_vm, [])

    # MANDATORY: Register the observable state to ensure re-renders
    state, _ = ft.use_state(vm.state) 

    return ft.Column([
        ft.Text(f"Items: {len(state.items)}")
    ])
```

### 3. Components (Functions returning UI)

Leverage Flet's functional component pattern by using the `@ft.component` decorator for all UI components and screens. Avoid subclassing Flet controls (like `ft.Container`) or using the legacy `ft.UserControl`. A component takes props, uses hooks, and returns controls. Do NOT imperatively mutate the page tree inside components.

### 4. Hooks (Local Transient State)

For internal, short-lived component state (like text field buffers or toggle flags), use `ft.use_state()`.

```python
@ft.component
def MyComponent():
    is_editing, set_is_editing = ft.use_state(False)

    def toggle(e):
        set_is_editing(not is_editing)

    return ft.Column([
        ft.Text("Editing Mode" if is_editing else "View Mode"),
        ft.Button("Toggle", on_click=toggle)
    ])
```

### 5. `use_memo` (Persistent Instances)

Use `ft.use_memo()` to initialize ViewModels or other complex instances that should be created only once and persist across re-renders (using an empty dependency list `[]`).

```python
@ft.component
def ScreenWithViewModel():
    vm = ft.use_memo(di.build_view_model, [])
```

## Two Approaches in Flet Router: `manage_views=True` vs `manage_views=False`

Flet's Router can operate in two modes:

1. **`manage_views=False` (Single View)**: The router renders all route content within a single `ft.View`. Route components return standard controls (like `ft.Column`, `ft.Container`, etc.). This is useful for simple web apps or desktop apps where you don't need a mobile-like view stack (like swipe-back gestures or system back buttons).
   
   - *Example:* A `@ft.component` returns `ft.Text("Home")`.

2. **`manage_views=True` (View Stack)**: The router returns a list of `ft.View` objects—one per path level. This enables native features like mobile swipe-back gestures, the system back button, implicit AppBar back buttons, and slide transitions between route levels. Route components MUST return `ft.View` objects. 
   
   - *Example:* A `@ft.component` returns `ft.View(route=..., appbar=..., controls=[...])`.

## 🚨 THIS PROJECT USES: `manage_views=False` 🚨

**Important Rule:** The required return types for your components depend entirely on the flag above:

- **If `manage_views=False` is set:** EVERY top-level route component (Screen) MUST return standard controls (like `ft.Column`, `ft.Container`, etc.). DO NOT return `ft.View`.
- **If `manage_views=True` is set:** EVERY top-level route component MUST return an `ft.View` object and utilize `ft.use_view_path()` for its route property.

## Feature navigation

Each feature MUST have a dedicated routing file named `feature_name_routes.py` (e.g., `voice_recorder_routes.py`).
Inside this file, define a function or list that returns the feature's `ft.Route` tree.

**NO MAGIC STRINGS:** Route paths (e.g., `"recorder"`) must be defined as class constants or module-level constants. 

**Example Feature Route Definition (`voice_recorder_routes.py`):**

```python
import flet as ft
from features.voice_recorder.ui.screens.recorder_view import RecorderView

RECORDER_ROUTE = "recorder"

def get_voice_recorder_routes() -> ft.Route:
    return ft.Route(path=RECORDER_ROUTE, component=RecorderView)
```

## File Naming Convention

Screen files with ui MUST always use the `*_view.py` suffix (e.g., `project_pick_view.py`, `recorder_view.py`). This convention applies regardless of whether the file contains a class inheriting from `ft.View` or a function decorated with `@ft.component`. The `*_view.py` suffix denotes that the file represents a **screen-level UI entry point**, not the internal implementation pattern.

## The Central Router (NavHost)

The application uses a central `@ft.component` called `NavHost`, located in `src/infrastructure/nav_host.py`. This component aggregates all feature routes into a single `ft.Router`.

**Example NavHost (`src/infrastructure/nav_host.py`):**

```python
import flet as ft
from features.voice_recorder.ui.voice_recorder_routes import get_voice_recorder_routes

@ft.component
def NavHost():
    return ft.Router(
        routes=[
            # ... other routes
            get_voice_recorder_routes(),
        ],
        # ALWAYS set this to match the "THIS PROJECT USES" flag!
        manage_views=False 
    )
```

## Entry Point (Main)

The `main.py` file must be located in the `src` folder. It initializes the Flet app using the central Router.

```python
import flet as ft
from infrastructure.nav_host import NavHost

async def main(page: ft.Page):
    # ALWAYS check the "THIS PROJECT USES" flag to determine the render method!

    # Initialize Dependency Injection container
    from infrastructure.app_di_container import AppDIContainer
    di = AppDIContainer()
    await di.initialize()
    page.session.store.set("di_container", di)

    # If manage_views=False:
    page.render(NavHost)

    # If manage_views=True:
    # page.render_views(NavHost)

if __name__ == "__main__":
    ft.run(main)
```

## Navigation between screens

Navigation is handled directly through Flet's page routing context:

- **Synchronous navigation:** `ft.context.page.navigate("/recorder")`
- **Asynchronous navigation:** `await ft.context.page.push_route("/recorder")`

### Communication between ViewModels / Passing Parameters

When you need to pass parameters between screens (or communicate between ViewModels), the **best practice is to use route parameters via `ft.use_route_params()`** rather than relying on global state. You can also use the session store (injected via DI), but it should be avoided if you only need to pass 1-2 parameters.

**Example of passing parameters via Route:**

1. Define the route with dynamic segments:
   
   ```python
   ft.Route(
    path="/workspace/:workspace_id/project/:project_id",
    component=ProjectScreen,
   )
   ```

2. Navigate and pass the values in the URL:
   
   ```python
   ft.context.page.navigate("/workspace/5/project/123")
   ```

3. Read the parameters in your component/ViewModel using `ft.use_route_params()`:
   
   ```python
   @ft.component
   def ProjectScreen():
    params = ft.use_route_params()
   
    workspace_id = params["workspace_id"]
    project_id = params["project_id"]
   
    return ft.Column(
        controls=[
            ft.Text(f"Workspace: {workspace_id}"),
            ft.Text(f"Project: {project_id}")
        ]
    )
   ```

## Route Paths & Hooks

- **Route Path Format:** All route paths MUST be strings. Nested routes should be defined without leading slashes. Top-level paths may start with a slash depending on how they are defined. Dynamic segments use Express-style syntax (e.g., `path="profile/:id"`).
- **Built-in Hooks:** Use built-in Router hooks within your `@ft.component` instead of passing data through constructors manually:
  - `ft.use_route_params()`: Get the dictionary of dynamic segment values.
  - `ft.use_view_path()`: Critical for `manage_views=True`. Use this value for the `route` property in `ft.View` to ensure proper back-stack management.
  - `ft.is_route_active(path)`: Check if a nav item is currently selected.

**Example of Hooks usage:**

```python
@ft.component
def ProductDetails():
    params = ft.use_route_params()

    # ALWAYS check the "THIS PROJECT USES" flag!

    # Example for manage_views=False:
    return ft.Column([
        ft.Text(f"Product ID: {params['id']}")
    ])

    # Example for manage_views=True:
    # return ft.View(
    #     route=ft.use_view_path(), 
    #     controls=[ft.Text(f"Product ID: {params['id']}")]
    # )
```
