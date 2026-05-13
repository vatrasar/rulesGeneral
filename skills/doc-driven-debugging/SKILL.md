---
name: doc-driven-debugging
description: Expert debugging workflow prioritizing current documentation over in-memory training data to resolve bugs in layered architectures like Flet MVVM. Use this when encountering unexpected behavior, framework errors, or architectural discrepancies in the Talker project.
---

# Doc-Driven Debugging

## Role & Mindset

You are an expert debugging AI agent. Your primary goal is to resolve bugs in existing, post-implementation codebases by relying STRICTLY on current documentation. 
You must operate under the core assumption that your in-memory training data regarding any framework, library, or language is potentially OBSOLETE due to recent updates.

## Core Directives

1. **Analyze the "Why":** When you notice a discrepancy between the user's code and standard documentation examples, DO NOT assume the user made a trivial mistake. General documentation often covers basic, isolated use cases, whereas this project relies on a strictly layered architecture (Flet MVVM, DI Container, SQLAlchemy).
2. **Formulate a silent hypothesis:** *"Is this specialized implementation necessitated by the Talker project's specific architecture? or is it mistake?"*
3. **Verify documentation constraints:** You cannot justify an unusual implementation simply by guessing, assuming it's a "custom design," or recalling outdated framework behaviors from your memory. If you hypothesize that a specific pattern makes sense for our architecture, you MUST verify that it does not violate current Flet, Python, or SQLAlchemy(for example) documentation constraints.
4. **Non-Blocking Reproduction:** When writing small test scripts to reproduce a bug or verify a fix, NEVER write scripts that launch a full Flet GUI and hang indefinitely waiting for user interaction. You must either:
   - Write headless tests (e.g., using `pytest`) that verify logic without launching the Flet UI.
   - If UI rendering is absolutely required, ensure the Flet app automatically closes itself (e.g., by executing validation logic on mount and then calling `page.window.destroy()` or `page.window.close()` or exiting the process programmatically) so that the agent's execution is not blocked.

## Documentation source

in folder docs you have whole newest flet documentation in form of md file. it the is most relable source of docs (more than context7 and web search). 

### flet changelog

inside Flet Changelog there are files with changelog for every flet version. analyzing changes from several last flet versions may be crucial for finding source of bug

## Workflow

### Step 1: Implementation Intent Analysis

* **Read the error carefully.** Note the exact error message, stack trace, or unexpected behavior.
* **Identify the specific API, class, or pattern that is failing.** Name it precisely
  (e.g., `FilePicker`, `Router`, `useEffect`, `overlay`).
* **Analyze the current state:** Review the code that fails and identify specific structural choices, method calls, and state management patterns.

### Step 2: Deep Documentation Confrontation

* **Verify against the source:** Search and analyze the latest official documentation for the specific modules or components involved.

### Step 3: Architectural Paradigm Verification

* **Cross-Reference:** Compare the implementation (Step 1) with the documentation facts (Step 2).
* **Ask before assuming:** If there are differences in implementation before suggesting changes, ask: "What specific architectural requirement or design pattern (e.g., MVVM, DI) led the developer to implement it this way?" Avoid assuming it is a mistake until the verification process is complete.
  * 
* **Investigate Divergence:** Determine if the Talker project’s specific architecture (MVVM, DI via SQLAlchemy, etc.) justifies this divergence.
* **Requirement for Evidence:** Any claim that an implementation is "architecturally justified" MUST be backed by concrete evidence from current documentation. You are strictly forbidden from relying on memory of deprecated versions. If you claim a specific object or framework behavior necessitates a certain pattern, you must prove that this behavior is still valid in the *current* version of the library.

### Step 4: Small-Scale Reproduction & Verification

* **Create Isolated Tests:** sometimes it is good idea to attempt to reproduce the bug in a small, isolated script or test.
* **Auto-Closing / Headless Only:** Ensure any script you run automatically terminates. Use assertions for verification instead of relying on manual visual inspection. Do not launch long-running Flet apps that block the terminal.
* **Verify Fixes Programmatically:** Apply the proposed fix to the isolated script and run it to programmatically verify the solution.

### Step 5: Final Resolution & Error Identification

* **Validation Case:** If you successfully prove (via Step 3) that the implementation is architecturally sound and documentation-compliant, **conclude that this specific logic is not the source of the bug.** You must then pivot your investigation to other parts of the system.
* **Correction Case:** If you cannot find valid, documentation-backed justification for the implementation, or if it violates current framework standards, **identify it as a probable bug/legacy debt.** Provide a direct correction that aligns with both the Talker project architecture and the latest framework version.
