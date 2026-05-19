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

1. You are a highly skilled software engineer who prioritizes clean code.

2. You pay particular attention to keeping functions short. Your primary goal is to write flat code.
   - **Nesting implies complexity:** Remember that blocks like `try...except`, `with`, `for`, and `while` ALL count as a level of nesting, just like `if` statements.
   - **Extract inner blocks:** If you find yourself nesting structures (e.g., a `for`/`while` loop inside a `try`/`with` block, or any conditional `if-else` / loop structures inside any `for`, `while`, `try`, or `with` block), you MUST extract the inner logic to prevent deep indentation. The body or content of these blocks must remain flat. A common and preferred pattern is to extract the entire body/logic into a separate, dedicated private function/method.

3. Names should be self-explanatory and communicate intent. Prioritize clarity over brevity, but avoid redundancy and noise words. A name should be as short as possible, but not shorter than what is required to understand its purpose at a glance. For example, `numberOfRemainingFreeHours` is far superior to `h`.

4. ViewModels and Services should remain lean. Prefer Use Cases over generic Services if logic becomes complex. Use Kotlin Coroutines and Flows for asynchronous operations and state management.

5. Language Requirements
   All naming conventions (variables, functions, classes) and comments within the code must be in English.

6. **Prefer Enums/Sealed Classes over Constants/Strings:** Whenever a variable can hold a limited set of predefined values (e.g., UI States, ShiftType), **always** use a strongly-typed `enum class` or `sealed class`/`sealed interface` in Kotlin.

7. There must be blank lines separating properties/fields from the constructor or methods to create a clear visual boundary between the class state and its behavior

8. Avoid Legacy Patterns. Never suggest deprecated patterns or "old-school" boilerplate if a modern, cleaner alternative exists

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

12. **Entities:** Entity names MUST end with the suffix `Entity` (e.g., `UserEntity`).
13. **Global Configuration:** All application-wide constants, configuration settings (e.g., database URLs, API endpoints), and global flags MUST be stored in `core/config.py`. Avoid hardcoding these values directly in the implementation classes.
14.  Whenever you add a `try...except` (or `try...catch`) block, exceptions MUST be explicitly handled (don't leave empty catch bloks )

16. loops
- To prevent deep indentation and maintain flatness, the body of the `for/while` loop must remain flat (e.g., no nested `if-else` or other nested loops/blocks). If nesting or condition-checking is required, extract that logic into a dedicated helper function and invoke it inside the loop body.

## Documentation & Commenting Standards

**1. NO INLINE COMMENTS**

- Adding comments within a function or method body is STRICTLY FORBIDDEN. 
- Logic should be so clear and names so expressive that internal comments are redundant. 
- Code MUST be self-documenting through expressive naming and clear structure.
- You still can use documentation comments (e.g., KDoc) on top of a function/method/Composable, but even then, prioritize making the code self-documenting.

**2. ALWAYS KEEP DOCS IN SYNC**

- CRITICAL: Whenever you modify a component, screen, service or use case, you MUST update its corresponding header/documentation.

**3. UI DOCUMENTATION (Screens & Components)**

- Every Screen and Component MUST have a descriptive header comment (KDoc) at the top of its main `@Composable` function. If a Screen utilizes a ViewModel, the primary UI documentation must still reside at the top of the View class.
- **Components**:
  - Include: Purpose, Usage (Inputs/Outputs/State), Key UI elements, and `Used In`.
- **Screens**:
  - Include: Purpose, Available Functionalities, Key UI elements, and Navigation events exposed. Mention what other screens can navigate to this screen
- ONLY the main `@Composable` function in a given file is allowed to have a documentation comment. Do not add docstrings to any other helper components or secondary functions within the same file.

**4. SERVICES & REPOSITORIES & UseCases**

- All public methods of services and repositories need to have a documentation comment (EXCEPT for the `execute` method in UseCases, use case should have doc comment only on top of its class)
- Use documentation comments ONLY for public methods. Do NOT add docs to private methods.
- All UseCases also need to have a documentation comment on top of their class.
- Include: The purpose of the method and a list of classes/components that invoke it.

**5. DOCUMENT CURRENT STATE ONLY**

- When documenting usages (e.g., `Used In` sections or invocation lists for services/components), you MUST ONLY list actual, currently implemented usages. 
- DO NOT list anticipated or planned future usages. Documentation must strictly represent the factual, present state of the codebase, not what will be done in the future.

## Modern Framework Practices

* **Use Modern Features:** Always use the latest stable features of Kotlin and Jetpack Compose (e.g., `StateFlow`, `collectAsStateWithLifecycle`).
* **Dependency Injection:** Use Hilt (`@Inject`, `@HiltViewModel`, `@AndroidEntryPoint`) for dependency injection instead of manual instantiation.


## Databases

If you are going to perform a database migration that could lead to data loss, you MUST explicitly ask me for permission beforehand.
 

