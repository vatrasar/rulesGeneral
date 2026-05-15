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

- **Main @ft.component First:** The primary function or class decorated with `@ft.component` (representing the main entry point of the module) MUST be defined at the top of the file, immediately after the imports.
- **Immediate Visibility:** State management (e.g., `use_state`, `use_effect`) and the core high-level `return` statement must be clearly visible at the top.
- **Implementation Details Last:** ALL secondary sub-component builders, helper functions, and detailed UI logic MUST be placed *below* the main function.

### 2. Flat Structure & Strict Component Extraction (Global Rule)

- **No "Widget Tree Hell" ANYWHERE:** Avoid deeply nesting anonymous Flet controls with structural comments (e.g., `# Header`, `# Action Center`).
- **MAX NESTING DEPTH:** You must not nest Flet controls deeper than **2-3 levels** in ANY single function.
- **Component Extraction:** If a UI section is distinct or requires deeper nesting, you MUST extract its inner parts into separate `@ft.component` functions, rather than keeping them as massive inline blocks or assigning them to local variables.
- **Location of Extracted Components (CRITICAL):**
  - **Screens (Views):** The main view file for a screen MUST contain exactly **one** `@ft.component` function. Sub-components MUST be extracted into their own **separate files** within a `ScreenComponents` folder inside the screen folder.
  - **Components:** Non-screen components SHOULD define their specific sub-components (other `@ft.component` functions) within the **same file** as the parent component, below the main component function, to keep them together. (Unless shared across multiple files).
- **Table of Contents Return:** Every `controls` list in your main function should read like a clean table of contents of clearly named sub-components.

#### ❌ BAD EXAMPLE (REJECTED - Deeply nested, anonymous sections with comments):

```python
@ft.component
def PromptEditor():
    return ft.Container(
        content=ft.Column(
            controls=[
                # Status/Info Bar (BAD: anonymous block instead of component)
                ft.Container(
                    content=ft.Row([ft.Icon(ft.Icons.INFO), ft.Text("Status")])
                ),
                # Top Text Field
                ft.TextField(label="Source Context"),
                # Action Center (BAD: deep nesting)
                ft.Row(
                    controls=[
                        ft.Container(content=ft.IconButton(icon=ft.Icons.TRANSLATE))
                    ]
                )
            ]
        )
    )
```

#### ✅ GOOD EXAMPLE (ACCEPTED - Shallow nesting, extracted @ft.component functions):

```python
# Assuming this is a general Component file, not a Screen view file.
# If it were a Screen view file, InfoBar and ActionCenter would be in separate files.

@ft.component
def PromptEditor():
    return ft.Container(
        content=ft.Column(
            controls=[
                InfoBar(),
                ft.TextField(label="Source Context"),
                ActionCenter(),
            ]
        )
    )

@ft.component
def InfoBar():
    return ft.Container(
        content=ft.Row([ft.Icon(ft.Icons.INFO), ft.Text("Status")])
    )

@ft.component
def ActionCenter():
    return ft.Row(
        controls=[
            ft.Container(content=ft.IconButton(icon=ft.Icons.TRANSLATE))
        ]
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
