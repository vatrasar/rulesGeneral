---
trigger: always_on

---

# Code Rules

## Technologies used in project

The application is meant to be written using modern frameworks and libraries appropriate for the chosen stack.
It is meant to use a feature-oriented folder architecture and standard routing/navigation patterns.

## Coding rules

1. You are a highly skilled software engineer who prioritizes clean code.

2. You pay particular attention to keeping functions short. Your primary goal is to write flat code. Instead of building deeply nested structures, if you find that logic cannot be simplified without nesting, try extracting the inner block into a separate, dedicated function/method.

3. Names should be self-explanatory and communicate intent. Prioritize clarity over brevity, but avoid redundancy and noise words. A name should be as short as possible, but not shorter than what is required to understand its purpose at a glance. For example, `numberOfRemainingFreeHours` is far superior to `h`. It is better to have a descriptive, long name than an ambiguous one that fails to communicate intent.

4. Services should remain lean. If a service is unlikely to maintain high cohesion, prefer Use Cases over generic Services.

5. Language Requirements
   All naming conventions (variables, functions, classes) and comments within the code must be in English.

6. **Prefer Enums over Constants/Strings:** Whenever a variable can hold a limited set of predefined values (e.g., ShiftType, EmployeeRole, DayOfWeek), **always** use a strongly-typed `enum` (if supported by the language). Do not use plain string or integer constants for these purposes.

7. There must be blank lines separating properties/fields from the constructor or methods to create a clear visual boundary between the class state and its behavior.

8. Avoid Legacy Patterns. Never suggest deprecated patterns or "old-school" boilerplate if a modern, cleaner alternative exists within the framework.

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
- You still can use documentation comments (e.g., JSDoc, XML docs, Docstrings) on top of a function/method, but even then, prioritize making the code self-documenting through better naming and structure.

**2. ALWAYS KEEP DOCS IN SYNC**

- CRITICAL: Whenever you modify a component, screen, service (logic, UI, navigation, or usages) or use case, you MUST update its corresponding header/documentation.

**3. UI DOCUMENTATION (Screens & Components)**

- Every Screen and Component MUST have a descriptive header comment at the top of its logic/controller file.
- **Components** (Default location: `ScreenComponents`, unless explicitly instructed to use `FeatureComponents` or `GlobalComponents`):
  - Include: Purpose, Usage (Inputs/Outputs/Bindings), Key UI elements, and `Used In` (list of screens/components referencing it).
- **Screens**:
  - Include: Purpose, Available Functionalities, Key UI elements, and Navigation (`Navigate From` and `Navigate To` paths).

**4. SERVICES & REPOSITORIES & UseCases**

- All public methods of services and repositories need to have a documentation comment.
- Use documentation comments ONLY for public methods. Do NOT add docs to private methods.
- All UseCases also need to have a documentation comment on top of their class.
- Include: The purpose of the method and a list of classes/components that invoke it.


## Modern Framework Practices

* **Use Modern Features:** Always use the latest stable features of the framework (e.g., source generators, hooks, composition API, depending on the stack) rather than manual boilerplate.
* **Component Initialization:** Do not manually write initialization code that the framework or compiler generates automatically.
* **Reactivity:** Follow the framework's recommended patterns for reactivity and state observation instead of manual UI updates.

## Databases

If you are going to perform a database migration that could lead to data loss, you MUST explicitly ask me for permission beforehand.

