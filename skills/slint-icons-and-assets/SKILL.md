---
name: slint-icons-and-assets
description: Guidelines for managing and displaying icons, SVG vector graphics, and image assets in Slint desktop applications.
---

# Slint Icons & Asset Management

## When to use this skill
Use this skill whenever you need to add, display, or style icons and images in Slint components and screens.

## Guidelines

### 1. Asset Storage & Organization
- All static icons and images MUST be placed in the `assets/` directory at the project root:
  - `assets/icons/`: SVG vector icons (preferred for crisp scaling).
  - `assets/images/`: Raster artwork (PNG/JPEG).

### 2. Referencing Assets in Slint
- Use Slint's compile-time `@image-url("path")` macro:
  ```slint
  Image {
      source: @image-url("../../../../assets/icons/settings.svg");
      width: 24px;
      height: 24px;
  }
  ```
- Paths are resolved relative to the `.slint` file where the macro is called.

### 3. Icon Colorization & Tinting
- For monochrome SVG icons that should adapt to themes (e.g. Light/Dark mode), use the `colorize` property:
  ```slint
  Image {
      source: @image-url("assets/icons/save.svg");
      width: 20px;
      height: 20px;
      colorize: Palette.primary;
  }
  ```

### 4. Image Fit & Scaling
- Prevent distortion by specifying `image-fit`:
  - `image-fit: contain;` (preserves aspect ratio while fitting within bounds).
  - `image-fit: cover;` (fills the bounds, clipping excess).