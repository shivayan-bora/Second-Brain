---
id: initialize-state-dont-correct-in-effect
aliases: []
tags:
  - review-comments
  - react
  - state
  - effects
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
If you create state (a `useState`, a reducer, an [[XState]] actor) with the wrong initial value and then fix it in an effect, children render once with the wrong value. The fix also re-runs if the state is ever recreated, which resets the user's own choice. Pass the correct value in at creation time instead.

## Example
```tsx
// Trap
const [needsApproval, setNeedsApproval] = useState(true)
useLayoutEffect(() => { setNeedsApproval(defaultNeedsApproval) }, [])

// Better
const [needsApproval, setNeedsApproval] = useState(defaultNeedsApproval)

// XState: accept input instead of sending a corrective event
<MachineContext.Provider options={{ input: { needsApproval: defaultNeedsApproval } }}>
```

## Why it matters
Correct-after-mount code depends on subtle identity stability (refs, actor instances) and fights the user once it re-runs. It also takes two renders to express one value.

## Rule of thumb
Seed state with the right value. If you truly need a corrective effect, leave a comment explaining why. See [[You Might Not Need an Effect]].
