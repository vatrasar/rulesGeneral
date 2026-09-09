---
name: avalonia-hover-clipping-prevention
description: Diagnoses and prevents clipping of card borders, highlights, and hover effects in Avalonia UI controls (ListBox, ItemsControl, UserControl, Border), particularly when using RenderTransform (translate, scale) or thin borders in tight containers.
---

# Avalonia Hover & Border Clipping Prevention

## When to use this skill
Use this skill whenever:
- Creating or modifying hover styles (`:pointerover`) or selection styles (`:selected`) on cards, list items, or container elements.
- A card, button, or item's border/highlight appears partially cut off, missing (e.g., top edge or bottom edge absent), or clipped during hover or animations.
- Applying transforms like `RenderTransform="translate(...)"` or `RenderTransform="scale(...)"` inside `ListBox`, `ItemsControl`, or nested `UserControl` containers.
- Setting up item spacing and margins inside collections (`ListBox`, `ItemsControl`).

---

## Root Causes of Border & Hover Clipping

### 1. The `RenderTransform` Border Cutoff Pitfall
**What happens:**
When a card has a thin border (e.g. `BorderThickness="1"`) and a hover effect shifts the card upwards (e.g. `RenderTransform="translate(0px, -1px)"` or `-2px`):
- The card's top 1px border is pushed to negative Y coordinates ($Y = -1$) relative to its parent container (such as `UserControl`, `ContentPresenter`, or `ListBoxItem`).
- Even if the list itself has space between items, the immediate parent wrapper (`UserControl` or `ContentPresenter`) bounds start at $Y = 0$.
- Avalonia clips the child to container bounds, cutting off the exact pixel row(s) containing the top border highlight. The side and bottom borders remain visible, making it look as if the top border failed to render.

### 2. Zero Internal Margin on the Styled Card
**What happens:**
If `Margin` is applied solely to `ListBoxItem`, the inner `UserControl` and its root `Border` still sit flush against $(0, 0)$. Any scaling, translation, or anti-aliased sub-pixel rendering at the edges touches the clipping boundary.

---

## Prevention & Best Practices

### Rule 1: Avoid `translate(0px, -Ypx)` for Cards Inside Tight Containers
For hover feedback on cards inside `ListBox` or scrollable lists, prefer visual cues that do not move the visual outside its bounds:
- Background color shift (e.g., `#1f1f1f` -> `#272727`).
- Border brush change (e.g., `#2d2d2d` -> `#0073cf`).
- Subtle inner glow or box-shadow (if supported/needed).
- If scale or translation is strictly required, **you must ensure Rule 2 and Rule 3 are in place**.

### Rule 2: Provide Internal Clearance via `Margin` on the Card Element
Always provide internal margin on the card element (`Border`) itself, not just the parent `ListBoxItem`:
```xml
<Style Selector="Border.MyCard">
    <Setter Property="Margin" Value="0,3" /> <!-- Ensures buffer space above and below the border inside the UserControl -->
    <Setter Property="ClipToBounds" Value="False" />
</Style>
```
This ensures the border sits at $Y \ge 3$, completely protected from container boundary clipping.

### Rule 3: Disable Clipping on Wrappers and Templates
Whenever cards reside inside a `ListBox` or `ItemsControl`:
1. Disable clipping on the root of the item's `UserControl`:
   ```xml
   <rxui:ReactiveUserControl ... ClipToBounds="False">
   ```
2. Disable clipping on `ListBox`, `ListBoxItem`, and `ContentPresenter#PART_ContentPresenter`:
   ```xml
   <Style Selector="ListBox.MyList">
       <Setter Property="ClipToBounds" Value="False" />
       <Setter Property="Padding" Value="0,4" />
   </Style>

   <Style Selector="ListBox.MyList ListBoxItem">
       <Setter Property="Margin" Value="0,3" />
       <Setter Property="Padding" Value="0" />
       <Setter Property="ClipToBounds" Value="False" />
   </Style>

   <Style Selector="ListBox.MyList ListBoxItem /template/ ContentPresenter#PART_ContentPresenter">
       <Setter Property="ClipToBounds" Value="False" />
   </Style>
   ```

---

## Checklist for Card Hover Effects
- [ ] Does `:pointerover` use `translate` or `scale`? If so, does the element have sufficient `Margin` so its transformed bounds never exceed the parent bounds?
- [ ] Is `BorderThickness` at least 1px and are all 4 edges fully visible on hover?
- [ ] Is `ClipToBounds="False"` set on the `UserControl` and `ContentPresenter`?
- [ ] Is there sufficient spacing (`Margin`) between consecutive list items?
