---
name: material-icons-usage
description: Use this skill whenever you add or use Material Icons (Material.Icons.Avalonia) in the project, to ensure the required MaterialIconStyles is registered or icons render as empty squares
---

## When to use this skill
Use this skill whenever you add a Material Icon (`<material:MaterialIcon Kind="..." />` / `Material.Icons.Avalonia`) to any XAML file, or when you work on any screen/component that uses these icons. This prevents the common bug where icons show up as blank empty squares.

## How to use it
1. Whenever you use `<material:MaterialIcon Kind="..." />` (namespace `xmlns:material="using:Material.Icons.Avalonia"`), always verify the library styles are registered.
2. Check the global app styles in `project/App.axaml`:
   - The `materialIcons` namespace must be declared on the root `<Application>` element:
     ```xml
     xmlns:materialIcons="clr-namespace:Material.Icons.Avalonia;assembly=Material.Icons.Avalonia"
     ```
   - `Application.Styles` MUST contain `<materialIcons:MaterialIconStyles />`.
3. If either is missing, add it. Without this style, `Material.Icons.Avalonia` (v2.x and higher) cannot load the icon font and every `MaterialIcon` renders as an empty square.

## Gotchas
- The namespace in view files is `xmlns:material="using:Material.Icons.Avalonia"` and control is `<material:MaterialIcon ...>`, but the required style registration in `App.axaml` uses `xmlns:materialIcons="clr-namespace:Material.Icons.Avalonia..."`. Both refer to the same library.
- Adding the required styles is a one‑time setup in `App.axaml`; fixing it there fixes all icons in the app (screens, icon buttons, templates, etc.).