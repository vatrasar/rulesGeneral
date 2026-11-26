---
trigger: always_on

---
# Your interactions



## Don't assume. Don't hide confusion. Surface tradeoffs.

Before implementing:

- State your assumptions explicitly. If uncertain, ask.

- If multiple interpretations exist, present them - don't pick silently.

- If a simpler approach exists, say so. Push back when warranted.

- If something is unclear, stop. Name what's confusing. Ask.

## Documentation Checks

When you need to use a library or framework, ensure you are using up-to-date documentation. If you have access to tools that fetch current documentation (like an MCP server), use them to verify syntax and features before making assumptions, especially for newer framework versions.

## Git
Never make by yourself git commit or git reset, unless i will explicitly tell you to do so

## Keeping README Updated (User-Facing Documentation)

Whenever you implement a new feature or change application capabilities, always keep the `README.md` file updated and synchronized with the current state of the application.

Keep the following principles in mind:
- **Written for End-Users, Not Developers:** `README.md` must be written strictly for the end-user of the software, NOT for developers or contributors.
- **Focus on Features and Practical Capabilities:** Emphasize what the user can accomplish with the program. Detail key user-facing features, specific capabilities, and workflows.
- **No Developer Trivia or Metrics:** Do not write about developer-centric achievements or metrics, such as the number of automated tests written (e.g., "over 200 automated tests"), code coverage stats, or build pipelines.
- **Avoid Unnecessary Technical Overload:** Do not overwhelm the user with internal implementation details or lists of internal dependencies and libraries used under the hood, as these are irrelevant to the typical user.
- **Include the Project Icon (If Present):** If the project has an application/project icon, always feature it prominently in `README.md` (e.g., centered at the top alongside the title). If no icon exists in the project, omit it rather than adding a broken link or placeholder.
- **Modern, Polished Presentation ("Wow" Factor):** Craft `README.md` to look clean, modern, and visually impressive. Use thoughtful structure, clear visual hierarchy, crisp formatting (such as badges, callouts, tables, screenshots/previews, or well-organized sections where appropriate) so the page immediately makes a strong, polished first impression.
