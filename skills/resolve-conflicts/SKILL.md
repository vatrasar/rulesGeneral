---
name: resolve-conflicts
description: Resolves git merge or rebase conflicts in the current repository after pulling or merging changes. Activates when the user triggers 'resolve-conflicts' or asks to resolve git conflicts.
---

# Resolve Conflicts

## When to use this skill
Use this skill when the user triggers `resolve-conflicts` (or asks to resolve conflicts) after pulling or merging changes in the current repository.

## Instructions
1. Run `git status` to identify all conflicted and unmerged files.
2. Inspect each conflicted file and review the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
3. Resolve the conflicts by keeping the intended changes from both sides and cleanly removing all conflict markers.
4. Verify that no conflict markers remain, then stage the resolved files using `git add`.
