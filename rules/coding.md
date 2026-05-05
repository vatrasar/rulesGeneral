---
trigger: always_on

---

# Code Rules

## Technologies used in project

The application is built for Android using:
- **Language:** Kotlin (using idiomatic solutions like Coroutines, Flow, StateFlow).
- **UI:** Jetpack Compose (Material 3).
- **Navigation:** Navigation-Compose.
- **Dependency Injection:** Hilt.

## Coding rules

1. You are a highly skilled Android software engineer who prioritizes clean code.

2. You pay particular attention to keeping functions short. Your primary goal is to write flat code. Instead of building deeply nested structures, if you find that logic cannot be simplified without nesting, try extracting the inner block into a separate, dedicated function/method (e.g., smaller `@Composable` functions).

3. Names should be self-explanatory and communicate intent. Prioritize clarity over brevity, but avoid redundancy and noise words. A name should be as short as possible, but not shorter than what is required to understand its purpose at a glance. For example, `numberOfRemainingFreeHours` is far superior to `h`.

4. ViewModels and Services should remain lean. Prefer Use Cases over generic Services if logic becomes complex. Use Kotlin Coroutines and Flows for asynchronous operations and state management.

5. Language Requirements
   All naming conventions (variables, functions, classes) and comments within the code must be in English.

6. **Prefer Enums/Sealed Classes over Constants/Strings:** Whenever a variable can hold a limited set of predefined values (e.g., UI States, ShiftType), **always** use a strongly-typed `enum class` or `sealed class`/`sealed interface` in Kotlin.

7. There must be blank lines separating properties/fields from methods/functions to create a clear visual boundary.

8. Avoid Legacy Patterns. Never suggest deprecated patterns (like XML layouts, `findViewById`, or `AsyncTask`) since the project uses Jetpack Compose and Coroutines.

9. Use the suffix `DTO` only for models which are used for network communication.

10. Models shouldn't use the suffix "model". It's better to name a model `User` than `UserModel`.

11. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

## Documentation & Commenting Standards

**1. NO INLINE COMMENTS**

- Adding comments within a function or method body is STRICTLY FORBIDDEN. 
- Logic should be so clear and names so expressive that internal comments are redundant. 
- Code MUST be self-documenting through expressive naming and clear structure.
- You still can use documentation comments (e.g., KDoc) on top of a function/method/Composable, but even then, prioritize making the code self-documenting.

**2. ALWAYS KEEP DOCS IN SYNC**

- CRITICAL: Whenever you modify a component, screen, service or use case, you MUST update its corresponding header/documentation.

**3. UI DOCUMENTATION (Screens & Components)**

- Every Screen and Component MUST have a descriptive header comment (KDoc) at the top of its main `@Composable` function.
- **Components**:
  - Include: Purpose, Usage (Inputs/Outputs/State), Key UI elements, and `Used In`.
- **Screens**:
  - Include: Purpose, Available Functionalities, Key UI elements, and Navigation events exposed. Mention what other screens can navigate to this screen

**4. SERVICES & REPOSITORIES & UseCases**

- All public methods of services and repositories need to have a documentation comment.
- Use documentation comments ONLY for public methods. Do NOT add docs to private methods.
- All UseCases also need to have a documentation comment on top of their class.
- Include: The purpose of the method and a list of classes/components that invoke it.

## Modern Framework Practices

* **Use Modern Features:** Always use the latest stable features of Kotlin and Jetpack Compose (e.g., `StateFlow`, `collectAsStateWithLifecycle`).
* **Dependency Injection:** Use Hilt (`@Inject`, `@HiltViewModel`, `@AndroidEntryPoint`) for dependency injection instead of manual instantiation.
* **Reactivity:** Follow Compose's recommended patterns for state hoisting and reactivity (e.g., maintaining state in ViewModels and observing it in Composables).
