---
title: "Video — TanStack Query Crash Course"
pillar: software-engineering
type: summary
tags: [video, react, tanstack-query, server-state, hooks]
status: stable
source: "raw/videos/TanStack Query Crash Course.md"
created: 2026-06-09
updated: 2026-06-09
---

# Video — TanStack Query Crash Course

Wide-coverage crash course. Builds up from `useQuery` basics through `queryOptions` factoring, `useSuspenseQuery`, `useQueries`, freshness model (`staleTime`/`gcTime`), invalidation, and `useMutation`.

## TL;DR

- **TanStack Query is a server-state manager**, not a fetcher. It coordinates a cache (`QueryClient`) and exposes hooks that subscribe to it. You bring the fetching function.
- **Core surface**: `QueryClient` (cache + scheduler), `QueryClientProvider` (the React Context), `useQuery` (subscribe to a query), `useMutation` (server-side write), `queryOptions` (factor out reusable query configs).
- **`queryKey` is the identity** — same key, same cache entry. Array-shaped, semantically meaningful: `['comments', postId]` not `'comments-' + postId`.
- **Freshness model is dual-clock**: `staleTime` (how long is data "fresh"? default 0) and `gcTime` (how long is a cached entry kept after last subscriber unmounts? default 5 min). See [[query-cache-and-stale-time]].
- **`useSuspenseQuery`** is the variant whose `data` is never `undefined` — it suspends instead, integrating with React `<Suspense>`. See [[query-suspense-mode]].
- **`queryOptions` factory** — reusable query definitions extracted into module-level functions, spread into `useQuery` calls. Keeps queries DRY and type-safe.

## Key takeaways

- **`queryFn` takes a function reference, not a call.** `queryFn: getTodos` ✓ vs `queryFn: getTodos()` ✗ (the latter executes immediately and passes the promise/result as the function, which crashes).
- **For parameterized queries, wrap in an arrow**: `queryFn: () => getComments(id)`. The `id` also goes into the `queryKey` so different IDs get different cache entries.
- **`enabled: false`** disables auto-fetch on mount/dep-change; `refetch()` still works manually. Useful for "only fetch when user clicks button" or "depends on data not yet available."
- **`isPending` ≠ `isLoading` ≠ `isFetching`**. The video doesn't fully disambiguate; the rough mapping: `isPending` = no data yet (initial), `isLoading` = `isPending && fetching`, `isFetching` = any fetch in flight (including background refetches).
- **Type-safety via `queryOptions`**: factor the query into a helper that returns `queryOptions(...)`. The return type carries through, so `useQuery` knows the data shape without a manual generic.
- **`<Suspense>` + `useSuspenseQuery`** — the Suspense-integrated branch. `data` is guaranteed defined; loading state is hoisted to the Suspense boundary.

## Notable passages

> "TanStack query doesn't actually fetch the data but manages it."

> "queryKey: ['comments', id] — we need to pass the ID as well since this will be used to uniquely identify the piece of data returned by this query."

## Open questions

- Disambiguation of `isPending`, `isLoading`, `isFetching` — the source notes the difference but defers to an external link. Worth a dedicated concept page when sources get more precise.
- Mutations and optimistic updates are mentioned but not deeply demonstrated in the section I read. Future ingest could go deeper on `useMutation` + `onMutate` / `onError` rollback pattern.
- **Infinite queries** (`useInfiniteQuery`) — not covered. Pagination via offset/cursor — not covered.
- How does TanStack Query interact with **React Compiler** (auto-memoization)? Some setups disable RC for `useQuery`-heavy components.

## Cross-references

- Companion: [[query-gg-00-laying-the-foundation]] (the why), [[project-tanstack-query-basic]] (applied minimal project).
- Concepts: [[tanstack-query]], [[server-state-vs-client-state]], [[query-client]], [[use-query]], [[query-key]], [[query-cache-and-stale-time]], [[query-suspense-mode]], [[use-mutation]], [[query-invalidation]].

## Source

- `raw/videos/TanStack Query Crash Course.md`
