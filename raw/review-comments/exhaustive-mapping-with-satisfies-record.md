---
id: exhaustive-mapping-with-satisfies-record
aliases: []
tags:
  - review-comments
  - typescript
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
A single equality check (`status === 'running' ? a : b`) sends every other value to the `else` branch, including values added to the union later. A `Record<Union, T>` with `satisfies` makes the compiler require a case for every member, and still keeps the narrow literal types.

## Example
```ts
type Status = 'running' | 'success' | 'failed' | 'timeout'

const EMPTY_COPY = {
  running: 'Still running, results will appear when it finishes',
  success: 'Nothing matched your criteria',
  failed: 'The run did not complete',
  timeout: 'The run did not complete',
} as const satisfies Record<Status, string>
```

## Why it matters
This matters most in [[Empty States]], where "empty because it broke" and "empty because there's nothing there" mean opposite things. With an exhaustive map, adding a status to the union becomes a compile error instead of wrong copy.

## Rule of thumb
When UI branches on a union, map the whole union with `satisfies Record<Union, ...>`, and don't write `=== oneValue`.
