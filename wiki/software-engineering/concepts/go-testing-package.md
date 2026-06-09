---
title: "Go `testing` Package"
pillar: software-engineering
type: concept
tags: [go, testing, stdlib]
status: stable
sources: ["[[learn-go-with-tests-01-hello-world]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Go `testing` Package

## Definition

`testing` is Go's standard-library testing framework. It defines the `*testing.T` type that test functions receive, the `*testing.B` type for benchmarks, the `testing.TB` interface both satisfy, and the `go test` tool's conventions for discovering and running tests.

## Why it matters

Go's stdlib testing is the canonical answer for the language. There's no Jest, no JUnit — for nearly every Go codebase, `testing` is the entire test framework. The conventions are minimal and rigid, which is part of why Go codebases feel uniform across projects.

## The four rules

1. **File name** must end in `_test.go` — e.g., `hello_test.go`. The compiler treats these files as part of the package only when running `go test`.
2. **Function name** must start with `Test` followed by an uppercase letter — e.g., `TestHello`, not `testHello` or `Test_hello`.
3. **Single argument** of type `*testing.T` — e.g., `func TestHello(t *testing.T) { ... }`.
4. **Import `"testing"`** to make `*testing.T` available.

## Failing a test

```go
if got != want {
    t.Errorf("got %q want %q", got, want)
}
```

- `t.Errorf(format, args...)` marks the test as failed and **continues** the function.
- `t.Fatalf(format, args...)` marks the test as failed and **stops** the function immediately (use when later assertions would crash).
- `t.Error` / `t.Fatal` are the no-format versions.
- `%q` wraps strings in double quotes — invaluable for diffing values that might contain whitespace or be empty.

## `*testing.T` vs `*testing.B` vs `testing.TB`

- `*testing.T` — test functions
- `*testing.B` — benchmark functions (`BenchmarkXxx`)
- `testing.TB` — the interface both satisfy; use it as the parameter type in helper functions so they work for either:

```go
func assertCorrectMessage(t testing.TB, got, want string) {
    t.Helper()
    if got != want {
        t.Errorf("got %q want %q", got, want)
    }
}
```

See [[go-test-helpers]] for the `t.Helper()` machinery and the helper pattern.

## Running

```bash
go test            # current package
go test ./...      # whole module
go test -run TestHello -v   # one test, verbose
```

`go test` requires a module — without `go.mod` you get `go: cannot find main module`. See [[go-modules]].

## Related

- [[go-subtests]] — `t.Run` for grouping cases.
- [[go-test-helpers]] — `t.Helper()` + `testing.TB`.
- [[tdd-red-green-refactor]] — the practice the package enables.
- [[go-modules]] — `go test` precondition.

## Sources

- [[learn-go-with-tests-01-hello-world]] — the four rules and `t.Errorf`/`%q` come from here.
