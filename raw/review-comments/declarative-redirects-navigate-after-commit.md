---
id: declarative-redirects-navigate-after-commit
aliases: []
tags:
  - review-comments
  - react
  - routing
creation date: 2026-09-30 13:24
modification date: Wednesday 30th September 2026 13:24:11
---

## The idea
A `<Navigate>` component (in [[React Router]] and [[TanStack Router]]) doesn't redirect during render. It renders `null` and calls `navigate()` in a `useEffect`, so the rest of the tree from that render commits and paints first. TanStack Router's version re-runs whenever its props object changes identity. An inline `search={{ ... }}` is a new object on every render, so every re-render before the route changes fires another navigation.

## Example
```tsx
// Siblings still render for one frame, and every re-render re-fires the replace
return (
  <>
    <Table />
    {shouldClear ? <Navigate to="." search={{ ...search, selected: undefined }} replace /> : null}
  </>
)

// Safer: make the redirect idempotent (replace + the same target), and make sure
// nothing else in that render mounts side effects (queries, dialogs) you'd have to undo.
if (shouldClear) {
  return <Navigate to="." search={{ ...search, selected: undefined }} replace />
}
```

## Why it matters
If the redirecting render also mounts a query or a dialog, those effects start before the redirect takes over, and you get a flash or a wasted request. A non-idempotent target (push instead of replace, or a target that changes each render) can pile up history entries or loop.

## Rule of thumb
Treat `<Navigate>` as "navigate after this commit". Use `replace`, keep the target stable and idempotent, and don't render anything with side effects next to it. If the redirect comes from a user action, call `navigate()` in the handler instead.
