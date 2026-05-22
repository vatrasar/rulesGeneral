---
trigger: always_on

---

# Code Rules

## Technologies used in project

The application is to be written in C# using the following frameworks:

{

1. AvaloniaUi

2. ReactiveUI

3. xUnit

4. Microsoft.Extensions.DependencyInjection

5. Microsoft.Extensions.Configuration
6. Entity Framework Core
7. SQLite

}

It is meant to use routing from ReactiveUI and a feature-oriented folder architecture.

## Coding rules

1. You are a highly skilled software engineer who prioritizes clean code.

2. You pay particular attention to keeping functions short. Your primary goal is to write flat code.
   - **Nesting implies complexity:** Remember that blocks like `try...except`, `with`, `for`, and `while` ALL count as a level of nesting, just like `if` statements.
   - **Extract inner blocks:** If you find yourself nesting structures (e.g., a `for`/`while` loop inside a `try`/`with` block, or any conditional `if-else` / loop structures inside any `for`, `while`, `try`, or `with` block), you MUST extract the inner logic to prevent deep indentation. The body or content of these blocks must remain flat. A common and preferred pattern is to extract the entire body/logic into a separate, dedicated private function/method.


3. Names should be self-explanatory and communicate intent. Prioritize clarity over brevity, but avoid redundancy and noise words. A name should be as short as possible, but not shorter than what is required to understand its purpose at a glance. For example, numberOfRemainingFreeHours is far superior to h. It is better to have a descriptive, long name than an ambiguous one that fails to communicate intent.

4. Services should remain lean. If a service is unlikely to maintain high cohesion, prefer Use Cases over generic Services

5. Language Requirements
   All naming conventions (variables, functions, classes) and comments within the code must be in English.

6. **Prefer Enums over Constants/Strings:** Whenever a variable can hold a limited set of predefined values (e.g., ShiftType, EmployeeRole, DayOfWeek), **always** use a strongly-typed `enum`. Do not use `string` or `int` constants for these purposes.

7. There must be blank lines separating properties/fields from the constructor or methods to create a clear visual boundary between the class state and its behavior

8. Avoid Legacy Patterns. Never suggest deprecated patterns or "old-school" boilerplate if a modern, cleaner alternative exists

9. Use suffix DTO only for models which are used for network communication

10. Models shouldn't use suffix "model". Better to name model Malpa than MalpaModel

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
13. Whenever you add a `try...except` (or `try...catch`) block, exceptions MUST be explicitly handled (don't leave empty catch bloks )
 loops
14.  To prevent deep indentation and maintain flatness, the body of the `for/while` loop must remain flat (e.g., no nested `if-else` or other nested loops/blocks). If nesting or condition-checking is required, extract that logic into a dedicated helper function and invoke it inside the loop body.

## Documentation & Commenting Standards

**1. NO INLINE COMMENTS**

- Adding comments within a function or method body is STRICTLY FORBIDDEN. 
- Logic should be so clear and names so expressive that internal comments are redundant. 
- Code MUST be self-documenting through expressive naming and clear structure.
- You still can use XML Documentation comments (///) on top of fucntion/method, but even then, prioritize making the code self-documenting through better naming and structure.

**2. ALWAYS KEEP DOCS IN SYNC**

- CRITICAL: Whenever you modify a component, screen, service (logic, UI, navigation, or usages) or usecase, you MUST update its corresponding header/XML documentation.

**3. UI DOCUMENTATION (Screens & Components)**

- Every Screen and Component MUST have a descriptive header comment at the top of its `.axaml.cs` file.
- **Components** (Default location: `ScreenComponents`, unless explicitly instructed to use `FeatureComponents` or `GlobalComponents`):
  - Include: Purpose, Usage (Inputs/Outputs/Bindings), Key UI elements, and `Used In` (list of screens/components referencing it).
- **Screens**:
  - Include: Purpose, Available Functionalities, Key UI elements, and Navigation (`Navigate From` and `Navigate To` paths).

**4. SERVICES & REPOSITORIES & UseCases**

-  All public methods of services and repositories need to have a documentation comment (EXCEPT for the `execute` method in UseCases, use case should have doc comment only on top of its class)
- Use XML Documentation (`///`) ONLY for `public` methods. Do NOT add XML docs to `private` methods.
- All UseCases also need to have documentation comment on top of its class
- Include: The purpose of the method and a list of classes/components that invoke it.

**5. DOCUMENT CURRENT STATE ONLY**

- When documenting usages (e.g., `Used In` sections or invocation lists for services/components), you MUST ONLY list actual, currently implemented usages. 
- DO NOT list anticipated or planned future usages. Documentation must strictly represent the factual, present state of the codebase, not what will be done in the future.




## Threads and Asynchrony

### Task Cancellation

Always use the `CancellationToken` pattern for canceling asynchronous operations or long-running tasks.
Avoid useing boolean flags or direct `Task` disposal to stop asynchronous operations. Pass a `CancellationToken` to methods that support it.

## Anti legacy rules

### Avalonia Source Generators & InitializeComponent

- **NEVER write a manual `InitializeComponent()` method.** In Avalonia 11.x, source generators automatically create the `InitializeComponent()` method that initializes all `x:Name` fields, wire up event handlers, and load controls. A hand-written `InitializeComponent()` will SHADOW the generated one, causing all `x:Name` fields to remain `null`at runtime. The `.axaml.cs` constructor just calls `InitializeComponent()` — nothing more.

- **NEVER call `AvaloniaXamlLoader.Load(this)` manually.** This is a legacy pattern from older Avalonia versions. It's incompatible with source-generated initialization.

## Databases

If you are going to perform a database migration that could lead to data loss, you MUST explicitly ask me for permission beforehand.
