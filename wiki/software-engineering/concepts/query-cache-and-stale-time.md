---
title: "Query Cache, Stale Time, GC Time"
pillar: software-engineering
type: concept
tags: [react, tanstack-query, cache, freshness]
status: stable
sources: ["[[video-tanstack-query-crash-course]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Query Cache, Stale Time, GC Time

## Definition

TanStack Query's cache uses a **two-clock model** to decide when data is fresh, when to refetch in the background, and when to discard a cached entry:

- **`staleTime`** — how long a query is considered **fresh** after the last successful fetch. Fresh queries never refetch automatically.
- **`gcTime`** (formerly `cacheTime`) — how long a cached entry survives **after its last subscriber unmounts**. After `gcTime`, the entry is garbage-collected.

The two clocks measure different things. Confusing them is the most common TanStack Query misunderstanding.

## Why it matters

The defaults — `staleTime: 0`, `gcTime: 5 * 60 * 1000` — make every query refetch on every focus and every remount. For most apps this is too aggressive; tuning these per query is the single highest-leverage performance and UX optimization in a TanStack Query codebase.

## The two clocks

### `staleTime` — the freshness window

```tsx
useQuery({
  queryKey: ['user', id],
  queryFn: getUser,
  staleTime: 5 * 60 * 1000,   // 5 minutes
});
```

- **`staleTime: 0` (default)** — data is stale immediately after the fetch resolves. Any focus, remount, or interval triggers a background refetch.
- **`staleTime: Infinity`** — data is never stale; you have to explicitly `invalidateQueries` to trigger a refetch.
- **Anything in between** — a window where the cached value is trusted without refetch.

Stale doesn't mean "deleted." Stale data is still shown immediately; it just gets refetched in the background to refresh.

### `gcTime` — the eviction window

```tsx
useQuery({
  queryKey: ['user', id],
  queryFn: getUser,
  gcTime: 10 * 60 * 1000,   // 10 minutes after last subscriber unmounts
});
```

- The clock starts when the **last** component using this query key unmounts.
- If a new subscriber mounts within `gcTime`, the clock resets and the cached data is used (subject to `staleTime`).
- After `gcTime` with no subscribers, the entry is removed entirely. The next subscriber re-fetches from scratch.
- **Default: 5 minutes.**

### How they interact

```
[ fetch resolves ]
     │
     │ ── fresh (staleTime window) ──── stale ────►
     │      (no refetch)             (background refetch on focus/mount)
     │
[ subscribers all unmount ]
     │
     │ ── cached (gcTime window) ──── evicted ────►
     │      (instant rehydrate)      (next subscriber re-fetches)
```

## Picking values

### `staleTime`

Match it to **how often the underlying data actually changes**:

| Data type | Suggested `staleTime` |
|---|---|
| User profile (changes rarely) | `5 - 30 min` |
| Product catalog | `1 - 5 min` |
| Real-time feed (chat, notifications) | `0` (always background-refetch) |
| Reference data (countries, taxonomies) | `Infinity` (only invalidate explicitly) |

### `gcTime`

Match it to **how often users navigate back** to the data:

| Pattern | Suggested `gcTime` |
|---|---|
| User likely to return soon (modals, navigated-away pages) | `10 - 30 min` |
| Rare-access data | `1 - 5 min` (default-ish) |
| Memory-constrained app | Shorter |

**`gcTime` must be ≥ `staleTime`** — there's no point having data go stale before it's even garbage-collected.

## Common config patterns

### Sensible default at the client level

```tsx
new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60_000,      // 1 min default
      gcTime: 5 * 60 * 1000,  // default
    },
  },
});
```

### Per-query override

```tsx
useQuery({
  queryKey: ['user', id],
  queryFn: getUser,
  staleTime: Infinity,   // never re-fetch this — invalidate manually
});
```

### Refetch-controls

```tsx
useQuery({
  ...,
  refetchOnWindowFocus: false,    // disable focus-refetch for this query
  refetchOnReconnect: false,
  refetchInterval: 30_000,        // poll every 30s
});
```

## Common confusions

- **"`staleTime` controls how long data is cached."** No — `gcTime` controls cache lifetime. `staleTime` controls when *fresh* becomes *stale*.
- **"After `staleTime`, the data is deleted."** No — stale data is still rendered immediately on subscribe; a background refetch updates it.
- **"`cacheTime` and `gcTime` are different."** No — they're the same thing; `cacheTime` was renamed to `gcTime` in v5.

## Related

- [[tanstack-query]] — the library.
- [[query-client]] — where `defaultOptions` live.
- [[use-query]] — where per-query overrides go.
- [[query-invalidation]] — manual cache busting, independent of `staleTime`.

## Sources

- [[video-tanstack-query-crash-course]]
