---
name: create-screen
description: Generates the initial directory structure and MVI base files for a new Screen within a feature using a script.
---

# Create Screen Skill

## When to use this skill
Use this skill whenever you need to add a new Screen to an existing Feature. It creates the standard MVI structure (Screen, ViewModel, Contract).

## How to use it
Run the provided script with the feature name and the screen name:

```bash
bash rules/skills/create-screen/scripts/create_screen.sh <featureName> <ScreenName>
```

### 1. Parameters
- `<featureName>`: camelCase name of the feature (e.g., `questionManagement`).
- `<ScreenName>`: PascalCase name of the screen (e.g., `ManagePanel`, `QuestionDetails`).

### 2. Created Structure
The script creates the following directory `flashcardExpress/app/src/main/java/com/example/flashcardexpress/feature/<featureName>/presentation/<screenName>` (where `<screenName>` is camelCase) and generates the following files:
- `<ScreenName>Contract.kt`: Contains State, Event, Effect, and NavEffect classes.
- `<ScreenName>ViewModel.kt`: The Hilt ViewModel managing the MVI loop for the screen.
- `<ScreenName>Screen.kt`: The base Jetpack Compose screen.

## Patterns and Guidelines
- **Navigation:** The ViewModel should communicate navigation changes via `NavEffect` to the `NavGraph` level. Avoid passing the `NavController` directly into the `ViewModel` or `Screen`.
