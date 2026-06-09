---
title: "TanStack Query"
pillar: software-engineering
type: concept
tags: [react, tanstack-query, server-state, data-fetching]
status: stable
sources: ["[[query-gg-00-laying-the-foundation]]", "[[project-tanstack-query-basic]]", "[[video-tanstack-query-crash-course]]"]
created: 2026-06-09
updated: 2026-06-09
---

# TanStack Query

## Definition

**TanStack Query** (formerly React Query) is an asynchronous **state manager** for **server state** — data your app fetched from an external system. It coordinates a cache, deduplicates concurrent requests, tracks staleness, runs background refetches, and exposes hooks (`useQuery`, `useMutation`, etc.) that subscribe React components to the cache.

It does *not* fetch data. You write `fetch`/`axios`/whatever in the `queryFn`. TanStack Query manages everything else.

## Why it matters

Server state is the single most common source of "weird bugs" in React apps — stale data, race conditions, redundant network requests, prop-drilled data, loading state forgotten in one component, infinite spinners. TanStack Query is the canonical answer for the React ecosystem and has set the API shape (`queryKey`/`queryFn`, dual-clock freshness model) that subsequent libraries copy.

## What it solves

- **Caching** — same `queryKey`, same cache entry. Multiple components asking for the same data trigger one fetch.
- **Deduplication** — concurrent calls collapse into one in-flight request.
- **Stale tracking** — when is the cached data "fresh enough" to use without refetch?
- **Background refetching** — refresh stale data on window focus, network reconnect, interval, or component mount.
- **Race conditions** — newer responses always win over older ones with the same key.
- **Loading/error states** — every hook returns the full state machine: `isPending`, `isLoading`, `isFetching`, `isError`, `error`, `data`, `isSuccess`.
- **Type-safety** — full TypeScript inference via `queryOptions` and the generics on `useQuery`.

## Minimal setup

```tsx
import {
  QueryClient,
  QueryClientProvider,
  useQuery,
} from '@tanstack/react-query';

// 1. Create the cache — outside React
const queryClient = new QueryClient();

// 2. Provide it at the root
<QueryClientProvider client={queryClient}>
  <App />
</QueryClientProvider>

// 3. Use it in any component
function App() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['pokemon', id],
    queryFn: () => fetch(`/api/pokemon/${id}`).then(r => r.json()),
  });
}
```

See [[query-client]], [[use-query]], [[query-key]] for each piece.

## The conceptual core

> *"TanStack Query doesn't actually fetch the data but manages it."*

The killer insight: **fetching is easy, *managing* what's fetched is hard.** TanStack Query handles the management layer — cache shape, lifecycle, freshness, dedup — and stays out of the fetching itself. That decoupling means you can use any HTTP client, GraphQL, RPC, Server Actions, even WebSocket subscriptions — anything that returns a promise.

## What TanStack Query is *not*

- **Not a client-state manager.** For UI state, use `useState`, `useReducer`, Zustand, etc. See [[server-state-vs-client-state]].
- **Not a fetch library.** Bring your own — fetch, axios, ky, GraphQL client, etc.
- **Not a routing or form library.** Other TanStack libraries (Router, Form) cover those.
- **Not a replacement for React Server Components.** RSC fetches on the server with no client cache; TanStack Query assumes a long-lived client cache. They can complement each other (RSC for initial data, TanStack for client-side refresh) but don't merge naturally.

## The hooks

| Hook | Purpose |
|---|---|
| `useQuery` | Subscribe to a single query. Returns full state. |
| `useSuspenseQuery` | Same but suspends — `data` never `undefined`. See [[query-suspense-mode]]. |
| `useQueries` | Subscribe to many queries in parallel. |
| `useMutation` | Write side: POST/PUT/DELETE, with lifecycle callbacks. See [[use-mutation]]. |
| `useQueryClient` | Imperative access to the cache (invalidate, set data, prefetch). |
| `useInfiniteQuery` | Pagination support (not covered in current sources). |

## Trade-offs

### Pros

- **Eliminates the four-bug-mesh** described in [[query-gg-00-laying-the-foundation]].
- **Excellent DevTools** — separate package, visualizes every query's state.
- **Type-safe** — full TS inference once `queryOptions` factor is set up.
- **Battle-tested** — used by most large React apps; reliable, well-documented.
- **Framework-agnostic core** — `@tanstack/react-query`, `@tanstack/vue-query`, etc.

### Cons

- **Mental-model shift required.** Treating server state as "owned externally, cached locally with policies" is unfamiliar coming from raw `useState`/`useEffect`.
- **Cache invalidation discipline still required.** TanStack helps, but you still have to call `queryClient.invalidateQueries(...)` after mutations. See [[query-invalidation]].
- **Doesn't compose cleanly with React Server Components** without extra integration code.
- **The default `staleTime: 0` causes refetches that surprise newcomers** — every focus, every remount triggers a background fetch. Tune `staleTime` per query.

## Related

- [[server-state-vs-client-state]] — the conceptual frame.
- [[query-client]] — the cache + scheduler.
- [[use-query]] — the primary subscription hook.
- [[query-key]] — cache identity.
- [[query-cache-and-stale-time]] — freshness model.
- [[query-invalidation]] — explicit cache busting.
- [[use-mutation]] — write-side counterpart.
- [[query-suspense-mode]] — `useSuspenseQuery` variant.

## Sources

- [[query-gg-00-laying-the-foundation]]
- [[project-tanstack-query-basic]]
- [[video-tanstack-query-crash-course]]
