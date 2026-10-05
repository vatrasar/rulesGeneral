---
name: project-setup
description: Handles project initialization and setup when starting a new project. Activates when the user indicates setting up a project (e.g., 'setup projektu', 'robię setup projektu', 'nowy projekt', 'start new project', 'project setup', 'initialize project'). Translates user-provided project goals and descriptions from Polish (or any input language) into English and populates the project-info rule.
---

# Project Setup Skill

## When to use this skill
Activate this skill whenever the user starts or initializes a new project, especially when they use phrases such as:
- "robię setup projektu"
- "setup projektu"
- "rozpoczynam nowy projekt" / "nowy projekt"
- "project setup" / "setup project"
- "initialize project" / "new project configuration"

This skill is designed for the initial phase where general rules are copied into a new project and the project-specific configuration (`project-info.md`) needs to be populated.

## Context and Language Policy
- **User Communication:** The user commonly communicates in Polish (or their preferred language). You should converse with the user in Polish (or the language they used).
- **Rule & Codebase Language:** All project rules, documentation, and codebase technical artifacts MUST BE IN ENGLISH. Even though the user explains the project goals in Polish, all contents written into the rules (including `project-info.md`) must be translated and written in English.

## How to use it

1. **Capture and Analyze Project Details:**
   - Review the user's initial message. The user should provide a general description of the project and its goals (typically in Polish).
   - Extract the following information:
     - **Project Overview & Goals:** What the application does, what problems it solves, and its primary objectives.
     - **Target UI Language:** What language the end-user interface should use (e.g., Polish, English). If not specified, ask the user or confirm default.
     - **Key Features / Modules:** Any initial features, screens, or core requirements mentioned.
   - If the user's description is too brief or ambiguous, formulate clarifying questions (in Polish) to fill in the missing gaps before writing.

2. **Translate and Synthesize to English:**
   - Translate the user's description into clear, professional, technical English.
   - Summarize the main goals into concise bullet points or a short narrative suitable for the `project-info.md` rule.
   - Identify key features and draft initial English descriptions for each.

3. **Locate and Update `project-info.md`:**
   - Locate the project information rule file (typically `rules/project-info.md` or `.agents/rules/project-info.md` in the project root).
   - Update the sections in the file:
     - **`## What is this project`**: Replace `[Insert brief description of the application here. Explain its purpose and main goals.]` with the translated project description and core objectives.
     - **`### Language`**:
       - Keep `Codebase: All technical content (class names, variables, methods, comments, commits, documentation) MUST be in English.` intact.
       - Update `User Interface:` with the primary UI language (e.g., `Polish`, `English`, or multi-language support).
     - **`# Features Info`**:
       - Under `Below are brief descriptions of each feature:`, list each identified feature with a concise description (e.g., `- **Auth**: User authentication and session management.`).

4. **Confirm and Guide Next Steps:**
   - Report back to the user in Polish.
   - Show the translated summary and the changes made to `project-info.md`.
   - Ask for confirmation or adjustments.
   - Suggest the next steps (e.g., creating the first feature using `create-feature`, setting up architecture, or configuring tech stack dependencies).

## Example Flow

### User Input (Polish):
> "Robię setup projektu. To będzie aplikacja webowa do zarządzania budżetem domowym. Użytkownik może dodawać wydatki i przychody, kategoryzować je oraz przeglądać wykresy miesięczne. Interfejs ma być po polsku."

### Agent Action:
1. Translates project info to English:
   - **What is this project:** A web application for personal and household budget management. It enables users to record income and expenses, assign categories, and visualize financial trends through monthly charts.
   - **User Interface Language:** Polish.
   - **Features:** Expense Tracking, Income Tracking, Category Management, Analytics & Charts.
2. Updates `rules/project-info.md` with these details in English.
3. Responds to the user in Polish confirming the setup and presenting the updated `project-info.md` content.
