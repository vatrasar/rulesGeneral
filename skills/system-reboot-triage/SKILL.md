---
name: system-reboot-triage
description: Diagnoses and troubleshoots strange OS/display-server/session-level crashes (e.g. X11 "X connection broken", Mutter WM_PROTOCOLS warnings, audio daemon/Pipewire/ALSA lockups, DBus/IME failures) especially when a bug occurs across older baseline commits that previously worked fine. Recommends rebooting the computer or restarting the desktop session before modifying code.
---

# System Reboot & OS Session Troubleshooting Skill

## When to use this skill

Use this skill whenever you investigate a low-level, OS-, display-, or driver-related failure in a desktop application, characterized by:

1. **Low-level system error signatures:**
   - X11 fatal I/O errors: `X connection to :0 broken (explicit kill or server shutdown)` / `X IO Error triggered!`.
   - Window manager / compositor warnings in system logs (`journalctl`), e.g. Mutter/GNOME Shell complaining about `WM_PROTOCOLS`, invalid atoms, or unexpected client message formats.
   - DBus / IME errors during window lifecycle (e.g. `[IME] Error while destroying the context`, `DBusTextInputMethodBase.Dispose()`, IBus/Fcitx socket disconnects).
   - Audio server hangs or device disappearances (PipeWire, PulseAudio, or ALSA socket issues).
   - Video driver or OpenGL/EGL surface creation failures that abruptly terminate the process.

2. **The Golden Clue (User Statement vs Git Baseline Paradox):**
   - The user states: *"Before the changes introduced today / in older versions, this worked fine."*
   - **BUT** when you checkout the older baseline commit (which was known to work), **the exact same crash reproduces identically!**

## Why this happens

Desktop environments on Linux (GNOME Shell/Mutter, KDE/KWin, X11/Wayland, DBus, systemd user services, PipeWire/PulseAudio) maintain stateful sockets and resources. Over time, across sleep/wake cycles, multi-monitor reconnects, or heavy debugging sessions:

- The window manager (e.g. Mutter) or display server can enter an inconsistent state where handling window destruction (`WM_DELETE_WINDOW` / `XDestroyWindow`) triggers a broken pipe or explicit client kill.
- DBus daemon connections for input methods (IBus, Fcitx) or notification/tray services can become stale or orphaned.
- Audio backends can hold locked file descriptors or dead streams.

When this occurs, **every version of the application—even months-old stable commits—will crash with the exact same error**. Because developers are currently modifying code, it is easy to falsely assume that today's code changes caused the regression and waste hours attempting complex code workarounds for an OS session glitch.

## How to use it

### Step 1 - Test the baseline commit (don't guess)

Whenever a crash looks like an OS/display/audio communication failure:

1. Save any unstaged work (`git stash` or verify `git status`).
2. Checkout the baseline commit that the user identified as previously working (e.g. `git checkout <working-commit>`).
3. Build and run the exact reproduction test on the baseline commit.

### Step 2 - Evaluate the baseline result

- **Case A: The baseline commit WORKS, but HEAD fails.**
  - The bug was genuinely introduced in recent commits. Use `git bisect` or inspect diffs to find the regression in application code.

- **Case B: The baseline commit FAILS with the exact same low-level error.**
  - **STOP IMMEDIATELY! Do NOT modify the codebase.**
  - Do NOT invent complex workarounds, rewrite window destruction logic, or wrap framework internals.
  - The problem is external to the codebase (corrupted desktop session, compositor glitch, driver state, or zombie daemon).

### Step 3 - Recommend a reboot or session restart

If Case B applies:
1. Explain clearly to the user that the issue reproduces on older, unmodified commits that previously worked.
2. Ask the user to **reboot the computer** (or log out and log back in to restart the X11/Wayland session and user systemd daemons).
3. Wait for the user to confirm whether the reboot resolved the issue before making any code modifications.

## Decision Tree

```
Encounter crash on window close / audio / display / DBus
                    │
                    ▼
     Does error come from OS / X11 / Driver / DBus?
      (e.g., "X connection broken", PipeWire freeze)
                    │
           ┌────────┴────────┐
          YES                NO
           │                 │
           ▼                 ▼
 User says: "Worked fine     Investigate normal
 in older versions"          application logic
           │
           ▼
 Checkout older baseline commit
           │
           ▼
 Does older commit reproduce the exact same crash?
           │
     ┌─────┴────────────────────────┐
    YES                             NO
     │                              │
     ▼                              ▼
 OS/Session Corruption          Real Regression in code
 • DO NOT change code           • Bisect commits
 • DO NOT patch framework       • Fix recent diff
 • Ask user to REBOOT
```

## Real-world case study: makeBreak (Sep 2026)

- **Symptom:** Clicking the window frame close button ('X') on `StatisticsWindow` or `ProgressWindow` terminated the entire app with `X connection to :0 broken (explicit kill or server shutdown)`.
- **User report:** "Before today's changes, this didn't happen."
- **Investigation:** Git checkout of commit `5b4a6c2` (clean baseline from 3 days prior) showed the identical `X connection to :0 broken` crash on Mutter/GNOME Shell.
- **Resolution:** A system reboot completely resolved the issue without requiring any changes to the codebase.
