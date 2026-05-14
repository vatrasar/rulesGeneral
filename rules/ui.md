---
trigger: always_on
---

# UI Rules

## UI style

UI should look modern, add transition and hover animation etc. UI should give a "wow" effect. Make use of Flet's animation properties (e.g., `animate_opacity`, `animate_size`).

## Theme and colors

A global Theme MUST be defined in the `shared/global_styles` directory and applied to the Flet application.

- **Material 3 Colors (Flet 0.85+):** You MUST strictly use Material 3 color roles (e.g., `ft.Colors.PRIMARY`, `ft.Colors.SECONDARY`, `ft.Colors.SURFACE`, `ft.Colors.ON_PRIMARY`, etc.).
  - **Capitalized Accessors:** Always use **capitalized** class names for accessing standard Flet constants (`ft.Colors`, `ft.Icons`, `ft.Padding`, `ft.Margin`, `ft.Border`) to prevent `AttributeError`.
  - **Removed Tokens Warning:** Some older tokens have been removed and will cause an `AttributeError`.
    - **DO NOT USE** `ft.Colors.BACKGROUND` -> Use `ft.Colors.SURFACE`.
    - **DO NOT USE** `ft.Colors.SURFACE_VARIANT` -> Use `ft.Colors.SURFACE_CONTAINER`.
  - **ColorScheme Constraints:** When initializing `ft.ColorScheme`, DO NOT use `background`, `on_background`, or `surface_variant` arguments as they are removed in Flet 0.85+.
  - **Visual Density:** Always use `ft.VisualDensity` (e.g., `ft.VisualDensity.COMFORTABLE`), NOT `ft.ThemeVisualDensity`.
- **Prohibition of Hardcoded Colors:** DO NOT use hex codes (e.g., `#FFFFFF`) or direct named colors in the Flet controls. Always rely on the Material 3 theme properties.
- **Custom Colors:** The creation and use of custom colors outside of the Material 3 theme palette is strictly forbidden unless I explicitly command you to do so. If authorized, they must be added to the global color definitions (e.g., in a `shared/global_styles/colors.py` module).

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

## Flet Async-First & Imperative UI Policy

**Context:** Flet has shifted towards an imperative, asynchronous API. Legacy callback-driven event handling for I/O, dialogs, and pickers is considered bad practice and often deprecated.

When writing or refactoring Flet code, you MUST adhere to the following rules:

