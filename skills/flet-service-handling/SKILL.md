---
name: flet-service-handling
description: Guidelines for correctly implementing Flet controls that act as system API wrappers (like FilePicker, Audio, Video) to avoid "Unknown control" errors caused by incorrect registration timing or missing context.
---

## When to use this skill
Use this skill whenever you need to implement or troubleshoot Flet controls that interact with system APIs rather than just rendering UI. These controls often inherit from the internal `Service` class and follow a strict registration lifecycle. Examples include:
- `FilePicker` (File system)
- `Audio` / `Video` (Media playback)
- `Flashlight` / `Geolocator` (Hardware APIs)
- `ShakeDetector` / `KeyboardManager` (System events)

These controls follow a specific registration lifecycle.

## How to use it

### 1. Understand the Service Lifecycle
In Flet 0.85+, classes inheriting from `Service` automatically attempt to register themselves via `ft.context.page._services.register_service(self)` during their `init()` phase.

**CRITICAL:** This registration REQUIRES a valid Flet execution context (where `ft.context.page` is available).

### 2. Implementation Rules

#### Rule 1: Context is King
NEVER instantiate a Service control in a global scope, a standalone class constructor, or a Dependency Injection (DI) container that is initialized outside of the active Flet page context. 
- *Why:* If instantiated without a context, the service will fail to register with the page, leading to a red "Unknown control" error at runtime because the client (browser/desktop) doesn't know the control ID.

#### Rule 2: Component-Local Instantiation (Recommended)
The safest and most reliable way to implement a Service is inside an `@ft.component` using the `ft.use_memo` hook.

```python
@ft.component
def MyFeatureView():
    # Correct: Created inside component context. 
    # Auto-registers correctly.
    file_picker = ft.use_memo(ft.FilePicker, [])
    
    return ft.ElevatedButton("Pick", on_click=lambda _: file_picker.get_directory_path())
```

#### Rule 3: Register in page.services
In Flet 0.85+ (and 1.0), Services MUST be added to the `page.services` list to function correctly. This is done via `page.services.append(service)`.
- *Why:* Unlike visual controls that go into `page.add()` or `page.overlay`, services are registered in a dedicated list to manage their lifecycle and client-side communication without being part of the visual tree.

```python
@ft.component
def MyFeatureView():
    page = ft.context.page
    file_picker = ft.use_memo(ft.FilePicker, [])
    
    def register():
        page.services.append(file_picker)
        return lambda: page.services.remove(file_picker)
    
    ft.use_effect(register, [])
    
    return ft.Button("Pick", on_click=lambda _: file_picker.get_directory_path())
```

#### Rule 4: Clean Lifecycle
When using `ft.use_memo` inside a component, the Service is tied to that component's lifecycle. It will be created once and maintained as long as the component is mounted.

### 3. Troubleshooting "Unknown control"
If you encounter "Unknown control: [ServiceName]", check the following:
1. **Instantiation point:** Is the service being created in a place where `ft.context.page` is `None`? (e.g. in a DI container's `__init__`).
2. **Double Registration:** Are you manually adding it to `overlay` AND expecting it to work as a service?
3. **Execution Order:** Is the button using the service being rendered before the service has had a chance to register? (Rare with `use_memo` but possible with complex conditional rendering).

## Examples

### Correct implementation of FilePicker
```python
@ft.component
def ProjectPicker():
    page = ft.context.page
    # use_memo ensures stable reference and single initialization
    picker = ft.use_memo(ft.FilePicker, [])

    def register():
        page.services.append(picker)
        return lambda: page.services.remove(picker)
    
    ft.use_effect(register, [])

    async def on_click(e):
        path = await picker.get_directory_path()
        print(f"Selected: {path}")

    return ft.Button("Open Folder", on_click=on_click)
```

### Incorrect implementation (Causes "Unknown control")
```python
# Fails because context is missing during DI creation
class MyDI:
    def __init__(self):
        self.picker = ft.FilePicker() 

@ft.component
def BrokenView():
    di = get_di()
    return ft.Button("Click", on_click=lambda _: di.picker.pick_files())
```
