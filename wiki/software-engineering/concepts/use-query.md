---
title: "useQuery"
pillar: software-engineering
type: concept
tags: [react, tanstack-query, hooks, data-fetching]
status: stable
sources: ["[[project-tanstack-query-basic]]", "[[video-tanstack-query-crash-course]]"]
created: 2026-06-09
updated: 2026-06-09
---

# useQuery

## Definition

`useQuery` is TanStack Query's primary hook. It takes a [[query-key|`queryKey`]] (cache identity) and a `queryFn` (async function returning data), and returns the full query-state object: `data`, `isLoading`, `isPending`, `isFetching`, `isError`, `error`, plus utility callbacks like `refetch`.

## Why it matters

`useQuery` is the surface where the React component meets the server-state cache. Almost every TanStack Query best-practice (key shape, freshness policy, error handling, query factoring) ultimately surfaces at the `useQuery` call site — it's where the code-review attention belongs.

## Mechanics

### Minimal call

```tsx
const { data, isLoading, error } = useQuery({
  queryKey: ['products'],
  queryFn: fetchProducts,
});
```

### Parameterized query

```tsx
const { data, isLoading, error } = useQuery({
  queryKey: ['comments', postId],
  queryFn: () => getComments(postId),
});
```

- Wrap in an arrow when `queryFn` takes arguments — never call `queryFn: getComments(postId)`, which executes immediately.
- The `postId` goes into the [[query-key]] so different posts get different cache entries.

### Conditional execution — `enabled`

```tsx
const { data } = useQuery({
  queryKey: ['user', userId],
  queryFn: () => fetchUser(userId),
  enabled: userId !== undefined,   // skip fetch until userId is ready
});
```

`enabled: false` prevents auto-fetch. `refetch()` still works manually. Common when a query depends on data that arrives async or on a user action.

### `queryOptions` factory (reusable, type-safe)

```ts
// queryOptions/commentsOptions.ts
import { queryOptions } from '@tanstack/react-query';

export function commentsQueryOptions(postId: number) {
  return queryOptions({
    queryKey: ['comments', postId],
    queryFn: () => getComments(postId),
  });
}
```

```tsx
// Component
const { data } = useQuery(commentsQueryOptions(postId));
```

- Factors the query definition out of the component.
- Reusable: prefetch elsewhere with `queryClient.prefetchQuery(commentsQueryOptions(postId))`.
- Type-safe: return type carries through, so `data` is typed without manual generics.

## The return value

```ts
type UseQueryResult<TData, TError> = {
  data: TData | undefined;       // undefined until first fetch resolves
  error: TError | null;
  isLoading: boolean;            // first-time fetch in flight
  isPending: boolean;            // no data yet (initial state)
  isFetching: boolean;           // any fetch in flight, including background
  isSuccess: boolean;
  isError: boolean;
  refetch: () => Promise<...>;
  // ... and more
};
```

### Disambiguating the booleans

- **`isPending`** — `true` if no `data` yet. Includes initial state and after `enabled: false` was preventing the first fetch.
- **`isLoading`** — `isPending && isFetching`. The classic "first-time loading."
- **`isFetching`** — `true` whenever a fetch is in flight, including background refetches when stale data is already shown.

Use `isLoading` for first-load spinners; `isFetching` for "small spinner in the corner during background refresh."

### TypeScript narrowing

```tsx
if (isLoading) return <Spinner />;
if (isError) return <ErrorView error={error} />;
return <Data data={data} />;   // data: TData (no longer undefined)
```

Early-returns narrow `data`'s type from `TData | undefined` to `TData`.

## Common pitfalls

- **`queryFn: getTodos()`** (executes immediately) instead of **`queryFn: getTodos`** (function reference).
- **Missing inputs in `queryKey`** — `['comments']` but `queryFn` uses `postId` from closure. Cache shares entries across postIds. Bug.
- **`queryFn` returning `undefined`** — TanStack errors. Always return a value or throw.
- **Catching errors inside `queryFn`** — defeats `isError`. Let errors throw; TanStack catches them.
- **`new QueryClient()` inside a component** — recreates the cache every render. Always module-scope it.

## Alternatives

- `useSuspenseQuery` — same shape, suspends instead of returning `isLoading`. Pairs with `<Suspense>`. See [[query-suspense-mode]].
- `useQueries` — array of queries in parallel.
- `useInfiniteQuery` — pagination / "load more" patterns.

## Related

- [[tanstack-query]] — the library.
- [[query-key]] — cache identity.
- [[query-client]] — what `useQuery` reads from.
- [[query-suspense-mode]] — suspense variant.
- [[query-cache-and-stale-time]] — freshness model.
- [[use-mutation]] — write-side counterpart.

## Sources

- [[project-tanstack-query-basic]]
- [[video-tanstack-query-crash-course]]
