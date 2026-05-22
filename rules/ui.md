---
trigger: always_on
---
# UI Rules

## UI style

UI should look modern, add transition and hover animation etc. UI should give "wow" effect.

## Theme and colors

The application use the **FluentTheme** design system with custom palettes defined in the project.

- **Prohibition of Hardcoded Colors:** DO NOT use hex codes (e.g., `#FFFFFF`) or named colors (e.g., `Red`, `Blue`) directly in XAML or code. Use theme resources instead.
- **Dynamic Resources:** Always use `{DynamicResource}` for brushes and colors to ensure compatibility with Light/Dark mode switching.
- **Custom Colors:** If a unique color is absolutely necessary (e.g., for specific status indicators), it must be added to Shared/GlobalStyles/Colors.axaml
- additionaly to standard FluentTheme colors i defined (in AppThemeStyles)
  - ErrorColor
  - OnErrorColor
  - SuccessColor
  - OnSuccessColor



## Fonts

Use "HeaderFont" for headers, large texts i mean:
{StaticResource HeaderFont}. 
Fonts are defined in Fonts.axaml in Resources

## Icons

You have installed Material.Icons.Avalonia and Avalonia.Fluent.Icons so you can use them for icons

## Styles folders

- Files with styles related to feature should be placed in UI/FeatureStyles folder of feature.
- Styles used across several features should be placed in Shared/GlobalStyles folder.
- Styles used only in one screen should be placed in style ScreenStyles inside of screen folder
- Styles used only in one component should be placed in style ComponentStyles inside of component folder
- You can add new global and feature styles only if i directly tell to do so. For default you should place all new styles in ScreenStyles of screen which will use this styles (or in ComponentStyles of component which will use this styles)
- There should be separated files for styles for different types of controls (for example styles for Buttons and TextBlocks should be in separated files). Colors also should be placed in separated style file. 
- to use file with styles in your view you need to import it for example
- Files with styles should have name with suffix "Styles" for example ButtonsStyles.axaml
- Colors should be kept in
- To include resources:
   <ResourceDictionary.MergedDictionaries> 
  </ResourceDictionary.MergedDictionaries>

### Styles separation from views

- NEVER use inline `<UserControl.Styles>` or `<Window.Styles>` or `<ANYBuidlInControl.Styles>` directly inside View files (like UserControl or Window).
- ALL styles (and animations) MUST be extracted to dedicated `.axaml` files in the appropriate `Styles` directory (FeatureStyles, GlobalStyles or ScreenStyles).
- In the View file, you are ONLY allowed to import styles using `<StyleInclude Source="..." />`.
- DO NOT ignore this rule even for small, one-off styles.

### ControlTheme

- Control themes should be placed in same folders as styles
- files with ControlThemes should have suffix "ControlTheme" for example MalpaControlTheme.axaml

## 🧩 Layout & Dimensioning Philosophy (Logic Over Values)

1. **Layout-First Approach:**
   
   - Prioritize **Fluid Layouts** over fixed dimensions. If a layout goal can be achieved using `Grid` (star/auto sizing), `StackPanel` (with `Spacing`), or `DockPanel`, you MUST choose that over hardcoded `Width`/`Height`.
   - Use `HorizontalAlignment="Stretch"` and `VerticalAlignment="Stretch"` as the default behavior for containers.

2. **Smart Hardcoding (The "Pragmatic Developer" Rule):**
   
   - **Spacing & Gaps:** Hardcoded values for `Margin`, `Padding`, and `Spacing` are perfectly fine for fine-tuning the UI.
   - **Constraint Over Definition:** Use `MaxWidth` or `MinWidth` to control the visual flow on large screens, rather than a hardcoded `Width`. It’s better to say "this sidebar shouldn't exceed 300px" than to say "this sidebar IS 300px".

3. **Anti-Pattern Warning (Margin Abuse):**
   
   - NEVER use large margins or paddings to "push" or "center" elements (e.g., `Margin="0,0,500,0"`), you should use layouts instead of that

4. Use `Grid` for complex, multi-dimensional layouts where `StackPanel` would require excessive nesting.

## AvaloniaUI: Dependency Property Value Precedence (STRICT BAN on mixing local values with dynamic styles)

**RULE:** In AvaloniaUI, values set locally directly on the control tag (e.g., `<Border Width="720">`) HAVE THE HIGHEST PRECEDENCE and will permanently override any values set inside `<Style>` blocks.

If any property (e.g., `Width`, `Height`, `Opacity`, `Background`, `Margin`) needs to be dynamically modified using style classes (e.g., `Classes.hidden="{Binding...}"` or pseudo-classes like `:pointerover`), **YOU MUST NOT** assign its value locally on the control tag.

**WHY:** The local value completely blocks the styling engine for that specific property. The UI framework stops evaluating at the tag level and ignores the logic hidden inside the style selectors.

**🔴 BAD (Legacy / Bug-prone):**

```xml
<Border Width="720" >
    <Border.Styles>
        <Style Selector="Border.hidden">
            <Setter Property="Width" Value="0" />
        </Style>
    </Border.Styles>
</Border>
```

## x:Name 🚨

**NEVER GENERATE AN INTERACTIVE XAML ELEMENT WITHOUT AN x:Name.**

- **Goal**: To streamline code navigation and provide precise element referencing for AI-assisted development and prompt engineering.

- **Mandatory x:Name**: All interactive elements (`Button`, `TextBox`, `CheckBox`, `ComboBox`) and primary data containers (`ListBox`, `DataGrid`, `ItemsControl`) **MUST** include an `x:Name` attribute. **Failure to do this is UNACCEPTABLE.**

- **Naming Convention**: Use PascalCase. Names must follow the `[Function][Type]` pattern (e.g., `LoginButton`, `EmployeeList`, `ScheduleGrid`).

- **No Generic Names**: Do not use names like `Button1`, `MyTextBlock`, or `Input_Field`.

- **Attribute Placement**: The `x:Name` attribute should be placed as the **first or second attribute** within the XAML tag, immediately following the element type, to ensure high visibility.

### ✅ good:

```xml
<Button x:Name="SaveUserButton" Content="Zapisz" />
<ItemsControl x:Name="DaysItemsControl" />
```

### ❌ bad:

```xml
<Button Content="Zapisz" />
<ItemsControl  />
```

## Avalonia XAML Constraints

- **Border Property Isolation**: Never apply `BorderBrush`, `BorderThickness`, or `CornerRadius` directly to layout panels (e.g., `Grid`, `StackPanel`, `DockPanel`, `WrapPanel`, `UniformGrid`) or `ItemsControl`. These properties are not defined for these types in Avalonia.
- **Required Pattern**: To add a border, background, or rounded corners to these elements, they must be wrapped in a `Border` control with the properties defined on the wrapper.
