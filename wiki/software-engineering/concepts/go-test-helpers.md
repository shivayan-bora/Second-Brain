---
title: "Go Test Helpers (`t.Helper`, `testing.TB`)"
pillar: software-engineering
type: concept
tags: [go, testing, stdlib]
status: stable
sources: ["[[learn-go-with-tests-01-hello-world]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Go Test Helpers (`t.Helper`, `testing.TB`)

## Definition

A **test helper** is a regular Go function whose first parameter is `testing.TB` (the interface both `*testing.T` and `*testing.B` satisfy) and whose body calls `t.Helper()` so that failure messages report the **caller's** file/line, not the helper's. It's how you extract repeated assertion/setup code without losing useful error locations.

## Why it matters

Without `t.Helper()`, extracting an `assertCorrectMessage` helper would make every failure report the same line — the `t.Errorf` inside the helper — instead of the test that actually called it. That kills debuggability. `t.Helper()` is the one-line fix that makes helpers safe to use.

## Mechanics

```go
func assertCorrectMessage(t testing.TB, got, want string) {
    t.Helper()    // 👈 the magic line
    if got != want {
        t.Errorf("got %q want %q", got, want)
    }
}
```

- **`t.Helper()`** must be called from inside the helper. It tells the testing framework: "when I report an error, point at my caller, not at me."
- **`testing.TB`** parameter type makes the helper usable from either tests (`*testing.T`) or benchmarks (`*testing.B`). Don't accept `*testing.T` if you want benchmark compatibility.

## Same-type parameter shorthand

When multiple parameters share a type, Go lets you list the names and write the type once:

```go
// Verbose
func assertCorrectMessage(t testing.TB, got string, want string)

// Shorthand — equivalent
func assertCorrectMessage(t testing.TB, got, want string)
```

Common in test helpers; idiomatic across Go.

## Anti-pattern

Helpers that return a `bool` (or stash state) instead of calling `t.Errorf` directly:

```go
// ❌ Loses the t.Helper() advantage
func messageMatches(got, want string) bool {
    return got == want
}
```

The caller still has to write `if !messageMatches(...) { t.Errorf(...) }`. You haven't saved much, and you've lost the line-reporting cleanness `t.Helper()` provides.

## Related

- [[go-testing-package]] — the parent surface.
- [[go-subtests]] — helpers compose cleanly with `t.Run`.
- [[go-functions]] — the same-type parameter shorthand appears here.

## Sources

- [[learn-go-with-tests-01-hello-world]] — the `assertCorrectMessage` example comes from here.
