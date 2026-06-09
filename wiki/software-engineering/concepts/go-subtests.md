---
title: "Go Subtests (`t.Run`)"
pillar: software-engineering
type: concept
tags: [go, testing]
status: stable
sources: ["[[learn-go-with-tests-01-hello-world]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Go Subtests (`t.Run`)

## Definition

A **subtest** is a nested test invoked via `t.Run("name", func(t *testing.T) { ... })`. Subtests provide named grouping under one parent `TestXxx`, isolated failure reporting per case, and selective execution via `go test -run`.

## Why it matters

Subtests are how Go-idiomatic test files keep related cases grouped without exploding the count of top-level `TestXxx` functions. They also enable a path toward [[table-driven-tests]] (deferred to a later chapter in *Learn Go with Tests*) — a `for _, tc := range cases { t.Run(tc.name, ...) }` loop is the canonical step up.

## Mechanics

```go
func TestHello(t *testing.T) {
    t.Run("saying hello to people", func(t *testing.T) {
        got := Hello("Shivayan", "")
        want := "Hello, Shivayan"
        assertCorrectMessage(t, got, want)
    })

    t.Run("empty string defaults to 'World'", func(t *testing.T) {
        got := Hello("", "")
        want := "Hello, World"
        assertCorrectMessage(t, got, want)
    })
}
```

- Each `t.Run` receives a **fresh** `*testing.T` for that subtest. Failures and parallelism are tracked independently.
- Subtest names appear in test output as `TestHello/saying_hello_to_people` (spaces become underscores).
- Run a specific subtest: `go test -run TestHello/saying_hello_to_people`.

## When to use

- Several cases of the same behaviour — input/output pairs of one function.
- Grouped scenarios where the setup is shared (the parent function does setup; each `t.Run` exercises one scenario).
- Parallel cases: each subtest can call `t.Parallel()` to run alongside its siblings.

## What it isn't

Subtests are **not** the same as table-driven tests. They give you naming and isolation; the table form gives you cases-as-data with one assertion site. Most idiomatic Go combines them: a slice of structs + a `t.Run(tc.name, ...)` loop. See [[table-driven-tests]] (planned for a later chapter).

## Examples

```go
// Selective re-run while debugging
go test -run TestHello/empty -v
```

```go
// Pattern progression: when you find yourself repeating t.Run bodies,
// promote to table-driven:
cases := []struct {
    name, in, want string
}{
    {"empty", "", "Hello, World"},
    {"shivayan", "Shivayan", "Hello, Shivayan"},
}
for _, tc := range cases {
    t.Run(tc.name, func(t *testing.T) {
        if got := Hello(tc.in, ""); got != tc.want {
            t.Errorf("got %q want %q", got, tc.want)
        }
    })
}
```

## Related

- [[go-testing-package]] — the parent surface.
- [[go-test-helpers]] — helpers work the same inside subtests.
- [[table-driven-tests]] — the next refactor step.

## Sources

- [[learn-go-with-tests-01-hello-world]]
