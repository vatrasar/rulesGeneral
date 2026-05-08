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
- `<FeatureUIPath>`: Path to the feature's UI directory (e.g., `Src/Features/Billing/UI`).
- `<ScreenName>`: PascalCase or snake_case name of the screen (e.g., `InvoiceDetails`).

### 2. Created Structure
The script creates the following directories in `<FeatureUIPath>/Screens/<ScreenName>/`:
- `ScreenComponents`
- `ScreenStyles`

## Patterns and Guidelines
- **File Creation:** After creating the directories, you will need to create the necessary view and logic Python modules following the project's coding standards.
