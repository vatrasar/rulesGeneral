---
name: create-feature
description: Generates the initial directory structure and files for a new Feature (Domain, UI Slint files, and Rust controller) following the architecture and naming conventions.
---

# Create Feature Skill

## When to use this skill
Use this skill whenever you need to create a new Feature in the application. A "Feature" consists of:
- A directory in `src/features/<feature_name>`.
- Standard subdirectories: `ui/screens`, `ui/components`, `domain/models`, `domain/services`, `domain/usecases`, `domain/enums`.
- `controller.rs` for Slint callback wiring.
- `mod.rs` for module exports.
- `<feature_name>.slint` for initial UI declarations.

## How to use it
The core of this skill is a bash script located at `scripts/create_feature.sh`.

### 1. Discovery
Always run the script with `--help` or without arguments first to confirm usage.

### 2. Execution
Run the bash script provided in the `scripts/` folder using the feature name:

```bash
bash skills/create-feature/scripts/create_feature.sh <feature_name>
```

### 3. What happens
The script will:
- Create the folder structure in `src/features/<feature_name>`.
- Generate `controller.rs` and `mod.rs` boilerplate.
- Generate domain subdirectories and `domain/mod.rs`.
- Generate the initial `<feature_name>.slint` component.

## Patterns and Guidelines
- **Naming:** Pass the feature name in PascalCase or snake_case (e.g., `Reports` or `employee_management`). The script normalizes folder names to `snake_case` and struct names to `PascalCase`.
- **Registration:** After creating the feature, expose and invoke its `Controller::setup(&ui)` in the application startup or routing coordinator.
