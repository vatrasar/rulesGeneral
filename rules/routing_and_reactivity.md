# Routing and Reactivity

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

- **CRITICAL RULE:** Screens (`@Composable` functions) and `ViewModels` must **NOT** contain or depend on `NavController`.
- **Navigation implementation:** Navigation must be implemented via events. The screen `@Composable` should expose lambda parameters (e.g., `onNavigateToHome: () -> Unit`), which are then implemented in the Navigation graph file where the `NavController` resides.
- **Handling Navigation Side-Effects:** 
  - The feature-specific navigation file is responsible for observing navigation "effects" from the ViewModel.
  - Inside the `composable` block of the navigation file, use `LaunchedEffect` to collect side-effects (e.g., `NavigateToDetails`) from the `ViewModel.effect` flow.
  - When a navigation effect is received, the navigation file calls `navController.navigate()`.
- **Separation of Events:**
  - **Navigation Events:** Represented as side-effects from the ViewModel or specific callbacks from the Screen, handled exclusively in the Navigation files.
  - **Frontend/Logic Events:** User interactions (e.g., `onEvent(UiEvent)`) are passed from the Screen to the ViewModel. The ViewModel processes logic and, if needed, emits a navigation side-effect.
  - This ensures that Screens and ViewModels remain decoupled from the specific navigation implementation and the `NavController`.

## Reactive State Management

- **Reactivity:** Follow Compose's recommended patterns for state hoisting and reactivity (e.g., maintaining state in ViewModels and observing it in Composables).
- **State Flows:** Use Kotlin Coroutines and Flows (specifically `StateFlow` and `SharedFlow`) for asynchronous operations and state management.
- **Observing State:** Use modern Compose features like `collectAsStateWithLifecycle` to observe state in a lifecycle-aware manner.
- **ViewModel Lean Logic:** ViewModels should remain lean. Use Kotlin Coroutines and Flows for state updates.
- **Asynchronous Operations:** Coroutines and Flows should be the primary tools for handling any asynchronous data streams.



## Screen Contracts

The UI state for each screen must be defined as an `@Immutable` data class within a dedicated **Screen Contract** file (`[ScreenName]Contract.kt`)
