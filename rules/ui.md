---
trigger: always_on
---
# UI Rules

## UI style

UI should look modern, add transition and hover/ripple animation etc. UI should give a "wow" effect. Use Jetpack Compose Material 3 components and principles.

## Theme and colors

The application should use a cohesive Material 3 design system with custom palettes defined in the project.

- **Prohibition of Hardcoded Colors:** DO NOT use hex codes (e.g., `Color(0xFFFFFFFF)`) or fixed colors directly in the modifiers or Composables if a theme variable exists. Use theme colors instead (e.g., `MaterialTheme.colorScheme.primary`).
- **Custom Colors:** If a unique color is absolutely necessary, it must be added to the global color definitions in the Compose Theme.

## Styles and Modifiers

- Jetpack Compose uses `Modifier` instead of separate style files.
- Styles used across several features or common modifier chains should be extracted as extension functions on `Modifier` or custom `@Composable` wrappers in the `Shared/Theme` or `Shared/GlobalComponents` folder.
- **Do not create complex inline Modifier chains that are heavily duplicated.** Extract them.

## 🧩 Layout & Dimensioning Philosophy (Logic Over Values)

1. **Layout-First Approach:**
   
   - Prioritize **Fluid Layouts** over fixed dimensions. Use Compose layout containers (`Column`, `Row`, `Box`) and modifiers like `fillMaxSize()`, `fillMaxWidth()`, and `weight()` over hardcoded Width/Height.
   - Use stretch and fill behaviors as the default for containers to adapt to screen sizes.

2. **Smart Hardcoding (The "Pragmatic Developer" Rule):**
   
   - **Spacing & Gaps:** Hardcoded values for Padding and Arrangement spaces (e.g., `Arrangement.spacedBy(8.dp)`, `modifier.padding(16.dp)`) are perfectly fine for fine-tuning the UI. Use `dp` for dimensions and `sp` for text sizes.
   - **Constraint Over Definition:** Use `widthIn(max = ...)` or `heightIn(max = ...)` to control the visual flow on large screens, rather than a hardcoded width.

3. **Anti-Pattern Warning (Padding Abuse):**
   
   - NEVER use large paddings to "push" or "center" elements. You should use layout alignment properties instead (e.g., `Arrangement.Center`, `Alignment.Center`, `weight()`).

## Element Identifiers / References 🚨

**NEVER GENERATE AN INTERACTIVE ELEMENT WITHOUT A CLEAR IDENTIFIER.**

- **Goal**: To streamline code navigation and provide precise element referencing for UI testing and AI-assisted development.
- **Mandatory Identifiers**: All interactive elements (Buttons, TextFields) and primary data containers (LazyColumns, LazyRows) **MUST** include a `testTag` modifier (e.g., `Modifier.testTag("loginButton")`). **Failure to do this is UNACCEPTABLE.**
- **Naming Convention**: Use a consistent naming pattern (e.g., `[Function][Type]` like `loginButton`, `employeeList`).
- **No Generic Names**: Do not use names like `button1`, `myText`, or `input_field`.

## Layout Container Constraints

- **Styling Layouts**: Be careful when applying visual styles (like borders or backgrounds) directly to abstract layout panels. If needed, wrap the layout in a dedicated visual container (like `Card`, `Surface`, or use `Modifier.background()` and `Modifier.border()`).


## 🏗️ Top-Down & Flat UI Structure (Jetpack Compose)
To ensure maintainability, scalability, and readability in Jetpack Compose, you MUST strictly follow these architectural principles. Failure to do so will result in rejected code.

1. Top-Down Organization (General to Specific)
Primary @Composable First: The main entry-point Composable function of the file MUST be defined at the very top, immediately after the imports.

Immediate Visibility: State hoisting, event callbacks, and the high-level layout structure must be clearly visible at the top of the function.

Implementation Details Last: ALL secondary sub-composables, private helper functions, and preview functions (@Preview) MUST be placed below the main Composable function.

2. Flat Structure & Strict Component Extraction (Global Rule)
Single Core Layout Block Per Function: A single Composable function must contain only ONE primary structural layout block (e.g., returning one main Box, Column, Row, or LazyColumn). You CANNOT define multiple layout structures as local variables or anonymous blocks and combine them later inside the same function. If you need multiple complex sections, they MUST be extracted into separate Composable functions.

*  Clean Parameter Slots: For simple leaf components (like TextField, Button, or Text), pass their state and modifiers clearly. Do not nest deep layout trees inside slot parameters (like Row inside a trailingIcon slot of a TextField). Extract them if they require more than a single component.

