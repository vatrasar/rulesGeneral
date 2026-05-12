# Project Architecture

## Folders architecture

### src

In this folder, you can find folders in which you will work most often.

- **features:** Here we keep folders related to specific features. Each feature must have a separate folder. Inside this folder, there should be the following folders:
  
  - ui - here should be folders for the screens, feature_styles (Python modules containing style configurations), and feature_components (Flet custom controls inheriting from `ft.Container` or other base controls).
  
  - domain - and in that folder you can add folders for services, models, use cases, enums, etc. if needed.
  
  - resources - here you put localization or asset files specific to this feature.
    You can also add additional folders (like for example "services" for services related to the feature) if needed.
    
    Additionally, each feature MUST have a dedicated navigation file named feature_name_navigation.py (e.g., voice_recorder_navigation.py). Inside this file, create a class like FeatureNameNavigation(BaseFeatureNavigation). This file must remain extremely lightweight to prevent circular imports. It should only import the UI View classes it needs to build. NO MAGIC STRINGS: Route paths must be defined as class constants.

- **infrastructure:** This folder contains core setup files that connect everything together. In this project, it houses the `nav_host.py` file, which contains the `NavHost` component (the central router), the **repositories** folder for concrete repository implementations, and the file containing the `AppDIContainer` (the simplified Dependency Injection container).

- **shared:** It is best to put here UI elements and logic that are shared across multiple features. You can find folders like:
  
  - resources with global string/localization files inside it.
  - global_styles with style files used across several features in the app.
  - global_components for custom reusable Flet components (for example, custom buttons).

- **core:** Here you can put some services, enums, models shared by several features, and base classes (like base ViewModels, base State classes or Controllers). Each category (services, models, enums, etc.) should have its own separated subfolder. This includes the **repository_contracts** folder, which stores repository interfaces, and the **config.py** file for global application constants.

### Assets

Here you can store things like icons, images, fonts, etc., which Flet will serve as static assets.

### tests

Here you should place all tests using `pytest`. Inside the tests folder, there should be:

- **core_tests:** here you put tests related to things from src/core.
- **features_tests:** and here in subfolders you put tests related to each feature (for example, tests of services from a specific feature should be placed in `features_tests/feature_name_tests/services_tests`).

## Strings & Localization

Strings used in the UI of the app shouldn't be hardcoded in view files or logic files. Instead, they should be stored in dedicated localization files (e.g., JSON) or Python dictionaries.

- Strings specific to a single feature should be placed in a localization module located at: `feature_name/resources/feature_name_strings`.
- Strings shared across multiple features (e.g., generic buttons like Save, Cancel, Error) should be placed in the global shared resources: `src/shared/resources/global_strings`.
- In Flet view files, retrieve strings from these resource objects. Do not use generic string interpolation directly with hardcoded English UI texts.
- Internal strings that are never visible to the user (e.g., dictionary keys, cache keys, event names, configuration names, etc.) shouldn't be placed in localization files.
- Instead, these internal strings should be defined as constants. Do not leave inline "magic strings" in the code.
- Before adding a new localized string to a feature-specific localization file, you should check if an equivalent string already exists in the global strings. If it does, reuse the global string.
- You shouldn't add new strings to the global strings file unless explicitly commanded to do so. If not explicitly stated to put it in global strings, always default to adding new strings to the active feature's local localization file.

## Enums

Files with enums should be stored in the "enums" folder in core or `feature_name/domain`. They should utilize Python's `enum.Enum` or `enum.StrEnum`.
For example, if we have a feature "animals" and we want to have an enum "Tiger", we should place it in `features/animals/domain/enums/tiger.py`.

## Repositories

Repositories are used to abstract data access logic. We use a contract-based approach to ensure decoupled architecture.

- **Repository Contracts (Interfaces):** All repository interfaces must be placed in `src/core/repository_contracts`. These interfaces must inherit from `abc.ABC` and use `@abstractmethod`.
- **Repository Implementations:** Concrete implementations of these repositories must be placed in `src/infrastructure/repositories`.

**Important:** The Repository is the *only* place where we operate on an **Entity**.

- A repository takes a model (or a primitive like `int`, `str`) as input.
- If necessary, the repository converts this input into an `Entity`.
- The `Entity` is then used for read/write operations (e.g., to a database, a file, or other storage resources).
- `Entities` are strictly meant for communication with data resources.

### Interface Example

```python
from abc import ABC, abstractmethod

class IPromptRepository(ABC):
    @abstractmethod
    def save_prompt(self, content: str) -> bool:
        pass

    @abstractmethod
    def get_all_prompts(self) -> list[str]:
        pass
```

## Database Architecture

We use SQLAlchemy for our database architecture. 

- **DBCore:** The core database configuration is managed in `src/infrastructure/database/db_core.py`. This file contains the `DBCore` class which handles the `create_engine` and `session_factory`. It also provides a `@contextmanager` decorated `get_session()` method. This context manager is crucial for ensuring that database sessions are properly yielded, rolled back on exceptions, and securely closed in the `finally` block.
- **Entities:** All database entities MUST be located in the `src/core/data/entities` folder.
- **Entity Registration:** Every entity must be imported in `src/core/data/entities/__init__.py`. This is extremely important because `init_db_schema` (which is called during app startup) uses `EntityBase.metadata.create_all()` to create tables, and if entities are not imported in `__init__.py`, the database will not see them.
- **DI Container:** The `DBCore` instance is created and held within the `AppDIContainer` (in `src/infrastructure/app_di_container.py`), where `init_db_schema()` is also invoked during application startup. The container makes `DBCore` available to repositories and services that require database access.

## Data Transfer Objects (DTOs)

DTOs are used for communication with external APIs. They should not be confused with Entities, which are used strictly for internal data resources within Repositories.

## Dependency Injection (DI)

We use a simplified, custom Dependency Injection (DI) container pattern without relying on dedicated external DI libraries. 

- **AppDIContainer:** The container is implemented as a class named `AppDIContainer` located in the `infrastructure` folder. 
- **Responsibilities:** The `AppDIContainer` holds properties containing instances of singleton objects (like services or repositories) and contains build methods for creating ViewModels.
- **Initialization:** The container is physically created in the main entry point (e.g., `main.py`) and is set in the page session using: `page.session.set("di_container", AppDIContainer())`.
- **Usage in Views:** When a view needs to instantiate its ViewModel, it must access the container using `page = ft.context.page` and then retrieve the container with `page.session.get("di_container")`.
- **Properties:** All properties in the container that provide access to services, repositories, or other dependencies MUST use the `@property` decorator.
- **Constraint:** The constructor of any ViewModel MUST ONLY be called by the `AppDIContainer` (via its ViewModel build method). Views or other components must never instantiate ViewModels directly.
