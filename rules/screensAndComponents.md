# Screens and components

## Screens

When in instruction for you I use the word "screen", I mean the associated files that make up a screen view (e.g., the Template/Markup, the Logic/Controller/ViewModel, and optionally styling).
The files are usually grouped in a single folder and are responsible for the UI of one screen.

Before starting any work on a screen, you MUST read the documentation comment at the top of its main logic file to understand its purpose, functionalities, and context.

Inside the screen folder, there may be a folder `ScreenComponents` where you can put folders of components used only by this screen.

### Models for screens and components

Files with models can only be at the feature or core level. You can't put models in the screens or components folders. If a component is on a global level, the model for it should be placed in the core folder.

## Components

Components are reusable or isolated UI blocks that are NOT full screens and are usually not directly routable.

Every component MUST contain documentation in a comment at the top of its logic/script file, which serves as the documentation for that specific component.

### Custom components location

Custom components should by default be placed in `ScreenComponents`. You can place them in `FeatureComponents` or `GlobalComponents` only when I directly tell you to do that.


