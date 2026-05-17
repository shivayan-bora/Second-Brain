---
title: "Three Dots Labs — Go in One Evening 05: Slices"
pillar: software-engineering
type: summary
tags: [course, chapter, go, slices, collections]
status: stable
source: "raw/courses/Three Dots Labs Academy/Go in One Evening/05_slices.md"
course: "Three Dots Labs — Go in One Evening"
created: 2026-05-17
updated: 2026-05-17
---

# Three Dots Labs — Go in One Evening 05: Slices

Slices are Go's **dynamic-size** sequence type — the everyday workhorse you reach for instead of an [[go-arrays|array]]. Declared without a size: `[]string`.

## TL;DR

- `var contacts []string` declares a `nil` slice. **Indexing a nil slice panics** with `index out of range`.
- Slice literal `contacts := []string{}` gives you a non-nil, empty, len-0 slice.
- `make([]string, 5)` preallocates a slice of five zero-value strings.
- Slice literal with values: `[]string{"Alice", "John", "Emma"}`.
- `len(contacts)` works the same as arrays.

## Key takeaways

- **Slices are the default sequence in Go.** Almost no idiomatic code uses raw arrays. See [[go-slices]].
- **`nil` slice vs empty slice is a real distinction** — both have `len() == 0`, both are safe to `range` over, but the `nil` one will panic on direct indexing and may behave differently when JSON-encoded (`null` vs `[]`).
- **`make([]T, n)` is for preallocation,** which matters when you know the final size — it avoids the repeated reallocations of repeatedly `append`-ing to a slice.
- **Slice declaration shape: `[]T` (no number)** distinguishes it from an array's `[N]T`. The absence of the size literal is the visual cue you're working with the dynamic version.

## Notable passages

> "A declared slice is equal to `nil` i.e. nothing or no value. The slice is not initialized yet. Trying to access elements of a `nil` value will cause the application to crash."
> — *Go in One Evening*, ch. 05 (`raw/courses/Three Dots Labs Academy/Go in One Evening/05_slices.md`)

## Open questions

- The course doesn't cover `append`, slice-of-slice semantics, the capacity vs length distinction, or the shared-backing-array gotchas. Big follow-up area.
- When does `make([]T, 0, cap)` (length 0, capacity cap) make more sense than `make([]T, cap)`?
- How does range-with-index work on slices, and does it differ from arrays?

## Cross-references

- [[three-dots-labs-go-04-arrays]] — the fixed-size predecessor and the contrast that motivates slices.
- Concepts introduced: [[go-slices]].
