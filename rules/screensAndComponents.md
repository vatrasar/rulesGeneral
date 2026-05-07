# Screens and components

## Screens

When in instruction for you I use the word "screen", I mean the associated files that make up a screen view (e.g., the Flet `View` class, the ViewModel for this screen, and optionally styling modules).
The files are usually grouped in a single folder and are responsible for the UI of one Flet View.

Before starting any work on a screen, you MUST read the docstring at the top of its View class to understand its purpose, functionalities, and context.

Inside the screen folder, there may be a folder `ScreenComponents` where you can put folders of Flet components used only by this screen.

### Models for screens and components

Files with models can only be at the feature or core level. You can't put models in the screens or components folders. If a component is on a global level, the model for it should be placed in the core folder.

## Components

Components are reusable or isolated UI blocks (typically subclasses of `ft.Container` or other base Flet controls) that are NOT full screens and are usually not directly routable.

Every component MUST contain documentation in a docstring at the top of its View class, which serves as the documentation for that specific component.

### Custom components location

Custom components should by default be placed in `ScreenComponents`. You can place them in `FeatureComponents` or `GlobalComponents` only when I directly tell you to do that.
