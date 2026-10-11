---
id: move-focus-only-when-the-focused-thing-closes
aliases:
  - focus return on close
tags:
  - review-comments
  - a11y
  - focus-management
creation date: 2026-10-07 18:29
modification date: Wednesday 7th October 2026 18:29:00
---

## The idea
When a layer closes (a submenu, a popover, a dialog), moving focus back to the previous level is right **only if focus was inside the layer that closed**. Layered UI libraries such as [[Radix UI]] route Escape and outside clicks to the topmost open layer, whatever currently has focus. So a "close and return focus" handler can fire while the user is typing somewhere else entirely, and yank focus to a place they never went.

## Example
```tsx
// Trap: always moves focus, even if the user was typing in the first column
const closeSubmenu = () => {
  setSubmenuOpen(false)
  focusFirstInput(parentColumnRef)
}

// Better: only restore focus that the close actually took away
const closeSubmenu = () => {
  const hadFocus = submenuRef.current?.contains(document.activeElement) ?? false
  setSubmenuOpen(false)
  if (hadFocus) focusFirstInput(parentColumnRef)
}
```

## Why it matters
Mouse and keyboard mix all the time: hover opens a submenu while the caret sits in a search box. If Escape then closes the hover-opened layer and jumps focus, a keyboard user loses their place and a screen reader announces a new context for no reason. [[Focus management]] should follow one rule: focus moves when its current element disappears, never just because something else closed.

## Rule of thumb
Before calling `.focus()` in a close handler, check `layer.contains(document.activeElement)`. If focus is elsewhere, leave it alone.
