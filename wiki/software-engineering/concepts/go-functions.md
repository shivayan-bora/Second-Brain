---
title: Go Functions
pillar: software-engineering
type: concept
tags: [go, functions, multiple-return-values]
status: in-progress
sources: ["[[three-dots-labs-go-02-functions]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Go Functions

## Definition

A Go **function** is a first-class named callable declared with `func`. It takes zero or more typed parameters and returns zero, one, or **multiple** typed values. Function names follow Go's package visibility rule: capitalized names are exported, lowercase names are package-private.

## Why it matters

Functions are the unit of composition in Go. Two design choices set Go apart from neighboring languages and shape everything built on top: **multiple return values** (which underlie [[go-error-handling|idiomatic error handling]]) and **capitalization-as-visibility** (which makes the public API of a [[go-packages|package]] visually obvious).

## Mechanics

### Declaration shape

```go
func Name(param1 Type1, param2 Type2) ReturnType {
    // ...
}
```

- No parameters: `func Hello() { ... }`
- No return: omit the return type.
- Multiple returns: parenthesize the return type list.

### Same-type parameter shorthand

Adjacent parameters of the same type can collapse:

```go
func Add(a, b, c, d, e int) int { return a + b + c + d + e }
```

is equivalent to `func Add(a int, b int, c int, d int, e int) int`.

### Multiple return values

A function may return more than one value. Parenthesize the return type list:

```go
func FullName() (string, string) {
    return "Alice", "Smith"
}

func MonthAndYear() (string, int) {
    return "April", 2012
}
```

Callers destructure with `:=` or `var`:

```go
firstName, lastName := FullName()
var month, year = MonthAndYear()
```

This is the substrate of Go's `(result, error)` convention — see [[go-error-handling]].

### Visibility

- `func Hello()` — **exported**, callable from other packages.
- `func hello()` — **unexported**, package-private.

The course's examples (`Hello`, `Add`, `FullName`) are all exported by virtue of their capital first letters; in real code, helpers stay lowercase unless they're intended as public API.

## Examples

Defining and calling a function with multiple returns:

```go
package main

import "fmt"

func main() {
    firstName, lastName := FullName()
    fmt.Println(firstName, lastName) // Alice Smith

    fmt.Println(Add(1, 2, 3, 4, 5)) // 15
}

func Add(a, b, c, d, e int) int {
    return a + b + c + d + e
}

func FullName() (string, string) {
    return "Alice", "Smith"
}
```

## Related

- [[go-variables]] — parameters and return bindings follow the same type-after-name shape.
- [[go-error-handling]] — multi-return is the mechanism behind `result, err := f()`.
- [[go-http-server]] — HTTP handlers are just functions with the fixed signature `func(w http.ResponseWriter, r *http.Request)`.
- [[go-packages]] — capitalization rule for exported names lives at the package boundary.

## Sources

- [[three-dots-labs-go-02-functions]] (`raw/courses/Three Dots Labs Academy/Go in One Evening/02_functions.md`)
