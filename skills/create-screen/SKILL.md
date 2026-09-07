---
name: create-screen
description: Generates the initial directory structure and files for a new Screen (Slint markup, Rust controller, and Screen.md documentation) in the project following the architecture and naming conventions.
---

# Create Screen Skill

## When to use this skill
Use this skill whenever you need to create a new Screen in the application. A "Screen" in this project consists of:
- `<ScreenName>Screen.slint` (Slint UI declaration).
- `<screen_name>_controller.rs` (Rust controller wiring callbacks and state).
- `Screen.md` (screen documentation).
- A `ScreenComponents/` directory for screen-local widgets.

## How to use it
The core of this skill is a bash script located at `scripts/create_screen.sh`.

### 1. Discovery
Always run the script with `--help` or without arguments first to confirm usage (if you haven't used it in this session).

### 2. Execution
Run the bash script provided in the `scripts/` folder using the following parameters:
- `feature_path`: The path to the feature directory (e.g., `src/features/reports`).
- `screen_name`: The name of the new screen (e.g., `MonthlyReport` or `overview`).

```bash
bash skills/create-screen/scripts/create_screen.sh <feature_path> <screen_name>
```

### 3. What happens
The script will:
- Create the directory `<feature_path>/ui/screens/<snake_case_name>/`.
- Generate `<ScreenName>Screen.slint` with basic layout and back button callback.
- Generate `<snake_case_name>_controller.rs` with `setup(ui: &AppWindow)` boilerplate.
- Generate `Screen.md` template.
- Create `ScreenComponents/` directory.

## Patterns and Guidelines
- **Naming:** Pass the screen name in PascalCase or snake_case; the script normalizes `.slint` components to PascalCase and directories/rust files to snake_case.
- **Routing:** After creating the screen, add its enum variant to the `Screen` enum in `app_window.slint`, render it conditionally in the view host, and wire its navigation in the feature/routing coordinator.
