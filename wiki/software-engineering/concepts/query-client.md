---
title: "QueryClient and QueryClientProvider"
pillar: software-engineering
type: concept
tags: [react, tanstack-query, cache, provider]
status: stable
sources: ["[[project-tanstack-query-basic]]", "[[video-tanstack-query-crash-course]]"]
created: 2026-06-09
updated: 2026-06-09
---

# QueryClient and QueryClientProvider

## Definition

**`QueryClient`** is TanStack Query's cache + scheduler. It's a plain JavaScript class (not React-aware) that holds the cache, deduplicates requests, runs background refetches, and exposes an imperative API for invalidation/prefetch.

**`QueryClientProvider`** is the React Context wrapper that makes a `QueryClient` available to descendants. Every `useQuery`/`useMutation` call inside the provider tree reads from this client.

## Why it matters

The split — pure-JS class for the data layer + React Context for the binding — is what makes TanStack Query framework-agnostic at its core and React-friendly at its boundary. Understanding the split also clarifies the setup rules: instantiate the client *outside* React; use the provider as your *only* React-side integration.

## Mechanics

### Instantiate outside React

```tsx
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60 * 1000,    // 1 min default freshness
      gcTime: 5 * 60 * 1000,   // 5 min default garbage collection
      retry: 1,
      refetchOnWindowFocus: true,
    },
  },
});
```

- **Outside React** because the cache should outlive any single component. Putting `new QueryClient()` inside a component body would recreate the cache on every render.
- `defaultOptions` set the policy floor; individual `useQuery` calls override per-query.

### Provide at the root

```tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  </StrictMode>,
);
```

- All `useQuery` / `useMutation` calls inside `<App>` use this client.
- For tests, wrap in a fresh `QueryClient` per test (cache isolation).
- For SSR (Next.js, Remix), create one client per request (server-side) and hydrate the client one on the browser.

### Reading the client imperatively

```tsx
import { useQueryClient } from '@tanstack/react-query';

function MyComponent() {
  const queryClient = useQueryClient();

  // Refetch a specific query
  queryClient.invalidateQueries({ queryKey: ['posts'] });

  // Read cached data without subscribing
  const data = queryClient.getQueryData(['posts']);

  // Set cached data directly (e.g., after a mutation)
  queryClient.setQueryData(['posts'], newData);

  // Prefetch ahead of navigation
  queryClient.prefetchQuery({ queryKey: ['post', id], queryFn: ... });
}
```

`useQueryClient()` returns the client from context. The most-used methods are `invalidateQueries`, `setQueryData`, and `prefetchQuery`.

## Default options worth setting

```tsx
new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60_000,            // default is 0 — refetch on every focus/mount
      gcTime: 5 * 60 * 1000,        // default; renamed from cacheTime in v5
      refetchOnWindowFocus: true,   // default
      retry: 3,                     // default
    },
    mutations: {
      retry: 0,                     // mutations usually shouldn't retry silently
    },
  },
});
```

The default `staleTime: 0` is the single most-surprising default — every focus and remount triggers a background fetch. Most apps want a non-zero default.

## SSR and hydration

For SSR frameworks (Next.js App Router, Remix, TanStack Start):

```tsx
// per-request server-side QueryClient
function getQueryClient() {
  if (typeof window === 'undefined') {
    return new QueryClient(...);
  }
  // browser: reuse a singleton
  if (!browserClient) browserClient = new QueryClient(...);
  return browserClient;
}
```

Pair with `HydrationBoundary` to ship the server-side cache to the client without re-fetching.

## Trade-offs

- **Pro:** clean separation between data layer (pure JS) and React binding.
- **Pro:** testable — instantiate a fresh client per test.
- **Pro:** SSR-friendly — per-request client on the server.
- **Con:** easy to misconfigure (cache inside React component, multiple clients, etc.).
- **Con:** `defaultOptions` are global — per-feature tuning requires per-query overrides.

## Related

- [[tanstack-query]] — the library.
- [[use-query]] — the primary consumer.
- [[query-invalidation]] — uses `queryClient.invalidateQueries`.
- [[query-cache-and-stale-time]] — the policies the client enforces.

## Sources

- [[project-tanstack-query-basic]]
- [[video-tanstack-query-crash-course]]
