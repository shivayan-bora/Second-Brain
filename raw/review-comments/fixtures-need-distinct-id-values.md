---
id: fixtures-need-distinct-id-values
aliases: []
tags:
  - review-comments
  - testing
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
When an entity has several id-like fields (`id`, `externalId`, `nodeId`), test fixtures often set them all to the same value. A test that asserts "sends ids `['1', '2']`" then passes no matter which field the code actually sends, so it can't catch the mix-up it exists to catch.

## Example
```ts
// Trap
const account = { id: '1', externalId: '1', node: { id: '1' } }

// Better: every id-like field is distinguishable
const account = { id: 'account-1', externalId: 'ext-1', node: { id: 'node-1' } }
```

## Why it matters
What the user selects, what the UI counts and what the backend receives can quietly diverge, and the fixtures hide it. This is common with nullable ids that get filtered out of the payload but still counted in the confirm copy.

## Rule of thumb
Give each id-like field a distinct, self-describing value in fixtures. Derive the count you display from the exact payload you send.
