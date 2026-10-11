---
id: one-server-fact-one-query-key
aliases:
  - dedupe requests by sharing a query key
tags:
  - review-comments
  - tanstack-query
  - data-fetching
  - performance
creation date: 2026-10-06 23:11
modification date: Wednesday 7th October 2026 14:58:41
---

## The idea
[[TanStack Query]] dedupes requests and shares cached data only between hooks whose query keys are equal. If two components on one screen need the same number (say a filtered total) but each gets it through a different query, the library sees two unrelated queries and fetches both. A common way this happens is a "metrics" request that batches several counts as GraphQL aliases, one of which is the same count a table already asks for on its own.

## Example
```ts
// Trap: the same count fetched twice under two keys
// metrics: ['items', 'metrics', { filters }] -> { total: items(filters) { count }, stale: ... }
// table:   ['items', 'count', { filters }]   -> items(filters) { count }

// Better: both read the same hook, so one request serves both
const useItemCount = (filters) =>
  useQuery({ queryKey: ['items', 'count', filters], queryFn: () => fetchCount(filters) })

const TotalCard = ({ filters }) => <Kpi value={useItemCount(filters).data} />
const TableFooter = ({ filters }) => <Pager total={useItemCount(filters).data} />
```
Keep the batched request for the counts nobody else needs.

### Same field, different selection set
In GraphQL the trap also shows up when two components select different fields from the same root field with the same arguments. Each one writes its own query document under its own key, so the cache treats them as unrelated, and the resolver runs twice.

```ts
// Trap: tiles and a summary panel each run summary(filterBy) for their own fields
// tiles:   ['summary', 'tiles', f]  -> summary(filterBy: f) { total orphaned dormant }
// insights: ['summary', 'ownership', f] -> summary(filterBy: f) { total orphaned dormantOrphaned }

// Better: the page owns one query with the union of fields; the panel becomes presentational
const query = useSummary(f) // selects total orphaned dormant dormantOrphaned
<Tiles counts={query.data} isLoading={query.isLoading} />
<Insights counts={query.data} isLoading={query.isLoading} isError={query.isError} />
```
Watch for a side effect: two documents for the same field can also disagree about nullability. One validates the field as nullable and the other dereferences it directly, and only one of them is right.

## Why it matters
Counts over large tables are usually the most expensive part of a list page. Paying for one twice on every filter change doubles database load for nothing. The two on-screen copies can also briefly disagree while one request is still in flight.

## Rule of thumb
Before adding a field to a batched request, check whether some other component already fetches that exact fact. If it does, reuse its hook and key. Batching saves round trips, but anything inside the batch can't be shared with other queries through the cache.
