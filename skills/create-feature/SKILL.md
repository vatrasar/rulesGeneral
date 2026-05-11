---
name: create-feature
description: Generates the initial directory structure and Python modules for a new Feature using a script.
---

# Create Feature Skill

## When to use this skill
Use this skill whenever you need to start a new Feature in the application. A "Feature" in this project consists of a specific directory structure to ensure isolation and organization.

## How to use it
Run the provided script with the feature name as an argument:

```bash
bash skills/create-feature/scripts/create_feature.sh <FeatureName>
```

### 1. Naming
Use snake_case for the feature name (e.g., `billing`, `user_management`), following Python module naming conventions.

### 2. Created Structure
The script creates the following directories in `src/features/<feature_name>/`:
- `ui/feature_styles`
- `ui/feature_components`
- `domain`
- `resources`

## Patterns and Guidelines
- **Isolation:** Keep everything related to the feature inside its directory.
- **Registration:** After creating the structure, create a `feature_name_routes.py` file in the feature root with `ft.Route` definitions and register it in the central `NavHost` component.
