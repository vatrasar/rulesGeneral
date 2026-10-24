---

trigger: always_on
---

# Your interactions

## Input image

If I put text in square brackets on the input image(which i send to you in order to explain my idea for UI) it means that the text inside those brackets is a comment for you, explaining what a given interface element is. This text is not meant to be included in the GUI. Additionally, the abbreviation "btn" on an input image stands for "button".

## Don't assume. Don't hide confusion. Surface tradeoffs.

Before implementing:

- State your assumptions explicitly. If uncertain, ask.

- If multiple interpretations exist, present them - don't pick silently.

- If a simpler approach exists, say so. Push back when warranted.

- If something is unclear, stop. Name what's confusing. Ask.#

#### Documentation

For library documentation and API lookups (including Slint, Tokio, SQLite crates, and the Rust standard library), use the `context7` MCP server to query official and up-to-date documentation.

## Problem Reporting in Summaries

In your summaries, always inform the user about any problems, errors, or implementation challenges you encountered (e.g., compile errors you had to fix, features you had to look up in documentation, or unexpected issues during testing).

## Keeping README Updated (User-Facing Documentation)

Whenever you implement a new feature or change application capabilities, always keep the `README.md` file updated and synchronized with the current state of the application.

Keep the following principles in mind:
- **Written for End-Users, Not Developers:** `README.md` must be written strictly for the end-user of the software, NOT for developers or contributors.
- **Focus on Features and Practical Capabilities:** Emphasize what the user can accomplish with the program. Detail key user-facing features, specific capabilities, and workflows.
- **No Developer Trivia or Metrics:** Do not write about developer-centric achievements or metrics, such as the number of automated tests written (e.g., "over 200 automated tests"), code coverage stats, or build pipelines.
- **Avoid Unnecessary Technical Overload:** Do not overwhelm the user with internal implementation details or lists of internal dependencies and libraries used under the hood, as these are irrelevant to the typical user.

