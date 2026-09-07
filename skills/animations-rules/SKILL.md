---
name: animations-rules
description: Use this skill when you need to create, edit, or optimize UI animations in Slint, including property transitions, state animations, and event-loop timers.
---

## When to use this skill
Use this skill when you need to create or edit UI animations, transitions, or periodic UI update timers in Slint applications.

## How to use it
1. Use Slint's native `animate` property syntax for smooth transitions (e.g., changes in `opacity`, `background`, `width`, `x`, `y`).
2. Define `states [ ... ]` blocks when animating transitions between different component states (such as hover, pressed, active, or expanded).
3. For periodic animations or ticking logic, use `slint::Timer` with `slint::TimerMode::Repeated` rather than spawning unbounded background OS threads.
4. Avoid heavy layout-triggering property animations at high frequencies; prefer animating transform properties (`x`, `y`, `rotation-angle`) and `opacity`.

## Guidelines

### Property Animations
- Slint allows declaring animations directly on properties:
  ```slint
  Rectangle {
      background: touch.has-hover ? #3b82f6 : #1e1e1e;
      animate background { duration: 200ms; easing: ease-out; }
  }
  ```

### State-Driven Animations
- When components have multiple visual states, use the `states` syntax:
  ```slint
  states [
      expanded when root.is-expanded: {
          height: 200px;
          in {
              animate height { duration: 250ms; easing: ease-in-out; }
          }
          out {
              animate height { duration: 200ms; easing: ease-in; }
          }
      }
  ]
  ```

### Periodic Timers in Rust
- When an animation or periodic update must be driven from Rust, use `slint::Timer`:
  ```rust
  let timer = slint::Timer::default();
  let ui_weak = ui.as_weak();
  timer.start(slint::TimerMode::Repeated, std::time::Duration::from_millis(16), move || {
      if let Some(ui) = ui_weak.upgrade() {
          ui.set_tick_count(ui.get_tick_count() + 1);
      }
  });
  ```

