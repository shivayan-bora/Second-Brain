---
id: delayed-auto-open-causes-layout-shift
aliases: []
tags:
  - review-comments
  - ux
  - react
  - performance
creation date: 2026-09-30 10:15
modification date: Wednesday 7th October 2026 20:55:00
---

## The idea
Content that pushes the page down after the user has started reading (a banner or panel that auto-opens on a timer) is a [[Layout Shift]]. It makes users misclick and it hurts CLS (Cumulative Layout Shift). If dismissing it only updates local `useState`, it comes back on every mount, and a "Got it" button breaks its promise.

## Example
```tsx
// Trap: reopens 5s into every visit
const [open, setOpen] = useState(false)
useEffect(() => { const t = setTimeout(() => setOpen(true), 5000); return () => clearTimeout(t) }, [])

// Better: decide one-time vs per-session, persist the dismissal accordingly,
// and reserve the space (or overlay it) instead of pushing content down
const { dismissed, dismiss } = useDismissedPreference('welcome-panel')
if (dismissed) return null
```

Two more traps hide in the "wait N seconds, then open" timer itself:
- **It counts from mount, not from when the content shows.** If the component that owns the timer also renders a loading skeleton first, the delay includes the loading time. With slow data, the panel opens the moment the real content appears.
- **Only the official toggle cancels it.** A user who is already typing in a filter or clicking a row still gets the content pushed down under them.

```tsx
useEffect(() => {
  if (!isReady) return            // start counting only once the real content is on screen
  const id = setTimeout(() => setOpen(true), 5000)
  const cancel = () => clearTimeout(id)
  // any sign of intent wins over the timer
  document.addEventListener('pointerdown', cancel, { capture: true, once: true })
  document.addEventListener('keydown', cancel, { capture: true, once: true })
  return () => {
    cancel()
    document.removeEventListener('pointerdown', cancel, { capture: true })
    document.removeEventListener('keydown', cancel, { capture: true })
  }
}, [isReady])
```

## Why it matters
A recurring shift a few seconds after load is one of the most annoying UI patterns. It moves the thing the user was about to click.

## Rule of thumb
Auto-open plus a non-persistent dismiss makes a recurring layout shift. Persist dismissals, and don't push content after first paint.