*  **Async Handlers & Commands:** All UI event handlers and ViewModel commands must be defined as `async def`. Do not mix sync and async execution paths in the UI layer.
* **Await Direct Results:** For components that interact with the OS or require user input (e.g., `FilePicker`, `AlertDialog`, `BottomSheet`, `client_storage`), you must `await` the method and capture the result directly. 
   - *Example (DO):* `path = await file_picker.get_directory_path()`
   - *Example (DON'T):* Binding an event to `on_result` and waiting for `FilePickerResultEvent`.
* **No Phantom Events:** Do not use or reference deprecated or non-existent event types like `FilePickerResultEvent`. Always check the return type of the awaited method (e.g., `Optional[str]`, `List[FilePickerFile]`).
* **Prevent UI Blocking:** Since the UI is async, synchronous database operations (e.g., standard SQLAlchemy with sqlite3) on the main thread will block the event loop. Always ensure database calls within ViewModels or Handlers are handled asynchronously 

## Styles folders

In Python/Flet, styles are typically dictionaries or objects containing kwargs for Flet controls.

- Files with styles related to a feature should be placed in the `ui/feature_styles` folder of that feature.
- Styles used across several features should be placed in the `shared/global_styles` folder.
- Styles used only in one screen should be placed in `screen_styles` inside of the screen folder.
- Styles used only in one component should be placed in `component_styles` inside of the component folder.
- You can add new global and feature styles only if I directly tell you to do so. By default, you should place all new styles in `screen_styles` of the screen which will use these styles (or in `component_styles` of the component).
- Files with styles should have a descriptive suffix (e.g., `buttons_styles.py`).
- To use a style module in your view, make sure it is properly imported and passed to the Flet controls.

### Styles separation from views

- **PRAGMATIC STYLE EXTRACTION:** All styling that groups multiple properties (e.g., `ft.TextStyle`, `ft.ButtonStyle`, `ft.Animation`) or is significantly reused (e.g., a shared `border_radius`) MUST be extracted to dedicated style files.
- **PROHIBITION OF ATOMIZED CONSTANTS:** Do NOT extract single properties (like a one-off `spacing`, `padding`, or `color`) into standalone constants (e.g., `SPACING_SMALL = 10`). These should remain as inline arguments to keep the UI code readable and avoid unnecessary file-jumping.
- **Extraction Goal:** The goal of extraction is to reduce "Style Spaghetti" and keep the UI component logic focused on structure, not to move every single number to a separate file.
- **Dictionary Unpacking:** Use Python's dictionary unpacking (`**my_style_dict`) when using dictionary-based styles, but prefer using native Flet style objects (`style=Styles.MY_TEXT_STYLE`) where possible.

## 🧩 Layout & Dimensioning Philosophy (Logic Over Values)

1. **Layout-First Approach:**
   
   - Prioritize **Fluid Layouts** over fixed dimensions. If a layout goal can be achieved using dynamic layout systems (like Flet's `ft.Row`, `ft.Column`, `expand=True`, or alignment), you MUST choose that over hardcoded `width`/`height`.
   - Use `expand=True` as the default for containers to adapt to screen sizes.

2. **Smart Hardcoding (The "Pragmatic Developer" Rule):**
   
   - **Spacing & Gaps:** Hardcoded values for Flet's `spacing`, `margin`, and `padding` are perfectly fine for fine-tuning the UI.
   - **Constraint Over Definition:** Use `max_width` or `min_width` (e.g., on `ft.Container`) to control the visual flow on large screens, rather than a hardcoded `width`.

3. **Anti-Pattern Warning (Margin Abuse):**
   
   - NEVER use large margins or paddings to "push" or "center" elements. You should use Flet's alignment properties (`alignment`, `horizontal_alignment`, `vertical_alignment`, `main_axis_alignment`) instead.



## 🏗️ Top-Down & Flat UI Structure

To ensure maintainability and readability, you MUST strictly follow these architectural principles. Failure to do so will result in rejected code.

### 1. Top-Down Organization (General to Specific)

- **Main Component First:** The primary function or class for the UI component MUST be defined at the top of the file.
- **Immediate Visibility:** State management (e.g., `use_state`, `use_effect`) and the core high-level `return` statement must be clearly visible at the top.
- **Implementation Details Last:** ALL secondary sub-component builders, helper functions, and detailed UI logic MUST be placed *below* the main function.

### 2. Flat Structure & Strict Nesting Limits (Global Rule)

- **No "Widget Tree Hell" ANYWHERE:** This applies to the main function AND all private helper functions.
- **MAX NESTING DEPTH:** You must not nest Flet controls (e.g., `Column` inside `Container` inside `Row`) deeper than **2-3 levels** in ANY single function.
- **Recursive Extraction:** If a sub-component (like `HeaderSection`) starts requiring deeper nesting, you MUST extract its inner parts into further well-named local variables or additional `@ft.component` functions (e.g., `LogoSection`, `HeaderActions`).
- **Table of Contents Return:** Every `controls` list, whether in the main component or a sub-component, must read like a clean table of contents, abstracting away the low-level styling and padding.

#### ❌ BAD EXAMPLE (REJECTED - Deeply nested and using old naming style):

```python
def build_header(): # Incorrect naming and missing @ft.component
    return ft.Container(
        padding=20,
        content=ft.Row(
            controls=[
                ft.Column(
                    controls=[
                        ft.Icon(ft.Icons.PERSON),
                        ft.Text("User Profile") # Too deep! Hard to read.
                    ]
                ),
                ft.ElevatedButton("Logout")
            ]
        )
    )
```

#### ✅ GOOD EXAMPLE (ACCEPTED - Shallow nesting, extracted @ft.component):

```python
@ft.component
def HeaderSection():
    # Inner parts extracted to local variables to keep nesting shallow
    profile_section = ft.Column(
        controls=[ft.Icon(ft.Icons.PERSON), ft.Text("User Profile")]
    )

    logout_button = ft.ElevatedButton("Logout")

    return ft.Container(
        padding=20,
        content=ft.Row(controls=[profile_section, logout_button])
    )
```

## 🧠 Lifecycle & Resource Management 🚨

- **Global Event Cleanup:** When assigning handlers to global objects (e.g., `ft.Page.on_resize`, `ft.Page.on_keyboard_event`) inside a component using `ft.use_effect`, you **MUST** return a cleanup function to clear or restore the handler when the component is unmounted. 
  - *Example:* `return lambda: setattr(page, "on_resize", None)`
- **Prevent Memory Leaks:** Failure to clean up global listeners prevents the component and its state from being garbage collected, leading to memory leaks and unexpected behavior on other screens.
- **Prefer Local Listeners:** Whenever possible, use local event listeners (e.g., `on_size_change` on a root container) instead of global ones to ensure automatic cleanup by the framework.

## Element Identifiers / References 🚨

**NEVER GENERATE AN INTERACTIVE ELEMENT WITHOUT A CLEAR IDENTIFIER.***

- **Naming Convention**: Use a consistent naming pattern (e.g., `[function]_[type]` like `login_button`, `employee_list`).
- **Use `key`, NOT `id`**: ALWAYS use the `key` property to assign unique identifiers to controls in their constructor. Flet controls DO NOT accept an `id` argument in `__init__`, and using it will cause a `TypeError`.
- **No Generic Names**: Do not use names like `button1`, `my_text`, or `input_field`.
