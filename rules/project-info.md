---
trigger: always_on
---
# Project Basic Information

## What is this project

Make Break remaster: Desktop application that organizes and enforces break times while working at the computer. It works similarly to safeYourEyes, but the difference is that it provides a button to confirm when the break is over. This way the app better determines the user's actual work time.

The project is being reimplemented from an old PyQt5 version into a cross-platform **Avalonia UI** (.NET) application.


### Language

- **Codebase:** All technical content (class names, variables, methods, comments, commits, documentation) MUST be in English.
- **User Interface:** [English(UI strings, labels, and messages are displayed in English).

# Features Information

Below are brief descriptions of each feature:

## Break Scheduling

The core logic that tracks work sessions and automatically triggers breaks. It schedules both short breaks and long breaks based on configured intervals. When a break is due, the app shows the break screen. The user must confirm the end of the break using a button, which lets the app better determine the real work time.

## System Tray Integration

The app runs in the system tray (not only as a standalone window). From the tray menu the user can:
- Open the settings dialog.
- Show current progress of the short/long work intervals.
- Pause (stop) the break schedule.
- Resume the break schedule.
- Exit the application.

## Settings (Configuration Dialog)

A dialog window where the user configures the four parameters of the app:
- Long break duration (minutes).
- Short break duration (seconds).
- Time between short breaks (minutes).
- Time between long breaks (minutes).

Settings are persisted to a config file (`conf.txt`).

## Progress Window

A dialog that displays the progress of the current short and long work intervals using progress bars.

## Configuration Persistence

The break-related configuration values are saved to and loaded from a plain text config file (`conf.txt`), located next to the executable.

## Startup Integration

The app is intended to be set up as a startup program (e.g., on Ubuntu via startup applications) so it runs in the background after the user logs in.

## System Tray Icon

The tray and window use the icon image stored in the resources folder (`resources/ikona.png`).