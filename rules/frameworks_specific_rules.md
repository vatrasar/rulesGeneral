---
trigger: always_on
---
# Framework Specific Rules

## Running Tests and Compiling

- **JAVA_HOME Configuration**: The environment does not have a global Java runtime in the `PATH`. You must prefix all Gradle commands with the embedded JDK from Android Studio: `JAVA_HOME=/snap/android-studio/209/jbr` (or another active version under `/snap/android-studio`).
- **Working Directory**: Always run Gradle commands from the `project` subfolder.
- **Verification Command**:
  ```bash
  JAVA_HOME=/snap/android-studio/209/jbr ./gradlew test
  ```
