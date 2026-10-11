---
id: tanstack-query-error-boundary-with-cached-data
aliases: []
tags:
  - review-comments
  - react
  - tanstack-query
  - error-handling
creation date: 2026-09-30 10:15
modification date: Wednesday 7th October 2026 14:58:41
---

## The idea
In [[TanStack Query]], a boolean `useErrorBoundary: true` (`throwOnError` in v5) throws **any** error to the nearest [[Error Boundary]], even when the query already has cached data from an earlier success. A failed manual refetch then replaces the whole screen the user was reading with the error page. The option can be a function, so you can throw only when there's nothing to show.

## Example
```ts
useQuery({
  queryKey,
  queryFn,
  useErrorBoundary: (_error, query) => query.state.data === undefined, // v5: throwOnError
})

// And on a manual refresh, surface failures softly
const result = await query.refetch()
if (result.isError) toast.error('Could not refresh')
```

## Optional sections inherit the hook's blast radius
Data hooks often default to throwing because they were written for page-critical data. When you reuse one for an optional section (a summary panel, a suggestions row), a failure in that section now replaces the whole page, even though the page would be perfectly usable without it. Turning the boundary off isn't enough on its own. If the component then falls back to `data?.count ?? 0`, a failure shows as a confident zero (see [[unknown-is-not-zero]]).

```tsx
const query = useSummary(filters, { useErrorBoundary: false }) // v5: throwOnError: false

if (query.isLoading) return <SummarySkeleton />
if (query.isError) return <InlineError>Couldn't load the summary.</InlineError>
return <Summary counts={query.data} />
```

## Why it matters
Adding a "Refresh" button to a query that throws to a boundary turns a transient network error into losing the page. Likewise, adding an optional panel backed by a throwing query makes the whole page depend on an endpoint it doesn't need.

## Rule of thumb
Throw to a boundary only when there's no data to show and the page can't work without it. Otherwise keep stale data on screen and show a toast, or fail the section inline.
