---
id: filter-before-paginating
aliases: []
tags:
  - review-comments
  - data-fetching
  - pagination
creation date: 2026-09-30 10:16
modification date: Wednesday 30th September 2026 10:16:17
---

## The idea
If you fetch a page of N rows and **then** drop some on the client (rows that can't be selected, rows the user can't act on), you end up with fewer than N, and nothing in the UI can tell. Any logic that compares against the server's total count, like "select first N", "all done" or "has more", will disagree with what's actually on screen. Filtering has to happen before the limit is applied, on the server, or the checks have to compare against what was actually selectable.

## Example
```ts
// Trap: fetch 100, keep 83, but completion is judged against the server total
const { items, total } = await fetchPage({ limit: 100 })
const selectable = items.filter(canSelect)
setSelection(selectable)
const isDone = selection.length >= Math.min(100, total) // never true, so the button never hides

// Better: push the filter into the query so the limit applies to selectable rows
const { items } = await fetchPage({ limit: 100, filter: { selectable: true } })

// Or, if the filter must stay client-side, judge "done" by what was selectable
const isDone = selectable.every(item => selection.includes(item.id))
```

## Why it matters
"Select first 100" silently selects 83, re-clicking does nothing, and the button never goes away. Page sizes, "load more" and infinite scroll break the same way: a page can even come back empty after filtering while more matches exist on the server.

## Rule of thumb
Filter, then limit, never the other way round. If you filter on the client after a paginated fetch, every count and completion check has to use the filtered result. See [[Pagination]].
