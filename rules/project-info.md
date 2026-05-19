---

trigger: always_on
---

# Project Basic Information

## What is this project

Flashcardexpress is app designed to help learning new languages using flahscards

### Stack

- **Language:** Kotlin
- **UI:** Jetpack Compose (Material 3)
- **Navigation:** Navigation-Compose
- **Dependency Injection:** Hilt

### Language

Codebase: All technical content (class names, variables, methods, comments, commits, documentation) MUST be in English.

User Interface: [Specify the primary language for the UI presented to the user].

# Features Info

1. Category Management
   
   * Management Panel: A central view that allows users to browse and oversee
     their existing flashcard categories.
   * Create Category: Users can add new categories to organize their flashcards
     by topic.
   * Category Details: View the contents of a specific category, including the
     list of associated questions.
   * Edit Category: Ability to rename or modify existing categories.
   2. Flashcard Management (Question Management)
   * Create Flashcards: Add new questions and answers to specific categories.
   * Edit Flashcards: Update and modify the content of previously created
     questions and answers.
   3. Learning & Repetition System
   * Repeat Panel: A hub for the learning module, tracking progress and
     indicating when flashcards are ready for review.
   * Study Sessions (Repetition): Conduct active learning sessions for a
     selected category. The system supports:
     * Selecting the number of questions for a session.
     * Starting new learning sessions.
     * Core repetition logic management (via RepetitionSessionManager).
   4. Interface & Navigation
   * App Bottom Bar: Quick navigation between the Management section and the
     Repetition/Study section.
   * Feedback System: Real-time user notifications (e.g., confirming a flashcard
     was successfully added) using a custom Snackbar system.
