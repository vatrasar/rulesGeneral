---
name: create-deb-package
description: Builds a Rust desktop application and packages it into a Debian .deb file. Use when the user asks to create, build, or release a .deb package, or to write/customize a .deb build script.
---

# Create .deb Package

## When to use this skill

Use this when asked to:
- Build / package a Rust Slint desktop app into a `.deb` file.
- Write or fix a `.deb` build script.
- Change install prefix, package/version handling, dependencies, or desktop integration.

## Generic rules (apply in any project)

This skill is project-agnostic. When writing a `.deb` build script, always:

### a) Version as an argument
- The version MUST be a **required positional argument** to the script, not a hardcoded constant.
- Debian format: plain number, no leading `v` (e.g. `1.2.3`, `2.3.1-beta.1`).
- If no argument is given, print usage and exit with a non-zero code.
- The version is used both for the output filename (e.g. `App_1.2.3_amd64.deb`) and the `Version:` field in `DEBIAN/control`.

### b) Release build before packaging
- The script MUST first compile the project in **Release** configuration using `cargo build --release`.
- Binary output is located at `target/release/<app_name>`.

### c) Script and .deb live in the workspace root folder
- The build script and the resulting `.deb` MUST go into the workspace root folder, **not** inside the `project/` subfolder.
- Discover root dynamically:
  ```bash
  ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_DIR="$ROOT_DIR/project"
  ```
- Never hardcode absolute user paths.

## How to use it (in this project)

The project provides a ready-made script at the workspace root: `build-deb.sh`.

### Running the script
```bash
./build-deb.sh <version>
```
The version is a required positional argument, e.g. `./build-deb.sh 1.2.3`. It produces `build/<AppName>_<version>_amd64.deb`.

### What the script does
1. Runs `cargo build --release` inside the project directory.
2. Stages a Debian package layout under `build/package/`:
   - Binary copied into `/opt/<AppName>/<AppName>`.
   - `DEBIAN/control` generated with package name, version, architecture (`amd64`), and computed `Installed-Size`.
   - `.desktop` launcher written to `/usr/share/applications/<AppName>.desktop`.
   - Icon copied to `/usr/share/icons/hicolor/scalable/apps/<AppName>.svg`.
3. Fixes permissions (`chmod +x` on the binary, `644` on desktop and icon files).
4. Calls `dpkg-deb --build --root-owner-group build/package build/<AppName>_${VERSION}_amd64.deb`.

### Principles baked into the script
- **Per-user data, not next to the executable:** Writable files (SQLite database, configuration) MUST reside in `~/.local/share/<AppName>` (via `dirs::data_local_dir()`). The `/opt/<AppName>` directory is root-owned and read-only for regular users.
- **Install prefix:** `/opt/<AppName>`.
- **Version as argument:** Never hardcode the version.

## Reference Script Template

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$ROOT_DIR/project"
APP_NAME="myapp"
ARCH="amd64"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi
VERSION="$1"

# 1) Release build
cd "$PROJECT_DIR"
cargo build --release
cd "$ROOT_DIR"

# 2) Stage packaging directory
BUILD_DIR="$ROOT_DIR/build"
PKG_DIR="$BUILD_DIR/package"
rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR/DEBIAN"
mkdir -p "$PKG_DIR/opt/$APP_NAME"
mkdir -p "$PKG_DIR/usr/share/applications"
mkdir -p "$PKG_DIR/usr/share/icons/hicolor/scalable/apps"

cp "$PROJECT_DIR/target/release/$APP_NAME" "$PKG_DIR/opt/$APP_NAME/"
chmod +x "$PKG_DIR/opt/$APP_NAME/$APP_NAME"

# 3) Generate control file
INSTALLED_SIZE=$(du -sk "$PKG_DIR" | cut -f1)
cat <<EOF > "$PKG_DIR/DEBIAN/control"
Package: $APP_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Installed-Size: $INSTALLED_SIZE
Maintainer: Valeria Team
Description: Desktop application built with Rust and Slint
EOF

# 4) Build .deb
dpkg-deb --build --root-owner-group "$PKG_DIR" "$BUILD_DIR/${APP_NAME}_${VERSION}_${ARCH}.deb"
```