---
id: idempotent-preset-filters
aliases:
  - preset filters replace same-field filters
tags:
  - review-comments
  - ux
  - state
creation date: 2026-10-06 23:11
modification date: Tuesday 6th October 2026 23:11:16
---

## The idea
A "preset" action, like a KPI card or quick-filter chip that says "show only X", should be idempotent. Clicking it twice should leave the same state as clicking it once. If the handler appends the preset to the current filters, every click adds another copy. A preset on a field the user has already filtered gets ANDed with that filter, which can silently return nothing.

## Example
```ts
// Trap: append. Two clicks give two identical chips.
setFilters((current) => [...current, ...preset])

// Better: replace any filter on the preset's fields, then add the preset
setFilters((current) => {
  const presetFields = new Set(preset.map((filter) => filter.field))
  return [...current.filter((filter) => !presetFields.has(filter.field)), ...preset]
})
```
Do the merge inside the state updater, on the previous state, not on a value captured at render time.

## Why it matters
Appending is harmless when the preset sends the user to a different page that starts from a clean slate. Put the same code on the page that shows the results, and each click feeds back into the filters it reads. The filter bar fills with duplicates, and conflicting ranges produce empty tables that look like missing data.

## Rule of thumb
When a button sets filters, ask what a second click should do. Usually the answer is "nothing new" (replace) or "undo" (toggle), never "add another one".
