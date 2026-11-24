---
name: antigravity-rules-and-skills
description: >-
  Provides standards, templates, and procedures for authoring Antigravity rules
  (.agents/rules/) and skills (.agents/skills/). Use whenever creating or modifying
  rules or skills.
---

# Antigravity Rules and Skills Authoring Guide

This skill provides reference specifications and best practices for creating, structuring, and configuring Antigravity rules and skills.

---

## 1. Antigravity Rules

Rules provide persistent guidelines, constraints, and operational principles for the agent.

### 1.1 File Location
- **Agent rules:** `.agents/rules/<rule-name>.md`
- **Directory-scoped rules:** `GEMINI.md` or `AGENTS.md` in any directory.

### 1.2 Mandatory Frontmatter
Rules in `.agents/rules/` require YAML frontmatter to control activation. **Without `trigger: always_on`, rules will not be injected unconditionally into context.**

```markdown
---
trigger: always_on
---

# Rule Title

Rule content and instructions go here...
```

### 1.3 Available Triggers
- `trigger: always_on`: Injected unconditionally into every conversation turn (subject to the 20,000-token aggregate rules budget). Use for core operating principles, workspace layout, and coding standards.
- `trigger: model_decision`: Loaded on demand when the agent decides the rule is relevant to the task.
- `trigger: manual`: Loaded only when explicitly invoked.

### 1.4 Rules Best Practices & Constraints
- **File Size Limit:** Keep each rule file under 24 KB (24,000 bytes) and keep total `always_on` rules well under the 20,000-token ceiling.
- **Tone & Format:** Use clear, imperative Markdown instructions with code blocks, tables, and bullet points.
- **Language:** Write all rules in English.

---

## 2. Antigravity Skills

Skills are modular, on-demand packages containing procedures, runbooks, helper scripts, and reference documentation.

### 2.1 Directory Structure
Every skill must reside in its own subdirectory inside `.agents/skills/`:

```text
.agents/skills/<skill-name>/
├── SKILL.md          # MANDATORY: Main entry point with YAML frontmatter
├── scripts/          # Optional: Helper CLI scripts and automation tools
├── references/       # Optional: Detailed manuals, API specs, deep documentation
├── examples/         # Optional: Reference inputs, outputs, and sample files
└── resources/        # Optional: Templates, prompts, static data
```

### 2.2 Main Instruction File (`SKILL.md`)
The `SKILL.md` file must start with a YAML frontmatter block containing `name` and `description`:

```markdown
---
name: kebab-cased-skill-name
description: >-
  Third-person description explaining WHAT the skill does and WHEN to trigger it.
  Keep concise (1-2 sentences, <= 25 words) with key trigger keywords.
---

# Skill Title

## Overview
Brief description of the workflow.

## When to Use
Explicit trigger scenarios and task types.

## Step-by-Step Procedure
1. Step one...
2. Step two...

## Verification & Output Checklist
Checklist to verify task completion.
```

### 2.3 Critical Frontmatter Fields
- **`name`** (string, required): Lowercase, hyphen-separated identifier (e.g., `cli-for-agents`, `db-migrations`).
- **`description`** (string, required): **Most critical element.** Antigravity uses progressive disclosure: only `name` and `description` are loaded initially. The full `SKILL.md` is loaded only when the agent matches the task to this description.
  - Write in the third person.
  - State both **what** the skill does and **when** to trigger it.
  - Keep it concise (1–2 sentences, ≤ 25 words) to avoid bloating the always-on prompt.

### 2.4 Skills Best Practices
1. **Progressive Disclosure:** Keep `SKILL.md` lean. Put bulky reference text, large templates, or long checklists into `references/` or `resources/`, and link to them using relative links (`[Manual](./references/manual.md)`).
2. **Deterministic Scripts:** Wrap repetitive, complex, or error-prone transformations into scripts (in `project/` for project deliverables, or `scripts/` inside the skill for skill-specific helpers). Instruct the agent to run `--help` or execute the script rather than doing manual boilerplate.
3. **Verification Steps:** Always end the skill workflow with explicit verification or sanity checks.

---

## 3. Workspace Layout

- **`.agents/rules/`**: Persistent rules governing the agent's behavior.
- **`.agents/skills/`**: On-demand skills for specialized workflows.
- **`project/`**: All project source code, scripts, tests, and deliverables.
