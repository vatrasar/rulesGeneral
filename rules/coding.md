---
trigger: always_on

---

# Code Rules

## Technologies used in project

The application is meant to be written using modern frameworks and libraries appropriate for the chosen stack.
It is meant to use a feature-oriented folder architecture.

## Coding rules

1. You are a highly skilled software engineer who prioritizes clean code.

2. You pay particular attention to keeping functions short. Your primary goal is to write flat code. Instead of building deeply nested structures, if you find that logic cannot be simplified without nesting, try extracting the inner block into a separate, dedicated function/method.

3. Names should be self-explanatory and communicate intent. Prioritize clarity over brevity, but avoid redundancy and noise words. A name should be as short as possible, but not shorter than what is required to understand its purpose at a glance. For example, `numberOfRemainingFreeHours` is far superior to `h`. It is better to have a descriptive, long name than an ambiguous one that fails to communicate intent.

4. Classes, ViewModels/controllers, and services should aim for high cohesion and remain lean. If a service is unlikely to maintain high cohesion, prefer Use Cases over generic Services.

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

12. **File Length Limits:** Files should not exceed 600 lines, and ideally should stay under 300 lines. If you intend to create or expand any file beyond 600 lines, you MUST ask for and obtain explicit permission from the user beforehand. This rule also strictly applies to UI template/view files (if a view becomes too large, split it into smaller components or extract reusable styling/resources). It is far better to have many small, specialized files than a single monolithic giant.
    - **No Workarounds via Partial Classes or Extension Methods:** Do NOT bypass file length limits by splitting a single class across multiple files using `partial class` (or equivalent constructs) or moving private/internal methods into artificial extension methods. This obscures code structure, scatters functionalities without clear boundaries, and creates pseudo-refactoring that fails to address underlying architectural bloat.
    - **Prefer Composition:** When a class or component grows too large, refactor it using **composition** — extract cohesive child components, dedicated Use Cases, specialized services, or helper classes.
    - **Legitimate Uses of Partial Classes and Extension Methods:** Partial classes are permitted when required by the framework or source generators (e.g., UI code-behind paired with generated classes, compiler source generators). Extension methods are permitted for standard framework idioms (e.g., dependency injection setup, fluent APIs, endpoint mapping, or generic utility helpers). They should never be used as a shortcut to bypass file size limits for a bloated class.
    - **Exceptions to Line Limits:** This limit does NOT apply to tool-generated files (e.g., auto-generated code, designer files) and database migration files, which must never be manually split or restricted.

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

## Threads and Asynchrony

### 1. Strict UI Thread Offloading (Zero UI Blocking)

- **Absolute Ban on Heavy Work on the UI Thread:** If the project includes a user interface, NEVER execute CPU-intensive, I/O-bound, or blocking operations on the UI / main thread. This includes:
  - Database queries and persistence operations.
  - File system, disk, and network I/O.
  - Heavy data parsing, serialization/deserialization (e.g., large JSON/XML).
  - Long loops, complex filtering, sorting, or data transformations on large collections.

### 2. Database Operations: Asynchronous, Not Concurrent

- **Async Database Access:** All database operations (queries, inserts, updates) MUST be fully asynchronous and executed off the UI thread to prevent UI freezing.
- **Single-Threaded Context/Session Use:** Do NOT attempt to run concurrent or multi-threaded operations on a database context/session that is not thread-safe. Database operations should be executed sequentially in an asynchronous manner, rather than parallelized across multiple threads. Prefer batch operations over parallel thread loops for database tasks.

### 3. Task Cancellation & Responsiveness

- **Cancellation Pattern:** Always propagate and respect cancellation mechanisms (e.g., cancellation tokens or abort signals) for all asynchronous operations, background workers, and long-running loops.
- **Cooperative Cancellation:** Periodically check for cancellation requests inside CPU-intensive or iterative background tasks to ensure user actions or navigation promptly cancel obsolete background work.

## Databases

If you are going to perform a database migration that could lead to data loss, you MUST explicitly ask me for permission beforehand.

