# Routing and Reactivity

## Routing

The routing paths and dependencies for a given feature should be registered in the module file of the given feature.
Each module should be automatically registered (e.g., via reflection or a DI container) in the AppBootstrapper.

### Main Routing Host

The place where views/screens will change is located in the shell feature, usually in the Host screen. The job of the main window/activity/page is just to display this Host screen.

### Navigation between screens

Navigation should be handled through a router or navigation service. Every screen/viewModel should have access to this routing mechanism, typically passed during navigation or via dependency injection.

## Reactivity and State Management

Follow the framework's recommended patterns for reactivity and state observation instead of manual UI updates.

### Screen State Pattern

Every screen MUST have a dedicated state class named `[ScreenName]State` (e.g., `HomeState`, `SettingsState`).
- This class is responsible for holding the entire state of the screen.
- It should be implemented as a **data class** or **record** (depending on the project's language).
- The state should be immutable where possible, with updates handled via "copy with" patterns or the framework's reactive state management system.
