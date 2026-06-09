---
title: Go Slices
pillar: software-engineering
type: concept
tags: [go, slices, collections, dynamic-arrays]
status: stable
sources: ["[[three-dots-labs-go-05-slices]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Go Slices

## Definition

A Go **slice** is a **dynamic-length** view over an underlying array. Declared as `[]T` — the absence of a length in the brackets is the visual cue that distinguishes a slice from an [[go-arrays|array]] (`[N]T`). Slices are the default sequence type in idiomatic Go.

## Why it matters

Almost every "list of things" in Go is a slice. They're flexible, they're what every stdlib API takes and returns, and they have a couple of sharp edges (nil vs empty, the shared-backing-array gotcha when slicing or appending) that bite anyone who skips over them. Understanding the slice mental model — *header + backing array* — pays off across the entire language.

## Mechanics

### Declaration

```go
var contacts []string         // nil slice — len == 0, but indexing panics
contacts := []string{}        // empty slice literal — len == 0, indexable safely
contacts := make([]string, 5) // preallocated slice of 5 zero-value strings
contacts := []string{"Alice", "John", "Emma"} // literal with values
```

### `nil` vs empty

Both have `len() == 0`, both are safe to `range` over, both are safe to `append` to. They differ in:

- **Direct indexing** of a nil slice panics: `var s []string; s[0] = "x"` → `panic: runtime error: index out of range`.
- **JSON encoding** treats them differently — a nil slice marshals to `null`, an empty slice to `[]`.

### `make` for preallocation

```go
contacts := make([]string, 5)   // length 5, capacity 5, all elements ""
```

Preallocation avoids the repeated reallocations of growing a slice via `append` when you already know the final size.

### Length

```go
len(contacts)
```

(`cap(contacts)` — capacity, the backing-array size — is not covered in the source but matters once you start `append`-ing.)

## Examples

Safe empty initialization:

```go
contacts := []string{}
contacts = append(contacts, "Alice")
fmt.Println(contacts) // [Alice]
```

Nil slice gotcha:

```go
var contacts []string
contacts[0] = "Jenny" // panic: index out of range [0] with length 0
```

Preallocation:

```go
ids := make([]int, 0, 1000) // length 0, capacity 1000 — append 1000 times without reallocating
for i := 0; i < 1000; i++ {
    ids = append(ids, i)
}
```

## Related

- [[go-arrays]] — the fixed-length type. A slice is backed by an array; understanding arrays makes slice semantics make sense.
- [[go-variables]] — slice declaration follows the same `var` / `:=` patterns.

## Sources

- [[three-dots-labs-go-05-slices]] (`raw/courses/Three Dots Labs Academy/Go in One Evening/05_slices.md`)
