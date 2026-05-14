#!/bin/bash

# Script to initialize a new Flet project with standard structure
# Usage: ./init_flet_project.sh <project_name>

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

echo "Initializing Flet project: $PROJECT_NAME"

# Create core structure
mkdir -p src/core/{base,data,enums,models,repository_contracts,services}
mkdir -p src/features
mkdir -p src/infrastructure/{database,repositories}
mkdir -p src/shared/{global_components,global_styles,resources}
mkdir -p src/assets
mkdir -p tests/{core_tests,features_tests,infrastructure_tests}

# Create dummy __init__.py files for package structure
find src tests -type d -exec touch {}/__init__.py \;

# Create initial main.py if it doesn't exist
if [ ! -f src/main.py ]; then
    cat <<EOF > src/main.py
import flet as ft

async def main(page: ft.Page):
    page.title = "$PROJECT_NAME"
    page.add(ft.Text("Welcome to $PROJECT_NAME!"))

if __name__ == "__main__":
    ft.run(main)
EOF
fi

# Create initial pyproject.toml if it doesn't exist
if [ ! -f pyproject.toml ]; then
    cat <<EOF > pyproject.toml
[project]
name = "$PROJECT_NAME"
version = "0.1.0"
description = "A Flet application"
readme = "README.md"
requires-python = ">=3.12"
dependencies = [
    "flet>=0.85.0",
    "sqlalchemy>=2.0.0",
    "aiosqlite>=0.20.0"
]

[tool.flet.app]
path = "src"

[tool.pytest.ini_options]
pythonpath = ["src"]
asyncio_mode = "auto"
asyncio_default_fixture_loop_scope = "function"
EOF
fi

# Create initial README.md
if [ ! -f README.md ]; then
    echo "# $PROJECT_NAME" > README.md
fi

# Create initial requirements.txt
if [ ! -f requirements.txt ]; then
    cat <<EOF > requirements.txt
flet>=0.85.0
sqlalchemy>=2.0.0
aiosqlite>=0.20.0
pytest>=8.0.0
pytest-asyncio>=0.23.0
EOF
fi

# Create initial .gitignore
if [ ! -f .gitignore ]; then
    cat <<EOF > .gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*\$py.class

# Distribution / packaging
build/
dist/
*.egg-info/

# Unit test / coverage reports
.pytest_cache/
.coverage
htmlcov/

# Environments
.env
.venv
env/
venv/
*Venv/

# Databases
*.db
*.sqlite3

# IDEs
.idea/
.vscode/

# OS files
.DS_Store
EOF
fi

echo "Project structure created successfully!"
