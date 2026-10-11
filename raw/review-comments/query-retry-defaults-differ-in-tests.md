---
id: query-retry-defaults-differ-in-tests
aliases: []
tags:
  - review-comments
  - react
  - tanstack-query
  - testing
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
[[TanStack Query]] retries failed queries 3 times by default, with exponential backoff (several seconds in total). Test setups usually create a QueryClient with `retry: false`, so tests never see this delay. A display-only lookup that has a fallback can show a skeleton for seconds in production before the fallback appears.

## Example
```ts
// A lookup that only decorates the UI and has a fallback
useQuery({
  queryKey: ['user-name', id],
  queryFn: () => getUserName(id), // select only the fields you show
  retry: false,
})
```

## Why it matters
Loading and error UX that look fine in tests can feel broken in production. Over-fetching a full entity just to show a name makes it worse.

## Rule of thumb
When judging loading or error UX, remember that test QueryClients and production QueryClients have different defaults (retries, `staleTime`). If a fallback exists, fail fast.
