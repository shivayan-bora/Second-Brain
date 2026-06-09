---
title: "Learn Go with Tests ch01 — Hello World"
pillar: software-engineering
type: summary
tags: [course, chapter, go, testing, tdd]
status: stable
source: "raw/courses/Learn Go with Tests/01_Hello World.md"
course: "Learn Go with Tests (quii)"
created: 2026-06-09
updated: 2026-06-09
---

# Learn Go with Tests ch01 — Hello World

Despite the modest "Hello World" title, this chapter packs in **most of the stdlib `testing` surface** the course uses thereafter: `*testing.T`, subtests, helpers via `t.Helper()` + `testing.TB`, the assertion-helper extraction, and an iterative TDD loop that grows the `Hello` function from constant string to multi-language switch.

## TL;DR

- The pedagogical move from `fmt.Println("Hello, world")` to `Hello() string` + `main() { fmt.Println(Hello()) }` is a **domain-vs-side-effect split** — the same separation that makes [[react-styling-options|styling]] testable in React. Pure functions are easy to test; `Println` calls are not.
- The Go `testing` package is **stdlib, not a third-party framework**. The four core rules: file `*_test.go`, function name `TestXxx`, single argument `t *testing.T`, import `"testing"`. See [[go-testing-package]].
- **Subtests** with `t.Run(name, func(t *testing.T) {...})` group related cases, give per-case failure context, and are the Go-idiomatic shape for "many cases of one behavior". See [[go-subtests]].
- **`t.Helper()`** is the magic line that makes extracted assertion helpers report the *caller's* line on failure rather than the helper's. Pair with `testing.TB` (the interface both `*testing.T` and `*testing.B` satisfy) so helpers work in benchmarks too. See [[go-test-helpers]].
- The chapter implicitly teaches the **red-green-refactor** TDD loop: write a failing test, make it pass with minimum code, refactor with the test as a net. See [[tdd-red-green-refactor]].

## Key takeaways

- **Separate domain from side-effects.** The first refactor is pulling the string out of `fmt.Println` so it can be returned and tested. This isn't a Go-specific lesson — it's a TDD reflex.
- **`%q` formats strings with surrounding double quotes** in `t.Errorf("got %q want %q", got, want)` — makes whitespace and empty-string bugs visible.
- **`go test` requires a module.** Without `go.mod`, you get `go: cannot find main module` — which is why [[learn-go-with-tests-00-install-go]] runs first.
- **Same-type parameter shorthand**: `func assertCorrectMessage(t testing.TB, got, want string)` collapses `got string, want string` to `got, want string`. Common in Go signatures.
- **Public vs private by capitalization**: `Hello` (exported, testable from another package) vs `assertCorrectMessage` and `greetingPrefix` (unexported helpers). See [[go-packages]].
- **Named returns**: `func greetingPrefix(language string) (prefix string)` declares `prefix` as the return variable; a bare `return` returns whatever value it holds. See [[go-functions]].
- **Grouped constants** with the `const ( ... )` block keep related literals together — illustrated with the english/spanish/french hello-prefix set.
- **`switch` with `default`**, no `break`: each case falls through to `return`/end implicitly. See [[go-conditionals]].

## Notable passages

> "It is good to separate your 'domain' code from the outside world (side-effects). The `fmt.Println` is a side effect (printing to `stdout`), and the string we send in is our domain."
> — *Learn Go with Tests* ch. 1

> "`testing.TB` is an interface that both `*testing.T` and `*testing.B` satisfy"
> — *Learn Go with Tests* ch. 1

> "`t.Helper()` tells the test suite that this is a helper function. The line reported during error will be our function call rather than the helper."
> — *Learn Go with Tests* ch. 1

## Open questions

- The chapter uses repeated `t.Run` calls rather than a single table-driven loop. Does ch02+ introduce the slice-of-structs [[table-driven-tests|table-driven]] form?
- `*testing.T` vs `testing.TB` — the chapter introduces both but doesn't explore where you'd reach for `T` directly versus `TB`. Probably benchmarks (`*testing.B`) come later.
- Go has no test "assert" library by default — the canonical practice is helpers + raw `if`/`t.Errorf`. The chapter teaches this discipline but the course should eventually mention `testify` and why it's *not* used here.

## Cross-references

- Setup: [[learn-go-with-tests-00-install-go]].
- Adjacent foundations: [[learning-go-ch00-environment-setup]], [[three-dots-labs-go-00-hello]].
- New concepts: [[go-testing-package]], [[go-subtests]], [[go-test-helpers]], [[tdd-red-green-refactor]].
- Cross-cutting: [[go-functions]] (named returns), [[go-variables]] (grouped const), [[go-conditionals]] (switch), [[go-packages]] (export capitalization).

## Source

- `raw/courses/Learn Go with Tests/01_Hello World.md`
