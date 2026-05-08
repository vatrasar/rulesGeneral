# UI Rules

## UI style

UI should look modern, add transition and hover animation etc. UI should give a "wow" effect. Make use of Flet's animation properties (e.g., `animate_opacity`, `animate_size`).

## Theme and colors

A global Theme MUST be defined in the `Shared/GlobalStyles` directory and applied to the Flet application.

- **Material 3 Colors:** You MUST strictly use Material 3 color roles (e.g., `ft.colors.PRIMARY`, `ft.colors.SECONDARY`, `ft.colors.SURFACE`, `ft.colors.ON_PRIMARY`, etc.) defined in the Flet theme.
- **Prohibition of Hardcoded Colors:** DO NOT use hex codes (e.g., `#FFFFFF`) or direct named colors in the Flet controls. Always rely on the Material 3 theme properties.
- **Custom Colors:** The creation and use of custom colors outside of the Material 3 theme palette is strictly forbidden unless I explicitly command you to do so. If authorized, they must be added to the global color definitions (e.g., in a `Shared/GlobalStyles/colors.py` module).

# 

## Styles folders

In Python/Flet, styles are typically dictionaries or objects containing kwargs for Flet controls.

- Files with styles related to a feature should be placed in the `UI/FeatureStyles` folder of that feature.
- Styles used across several features should be placed in the `Shared/GlobalStyles` folder.
- Styles used only in one screen should be placed in `ScreenStyles` inside of the screen folder.
- Styles used only in one component should be placed in `ComponentStyles` inside of the component folder.
- You can add new global and feature styles only if I directly tell you to do so. By default, you should place all new styles in `ScreenStyles` of the screen which will use these styles (or in `ComponentStyles` of the component).
- Files with styles should have a descriptive suffix (e.g., `buttons_styles.py`).
- To use a style module in your view, make sure it is properly imported and passed to the Flet controls.

### Styles separation from views

- DO NOT pass a massive list of hardcoded styling kwargs (margins, paddings, colors, borders) directly inside View files or control instantiations for complex styling.
- ALL reusable styles and animations MUST be extracted to dedicated Python style dictionaries/objects in the appropriate `Styles` directory (`FeatureStyles`, `GlobalStyles`, or `ScreenStyles`).
- Use Python's dictionary unpacking (`**my_style_dict`) to apply them to Flet controls.

## 🧩 Layout & Dimensioning Philosophy (Logic Over Values)

1. **Layout-First Approach:**
   
   - Prioritize **Fluid Layouts** over fixed dimensions. If a layout goal can be achieved using dynamic layout systems (like Flet's `ft.Row`, `ft.Column`, `expand=True`, or alignment), you MUST choose that over hardcoded `width`/`height`.
   - Use `expand=True` as the default for containers to adapt to screen sizes.

2. **Smart Hardcoding (The "Pragmatic Developer" Rule):**
   
   - **Spacing & Gaps:** Hardcoded values for Flet's `spacing`, `margin`, and `padding` are perfectly fine for fine-tuning the UI.
   - **Constraint Over Definition:** Use `max_width` or `min_width` (e.g., on `ft.Container`) to control the visual flow on large screens, rather than a hardcoded `width`.

3. **Anti-Pattern Warning (Margin Abuse):**
   
   - NEVER use large margins or paddings to "push" or "center" elements. You should use Flet's alignment properties (`alignment`, `horizontal_alignment`, `vertical_alignment`, `main_axis_alignment`) instead.

## Element Identifiers / References 🚨

**NEVER GENERATE AN INTERACTIVE ELEMENT WITHOUT A CLEAR IDENTIFIER.***

- **Naming Convention**: Use a consistent naming pattern (e.g., `[function]_[type]` like `login_button`, `employee_list`).
- **No Generic Names**: Do not use names like `button1`, `my_text`, or `input_field`.
