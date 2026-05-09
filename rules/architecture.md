# Project Architecture

## Folders architecture

### Src

In this folder, you can find folders in which you will work most often.

- **Features:** Here we keep folders related to specific features. Each feature must have a separate folder. Inside this folder, there should be the following folders:
  
  - UI - here should be folders for the screens, FeatureStyles, and FeatureComponents.
  - Domain - and in that folder you can add folders for services, models, use cases, enums, etc. if needed.
  - Resources - here you put localization or asset files specific to this feature.
    You can also add additional folders (like for example "services" for services related to the feature) if needed.
    Additionally, all features (except the main Shell feature) should have a module/registration file. This file should contain the registration of routes or dependencies for the given feature. The modules themselves are later registered in the main application bootstrapper.

- **Infrastructure:** Here we keep core setup files like AppBootstrapper or Module interfaces. It is used for registering modules and dependency injection setup.

- **Shared:** It is best to put here UI elements and logic that are shared across multiple features. You can find folders like:
  
  - Resources with global string/localization files inside it.
  - GlobalStyles with style files used across several features in the app.
  - GlobalComponents for custom reusable components (for example, custom buttons).

- **Core:** Here you can put some services, enums, models shared by several features, and base classes (like base ViewModels or Controllers). Each category (services, models, enums, etc.) should have its own separated subfolder.

### Assets

Here you can store things like icons, images, fonts, etc.

### Tests

Here you should place all tests. Inside the tests folder, there should be:

- **CoreTests:** here you put tests related to things from Src/Core.
- **FeaturesTests:** and here in subfolders you put tests related to each feature (for example, tests of services from a specific feature should be placed in `FeaturesTests/FeatureNameTests/ServicesTests`).

## Strings & Localization

Strings used in the UI of the app shouldn't be hardcoded in view files or logic files. Instead, they should be stored in dedicated localization files (e.g., JSON, resx, properties).

- Strings specific to a single feature should be placed in a localization file located at: `FeatureName/Resources/FeatureNameStrings`.

- Strings shared across multiple features (e.g., generic buttons like Save, Cancel, Error) should be placed in the global shared resources: `Src/Shared/Resources/GlobalStrings`.

- In view files, use the framework's standard localization binding mechanism to display strings. Do not use generic string interpolation for UI texts.

- Internal strings that are never visible to the user (e.g., dictionary keys, cache keys, event names, configuration names, etc.) shouldn't be placed in localization files. Localizing logic-bound strings breaks the application.

- Instead, these internal strings should be defined as constants. Do not leave inline "magic strings" in the code.

- Before adding a new localized string to a feature-specific localization file, you should check if an equivalent string already exists in the global strings. If it does, reuse the global string.

- You shouldn't add new strings to the global strings file unless explicitly commanded to do so. If not explicitly stated to put it in global strings, always default to adding new strings to the active feature's local localization file.

## Enums

Files with enums should be stored in the "Enums" folder in Core or `FeatureName/Domain`. 
For example, if we have a feature "Animals" and we want to have an enum "Tiger", we should place it in `Features/Animals/Domain/Enums/Tiger`.
