# Project Architecture

## Folders architecture

### app/src/main/kotlin (or java)

In this directory, you will find the main application code organized by features.

- **Features:** Here we keep folders related to specific features. Each feature must have a separate folder. Inside this folder, there should be the following folders:
  
  - Presentation - here should be folders for the screens (Composables), ViewModels, and FeatureComponents.
  - Domain - and in that folder you can add folders for services, models, use cases, enums, etc. if needed.
  - DI - here you put Hilt modules specific to this feature.
    You can also add additional folders if needed.

- **Infrastructure / DI:** Here we keep core setup files like the main `Application` class (annotated with `@HiltAndroidApp`), global Hilt modules, and main routing state (e.g., `NavHost` setup).

- **Common:** It is best to put here UI elements and logic that are shared across multiple features. You can find folders like:
  
  - GlobalComponents for custom reusable Composable components (for example, custom buttons).
  - Theme for global Material 3 theme files (`Color.kt`, `Theme.kt`, `Type.kt`).

- **Core:** Here you can put some services, enums, models shared by several features, and base classes. Each category (services, models, enums, etc.) should have its own separated subfolder.

### app/src/main/res

Here you store Android resources:
- `values/strings.xml` for localization and strings.
- `drawable/` and `mipmap/` for icons and images.
- `font/` for custom fonts.

### app/src/test & app/src/androidTest

Here you should place all tests. 
- **app/src/test:** Local unit tests (e.g., testing ViewModels, UseCases, Services).
- **app/src/androidTest:** Instrumented tests (e.g., UI tests for Jetpack Compose).

## Routing

Navigation is handled using **Navigation-Compose**.

### Main Routing Host

The root of the navigation is the `NavHost`, usually defined in a `NavGraph.kt` file within the `navigation` folder. This root host delegates the setup of specific routes to each feature.

### Feature-Specific Navigation

Each feature must have its own navigation setup:
- **Location:** `feature/[name]/navigation/[Name]Navigation.kt`.
- **Extension Function:** Navigation is defined using an extension function on `NavGraphBuilder`, e.g., `fun NavGraphBuilder.setupHomeNavigation(navController: NavController)`.
- **Integration:** These feature-specific setup functions are called within the main `NavHost` in the root `NavGraph.kt`.

### Navigation and Events in Screens

- **CRITICAL RULE:** The `NavController` MUST be maintained ONLY in Navigation files (both root and feature-specific ones).
- **NEVER** pass the `NavController` directly to screens (`@Composable` functions representing screens) or to `ViewModels`.
- **Handling Navigation Side-Effects:** 
  - The feature-specific navigation file is responsible for observing navigation "effects" from the ViewModel.
  - Inside the `composable` block of the navigation file, use `LaunchedEffect` to collect side-effects (e.g., `NavigateToDetails`) from the `ViewModel.effect` flow.
  - When a navigation effect is received, the navigation file calls `navController.navigate()`.
- **Separation of Events:**
  - **Navigation Events:** Represented as side-effects from the ViewModel or specific callbacks from the Screen, handled exclusively in the Navigation files.
  - **Frontend/Logic Events:** User interactions (e.g., `onEvent(UiEvent)`) are passed from the Screen to the ViewModel. The ViewModel processes logic and, if needed, emits a navigation side-effect.
  - This ensures that Screens and ViewModels remain decoupled from the specific navigation implementation and the `NavController`.

## Strings & Localization

Strings used in the UI of the app shouldn't be hardcoded in Composable files or logic files. Instead, they should be stored in Android's standard `res/values/strings.xml`.

- In Compose, use `stringResource(id = R.string.your_string_id)` to display strings. Do not use generic string interpolation for UI texts.
- Internal strings that are never visible to the user (e.g., dictionary keys, cache keys, event names, configuration names, etc.) shouldn't be placed in `strings.xml`. Localizing logic-bound strings breaks the application.
- Instead, these internal strings should be defined as constants. Do not leave inline "magic strings" in the code.

## Enums

Files with enums should be stored in the "Enums" folder in Core or `FeatureName/Domain`. 
For example, if we have a feature "Animals" and we want to have an enum "Tiger", we should place it in `Features/Animals/Domain/Enums/Tiger`.
