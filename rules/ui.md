---
trigger: always_on
---
# UI Rules

## UI Style

The UI should look modern, sleek, and responsive. Use smooth property transitions, hover effects, and clean spacing to achieve a high quality "wow" effect.

## Theme and Colors

The application relies on a centralized design palette defined in Slint:

- **Prohibition of Scattered Hardcoded Colors:** DO NOT hardcode arbitrary hex codes (e.g., `#FFFFFF`) or random color literals inside individual screen components. Use global palette properties instead.
- **Palette Definition:** Colors are defined in `src/shared/styles/palette.slint` using an exported global singleton:
  ```slint
  export global Palette {
      in-out property <color> background: #121212;
      in-out property <color> surface: #1e1e1e;
      in-out property <color> primary: #3b82f6;
      in-out property <color> on_primary: #ffffff;
      in-out property <color> text: #f3f4f6;
      in-out property <color> text_secondary: #9ca3af;
      in-out property <color> error: #ef4444;
      in-out property <color> success: #22c55e;
  }
  ```
- **Dark / Light Theme Switching:** Implement theme changes by updating properties on the `Palette` singleton.

## Typography and Fonts

- Global typography tokens (sizes, font weights, and families) should be defined centrally in `src/shared/styles/typography.slint`.
- Use consistent sizing tokens (e.g., `title_font_size`, `body_font_size`, `caption_font_size`).

## Icons and Assets

- Static icons and images should be kept in `assets/icons/` or `assets/images/`.
- Reference them in Slint components using the `@image-url("...")` syntax.
- Use vector SVG icons where possible for sharp rendering across different DPI scales.

## Styles and Modular Organization

- **Shared Styles:** Kept in `src/shared/styles/` (`palette.slint`, `theme.slint`).
- **Feature Styles:** When a feature requires custom styled components or styles used across its screens, place them in `src/features/<feature>/ui/styles.slint`.
- **Screen-Specific Styles:** Place local styles and components in `ScreenComponents` inside the screen folder.
- Separate components and styles cleanly; do not combine unrelated widget styles in a single massive `.slint` file.

## 🧩 Layout & Dimensioning Philosophy

1. **Layout-First Approach:**
   - Prioritize **Fluid Layouts** using Slint's `VerticalBox`, `HorizontalBox`, and `GridLayout` with `spacing` and `padding` properties over hardcoded `width` and `height`.
   - Use `horizontal-stretch: 1;` and `vertical-stretch: 1;` to allocate available space dynamically.

2. **Smart Sizing & Constraints:**
   - Spacing and padding are ideal for fine-tuning layout gaps.
   - Prefer `min-width`, `max-width`, `min-height`, and `preferred-width` over rigid fixed dimensions (`width: 300px`).

3. **Anti-Pattern (Padding/Margin Abuse):**
   - NEVER use massive padding/margins (e.g., `padding-left: 400px;`) to push elements to one side or center them. Use layout alignments (`alignment: center;`, spacer rectangles, or layouts) instead.

## Slint Element IDs (`id:`) 🚨

**ALL INTERACTIVE ELEMENTS AND MAIN DATA CONTAINERS MUST HAVE AN `id:`.**

- **Goal:** Enhances code readability, simplifies property bindings within the Slint component, and enables UI automation/testing via `slint-testing`.
- **Mandatory `id:`**: Interactive elements (`Button`, `LineEdit`, `CheckBox`, `ComboBox`, `ListView`) **MUST** include an `id:`.
- **Naming Convention:** Use `snake_case` with a descriptive name following the `[function]_[type]` pattern:
  - Good: `id: save_user_btn;`, `id: email_input;`, `id: items_list;`
  - Bad: `id: btn1;`, `id: input;`, `id: my_thing;`
- Place the `id:` declaration as the first property inside the element block:
  ```slint
  save_user_btn := Button {
      text: @tr("Save");
      clicked => { root.save_clicked(); }
  }
  ```
