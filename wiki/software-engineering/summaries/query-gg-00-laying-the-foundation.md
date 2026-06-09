---
title: "query.gg ch00 — Laying the Foundation"
pillar: software-engineering
type: summary
tags: [course, chapter, react, tanstack-query, data-fetching, server-state]
status: stable
source: "raw/courses/fireship.dev/query.gg/00_Laying the Foundation.md"
course: "query.gg (fireship.dev)"
created: 2026-06-09
updated: 2026-06-09
---

# query.gg ch00 — Laying the Foundation

The "why TanStack Query exists" chapter. Walks through the naive `useEffect` + `useState` approach, layers on the bugs (no loading/error state, race conditions, no dedup, no cache invalidation), and ends with the realization that you're rebuilding TanStack Query badly.

## TL;DR

- React's mental model is `v = f(s)` — view as a function of state. For UI state, React's primitives (`useState`, `useReducer`) are enough.
- But **server state is fundamentally different from client state**: not owned, possibly stale, asynchronous, multi-user-mutable. See [[server-state-vs-client-state]].
- The naive evolution — `useEffect` + `useState` + cleanup-closure for race conditions + custom hook + context for dedup — produces a complex mesh of code that *still* doesn't handle cache invalidation correctly. Cache invalidation is famously one of the hardest problems in CS.
- **TanStack Query is the asynchronous state manager** for server state. It doesn't fetch — it *manages* what's fetched. The fetching is yours (fetch/axios/whatever); the cache, dedup, stale tracking, refetching, invalidation, and React integration are TanStack's. See [[tanstack-query]].
- Minimal install:
  - `QueryClient` (the cache) → instantiated outside React.
  - `QueryClientProvider` at the root.
  - `useQuery({ queryKey, queryFn })` in any component.

## Key takeaways

- **The four bugs the naive approach hits:**
  1. No loading/error states → infinite spinner + CLS.
  2. Race conditions on rapid input changes (newer response can arrive before older one).
  3. Per-component state duplication (10 components fetching same URL = 10 fetches).
  4. No cache invalidation discipline — when does cached data go stale?
- **TanStack Query solves all four** by being a coordinated cache: requests dedup by `queryKey`, races resolve by latest, components share the cached data, invalidation is explicit.
- The chapter foreshadows **shared ownership** of server state — multiple users can change it; *your* cached copy is always a snapshot. This is the mental model TanStack Query is designed around.

## Notable passages

> "TanStack query doesn't actually fetch the data but manages it."

> "What started out as a simple data fetching operation resulted in a complex mesh of `useEffect`, `useState` and `useContext`."

> "Cache invalidation is one of the hardest problem statements in Computer Science."

## Open questions

- The chapter mentions `QueryClient` is the cache + scheduler — how does it interact with React Suspense (`useSuspenseQuery`)? See [[query-suspense-mode]].
- Are there cases where naive `useEffect` is preferable to `useQuery`? (Likely: one-shot, single-component, fire-and-forget. But where's the line?)
- How does TanStack Query interact with **React Server Components** in Next.js? RSC fetches on the server with no client cache; TQ assumes a long-lived client cache.

## Cross-references

- Companion: [[project-tanstack-query-basic]] (hands-on minimal project), [[video-tanstack-query-crash-course]] (full API surface).
- Concepts: [[tanstack-query]], [[server-state-vs-client-state]], [[query-client]], [[use-query]], [[query-key]].

## Source

- `raw/courses/fireship.dev/query.gg/00_Laying the Foundation.md`
