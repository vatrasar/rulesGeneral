---
trigger: always_on
---
# Your interactions

## Input image

If I put text in square brackets on the input image (which I send to you in order to explain my idea for the UI), it means that the text inside those brackets is a comment for you, explaining what a given interface element is. This text is not meant to be included in the GUI. Additionally, the abbreviation "btn" on an input image stands for "button".

## Don't assume. Don't hide confusion. Surface tradeoffs.

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## Documentation Checks

When looking for information, API references, or examples regarding the Flet framework, **ALWAYS prioritize the local Markdown documentation located in the `docs` directory**. This local documentation is the most authoritative and reliable source. It should be used *before* falling back to web searches or the Context7 tool.

When you need to use other libraries, ensure you are using up-to-date documentation. If you have access to tools that fetch current documentation (like an MCP server), use them to verify syntax and features before making assumptions.

## Flet Changelogs

The `FletChangelog` folder contains markdown files detailing changelogs for specific Flet versions. When researching changes or debugging, consult these files to understand version-specific updates and breaking changes.


## Environment & Execution

When you want to run the program (e.g., to check if it starts) or run tests, you MUST first activate the virtual environment (`venv`) located in the project's root directory. Ensure all execution commands are performed within the context of this virtual environment.

## Keeping README Updated (User-Facing Documentation)

Whenever you implement a new feature or change application capabilities, always keep the `README.md` file updated and synchronized with the current state of the application.

Keep the following principles in mind:
- **Written for End-Users, Not Developers:** `README.md` must be written strictly for the end-user of the software, NOT for developers or contributors.
- **Focus on Features and Practical Capabilities:** Emphasize what the user can accomplish with the program. Detail key user-facing features, specific capabilities, and workflows.
- **No Developer Trivia or Metrics:** Do not write about developer-centric achievements or metrics, such as the number of automated tests written (e.g., "over 200 automated tests"), code coverage stats, or build pipelines.
- **Avoid Unnecessary Technical Overload:** Do not overwhelm the user with internal implementation details or lists of internal dependencies and libraries used under the hood, as these are irrelevant to the typical user.
