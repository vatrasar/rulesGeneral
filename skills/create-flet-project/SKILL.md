---
name: create-flet-project
description: Initializes a new Flet project using the standard feature-oriented architecture, including the necessary pytest configuration in pyproject.toml.
---

## When to use this skill
Use this skill when the user asks to start a new project from scratch or wants to replicate the current project's structure in a new directory.

## How to use it
1. **Navigate to the target directory:** Ensure you are in the root directory where the new project should be created.
2. **Run the initialization script:** Execute the `init_flet_project.sh` script with the desired project name.
   ```bash
   bash .agents/skills/create-flet-project/scripts/init_flet_project.sh my_new_project
   ```
3. **Customize Configuration:** Verify the generated `pyproject.toml` and `requirements.txt` and adjust dependencies if necessary.
4. **Initialize Virtual Environment:** (Optional) Recommend the user to create and activate a virtual environment.

## Included Features
- **Standard Structure:** Creates folders for `core`, `features`, `infrastructure`, and `shared`.
- **Testing Ready:** Automatically configures `pytest` with `pythonpath = ["src"]` in `pyproject.toml`.
- **Async First:** Includes `sqlalchemy` and `aiosqlite` in default dependencies.
- **Modern Flet:** Targets Flet 0.85+ by default.
- **Git Ready:** Includes a pre-configured `.gitignore` file.

## Best Practices
- Always check the current directory before running the script to avoid overwriting existing files.
- If the project requires specific features (e.g., voice recorder, database), use the `create-feature` skill after initialization.