* No "Composable Tree Hell" ANYWHERE: Avoid deeply nesting anonymous Composable functions with structural comments (e.g., // Header, // Action Center).


* Component Extraction: If a UI section represents a distinct logical or visual part, you MUST extract it into a separate Composable function rather than keeping it as a massive inline block.

*  Location of Extracted Components (CRITICAL):

Screens : The main screen file (e.g., EditorScreen.kt) MUST contain the top-level Screen Composable and its stateless content wrapper. Sub-components specific only to this screen MUST be extracted into a components folder inside that specific screen's package.

Components: Non-screen, components SHOULD define their internal sub-composables within the same file (below the main function) if they are private to that component

* Table of Contents Return: The main body of any structural Composable should read like a clean table of contents made of clearly named sub-composables.
### ❌ BAD EXAMPLE (REJECTED - Deeply nested, anonymous sections with comments):
```
@Composable
fun EditorScreenContent() {
    // BAD: Deep nesting, anonymous layout structures used instead of extracted components
    Surface(modifier = Modifier.fillMaxSize()) {
        Column(modifier = Modifier.padding(16.dp)) {
            // Status/Info Bar
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(imageVector = Icons.Default.Info, contentDescription = "Info")
                Text(text = "Status", modifier = Modifier.padding(start = 8.dp))
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            // BAD: Placing complex inputs inline directly inside the main column
            OutlinedTextField(
                value = "",
                onValueChange = {},
                label = { Text("Source Context") }
            )
            
            Spacer(modifier = Modifier.height(16.dp))
            
            // Action Center (BAD: Unnecessary layout nesting instead of a clean component)
            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                IconButton(onClick = {}) {
                    Icon(imageVector = Icons.Default.Translate, contentDescription = "Translate")
                }
            }
        }
    }
}
```

### ❌ ANOTHER BAD EXAMPLE (REJECTED - Multiple layout blocks inside one function):
```
@Composable
fun EditorScreenContent() {
    // BAD: Defining sub-layouts inside the same function and nesting them manually.
    // This breaks the flat structure rule.
    
    val statusBar = @Composable {
        Row {
            Icon(imageVector = Icons.Default.Info, contentDescription = null)
            Text("Status")
        }
    }

    Column {
        statusBar() // BAD: Executing locally defined composable blocks
        OutlinedTextField(value = "", onValueChange = {}, label = { Text("Source Context") })
        FileBrowserSection()
    }
}
```

### ✅ GOOD EXAMPLE (ACCEPTED - Shallow nesting, clean top-down extraction):

```
@Composable
fun EditorScreenContent(
    uiState: EditorUiState,
    onTranslateClick: () -> Unit,
    onContextChange: (String) -> Unit,
    modifier = Modifier. someModifier
) {
    // Top-down entry point: Clear layout acting as a Table of Contents
    Row(modifier = modifier.fillMaxSize()) {
        EditorColumn(
            contextText = uiState.contextText,
            onContextChange = onContextChange,
            onTranslateClick = onTranslateClick,
            modifier = Modifier.weight(1f)
        )
        FileBrowserColumn(
            files = uiState.files,
            modifier = Modifier.weight(1f)
        )
    }
}

@Composable
private fun EditorColumn(
    contextText = String,
    onContextChange: (String) -> Unit,
    onTranslateClick: () -> Unit,
    modifier = Modifier = Modifier
) {
    Column(modifier = modifier.padding(16.dp)) {
        StatusBar()
        Spacer(modifier = Modifier.height(16.dp))
        OutlinedTextField(
            value = contextText,
            onValueChange = onContextChange,
            label = { Text("Source Context") },
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(16.dp))
        ActionCenter(onTranslateClick = onTranslateClick)
    }
}

@Composable
private fun FileBrowserColumn(
    files: List<File>,
    modifier: Modifier = Modifier
) {
    // File browser implementation details...
}

@Composable
private fun StatusBar(modifier: Modifier = Modifier) {
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(imageVector = Icons.Default.Info, contentDescription = null)
        Text(text = "Status", modifier = Modifier.padding(start = 8.dp))
    }
}

@Composable
private fun ActionCenter(
    onTranslateClick: () -> Unit,
    modifier = Modifier = Modifier
) {
    Box(
        modifier = modifier.fillMaxWidth(),
        contentAlignment = Alignment.Center
    ) {
        IconButton(onClick = onTranslateClick) {
            Icon(imageVector = Icons.Default.Translate, contentDescription = "Translate")
        }
    }
}
```