---
id: tanstack-query-isfetching-vs-isrefetching
aliases: []
tags:
  - review-comments
  - react
  - tanstack-query
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
`isFetching` is true for **any** fetch in flight: the first load, background refetches, and (with `keepPreviousData` / `placeholderData`) every page or sort change. `isRefetching` is `isFetching && !isLoading`, and `isPreviousData` (v4) / `isPlaceholderData` (v5) tells you the data on screen belongs to the previous key.

## Example
```ts
// Trap: refresh spinner spins on first load and every page change
<RefreshButton isRefreshing={query.isFetching} />

// Better: derive once, inside the shared component
const isRefreshing = query.isRefetching && !query.isPreviousData
```

## Why it matters
The wrong flag makes an indicator lie about what's happening. When five callers each derive it themselves, they drift apart, so pass the query into the shared component and derive the flag in one place.

## Rule of thumb
Match the status flag to the question: "anything loading?" is `isFetching`, "user-triggered refresh of the same data?" is `isRefetching && !isPreviousData`. See [[TanStack Query]].
