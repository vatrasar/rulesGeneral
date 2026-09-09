---
name: create-screen
description: Generates the initial directory structure and MVI base files for a new Screen within a feature using a script.
---

# Create Screen Skill

## When to use this skill
Use this skill whenever you need to add a new Screen to an existing Feature. It creates the standard MVI structure (Screen, ViewModel, Contract).

## How to use it
The core of this skill is a bash script located at `scripts/create_screen.sh`.

### 1. Discovery
Always run the script with `--help` or without arguments first to confirm usage.

### 2. Execution
Run the provided script with the feature name and the screen name:

```bash
bash rules/skills/create-screen/scripts/create_screen.sh <featureName> <ScreenName> [base_feature_path] [package_name]
```

### 3. Parameters
- `<featureName>`: camelCase name of the feature (e.g., `questionManagement`).
- `<ScreenName>`: PascalCase name of the screen (e.g., `ManagePanel`, `QuestionDetails`).
- `[base_feature_path]`: (Optional) Path to the features directory. If omitted, the script auto-detects it.
- `[package_name]`: (Optional) Base package name. If omitted, the script detects it or defaults to `[ProjectPackage]`.

### 4. Created Structure
The script creates the screen folder under `<base_feature_path>/<featureName>/presentation/<screenName>` and generates the following files:
- `<ScreenName>Contract.kt`: Contains State, Event, Effect, and NavEffect classes.
- `<ScreenName>ViewModel.kt`: The Hilt ViewModel managing the MVI loop for the screen.
- `<ScreenName>Screen.kt`: The base Jetpack Compose screen.

## Patterns and Guidelines
- **Navigation:** The ViewModel should communicate navigation changes via `NavEffect` to the `NavGraph` level. Avoid passing the `NavController` directly into the `ViewModel` or `Screen`.
