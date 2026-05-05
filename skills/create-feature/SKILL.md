---
name: create-feature
description: Generates the initial directory structure and files for a new Feature (Module, Resources with Designer.cs, and standard folders) in the project following the architecture and naming conventions.
---

# Create Feature Skill

## When to use this skill
Use this skill whenever you need to create a new Feature in the application. A "Feature" in this project consists of:
- A directory in `Src/Features/FeatureName`.
- Standard subdirectories: `UI/FeatureStyles`, `UI/FeatureComponents`, `Domain`, and `Resources`.
- `FeatureNameModule.cs` for route registration.
- `FeatureNameStrings.resx` for localization (code is generated automatically).

## How to use it
The core of this skill is a bash script located at `scripts/create_feature.sh`.

### 1. Discovery
Always run the script with `--help` or without arguments first to confirm usage.

### 2. Execution
Run the bash script provided in the `scripts/` folder using the feature name:

```bash
bash .agents/skills/create-feature/scripts/create_feature.sh <feature_name>
```

### 3. What happens
The script will:
- Create the folder structure in `Src/Features/<feature_name>`.
- Generate the `Module.cs` boilerplate.
- Generate the `.resx` file. The C# class will be generated automatically during build.

## Patterns and Guidelines
- **Naming:** Use PascalCase for the feature name (e.g., `Reporting`).
- **Namespace:** It automatically sets the namespace to `[ProjectNamespace].Src.Features.FeatureName`.
- **Registration:** After creating the feature, you still need to register the module in `AppBootstrapper.cs` (though it's often done automatically via reflection if the project is set up that way).
