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
Use PascalCase for the feature name (e.g., `Billing`, `UserManagement`).

### 2. Created Structure
The script creates the following directories and Python `__init__.py` files in `Src/Features/<FeatureName>/`:
- `UI/FeatureStyles`
- `UI/FeatureComponents`
- `Domain`
- `Resources`

## Patterns and Guidelines
- **Isolation:** Keep everything related to the feature inside its directory.
- **Registration:** After creating the structure, make sure to add the feature's routing registration to the central configuration module.
