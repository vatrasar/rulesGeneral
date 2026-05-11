---
name: create-screen
description: Generates the initial directory structure and Python module files for a new Screen within a feature using a script.
---

# Create Screen Skill

## When to use this skill
Use this skill whenever you need to add a new Flet Screen (View) to an existing Feature.

## How to use it
Run the provided script with the feature's UI path and the screen name:

```bash
bash skills/create-screen/scripts/create_screen.sh <FeatureUIPath> <ScreenName>
```

### 1. Parameters
- `<feature_ui_path>`: Path to the feature's UI directory (e.g., `src/features/billing/ui`).
- `<screen_name>`: snake_case name of the screen (e.g., `invoice_details`).

### 2. Created Structure
The script creates the following directories in `<feature_ui_path>/screens/<screen_name>/`:
- `screen_components`
- `screen_styles`

## Patterns and Guidelines
- **File Creation:** After creating the directories, create a `*_view.py` file with an `@ft.component` function for the screen, following the project's declarative UI coding standards.
