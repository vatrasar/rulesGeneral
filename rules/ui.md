# UI Rules

## UI style

UI should look modern, add transition and hover/ripple animation etc. UI should give a "wow" effect. Use Jetpack Compose Material 3 components and principles.

## Theme and colors

The application should use a cohesive Material 3 design system with custom palettes defined in the project.

- **Prohibition of Hardcoded Colors:** DO NOT use hex codes (e.g., `Color(0xFFFFFFFF)`) or fixed colors directly in the modifiers or Composables if a theme variable exists. Use theme colors instead (e.g., `MaterialTheme.colorScheme.primary`).
- **Custom Colors:** If a unique color is absolutely necessary, it must be added to the global color definitions in the Compose Theme.

## Styles and Modifiers

- Jetpack Compose uses `Modifier` instead of separate style files.
- Styles used across several features or common modifier chains should be extracted as extension functions on `Modifier` or custom `@Composable` wrappers in the `Shared/Theme` or `Shared/GlobalComponents` folder.
- **Do not create complex inline Modifier chains that are heavily duplicated.** Extract them.

## 🧩 Layout & Dimensioning Philosophy (Logic Over Values)

1. **Layout-First Approach:**
   
   - Prioritize **Fluid Layouts** over fixed dimensions. Use Compose layout containers (`Column`, `Row`, `Box`) and modifiers like `fillMaxSize()`, `fillMaxWidth()`, and `weight()` over hardcoded Width/Height.
   - Use stretch and fill behaviors as the default for containers to adapt to screen sizes.

2. **Smart Hardcoding (The "Pragmatic Developer" Rule):**
   
   - **Spacing & Gaps:** Hardcoded values for Padding and Arrangement spaces (e.g., `Arrangement.spacedBy(8.dp)`, `modifier.padding(16.dp)`) are perfectly fine for fine-tuning the UI. Use `dp` for dimensions and `sp` for text sizes.
   - **Constraint Over Definition:** Use `widthIn(max = ...)` or `heightIn(max = ...)` to control the visual flow on large screens, rather than a hardcoded width.

3. **Anti-Pattern Warning (Padding Abuse):**
   
   - NEVER use large paddings to "push" or "center" elements. You should use layout alignment properties instead (e.g., `Arrangement.Center`, `Alignment.Center`, `weight()`).

## Element Identifiers / References 🚨

**NEVER GENERATE AN INTERACTIVE ELEMENT WITHOUT A CLEAR IDENTIFIER.**

- **Goal**: To streamline code navigation and provide precise element referencing for UI testing and AI-assisted development.
- **Mandatory Identifiers**: All interactive elements (Buttons, TextFields) and primary data containers (LazyColumns, LazyRows) **MUST** include a `testTag` modifier (e.g., `Modifier.testTag("loginButton")`). **Failure to do this is UNACCEPTABLE.**
- **Naming Convention**: Use a consistent naming pattern (e.g., `[Function][Type]` like `loginButton`, `employeeList`).
- **No Generic Names**: Do not use names like `button1`, `myText`, or `input_field`.

## Layout Container Constraints

- **Styling Layouts**: Be careful when applying visual styles (like borders or backgrounds) directly to abstract layout panels. If needed, wrap the layout in a dedicated visual container (like `Card`, `Surface`, or use `Modifier.background()` and `Modifier.border()`).
