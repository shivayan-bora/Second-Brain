---
id: drop-stale-async-results
aliases: []
tags:
  - review-comments
  - react
  - async
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
Anything that can change during an `await` (filters, the selected entity, the page) can make the result belong to a context the user has already left. Writing that result to state is a [[Race Conditions|race condition]]. Record a request id (or use an `AbortController`) before the await, and drop the result if it's no longer current afterwards.

## Example
```ts
const requestIdRef = useRef(0)

async function selectAll() {
  const id = ++requestIdRef.current
  const items = await fetchAll(filters)
  if (id !== requestIdRef.current) return // context changed while we waited
  setSelection(items)
}

// Wherever the context resets (a filter change, say), bump the id too
function onFiltersChange(next) {
  requestIdRef.current++
  setSelection([])
  setFilters(next)
}
```

## Why it matters
The stale result overwrites the fresh state. It's especially dangerous when that state feeds a destructive confirm ("Disable 100 items?") for items the user no longer sees.

## Rule of thumb
For every `await` between a user action and a `setState`, ask what can change while it's pending. If anything can, guard the write.
