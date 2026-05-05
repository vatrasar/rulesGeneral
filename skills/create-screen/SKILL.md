---
name: create-screen
description: Generates the initial directory structure and files for a new Screen (ViewModel, View.axaml, View.axaml.cs, and ScreenStyles) in the project following the architecture and naming conventions.
---

# Create Screen Skill

## When to use this skill
Use this skill whenever you need to create a new Screen in the application. A "Screen" in this project consists of:
- `NameViewModel.cs` (inheriting from `ViewModelBase` and implementing `IRoutableViewModel`).
- `NameView.axaml` (ReactiveUI-based UserControl).
- `NameView.axaml.cs` (code-behind).
- `Screen.md` (documentation).
- A `ScreenStyles/` directory.

## How to use it
The core of this skill is a bash script located at `scripts/create_screen.sh`.

### 1. Discovery
Always run the script with `--help` or without arguments first to confirm usage (if you haven't used it in this session).

### 2. Execution
Run the bash script provided in the `scripts/` folder using the following parameters:
- `feature_ui_path`: The path to the `UI` directory of the feature where the screen should be created (e.g., `Src/Features/Malpa/UI`).
- `screen_name`: The PascalCase name of the new screen (e.g., `Pies`).

```bash
bash .agents/skills/create-screen/scripts/create_screen.sh <feature_ui_path> <screen_name>
```

### 3. What happens
The script will:
- Create the folder `.agents/skills/create-screen/scripts/../../<feature_ui_path>/Screens/<screen_name>`.
- Generate the four required files with pre-filled boilerplate logic (namespaces, class names, routing segment, and documentation template).
- Create a `ScreenStyles` directory inside the screen folder.

## Patterns and Guidelines
- **Naming:** The script automatically converts the `screen_name` to `kebab-case` for the `UrlPathSegment`.
- **Namespace:** It derives the namespace from the file path, ensuring it matches the project's folder architecture.
- **Routing:** After creating the screen, you still need to register it in the corresponding `Module.cs` file (e.g., `MalpaModule.cs`).
