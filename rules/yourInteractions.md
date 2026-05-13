# Your interactions

## Input image

If I put text in square brackets on the input image (which I send to you in order to explain my idea for the UI), it means that the text inside those brackets is a comment for you, explaining what a given interface element is. This text is not meant to be included in the GUI.

## Don't assume. Don't hide confusion. Surface tradeoffs.

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## Documentation Checks

When looking for information, API references, or examples regarding the Flet framework, **ALWAYS prioritize the local Markdown documentation located in the `docs` directory**. This local documentation is the most authoritative and reliable source. It should be used *before* falling back to web searches or the Context7 tool.

When you need to use other libraries, ensure you are using up-to-date documentation. If you have access to tools that fetch current documentation (like an MCP server), use them to verify syntax and features before making assumptions.

## Environment & Execution

When you want to run the program (e.g., to check if it starts) or run tests, you MUST first activate the virtual environment (`venv`) located in the project's root directory. Ensure all execution commands are performed within the context of this virtual environment.
