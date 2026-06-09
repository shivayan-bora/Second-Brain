---
title: "Server State vs Client State"
pillar: software-engineering
type: concept
tags: [react, state-management, server-state, mental-model]
status: stable
sources: ["[[query-gg-00-laying-the-foundation]]", "[[video-tanstack-query-crash-course]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Server State vs Client State

## Definition

**Client state** is state the application *owns*: UI state, form values, toggles, transient view models. It lives in React (`useState`, `useReducer`, Zustand, Redux). **Server state** is state the application *receives* — owned by a remote server, mutable by other users, possibly stale, asynchronous to fetch and update.

The distinction matters because the two need different tools.

## Why it matters

Treating server state like client state — `useState(null)` + `useEffect(fetch...)` — is the source of most "weird React bugs": race conditions, stale data, redundant requests, infinite spinners. The single most useful framing shift in modern React: **server state is not state you own; it's state you cache**. That framing reorients every tool decision around it.

## The contrast

| Property | Client state | Server state |
|---|---|---|
| **Ownership** | You | Remote server |
| **Synchronicity** | Synchronous | Asynchronous (network) |
| **Freshness** | Always current | Snapshot — can be stale |
| **Mutability** | You change it | You + other users + background jobs |
| **Persistence** | Ephemeral (per session, usually) | Persisted remotely |
| **Latency** | Zero | Variable (network) |
| **Failure mode** | Doesn't exist (or `undefined`) | Network errors, timeouts, partial data |
| **Examples** | `isOpen`, `selectedTab`, form values | `currentUser`, `productList`, `notifications` |

## Why client-state tools don't work for server state

`useState` + `useEffect` for server data hits at least four problems:

1. **No built-in loading/error states.** You hand-roll `isLoading` and `error` per query.
2. **Race conditions.** Rapid input changes cause out-of-order responses; the latest doesn't always arrive last.
3. **No deduplication.** Two components fetching the same URL = two requests, two state copies, possible divergence.
4. **No cache invalidation policy.** When does cached data go stale? When do you refetch?

You can solve all four with enough code — and what you end up with is essentially TanStack Query reinvented badly. See [[query-gg-00-laying-the-foundation]] for the walkthrough.

## What server-state tools provide

| Need | Server-state tool feature |
|---|---|
| Dedup concurrent requests | Single cache entry per query key |
| Race condition safety | Latest request wins by key |
| Loading/error states | Built into every hook's return |
| Cache lifecycle | `staleTime` / `gcTime` policy |
| Background refresh | Refetch on focus / reconnect / interval |
| Cross-component sharing | All subscribers to the same key see same data |
| Optimistic updates | Mutation lifecycle hooks |

## The tool landscape

### Client state

- `useState`, `useReducer` — built-in
- **Zustand** — minimal external store
- **Jotai**, **Recoil** — atomic state
- **Redux** (Toolkit) — for complex cross-cutting state
- **XState** — state machines for complex flows

### Server state

- **TanStack Query** ([[tanstack-query]]) — most popular for React/Vue/etc.
- **SWR** — Vercel's lighter alternative
- **Apollo Client** (GraphQL) — covers server state for Apollo users
- **Relay** (GraphQL) — Meta's variant
- **RTK Query** — Redux Toolkit's server-state slice
- **TanStack Loader** (in Router) — route-tied server state

## When a piece of state is ambiguous

Some state has both properties — a user's draft of a comment is client state (they own it, ephemeral) until they post it, at which point it's server state. The rule: **classify by the moment of need**. A draft is client; after `POST` it's server. Use the right tool for each phase.

## Related

- [[tanstack-query]] — the most common server-state tool.
- [[query-gg-00-laying-the-foundation]] — the four-bug walkthrough.
- [[react-hooks]] — `useState` covers client state.

## Sources

- [[query-gg-00-laying-the-foundation]]
- [[video-tanstack-query-crash-course]]
