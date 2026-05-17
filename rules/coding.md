---
trigger: always_on
---

# Code Rules

## Technologies used in project

The application is meant to be written in Python (version 3.12) using the Flet framework (version v0.85, avoid legacy code! ) for the UI and `pytest` for testing.
It is meant to use a feature-oriented folder architecture and standard Flet view-based routing/navigation patterns.

## Coding rules

1. You are a highly skilled software engineer who prioritizes clean code.

2. You pay particular attention to keeping functions short. Your primary goal is to write flat code.
   - **Nesting implies complexity:** Remember that blocks like `try...except`, `with`, `for`, and `while` ALL count as a level of nesting, just like `if` statements.
   - **Extract inner blocks:** If you find yourself nesting structures (e.g., a `for`/`while` loop inside a `try`/`with` block, or any conditional `if-else` / loop structures inside any `for`, `while`, `try`, or `with` block), you MUST extract the inner logic to prevent deep indentation. The body or content of these blocks must remain flat. A common and preferred pattern is to extract the entire body/logic into a separate, dedicated private function/method.
   - **Prohibition of Nested Functions/Methods:** Defining a function or method inside another function/method is STRICTLY FORBIDDEN outside of `@ft.component` functions.
     - **Exception:** Within an `@ft.component` function, you may define nested helper functions (e.g., event handlers).
     - **Double Nesting Restriction:** Even within an `@ft.component`, you cannot nest a function inside another nested function (e.g., if function `A` is nested in a component, function `B` cannot be nested inside `A`).
     - **Mandatory Permission:** If you believe nesting is absolutely necessary in any case not covered by the exception, you MUST ask the USER for explicit permission before implementing it.

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

11. **Entities:** Entity names MUST end with the suffix `Entity` (e.g., `UserEntity`).

12. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.

- Don't remove pre-existing dead code unless asked.
13. **Import Conventions:**
    The `src` directory is added to the `PYTHONPATH` because the entry point (`main.py`) is located there. Therefore, all imports MUST start directly with the folders inside `src` (e.g., `features`, `infrastructure`, `shared`, `core`). DO NOT use the `src.` prefix in your import statements.

14. **Global Configuration:** All application-wide constants, configuration settings (e.g., database URLs, API endpoints), and global flags MUST be stored in `src/core/config.py`. Avoid hardcoding these values directly in the implementation classes.

15. **Exception Handling:** Whenever you add a `try...except` (or `try...catch`) block, exceptions MUST be explicitly handled. Do not simply use a `pass` statement or leave the block empty.

16. **Prohibition of List Comprehensions for Control Lists / Complex Operations:**
    - Do NOT use list comprehensions (e.g., `[x for x in items]`) to generate lists of controls or to perform iteration over collections in your views, components, or services.
    - Always use standard, readable `for` loops with an explicit, indented loop body and standard `append()` calls (e.g., initialize an empty list, loop over the collection, call the creation/mapping helper inside the loop body, and append). This maintains high readability and complies with traditional, visual structure preferences.
    - To prevent deep indentation and maintain flatness, the body of the `for` loop must remain flat (e.g., no nested `if-else` or other nested loops/blocks). If nesting or condition-checking is required, extract that logic into a dedicated helper function and invoke it inside the loop body.

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
- **Components** (Default location: `screen_components`, unless explicitly instructed to use `feature_components` or `global_components`):
  - Include: Purpose, Usage (Inputs/Outputs/Bindings), Key UI elements, and `Used In` (list of screens/components referencing it).
- **Screens**:
  - Include: Purpose, Available Functionalities, Key UI elements, and Navigation (`Navigate From` and `Navigate To` paths).
- ONLY the main `ft.component` function in a given file is allowed to have a documentation comment. Do not add docstrings to any other helper components or secondary functions within the same file.
- If a component file contains any helper functions that are not `ft.component`s, they MUST be placed at the very end of the file.

**4. SERVICES & REPOSITORIES & UseCases**

- All public methods of services and repositories need to have a docstring (EXCEPT for the `execute` method in UseCases).
- Use docstrings ONLY for public methods. Do NOT add docs to private methods.
- `__init__` methods inside classes MUST NOT have documentation comments.
- All UseCases need to have a docstring on top of their class. This class-level docstring is sufficient; therefore, the `execute` method of a UseCase MUST NOT have its own additional docstring.
- Include: The purpose of the method and a list of classes/components that invoke it.

**5. DOCUMENT CURRENT STATE ONLY**

- When documenting usages (e.g., `Used In` sections or invocation lists for services/components), you MUST ONLY list actual, currently implemented usages. 
- DO NOT list anticipated or planned future usages. Documentation must strictly represent the factual, present state of the codebase, not what will be done in the future.

## Modern Framework Practices

* **Use Modern Features:** Always use the latest stable features of Python and Flet. Use data classes (`@dataclass`) or Pydantic models for data structures.

## Async Operations & Databases

1. **Asynchronous Database Access:** The project uses asynchronous SQLAlchemy with the `aiosqlite` driver. All database interactions MUST be non-blocking.
2. **Async Repositories & Use Cases:** All repository methods and Use Case `execute` methods MUST be defined as `async def` and properly awaited.
3. **Async Session Management:** Use `AsyncSession` provided by `DBCore.get_async_session()` (asynchronous context manager).
4. **Non-blocking UI:** Never perform synchronous blocking I/O (like file system access or sync DB calls) in Flet event handlers or component render functions. Always use `async` handlers or `asyncio.to_thread` for legacy sync code.
5. **Database Initialization:** Application-wide database setup (e.g., schema creation) must be awaited during the application's asynchronous initialization phase (e.g., in `AppDIContainer.initialize()`).

## Databases

If you are going to perform a database migration that could lead to data loss, you MUST explicitly ask me for permission beforehand.

## Debugging

When encountering a bug, often it may be good idea to create a separate, minimal Python script to reproduce and troubleshoot the issue. It is much easier to fix bugs in a small, isolated script. Once the bug is fixed and the debugging session is over, you MUST delete this temporary script.

When your debugging script runs a Flet GUI, you must ensure it closes automatically so it doesn't block the terminal and require manual user intervention. To avoid this, apply the following "Auto-closing Template":

1. **Always use `await page.window.destroy()`**: This is the most drastic but most effective method to close a Flet app in test scripts. `page.window.close()` might be blocked if there is an `on_prevent_close` event handler.
2. **Use a `try...finally` block**: Even if the test/reproduction fails, the window must be closed.
3. **Use `ft.run()` instead of `ft.app()`**: `ft.app()` is deprecated since version 0.80.0.

**Auto-closing Template:**

```python
import flet as ft
import asyncio

async def main(page: ft.Page):
    try:
        # 1. Test logic / reproduction
        print("Starting test...")
        # ... your code ...

    except Exception as e:
        print(f"Error during test: {e}")
    finally:
        # 2. Guaranteed window closure
        print("Closing window automatically...")
        await page.window.destroy()

if __name__ == "__main__":
    # 3. Use ft.run for full asynchronicity
    ft.run(main)
```