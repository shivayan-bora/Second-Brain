---
title: Go Conditionals
pillar: software-engineering
type: concept
tags: [go, conditionals, control-flow, if, switch]
status: in-progress
sources: ["[[three-dots-labs-go-06-conditionals]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Go Conditionals

## Definition

Go's conditional control flow comprises two constructs: **`if / else if / else`** and **`switch / case`**. Both follow Go's general preference for explicit, low-magic syntax — but each makes one small deviation from C-family languages worth memorizing.

## Why it matters

The two surface-level differences (no parens in `if`, no fallthrough in `switch`) are tiny but they shape readability across an entire codebase. The deeper point is that Go consciously eliminated several classic conditional bugs by design: no missing-`break` fallthrough, no `if x = 1` assignment-in-condition (because `=` returns no value), and no dangling-else ambiguity (because braces are mandatory).

## Mechanics

### `if / else if / else`

```go
if role == "admin" {
    // ...
} else if role == "user" {
    // ...
} else {
    // ...
}
```

- **No parentheses** around the condition (unlike C / Java / JavaScript).
- **Braces are mandatory**, even for single-statement bodies. No `if x == 1 doThing()`.
- The `else` and `else if` go on the **same line** as the closing brace of the previous block — `gofmt` will enforce this.

### `if` with initializer (Go idiom, not in source)

Not covered in this chapter but extremely common in real Go — scopes a variable to the `if` block:

```go
if v, err := f(); err != nil {
    return err
} else {
    use(v)
}
```

This is the everyday shape of error handling: see [[go-error-handling]].

### `switch / case`

```go
switch x {
case 0:
    // Zero
case 1:
    // One
case 2:
    // Two
default:
    // Other
}
```

- **No `break` required.** Cases do *not* fall through by default — the opposite of C/Java/JavaScript.
- **Opt into fallthrough** with the explicit `fallthrough` keyword (not in this source, but worth knowing).
- **Multiple values per case** are comma-separated: `case 0, 1, 2:`.

### Why these defaults

- Removing parens around `if` removes a typo class and reads cleaner.
- Inverting the fallthrough default eliminates the classic "forgot the `break`" bug that haunts C-family languages.

### No ternary

Go intentionally **does not have a ternary operator** (`cond ? a : b`). Use `if/else`. The team's stated position is that ternaries hurt readability — a deliberate language-design trade-off.

## Examples

Validating an HTTP query param (drawn from [[three-dots-labs-go-03-http-server]]):

```go
if name == "" {
    w.WriteHeader(http.StatusBadRequest)
    return
}
```

Multi-value case:

```go
switch status {
case 200, 201, 204:
    // success
case 400, 401, 403, 404:
    // client error
default:
    // other
}
```

## Related

- [[go-http-server]] — handler logic is mostly `if`-driven validation.
- [[go-error-handling]] — `if err != nil { return err }` is the canonical Go error check.
- [[go-functions]] — early-return patterns rely on conditionals + multi-return.

## Sources

- [[three-dots-labs-go-06-conditionals]] (`raw/courses/Three Dots Labs Academy/Go in One Evening/06_conditionals.md`)
