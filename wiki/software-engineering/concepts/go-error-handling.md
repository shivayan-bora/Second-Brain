---
title: Go Error Handling
pillar: software-engineering
type: concept
tags: [go, errors, error-handling]
status: in-progress
sources: ["[[three-dots-labs-go-07-errors]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Go Error Handling

## Definition

In Go, **errors are values**, not exceptions. Functions that can fail return an `error` as their last return value — a built-in interface type. Callers explicitly check the error with an `if err != nil` block and decide whether to handle it, wrap it, or propagate it up. There is no `try / catch`.

> [!WARNING]
> The source for this concept ([[three-dots-labs-go-07-errors]]) is currently a placeholder — the raw file has no Go content. This page captures the well-established baseline conventions but should be expanded once the source is populated.

## Why it matters

Go's error model is one of its most discussed and most divisive design choices. The pattern is verbose by design: every fallible call costs three lines of code minimum. The trade-off is that the **control flow is always visible** — there are no hidden exception paths, no `try` blocks half a screen above the throw site, no surprises about which functions can unwind your stack. For a staff engineer reviewing critical-path code, "where can this fail?" is answered by `grep` for `if err != nil`.

## Mechanics

### The `error` interface

`error` is a built-in interface with a single method:

```go
type error interface {
    Error() string
}
```

Any type that implements `Error() string` is an `error`.

### Canonical fallible signature

```go
func DoThing() (Result, error) {
    // ...
}
```

The error is always the **last** return value. Callers destructure with the walrus operator (see [[go-functions|multiple return values]]):

```go
result, err := DoThing()
if err != nil {
    return err // or wrap, log, retry, etc.
}
// use result safely
```

### The `if err != nil` chain

The signature shape combined with the [[go-conditionals|if-statement]] gives Go its characteristic vertical rhythm:

```go
a, err := step1()
if err != nil {
    return err
}
b, err := step2(a)
if err != nil {
    return err
}
c, err := step3(b)
if err != nil {
    return err
}
return c, nil
```

The `if err != nil { return err }` pattern is so common it has been the subject of multiple proposals to add syntactic sugar (`try` keyword, `?` operator). All have been rejected so far.

### Constructing errors (baseline)

The standard library provides:

- `errors.New("message")` — opaque error with a static message.
- `fmt.Errorf("...: %w", err)` — error with formatting and **error wrapping** (`%w` preserves the cause for `errors.Is` / `errors.As`).

Sentinel errors (`var ErrNotFound = errors.New("not found")`) are compared with `errors.Is`. Typed errors (custom structs implementing `error`) are unwrapped with `errors.As`.

### `panic` / `recover`

Go has `panic` and `recover`, but they are explicitly **not** the normal error-handling mechanism. Reserve `panic` for unrecoverable programmer errors (impossible states, broken invariants). Production-quality library code rarely panics and almost never `recover`s.

## Examples

Idiomatic fallible function and its caller:

```go
import (
    "errors"
    "fmt"
)

func Divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func main() {
    result, err := Divide(10, 0)
    if err != nil {
        fmt.Println("error:", err)
        return
    }
    fmt.Println("result:", result)
}
```

## Related

- [[go-functions]] — multi-return is the mechanical foundation of `(result, error)`.
- [[go-conditionals]] — `if err != nil` is the universal error check.
- [[go-http-server]] — HTTP handlers translate errors into status codes.

## Sources

- [[three-dots-labs-go-07-errors]] (`raw/courses/Three Dots Labs Academy/Go in One Evening/07_errors.md`) — *placeholder; source incomplete*
