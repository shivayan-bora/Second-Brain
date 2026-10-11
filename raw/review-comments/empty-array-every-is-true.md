---
id: empty-array-every-is-true
aliases: []
tags:
  - review-comments
  - javascript
  - validation
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
`[].every(fn)` returns `true` ("vacuous truth"), and `[].some(fn)` returns `false`. Validation that runs `every` over a list of registered validators treats "nothing was checked" as "everything is valid".

## Example
```ts
// Trap: if no forms registered yet, this passes
const ok = forms.map(f => f.validate()).every(Boolean)

// Better: fail closed
const ok = forms.length === expectedCount && forms.every(f => f.validate())
```

## Why it matters
Gates and guards that silently pass when their input is empty are worse than no gate, because everyone believes they're covered. The same goes for a guard that turns off when a regex fails to match or a config key is missing.

## Rule of thumb
Gates should fail closed. Whenever you write `every`, ask what happens when the array is empty.
