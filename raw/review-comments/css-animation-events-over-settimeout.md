---
id: css-animation-events-over-settimeout
aliases: []
tags:
  - review-comments
  - css
  - react
  - animation
creation date: 2026-09-30 10:15
modification date: Friday 2nd October 2026 12:08:08
---

## The idea
Mirroring a CSS animation's duration in a JS `setTimeout` makes two sources of truth that drift apart (someone changes `3s` to `2.5s` in CSS). The DOM already fires `animationstart`, `animationiteration` and `animationend` (in React, `onAnimationIteration` and friends), so the CSS can drive the JS.

## Example
```tsx
// Keep animating while hovered, finish the current loop after the pointer leaves
const [hovered, setHovered] = useState(false)
const [animating, setAnimating] = useState(false)

<button
  onPointerEnter={() => { setHovered(true); setAnimating(true) }}
  onPointerLeave={() => setHovered(false)}
  onAnimationIteration={() => { if (!hovered) setAnimating(false) }}
>
  <Icon className={animating ? 'animate-shimmer' : ''} />
</button>
```

The same applies to "wait for the exit animation, then do X" (unmount a drawer, change the route):
```tsx
// Trap: duplicates the CSS duration, and still waits when reduced motion skips the animation
const CLOSE_MS = 300 // must match duration-300
onOpenChange={(open) => { if (!open) setTimeout(close, CLOSE_MS) }}

// Better: finish when the closing animation actually ends
<DrawerContent
  onAnimationEnd={(event) => {
    if (event.currentTarget.dataset.state === 'closed') close()
  }}
/>
```
If the animation is behind `prefers-reduced-motion`, no `animationend` fires, so close immediately in that case.

## Why it matters
Timer-synced animation stutters or cuts off. Hacks like double `requestAnimationFrame` and writing refs during render tend to pile up around it.

## Rule of thumb
Let CSS own the timing and react to animation events. Never hard-code a CSS duration in JS.
