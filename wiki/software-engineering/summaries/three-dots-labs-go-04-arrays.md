---
title: "Three Dots Labs — Go in One Evening 04: Arrays"
pillar: software-engineering
type: summary
tags: [course, chapter, go, arrays, collections]
status: stable
former_source: "raw/courses/Three Dots Labs Academy/Go in One Evening/04_arrays.md"
source_status: deleted
course: "Three Dots Labs — Go in One Evening"
created: 2026-05-17
updated: 2026-06-09
---

# Three Dots Labs — Go in One Evening 04: Arrays

> [!NOTE] Raw source deleted
> The raw note this summary was ingested from has since been deleted from the vault during a cleanup. The wiki page below is retained as a record of the user's prior notes. See `former_source` in frontmatter for the original path.

Go arrays are **fixed-size, single-type** sequences. Size is part of the type. Zero-indexed. `len()` returns the length.

## TL;DR

- Declaration: `var contactMethods [3]string` — three-element string array, zero-valued.
- Literal: `contactMethods := [3]string{"email", "phone", "sms"}`.
- Element access and assignment use 0-based indexing: `contactMethods[0]`, `contactMethods[2] = "text"`.
- `len(contactMethods)` returns the array length.
- Size is part of the type — `[3]string` and `[4]string` are *different types*. This is why [[go-slices]] exist.

## Key takeaways

- **Arrays in Go are rarely used directly.** Their fixed size makes them inflexible; almost all real-world Go code reaches for [[go-slices|slices]] instead. See [[go-arrays]].
- **Size is part of the type, not metadata.** `func f(a [3]string)` won't accept a `[4]string`. Practical implication: array parameters and return types are a code smell outside specific perf scenarios.
- **Zero-value initialization is automatic.** A `[3]string` declared with `var` is `["", "", ""]`, not `nil`. Same predictable zero-value story as [[go-variables|primitive variables]].

## Notable passages

> "Arrays in Go keep a set of variables of the same type. They have a fixed size defined within brackets."
> — *Go in One Evening*, ch. 04 (`raw/courses/Three Dots Labs Academy/Go in One Evening/04_arrays.md`)

## Open questions

- When *should* I prefer a Go array over a slice? Stack-allocation? Fixed-size cryptographic buffers (`[32]byte`)?
- What does iterating an array vs a slice with `range` actually look like? Not covered here.

## Cross-references

- [[three-dots-labs-go-05-slices]] — next chapter, the dynamic-size cousin and the one you actually use day-to-day.
- Concepts introduced: [[go-arrays]].
