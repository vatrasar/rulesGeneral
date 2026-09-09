---
name: create-feature
description: Generates the initial directory structure and base Navigation files for a new Feature using a script.
---

# Create Feature Skill

## When to use this skill
Use this skill whenever you need to start a new Feature in the application. A "Feature" in this Android project consists of a specific directory structure to ensure isolation and organization, along with base Navigation files.

## How to use it
The core of this skill is a bash script located at `scripts/create_feature.sh`.

### 1. Discovery
Always run the script with `--help` or without arguments first to confirm usage.

### 2. Execution
Run the provided script with the feature name (in camelCase) as an argument:

```bash
bash rules/skills/create-feature/scripts/create_feature.sh <featureName> [base_feature_path] [package_name]
```

### 3. Parameters
- `<featureName>`: camelCase name of the feature (e.g., `userProfile`, `billing`).
- `[base_feature_path]`: (Optional) Path to the features directory. If omitted, the script auto-detects it.
- `[package_name]`: (Optional) Base package name. If omitted, the script detects it or defaults to `[ProjectPackage]`.

### 4. Created Structure
The script creates the following directories and files under `<base_feature_path>/<featureName>/`:
- `domain/`
- `presentation/components/`
- `navigation/`
  - `<FeatureName>Navigation.kt` (Setup function for NavGraphBuilder)
  - `<FeatureName>Screen.kt` (Sealed interface with Serializable routes)

## Patterns and Guidelines
- **Isolation:** Keep everything related to the feature inside its directory.
- **Registration:** After creating the feature, remember to call the `setup<FeatureName>Navigation(navController)` function in the main `NavGraph.kt`.
