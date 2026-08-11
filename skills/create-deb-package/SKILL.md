---
name: create-deb-package
description: Builds a .NET Avalonia desktop app and packages it into a Debian .deb file. Use when the user asks to create, build, or release a .deb package, or to write/customize a .deb build script.
---

# Create .deb Package

## When to use this skill

Use this when asked to:

- Build / package an app into a `.deb` file.
- Write or fix a `.deb` build script.
- Change the install prefix, package/version handling, or desktop integration.

## Generic rules (apply in any project)

This skill is project-agnostic. When writing a `.deb` build script, always:

### a) Version as an argument

- The version MUST be a **required positional argument** to the script, not a hardcoded constant.
- Debian format: plain number, no leading `v` (e.g. `1.2.3`, `2.3.1-beta.1`).
- If no argument is given, print usage and exit with a non-zero code.
- The version is used both for the output filename (e.g. `App_1.2.3_amd64.deb`) and the `Version:` field in `DEBIAN/control`.

### b) Release build before packaging

- The script MUST first build the project in **Release** configuration before creating the `.deb`.
- Use `dotnet publish` with `-c Release`. For a self-contained single install dir, use `-r linux-x64 --self-contained true`.

### c) Script and .deb live in the agent's root folder, NOT in the project folder

- The build script and the resulting `.deb` MUST go into the agent/workspace root folder, **not** inside the `project/` subfolder.

- Remember: the agent root is not always the OpenCode folder — it is wherever this agent's workspace root is. Discover it at runtime with:
  
  ```bash
  ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  ```
  
  and then resolve the actual project path relative to it (e.g. `PROJECT_DIR="$ROOT_DIR/project"`).

- Never hardcode absolute agent paths into the skill or the script.

## How to use it (in this project)

The project provides a ready-made script at the workspace root: `build-deb.sh`.

### Running the script

```bash
./build-deb.sh <version>
```

The version is a required positional argument, e.g. `./build-deb.sh 1.2.3`. It produces `build/Ismi_<version>_amd64.deb`. If no argument is given the script prints usage and exits.

Do NOT edit the script by hand for routine builds. Prefer running it directly.

### What the script does

1. `dotnet publish` the project in **Release** mode, self-contained RID `linux-x64`, output to `build/publish/`.
2. Stage a Debian package layout under `build/package/`:
   - Binary + runtime copied into `/opt/Ismi/`.
   - `DEBIAN/control` generated with package name `Ismi`, version, arch `amd64`, and install size computed from the staged tree.
   - `.desktop` launcher written to `/usr/share/applications/Ismi.desktop`.
   - Icon copied from `app_icon.svg` at workspace root into the scalable icons path.
3. Fix permissions (executable bit on the binary, 644 on other files).
4. `dpkg-deb --build` to produce the final `.deb` in `build/`.

### Principles baked into the script (do not regress)

- **Per-user data, not next to the executable:** the DB and `conf.txt` are resolved via `Environment.SpecialFolder.LocalApplicationData`, so the `/opt/Ismi` install dir stays read-only for regular users.
- **Install prefix:** `/opt/Ismi` (the app dir is root-owned and read-only; any writable file MUST go to the per-user data folder).
- **Do not hardcode the version** inside the script — it is an argument.

## Writing the script from scratch (other projects)

Follow this structure:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$ROOT_DIR/project"        # adjust per project layout
PROJECT_FILE="$PROJECT_DIR/<App>.csproj"

APP_NAME="<App>"                       # package + binary name
INSTALL_PREFIX="/opt/$APP_NAME"
RID="linux-x64"
ARCH="amd64"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi
VERSION="$1"

# 1) Release publish
dotnet publish "$PROJECT_FILE" -c Release -r "$RID" --self-contained true -o "$BUILD_DIR/publish"

# 2) stage DEBIAN/control, binary dir, .desktop, icon under build/package/
# 3) chmod +x the binary; chmod 644 other files
# 4) dpkg-deb --build --root-owner-group package build/App_${VERSION}_${ARCH}.deb
```

## Customizing the script

If the user asks to change behavior (e.g. package name, architecture, dependencies, app category), edit the variables at the top of `build-deb.sh` (`APP_NAME`, `INSTALL_PREFIX`, `RID`, `ARCH`, the `control` `Depends:` line, or the `.desktop` contents). After editing, always re-run `./build-deb.sh <version>` to verify it still builds.