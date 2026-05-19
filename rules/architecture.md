---
trigger: always_on
---
# Project Architecture

## Folders architecture
**Important Note on Project Root:**
The actual project is located inside a folder named `project`. The folders described below, such as `Features`, `navigation`, and `ec`, are located *inside* this `project` folder. For you the "root" folder is located "above" the `project` folder itself.


### app/src/main/kotlin (or java)

In this directory, you will find the main application code organized by features.

- **Features:** Here we keep folders related to specific features. Each feature must have a separate folder. Inside this folder, there should be the following folders:
  
  - Presentation - here should be folders for the screens (Composables), ViewModels, and FeatureComponents.
  - Domain - and in that folder you can add folders for services, models, use cases, enums, etc. if needed.
  - DI - here you put Hilt modules specific to this feature.
    You can also add additional folders if needed.
  - navigation  Inside there are two files:
  [featureName]Navigation and [featureName]Screen.kt. 
  * [featureName]Screen are sealed interface. inside of them there are @Serializable data class and data object used in navigation.
  * [featureName]Navigation : Define navigation graphs for feature using `NavGraphBuilder` extension functions. Use type-safe destination objects/classes directly in `composable<Destination>` declarations.

- **navigation:** Here we AppBottomBar, main nav file NavGraph, base Screen class

- **Common:** It is best to put here UI elements and logic that are shared across multiple features. You can find folders like:
  
  - GlobalComponents for custom reusable Composable components (for example, custom buttons).
  - Theme for global Material 3 theme files (`Color.kt`, `Theme.kt`, `Type.kt`).

- **Core:** Shared components used by multiple features.
  - `data/local/entities`: Room database entities (e.g., `QuestionEntity`).
  - domain/enums
  - `data/local/mapper`: Extension functions to convert between Entities and Domain Models.
  - `domain/model`: Pure domain models used by the UI and business logic (e.g., `Question`).
  - `di`: Global Hilt modules (e.g., `DatabaseModule`).
  - Also includes shared services, enums, and base classes in their own subfolders.

### app/src/main/res

Here you store Android resources:
- `values/strings.xml` for localization and strings.
- `drawable/` and `mipmap/` for icons and images.
- `font/` for custom fonts.

### app/src/test & app/src/androidTest

Here you should place all tests. 
- **app/src/test:** Local unit tests (e.g., testing ViewModels, UseCases, Services).
- **app/src/androidTest:** Instrumented tests (e.g., UI tests for Jetpack Compose).

Inside of this folders there should be separated folders
- **featuresTests:** and here in subfolders you put tests related to each feature (for example, tests of services from a specific feature should be placed in `featuresTests/featureNameTests/sericesTests`).
- coreTests here you put tests related to things from core

## Database & Data Modeling

### Room Database
- We use Room Database (`FlashcardDb`).
- **Migration Strategy:** In general you should plan migration in such way that prevent losing data from old version of db


### Data Mapping Policy
The project strictly separates data layers to ensure clean architecture:
1. **Entity:** `core/data/local/entities` - Database-specific structure.
2. **Domain Model:** `core/domain/model` - Business logic and UI structure.
3. **Mapper:** `core/data/local/mapper` - Extension functions for bidirectional conversion.
- **Rule:** Every data structure change MUST be reflected in all three places (Entity, Domain Model, and Mapper).

### Sorting & Filtering
- **SQL First:** Sorting (e.g., by date, category) and filtering should be performed at the SQL level in the DAO interfaces (e.g., `QuestionDao`) rather than in-memory in the ViewModel.
- **Reactive Streams:** DAOs should return `Flow` to provide reactive updates to the UI.

## Business Logic & UseCases

- **UseCases:** Business logic (creation, editing, deletion) resides in dedicated UseCases located in `feature/[name]/domain/usecase/`.
- **Domain Object Creation:** Domain models (like `Question`) are often instantiated or modified within ViewModels before being passed to a UseCase for persistence or processing.



## Strings & Localization

Strings used in the UI of the app shouldn't be hardcoded in Composable files or logic files. Instead, they should be stored in Android's standard `res/values/strings.xml`.

- In Compose, use `stringResource(id = R.string.your_string_id)` to display strings. Do not use generic string interpolation for UI texts.
- Internal strings that are never visible to the user (e.g., dictionary keys, cache keys, event names, configuration names, etc.) shouldn't be placed in `strings.xml`. Localizing logic-bound strings breaks the application.
- Instead, these internal strings should be defined as constants. Do not leave inline "magic strings" in the code.

## Enums

Files with enums should be stored in the "Enums" folder in Core or `FeatureName/Domain`. 
For example, if we have a feature "Animals" and we want to have an enum "Tiger", we should place it in `Features/Animals/Domain/Enums/Tiger`.

## Repositories

Repositories are used to abstract data access logic. We use a contract-based approach to ensure decoupled architecture.

- **Mandatory Interfaces:** Every repository MUST have its own dedicated interface (contract) defined, and the concrete repository class MUST implement this interface.
- **Placement Restriction:** Repositories MUST NOT be placed in the `features` folder or at the feature level.
- **Repository Contracts (Interfaces):** All repository interfaces belong to the `core` layer and must be placed in core/domain/repository.
- Repository implementations should be placed in
 `core/data/repository`
### Entities

- **Important:** The Repository is the *only* place where we operate on an **Entity**.

- A repository takes a model (or a primitive like `int`, `str`) as input.
- If necessary, the repository converts this input into an `Entity`.
- The `Entity` is then used for read/write operations (e.g., to a database, a file, or other storage resources).
- `Entities` are strictly meant for communication with data resources.
- **NEVER return an `Entity` from a public repository method.** If a repository needs to return data to a Service or ViewModel, it MUST convert the `Entity` into a domain model or a primitive type first. Entities can only be returned by private/internal methods within the repository itself.

## Database Architecture

- We use room for our database architecture.
- We use @Dao interfaces tu make queries to db
for example
@Dao
interface CategoryDao {


    @Insert(onConflict = OnConflictStrategy.ABORT)
    suspend fun insertCategory(category: CategoryEntity)
}

dao interfaces are placed inside core/local/dao

- inside file core/local/[NameOfApp]Db
there is abstract class signed with @Database adnotation for example

@Database(
    entities = [QuestionEntity::class, CategoryEntity::class],
    version = 5,
    exportSchema = false
)
abstract class FlashcardDb: RoomDatabase() {

    abstract fun flashcardDao(): CategoryDao
    abstract fun questionDao(): QuestionDao
    abstract fun repetitionDao(): RepetitionDao


    companion object {

        const val DATABASE_NAME = "flashcard_db"
    }
}

## Dependency Injection (DI)
we use hilt for DI.
inside of core/di there are Modules which are used to add things like repositories and ect to di container