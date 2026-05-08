# Project Architecture

## Folders architecture

### Src

In this folder, you can find folders in which you will work most often.

- **Features:** Here we keep folders related to specific features. Each feature must have a separate folder. Inside this folder, there should be the following folders:
  
  - UI - here should be folders for the screens, FeatureStyles (Python modules containing style configurations), and FeatureComponents (Flet custom controls inheriting from `ft.Container` or other base controls).
  - Domain - and in that folder you can add folders for services, models, use cases, enums, etc. if needed.
  - Resources - here you put localization or asset files specific to this feature.
    You can also add additional folders (like for example "services" for services related to the feature) if needed.
    
    
    
    Additionally, each feature MUST have a dedicated navigation file named `feature_name_navigation.py` (e.g., `voice_recorder_navigation.py`). Inside this file, create a class like `FeatureNameNavigation(BaseFeatureNavigation)`. This file must remain extremely lightweight to prevent circular imports. It should only import the UI View classes it needs to build. NO MAGIC STRINGS: Route paths must be defined as class constants.

- **Infrastructure:** Here we keep core setup files like `nav_host.py`. It is used for registering the `NavHost` which manages routing state and dependency injection setup. 

- **Shared:** It is best to put here UI elements and logic that are shared across multiple features. You can find folders like:
  
  - Resources with global string/localization files inside it.
  - GlobalStyles with style files used across several features in the app.
  - GlobalComponents for custom reusable Flet components (for example, custom buttons).

- **Core:** Here you can put some services, enums, models shared by several features, and base classes (like base ViewModels or Controllers). Each category (services, models, enums, etc.) should have its own separated subfolder.

### Assets

Here you can store things like icons, images, fonts, etc., which Flet will serve as static assets.

### Tests

Here you should place all tests using `pytest`. Inside the tests folder, there should be:

- **CoreTests:** here you put tests related to things from Src/Core.
- **FeaturesTests:** and here in subfolders you put tests related to each feature (for example, tests of services from a specific feature should be placed in `FeaturesTests/FeatureNameTests/ServicesTests`).

## Routing

This project uses Flet's **views for routing** (manipulating `page.views`), instead of `page.clean()`.
Navigation is strictly managed through an Object-Oriented, decentralized route registration system to maintain the Single Responsibility Principle and avoid bloated bootstrapper files.

### The Contract (Core)

All feature navigation must inherit from the base interface located at `Src/Core/Base/base_navigation.py`.
The base class `BaseFeatureNavigation` requires implementing the `get_routes(self) -> Dict[str, Callable[[], ft.View]]` method.

### Feature navigation

Each feature MUST have a dedicated navigation file named `feature_name_navigation.py` (e.g., `voice_recorder_navigation.py`).
Inside this file, create a class like `FeatureNameNavigation(BaseFeatureNavigation)`.

**NO MAGIC STRINGS:** Route paths (e.g., `"/recorder"`) must be defined as class constants. Never hardcode strings directly in the `get_routes` dictionary.
This file must remain extremely lightweight to prevent circular imports. It should only import the UI View classes it needs to build.

### The Dispatcher (Infrastructure)

The central navigation engine is `NavHost` located in `Src/Infrastructure/nav_host.py`.
`NavHost` initializes a private list of instantiated feature navigation objects (e.g., `self._feature_navigations = [VoiceRecorderNavigation(), ...]`).
`NavHost` iterates through this list to populate its internal route dictionary.
`NavHost` exclusively handles Flet's `page.on_route_change` and `page.on_view_pop` events. Views are added directly to `page.views`.

### Entry Point (Main)

The `main.py` file must be located in the `Src` folder. It must remain completely agnostic of specific routes or features.
It should only instantiate `NavHost(page)` and call the initial routing trigger (e.g., `nav_host.navigate_to("/")`). This means we do not use an AppBootstrapper.

### Navigation between screens

Navigation should be handled through the `NavHost` capabilities (e.g., a `navigate_to` method). Every screen/viewModel should have access to this routing mechanism, typically passed during navigation or via dependency injection.

## Strings & Localization

Strings used in the UI of the app shouldn't be hardcoded in view files or logic files. Instead, they should be stored in dedicated localization files (e.g., JSON) or Python dictionaries.

- Strings specific to a single feature should be placed in a localization module located at: `FeatureName/Resources/FeatureNameStrings`.
- Strings shared across multiple features (e.g., generic buttons like Save, Cancel, Error) should be placed in the global shared resources: `Src/Shared/Resources/GlobalStrings`.
- In Flet view files, retrieve strings from these resource objects. Do not use generic string interpolation directly with hardcoded English UI texts.
- Internal strings that are never visible to the user (e.g., dictionary keys, cache keys, event names, configuration names, etc.) shouldn't be placed in localization files.
- Instead, these internal strings should be defined as constants. Do not leave inline "magic strings" in the code.
- Before adding a new localized string to a feature-specific localization file, you should check if an equivalent string already exists in the global strings. If it does, reuse the global string.
- You shouldn't add new strings to the global strings file unless explicitly commanded to do so. If not explicitly stated to put it in global strings, always default to adding new strings to the active feature's local localization file.

## Enums

Files with enums should be stored in the "Enums" folder in Core or `FeatureName/Domain`. They should utilize Python's `enum.Enum` or `enum.StrEnum`.
For example, if we have a feature "Animals" and we want to have an enum "Tiger", we should place it in `Features/Animals/Domain/Enums/tiger.py`.
