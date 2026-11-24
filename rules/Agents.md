---
trigger: always_on
---

# Project Operating Guidelines & Coding Standards

## 1. Workspace & Directory Architecture

- **`project/` (Primary Codebase & Tests):**
  - All project source code, CLI tools, modules, reusable scripts, **and automated tests** (e.g., `project/tests/`) **must be created and maintained inside `project/`**.
  - Keep automated unit and integration tests isolated from production data and runtime state (use ephemeral/in-memory fixtures or temporary directories).
- **`.agents/` (Agent Rules & Skills):**
  - `.agents/rules/`: Persistent, high-signal operational rules for the coding agent.
  - `.agents/skills/`: Modular, on-demand procedural skills (`SKILL.md` + optional `scripts/`, `references/`, `examples/`).
  - The primary focus of this repository is software development inside `project/`. Update `.agents/rules/` or `.agents/skills/` only when adjusting or improving the agent's own workflow (following the `antigravity-rules-and-skills` skill).

---

## 2. Language Standard

- All code, scripts, rules, skills, docstrings, and technical comments **must be written in English**.
- Communicate with the user in the user's preferred language (e.g., Polish if the user prompts in Polish), while keeping all repository deliverables in English.

---

## 3. Rules vs. Skills & Token Budget Discipline

### 3.1 Token Budget Protection & Rule Conciseness
- Antigravity enforces a strict **20,000-token ceiling** on `always_on` rules. Exceeding it degrades or drops rules from context.
- Rules in `.agents/rules/` must remain **dense, concise, and strictly prescriptive**. Avoid theoretical essays, verbose narrative justifications, and duplicate explanations across files.

### 3.2 Heuristic: When to Use a Rule vs. a Skill
- **Rules (`always_on`):**
  - Use for non-negotiable constraints, architectural boundaries, coding standards, and **frequently used core commands** executed repeatedly across turns.
- **Skills (On-Demand Loading):**
  - Use for specialized procedures, authoring templates, checklists, and **episodic workflows** executed only for specific tasks (e.g., CLI design, authoring new rules/skills, deployment, migrations).

### 3.3 Small & Modular Skills Principle
- **Prefer Small Skills:** Large, monolithic skills degrade attention and cause instructions to be missed. Keep each skill focused on a single capability or workflow.
- **Micro-Descriptions in YAML Frontmatter:** Skill `description:` fields are injected into the always-on system prompt. Keep them strictly within **1–2 sentences (≤ 25 words)** stating *what* the skill does and *when* to trigger it.

---

## 4. Coding Practices & Clean Code Standards

### 4.1 Strict File Length Limit (≤ 500 Lines)
- **Hard Ceiling:** No source code or script file may exceed **500 lines of code**.
- **Mandatory Decomposition:** If a script or module approaches or exceeds 500 lines, break it down into cohesive submodules across separate files (e.g., a package `project/<tool_name>/` with `__init__.py` and focused modules).
- **Proactive Refactoring:** When modifying an oversized legacy file, prioritize decomposing it into modular components that comply with the ≤ 500-line limit.

### 4.2 Modular Architecture & Separation of Concerns (SoC)
- **Eliminate Monoliths:** Never mix CLI argument parsing, data access/I/O, core business logic, external API calls, and presentation/formatting in a single "god file".
- **Layered Structure:** Separate complex tools into dedicated layers:
  - **CLI / Entrypoints:** Argument parsing, command routing, and high-level orchestration.
  - **Data / I/O Layer:** File reading/writing, database queries, and schema management.
  - **Domain Logic:** Core algorithms, transformations, validation, and business rules.
  - **External Clients:** Third-party API or service integrations.
  - **Formatting / Output:** Terminal output, Markdown/JSON generation, and reporting.

### 4.3 Code Quality & Maintainability
- **Type Annotations:** Use explicit type hints (e.g., Python `typing`) across function signatures and public APIs.
- **Single Responsibility Principle (SRP):** Keep functions small, focused, and shallowly nested; use early returns to avoid deep `if/else` trees.
- **DRY & Shared Utilities:** Extract repeated logic (e.g., config loaders, logging setup, path helpers) into shared utilities instead of duplicating code.
- **Robust Error Handling:** Avoid bare `except:` clauses or silent error swallowing. Catch specific exceptions and emit clear, actionable error messages.
