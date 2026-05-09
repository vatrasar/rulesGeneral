# Screens and components

## Screens

When in instruction for you I use the word "screen", I mean the associated files that make up a screen view: the main `@Composable` function and its associated `ViewModel`.
The files are usually grouped in a single folder and are responsible for the UI of one screen.

Each screen MUST have a corresponding **Screen Contract** file (`[ScreenName]Contract.kt`). This file centralizes the definitions for the screen's state, events, and side-effects.

### Screen Contract Structure

The contract file should be located in the same directory as the Screen and ViewModel and must contain the following components:

1.  **State**: An `@Immutable` data class representing the UI state.
2.  **Event**: A `sealed class` representing all user actions (e.g., button clicks, text changes).
3.  **Effect**: A `sealed class` for UI-related side-effects (e.g., showing a Snackbar).
4.  **NavEffect**: A `sealed class` specifically for navigation side-effects.

**Example:**
```kotlin
package com.example.flashcardexpress.feature.questionManagement.presentation.creationCategory

import androidx.compose.runtime.Immutable

sealed class CreationCategoryNavEffect {
    data object NavigateBackToManagePanel: CreationCategoryNavEffect()
}

sealed class CreationCategoryEffect {
    data class ShowSnackbar(val message:String,val resultType:String): CreationCategoryEffect()
}

sealed class CreationCategoryEvent {
    data class OnCategoryNameChanged(val currentValue:String): CreationCategoryEvent()
    data object OnAddCategoryClicked: CreationCategoryEvent()
    data object OnBackToManagePanel: CreationCategoryEvent()
}

@Immutable
data class CreationCategoryState(
    val categoryName: String
)
```

Before starting any work on a screen, you MUST read the documentation comment at the top of its main logic file to understand its purpose, functionalities, and context.

Inside the screen folder, there may be a folder `ScreenComponents` where you can put files of `@Composable` components used only by this screen.



### Models for screens and components

Files with models can only be at the feature or core level. You can't put models in the screens or components folders. If a component is on a global level, the model for it should be placed in the core folder.

## Components

Components are reusable or isolated UI blocks (`@Composable` functions) that are NOT full screens and are not routable. 

### Documentation Rules for Components and Functions

- **Components in Separate Files:** Every component that has its own separate file MUST contain a documentation comment (KDoc) at the top of its main `@Composable` function, serving as the documentation for that specific component.
- **Local Helper Functions:** Local, private, or helper `@Composable` functions that are located inside a screen's file and used only within that file **do NOT** need this documentation (unless it is the main screen `@Composable` method of that file).

### Custom components location

Custom components should by default be placed in `ScreenComponents`. You can place them in `FeatureComponents` or `GlobalComponents` only when I directly tell you to do that.
