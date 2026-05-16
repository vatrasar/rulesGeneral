---
trigger: always_on
---
# Framework Specific Rules

## Flet 0.85+ Specific Rules

Due to breaking API changes introduced in Flet 0.85.0, you MUST strictly adhere to the following rules when generating or modifying code:

1. **Alignment, Mouse Cursor & Hover:**
   - **ft.Alignment Constants:** The old lowercase constants like `ft.alignment.center` have been removed. You MUST use the **capitalized** constants from the `ft.Alignment` class (e.g., `alignment=ft.Alignment.CENTER`, `alignment=ft.Alignment.CENTER_RIGHT`) to prevent `AttributeError`.
   - **Implicit Mouse Cursor:** Do not explicitly set the `cursor` property (e.g., `cursor=ft.MouseCursor.CLICK`) on `ft.Container` or other clickable controls. Flet 0.85+ manages the pointer cursor automatically when an `on_click` event handler is provided.
   - **Event Data Types:** In Flet 0.85+, `e.data` is a properly typed Python value — not a raw string. For example, `on_hover` delivers a `bool`, text events deliver a `str`, etc. Use the value directly without string comparisons or conversions (e.g., `is_hovered = e.data`).
2. **Text Styling:**
   - `ft.Text` no longer accepts `letter_spacing` directly in its constructor. Text styling properties like `letter_spacing` must be passed via a `ft.TextStyle` object to the `style` parameter (e.g., `style=ft.TextStyle(letter_spacing=-1)`).
3. **Padding, Margin & BorderRadius:**
   - **Use Uppercase Classes:** You MUST use the **capitalized** class names (e.g., `ft.Padding`, `ft.Margin`, `ft.BorderRadius`) for these properties. 
   - **Avoid Lowercase Aliases:** DO NOT use lowercase aliases like `ft.padding.only` or `ft.margin.all`. In Flet 0.85+, these are often just modules and do not contain helper methods (like `only`, `all`, `symmetric`), which will cause an `AttributeError`.
   - **Correct Usage:** `padding=ft.Padding(left=20)`, `margin=ft.Margin.all(10)`, `border_radius=ft.BorderRadius.all(8)`.
4. **Size Constraints:**
   - **No min/max dimensions:** `ft.Container` and other controls in version 0.85 DO NOT support `min_width`, `max_width`, `min_height`, or `max_height`. 
5. **Animation API:**
   - **Use ft.Animation:** Always use `ft.Animation` directly. The `ft.animation` module is not available/used.
   - **Implicit Animation Property:** Use the `animate` property (e.g., `animate=ft.Animation(...)`) instead of `animate_size` or other specific animation properties if they are missing.

## Flet Async-First & Imperative UI Policy

**Context:** Flet has shifted towards an imperative, asynchronous API. Legacy callback-driven event handling for I/O, dialogs, and pickers is considered bad practice and often deprecated.

When writing or refactoring Flet code, you MUST adhere to the following rules:

* **Async Handlers & Commands:** All UI event handlers and ViewModel commands must be defined as `async def`. Do not mix sync and async execution paths in the UI layer.
* **Await Direct Results:** For components that interact with the OS or require user input (e.g., `FilePicker`, `AlertDialog`, `BottomSheet`, `client_storage`), you must `await` the method and capture the result directly. 
  - *Example (DO):* `path = await file_picker.get_directory_path()`
  - *Example (DON'T):* Binding an event to `on_result` and waiting for `FilePickerResultEvent`.
* **No Phantom Events:** Do not use or reference deprecated or non-existent event types like `FilePickerResultEvent`. Always check the return type of the awaited method (e.g., `Optional[str]`, `List[FilePickerFile]`).
* **Prevent UI Blocking:** Since the UI is async, synchronous database operations (e.g., standard SQLAlchemy with sqlite3) on the main thread will block the event loop. Always ensure database calls within ViewModels or Handlers are handled asynchronously 

## State Management & Reactivity Limitations

Flet's `@ft.observable` decorator has specific limitations regarding how it detects changes in collections. You MUST handle state updates according to these rules to ensure the UI re-renders correctly:

1. **Lists and Dictionaries (Auto-wrapped):**
   - Flet automatically wraps `list` and `dict` objects in internal observable variants (e.g., `ObservableList`). 
   - In-place mutations like `my_list.append()` or `my_dict.update()` WILL trigger a re-render automatically.
2. **Sets (`set`) and Custom Objects (Blind spots):**
   - Flet DOES NOT provide an `ObservableSet` and does not auto-wrap custom domain objects.
   - In-place mutations on a `set` (e.g., `my_set.add()`, `my_set.remove()`) or modifying attributes of a nested object WILL NOT trigger a re-render.
3. **The Immutability Rule for Sets:**
   - To update a `set` in an observable state, you MUST treat it immutably. 
   - Create a new copy of the set, modify the copy, and assign it back to the state property. 
   - **Crucial Warning:** Do not mutate the original set *before* copying it, as Flet will compare the new assignment to the currently held (already mutated) object, determine `Old == New`, and skip the re-render.
   - *Example (DO):*
     ```python
     new_set = set(state.my_set)
     new_set.add(item)
     state.my_set = new_set
     ```
   - *Example (DON'T):*
     ```python
     state.my_set.add(item) # Mutates in-place (no re-render)
     state.my_set = set(state.my_set) # Reassigns identical content (still no re-render)
     ```
