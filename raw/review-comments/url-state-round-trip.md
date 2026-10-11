---
id: url-state-round-trip
aliases: []
tags:
  - review-comments
  - routing
  - state
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
When you rewrite or alias URLs, the page state lives in both the pathname and the search params. A route's search schema (for example [[Zod]]) usually strips keys it doesn't declare, so a param can vanish when the URL reloads through a different route. Fallback logic that picks either the defaults or the incoming search, instead of merging them, loses data too.

## Example
```ts
// Trap: either/or, and incoming params the schema doesn't know get dropped
const search = hasIncoming ? incoming : defaults

// Better: merge, and make sure the target schema declares every param it reads
const search = { ...defaults, ...incoming }
```

## Why it matters
Once users can bookmark or reload a rewritten URL, the page state is only as safe as the least careful route along the way. The bug shows up as "my filter disappeared after refresh".

## Rule of thumb
Treat a URL mapping as a round trip: test that the pathname **and** the search both survive. Merge defaults with incoming state, don't choose between them. See [[Route Redirects]].
