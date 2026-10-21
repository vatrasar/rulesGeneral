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

4. Classes, ViewModels, and services should aim for high cohesion and remain lean. If a service is unlikely to maintain high cohesion, prefer Use Cases over generic Services.

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
15. **File Length Limits:** Files should not exceed 600 lines, and ideally should stay under 300 lines. If you intend to create or expand any file beyond 600 lines, you MUST ask for and obtain explicit permission from the user beforehand. This rule also strictly applies to `.axaml` files (if a view becomes too large, split it into components or extract reusable styles/templates into a `ResourceDictionary`). It is far better to have many small, specialized files than a single monolithic giant.
    - **No Workarounds via Partial Classes or Extension Methods:** Do NOT bypass file length limits by splitting a single class across multiple files using `partial class` or moving its private/internal methods into artificial extension methods. This obscures code structure, scatters functionalities without clear boundaries, and creates pseudo-refactoring that fails to address the underlying architectural bloat.
    - **Prefer Composition:** When a class or ViewModel grows too large, refactor it using **composition** — extract cohesive child components, dedicated Use Cases, specialized services, or helper classes.
    - **Legitimate Uses of Partial Classes and Extension Methods:** Partial classes are permitted when required by the framework or source generators (e.g., Avalonia `.axaml.cs` code-behind, ReactiveUI/CommunityToolkit source generators). Extension methods are permitted for standard framework idioms (e.g., DI registrations like `IServiceCollection.Add...()`, ASP.NET Core Minimal API endpoint mappings, or generic utility helpers). They should never be used as a shortcut to bypass file size limits for a bloated class.
    - **Exceptions to Line Limits:** This limit does NOT apply to tool-generated files, specifically auto-generated designer files (e.g., `*.Designer.cs`) and Entity Framework Core migration files (`Migrations/*_*.cs`), which must never be manually split or restricted.

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

### 1. Strict UI Thread Offloading (Zero UI Blocking)

- **Absolute Ban on Heavy Work on the UI Thread:** Never execute CPU-intensive, I/O-bound, or blocking operations on the UI thread (`Dispatcher.UIThread`). This includes:
  - Database queries and persistence (EF Core calls).
  - File system, disk, and network I/O.
  - Heavy data parsing, serialization/deserialization (e.g., large JSON/XML).
  - Long loops, complex filtering, sorting, or data transformations on large collections.

### 2. Database Operations: Asynchronous, Not Concurrent

- **Async Database Access:** All database operations (queries, inserts, updates via EF Core) MUST be fully asynchronous (e.g., `SaveChangesAsync()`, `ToListAsync()`, `FirstOrDefaultAsync()`) and executed off the UI thread to prevent UI freezing.
- **Single-Threaded Context Use:** Do NOT attempt to run concurrent or multi-threaded operations on the same `DbContext` instance. Database operations should be executed sequentially in an asynchronous manner, rather than parallelized across multiple threads. Use batch operations (e.g., `AddRangeAsync`, single queries with `Contains`) instead of parallel thread loops for database tasks.

### 3. Task Cancellation & Responsiveness

- **CancellationToken Pattern:** Always propagate and respect `CancellationToken` for all asynchronous operations, background workers, and long-running loops.
- **Cooperative Cancellation:** Periodically call `cancellationToken.ThrowIfCancellationRequested()` inside CPU-intensive or iterative background tasks to ensure user navigation or cancellation promptly frees background threads.
- Avoid using boolean flags or direct `Task` disposal to abort asynchronous operations.

## Anti legacy rules

### Avalonia Source Generators & InitializeComponent

- **NEVER write a manual `InitializeComponent()` method.** In Avalonia 11.x, source generators automatically create the `InitializeComponent()` method that initializes all `x:Name` fields, wire up event handlers, and load controls. A hand-written `InitializeComponent()` will SHADOW the generated one, causing all `x:Name` fields to remain `null`at runtime. The `.axaml.cs` constructor just calls `InitializeComponent()` — nothing more.

- **NEVER call `AvaloniaXamlLoader.Load(this)` manually.** This is a legacy pattern from older Avalonia versions. It's incompatible with source-generated initialization.

## Databases

If you are going to perform a database migration that could lead to data loss, you MUST explicitly ask me for permission beforehand.
