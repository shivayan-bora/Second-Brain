---
id: uselayouteffect-for-paint-affecting-resets
aliases: []
tags:
  - review-comments
  - react
  - effects
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
`useEffect` runs **after** the browser paints, and `useLayoutEffect` runs after the DOM updates but **before** paint. If an effect resets state that changes what's on screen (for example clearing a selection when the mode changes), a passive effect shows one frame of the inconsistent state first.

## Example
```tsx
// Trap: one frame shows the new mode's toolbar over the old selection
useEffect(() => { clearSelection() }, [mode])

// Better: runs before paint
useLayoutEffect(() => { clearSelection() }, [mode])

// Also fine: reset during render by tracking the previous value
const [prevMode, setPrevMode] = useState(mode)
if (mode !== prevMode) { setPrevMode(mode); setSelection([]) }
```

## Why it matters
The flash is often too short to notice by eye but still possible to click, and with a destructive action it's more than a cosmetic bug. If you derive the reset from the URL (not from a click handler), it also covers the Back button.

## Rule of thumb
If a reset changes what's painted, use `useLayoutEffect` or do it during render. Keep `useEffect` for syncing with the outside world. See [[useEffect]].
