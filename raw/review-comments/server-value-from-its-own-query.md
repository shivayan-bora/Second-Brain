---
id: server-value-from-its-own-query
aliases: []
tags:
  - review-comments
  - react
  - tanstack-query
  - data-fetching
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 13:24:11
---

## The idea
A child that shows a server value (a status, say) and reads it from a parent's cached paginated list gets a copy that goes stale with the list, and it's `undefined` on deep links. The child should query the entity by its own key. `refetchInterval` can be a function, so it polls only while the entity is in a transient state.

## Example
```ts
const { data: run } = useQuery({
  queryKey: ['run', runId],
  queryFn: () => getRun(runId),
  refetchInterval: (data) => (data?.status === 'running' ? 5000 : false),
  // v5 signature: (query) => query.state.data?.status === 'running' ? 5000 : false
})
```

## Why it matters
UI that promises live behavior ("results will appear once it completes") without polling behind it breaks that promise. Reading from the list also couples the child to whichever parent happened to render it.

## Refreshing one copy
The same trap shows up with a manual refresh. If a detail panel refetches its own query but the list row behind it reads the same fact (a count, a status) from the list query, the refresh makes the screen disagree with itself. Nest both keys under one prefix and invalidate the prefix:

```ts
// keys: ['runs', 'list', params] and ['runs', 'subjects', params]
await Promise.all([
  detailQuery.refetch(),
  queryClient.invalidateQueries({ queryKey: ['runs', 'list'] }),
])
```

## Rule of thumb
A component that displays an entity reads it from that entity's own query key. Poll conditionally, only while it's in progress. A refresh the user triggers should refresh every on-screen copy of that entity.
