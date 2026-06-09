---
title: Go Variables
pillar: software-engineering
type: concept
tags: [go, variables, types, constants, scoping]
status: stable
sources: ["[[three-dots-labs-go-01-variables]]", "[[learn-go-with-tests-01-hello-world]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Go Variables

## Definition

A **variable** in Go is a named binding to a value of a specific, statically-known type. Go is statically typed but uses **type inference** to keep declarations short. There are three ways to declare a variable, two scopes (local and package-global), and an immutable sibling, the `const`.

## Why it matters

Variable declaration is the smallest unit of Go syntax, and it's where the language signals its values: predictable zero values, no implicit conversions, and short-form `:=` for the common case. Knowing the four variants and when each is legal removes a class of "why won't this compile" friction early on.

## Mechanics

### Primitive types covered by the source

- `int` — integer, e.g. `42`, `-200`.
- `bool` — `true` / `false`.
- `float64` — decimal, e.g. `3.1415`.
- `string` — text, e.g. `"Alice"`.

### Three declaration forms

1. **Walrus / short form** — `name := expr`
   - Both declares and infers type from `expr`.
   - **Function scope only** — illegal at package level.
   - The most common form in Go.
   ```go
   year := 2012      // int
   fact := "Go 1.0"  // string
   ```
2. **`var` with type, no value** — `var name type`
   - Initializes to the **zero value** of the type.
   - `int → 0`, `bool → false`, `float64 → 0.0`, `string → ""`.
   ```go
   var year int   // 0
   ```
3. **`var` with type inference** — `var name = expr`
   - Works at both function and package scope.
   ```go
   var firstName = "Shivayan"
   ```

### Constants

Replace `var` with `const`. Same scoping and inference rules; the binding is immutable.

```go
const pi = 3.14
```

### Scope

- **Local** — declared inside a function. Lives until the function returns.
- **Package-global** — declared outside any function. Visible to every file in the package. Use `var` (not `:=`).

```go
var globalName = "Shivayan"

func main() {
    localVariable := "Debanjali"
}
```

### Grouped declarations

`var (...)` and `const (...)` blocks batch related package-level state:

```go
var (
    name  = "Alice"
    hours = 10
)

const (
    pi         = 3.1415
    hoursInDay = 24
)
```

## Examples

Mixing the forms in one function:

```go
package main

import "fmt"

func main() {
    fact := "Go 1.0 was released in"  // walrus, type inferred
    year := 2012                       // walrus, type inferred
    var month string                   // explicit, zero-valued ""

    month = "March"
    fmt.Println(fact, year, month)
}
```

## Related

- [[go-functions]] — parameters and return values use the same type-after-name shape; multiple return values fan out into multiple `:=` bindings.
- [[go-packages]] — package-global variables are visible only via exported (capitalized) names.

## Sources

- [[three-dots-labs-go-01-variables]] (`raw/courses/Three Dots Labs Academy/Go in One Evening/01_variables.md`)
- [[learn-go-with-tests-01-hello-world]] — concrete grouped-const example (english/spanish/french hello-prefix block).
