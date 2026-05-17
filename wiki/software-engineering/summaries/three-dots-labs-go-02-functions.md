---
title: "Three Dots Labs — Go in One Evening 02: Functions"
pillar: software-engineering
type: summary
tags: [course, chapter, go, functions]
status: stable
source: "raw/courses/Three Dots Labs Academy/Go in One Evening/02_functions.md"
course: "Three Dots Labs — Go in One Evening"
created: 2026-05-17
updated: 2026-05-17
---

# Three Dots Labs — Go in One Evening 02: Functions

Function declaration, parameters (including same-type parameter shorthand), single and multiple return values, and destructuring of multi-return into local variables.

## TL;DR

- `func Name(args) returnType { ... }`. No arguments and no return type both collapse cleanly. See [[go-functions]].
- Same-type adjacent parameters can be compressed: `func Add(a, b, c, d, e int) int`.
- Functions can return **multiple values**: `func FullName() (string, string)`.
- Multi-return values are destructured with the walrus operator: `firstName, lastName := FullName()`.

## Key takeaways

- **Multiple return values are idiomatic, not exotic.** Go uses them everywhere — most notably as the `(result, error)` pair that drives [[go-error-handling|error handling]]. See [[go-functions]].
- **The capitalization of a function name matters.** Exported (public) functions start with an uppercase letter; unexported (package-private) start lowercase. The course uses `Hello` and `Add` — both technically exported. (This convention is mentioned implicitly via casing here, expanded elsewhere.)
- **Same-type parameter shorthand reduces noise** for arithmetic-style signatures: `func Add(a, b int) int` reads cleaner than `func Add(a int, b int) int`.

## Notable passages

> "function with multiple return values: `func FullName() (string, string) { return "Alice", "Smith" }`"
> — *Go in One Evening*, ch. 02 (`raw/courses/Three Dots Labs Academy/Go in One Evening/02_functions.md`)

## Open questions

- Are multi-return values implemented as tuples or as a stack/register convention? Cosmetic for now, but worth knowing if I ever care about FFI or perf.
- Named return values (`func f() (x int)`) — where do they help vs hurt readability?

## Cross-references

- [[three-dots-labs-go-01-variables]] — previous chapter; variable concepts underpin parameters and return bindings.
- [[three-dots-labs-go-07-errors]] — multi-return is the substrate of Go's error convention.
- Concepts introduced: [[go-functions]].
