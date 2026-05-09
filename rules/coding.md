---
trigger: always_on
---

# Code Rules

## Technologies used in project

The application is meant to be written in Python using the Flet framework (version v0.85, avoid legacy code! ) for the UI and `pytest` for testing.
It is meant to use a feature-oriented folder architecture and standard Flet view-based routing/navigation patterns.

## Coding rules

1. You are a highly skilled software engineer who prioritizes clean code.

2. You pay particular attention to keeping functions short. Your primary goal is to write flat code. Instead of building deeply nested structures, if you find that logic cannot be simplified without nesting, try extracting the inner block into a separate, dedicated function/method.

3. Names should be self-explanatory and communicate intent. Prioritize clarity over brevity, but avoid redundancy and noise words. A name should be as short as possible, but not shorter than what is required to understand its purpose at a glance.
   
   - Use **snake_case** for variables, functions, and module names.
   - Use **PascalCase** for class names.

4. Services should remain lean. If a service is unlikely to maintain high cohesion, prefer Use Cases over generic Services.

5. Language Requirements
   All naming conventions (variables, functions, classes) and comments within the code must be in English. Type hints (`typing`) are mandatory for all function arguments and return types.

6. **Prefer Enums over Constants/Strings:** Whenever a variable can hold a limited set of predefined values (e.g., ShiftType, EmployeeRole, DayOfWeek), **always** use Python's `enum.Enum` or `enum.StrEnum`. Do not use plain string or integer constants for these purposes.

7. There must be blank lines separating properties/fields from the constructor or methods to create a clear visual boundary between the class state and its behavior. Follow PEP 8 spacing rules.

8. Avoid Legacy Patterns. Never suggest deprecated patterns or "old-school" boilerplate if a modern, cleaner alternative exists within Python or Flet.

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

12. **Import Conventions:**
    The `Src` directory is added to the `PYTHONPATH` because the entry point (`main.py`) is located there. Therefore, all imports MUST start directly with the folders inside `Src` (e.g., `Features`, `Infrastructure`, `Shared`, `Core`). DO NOT use the `Src.` prefix in your import statements.

## Documentation & Commenting Standards

**1. NO INLINE COMMENTS**

- Adding comments within a function or method body is STRICTLY FORBIDDEN. 
- Logic should be so clear and names so expressive that internal comments are redundant. 
- Code MUST be self-documenting through expressive naming and clear structure.
- You must use Python Docstrings (Google style preferred) on top of a function/method/class, but even then, prioritize making the code self-documenting through better naming and structure.

**2. ALWAYS KEEP DOCS IN SYNC**

- CRITICAL: Whenever you modify a component, screen, service (logic, UI, navigation, or usages) or use case, you MUST update its corresponding docstring.

**3. UI DOCUMENTATION (Screens & Components)**

- Every Screen and Component MUST have a descriptive docstring at the top of its View class. If a Screen utilizes a ViewModel, the primary UI documentation must still reside at the top of the View class.
- **Components** (Default location: `ScreenComponents`, unless explicitly instructed to use `FeatureComponents` or `GlobalComponents`):
  - Include: Purpose, Usage (Inputs/Outputs/Bindings), Key UI elements, and `Used In` (list of screens/components referencing it).
- **Screens**:
  - Include: Purpose, Available Functionalities, Key UI elements, and Navigation (`Navigate From` and `Navigate To` paths).

**4. SERVICES & REPOSITORIES & UseCases**

- All public methods of services and repositories need to have a docstring.
- Use docstrings ONLY for public methods. Do NOT add docs to private methods.
- All UseCases also need to have a docstring on top of their class.
- Include: The purpose of the method and a list of classes/components that invoke it.

## Modern Framework Practices

* **Use Modern Features:** Always use the latest stable features of Python and Flet. Use data classes (`@dataclass`) or Pydantic models for data structures.

## Databases

If you are going to perform a database migration that could lead to data loss, you MUST explicitly ask me for permission beforehand.