# UI Rules

## UI style

UI should look modern, add transition and hover animation etc. UI should give a "wow" effect.

## Theme and colors

The application should use a cohesive design system with custom palettes defined in the project.

- **Prohibition of Hardcoded Colors:** DO NOT use hex codes (e.g., `#FFFFFF`) or named colors directly in the markup or styles if a theme variable exists. Use theme resources/variables instead.
- **Custom Colors:** If a unique color is absolutely necessary (e.g., for specific status indicators), it must be added to the global color definitions (e.g., in `Shared/GlobalStyles`).





## Styles folders

- Files with styles related to a feature should be placed in the `UI/FeatureStyles` folder of that feature.
- Styles used across several features should be placed in the `Shared/GlobalStyles` folder.
- Styles used only in one screen should be placed in `ScreenStyles` inside of the screen folder.
- Styles used only in one component should be placed in `ComponentStyles` inside of the component folder.
- You can add new global and feature styles only if I directly tell you to do so. By default, you should place all new styles in `ScreenStyles` of the screen which will use these styles (or in `ComponentStyles` of the component).
- Files with styles should have a descriptive suffix (e.g., `ButtonsStyles`).
- To use a style file in your view, make sure it is properly imported or included according to the framework's rules.

### Styles separation from views

- NEVER use inline styles directly inside View files or markup tags for complex styling.
- ALL reusable styles and animations MUST be extracted to dedicated style files in the appropriate `Styles` directory (`FeatureStyles`, `GlobalStyles`, or `ScreenStyles`).
- DO NOT ignore this rule even for small, one-off styles.

## 🧩 Layout & Dimensioning Philosophy (Logic Over Values)

1. **Layout-First Approach:**
   
   - Prioritize **Fluid Layouts** over fixed dimensions. If a layout goal can be achieved using dynamic layout systems (like Flexbox, Grid, or auto-sizing containers), you MUST choose that over hardcoded Width/Height.
   - Use stretch and fill behaviors as the default for containers to adapt to screen sizes.

2. **Smart Hardcoding (The "Pragmatic Developer" Rule):**
   
   - **Spacing & Gaps:** Hardcoded values for Margin, Padding, and Gaps are perfectly fine for fine-tuning the UI.
   - **Constraint Over Definition:** Use MaxWidth or MinWidth to control the visual flow on large screens, rather than a hardcoded Width. It’s better to say "this sidebar shouldn't exceed 300px" than to say "this sidebar IS 300px".

3. **Anti-Pattern Warning (Margin Abuse):**
   
   - NEVER use large margins or paddings to "push" or "center" elements (e.g., `Margin: 0 0 500px 0`). You should use layout alignment properties instead.


## Element Identifiers / References 🚨

**NEVER GENERATE AN INTERACTIVE ELEMENT WITHOUT A CLEAR IDENTIFIER.**

- **Goal**: To streamline code navigation and provide precise element referencing for testing and AI-assisted development.
- **Mandatory Identifiers**: All interactive elements (Buttons, Inputs) and primary data containers (Lists, Grids) **MUST** include a unique identifier (like `id`, `x:Name`, `data-testid`, or appropriate reference tag). **Failure to do this is UNACCEPTABLE.**
- **Naming Convention**: Use a consistent naming pattern (e.g., `[Function][Type]` like `loginButton`, `employeeList`).
- **No Generic Names**: Do not use names like `button1`, `myText`, or `input_field`.
- **Visibility**: The identifier attribute should be placed prominently within the tag to ensure high visibility.

## Layout Container Constraints

- **Styling Layouts**: Be careful when applying visual styles (like borders or backgrounds) directly to abstract layout panels if the framework doesn't naturally support it. If needed, wrap the layout in a dedicated visual container (like a Card or Border component).
