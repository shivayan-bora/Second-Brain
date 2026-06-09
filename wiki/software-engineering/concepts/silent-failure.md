---
title: "Silent Failure"
pillar: software-engineering
type: concept
tags: [error-handling, observability, debugging, design]
status: in-progress
sources: ["[[parse-vs-safe-parse]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Silent Failure

## Definition

A **silent failure** is an error that occurs without surfacing to a place that can act on it — no log, no alert, no exception, no visible UI state, no test failure. The code continues running as if everything worked; the bad outcome only manifests later, possibly in production, possibly far from the cause.

## Why it matters

Silent failures are the single hardest class of bug to debug because the trail is cold by the time you notice. For a staff engineer, recognizing the *shapes* that produce silent failures — and reviewing them out of code — is one of the highest-leverage code-review habits.

## Common shapes

### 1. Swallowed exceptions

```ts
try {
  await syncUserPreferences(userId);
} catch (e) {
  // 🚨 silent — error is lost
}
```

The intent was probably "don't crash the parent task." The effect is "we never know it failed." Always **at least log** in the catch.

### 2. Ignored Promise rejections

```ts
// 🚨 No await, no .catch
saveAnalytics(event);
```

If `saveAnalytics` rejects, the rejection becomes an unhandled-promise-rejection — logged somewhere, often *nowhere obvious*. Always `await` or `.catch()`.

### 3. Fall-through defaults

```ts
function getColor(theme: Theme): string {
  if (theme === 'light') return '#fff';
  if (theme === 'dark')  return '#000';
  return '#fff';   // 🚨 silently masks new Theme values
}
```

A new `Theme` value added to the type? The runtime silently shows light-mode. Use `never`-typed exhaustive checks instead:

```ts
const _exhaustive: never = theme;   // compile error if a Theme variant is unhandled
throw new Error(`Unhandled theme: ${theme}`);
```

### 4. `safeParse` (or similar) without a check

```ts
const result = Schema.safeParse(input);
const data = result.data;   // 🚨 may be undefined on failure
```

[[parse-vs-safe-parse|`safeParse`]] returns `{ success, data | error }`. Skipping the success check turns a validator into a silent producer of `undefined`. Either branch on `result.success` or use `parse` and let it throw.

### 5. Failed network requests treated as "no data"

```ts
const res = await fetch('/api/users');
const users = await res.json();   // 🚨 ignores res.ok
```

A 500 response still produces a JSON body (the error body); your UI shows the error JSON as if it were data. Always check `res.ok` (or use a library that does).

### 6. Default empty results

```ts
function findUsers(filter): User[] {
  try {
    return queryDB(filter);
  } catch {
    return [];   // 🚨 same shape as "found zero" — caller can't tell
  }
}
```

The caller has no way to distinguish "no matches" from "DB is on fire." Better to surface the failure (throw, return Result type, etc.).

### 7. Empty catch in tests

```ts
try {
  await fragileTest();
} catch (e) {
  console.error(e);   // 🚨 test passes despite the failure
}
```

Tests must *fail* when assertions don't hold. A catch that logs and continues is a silent test failure.

## What to do instead

- **Log at minimum.** Even an unhelpful `console.error` is better than nothing.
- **Surface to observability.** Sentry, Datadog, log aggregator — somewhere a human will notice.
- **Type-system enforcement.** Use exhaustive `never` checks for unions; use Result/Either types for fallible operations.
- **Boundary validation.** [[runtime-type-validation|Runtime validation]] at system boundaries forces the failure to be local and loud, not silent and distant.
- **Don't catch what you can't handle.** If you can't recover, let it propagate.

## Related

- [[parse-vs-safe-parse]] — `safeParse` is *easier* to silent-fail than `parse`.
- [[runtime-type-validation]] — boundary validation as a silent-failure prevention.
- [[tdd-red-green-refactor]] — TDD with strict assertion discipline makes silent test failures harder.
- [[continuous-integration]] — CI flaky-test handling is a place silent failures hide.

## Open questions

- This page would benefit from a dedicated source on error-handling patterns / observability culture. Worth a future ingest of *Site Reliability Engineering* (Beyer et al.) or a focused article on error-handling discipline.
- Cross-pillar candidate: a soft-skills page on *"surfacing problems vs. hiding them"* — engineering culture's relationship to silent failure.

## Sources

- [[parse-vs-safe-parse]] — flagged as a future cross-link from Zod's safe-parse mode.
