---
title: "Three Dots Labs — Go in One Evening 01: Variables"
pillar: software-engineering
type: summary
tags: [course, chapter, go, variables, types]
status: stable
former_source: "raw/courses/Three Dots Labs Academy/Go in One Evening/01_variables.md"
source_status: deleted
course: "Three Dots Labs — Go in One Evening"
created: 2026-05-17
updated: 2026-06-09
---

# Three Dots Labs — Go in One Evening 01: Variables

> [!NOTE] Raw source deleted
> The raw note this summary was ingested from has since been deleted from the vault during a cleanup. The wiki page below is retained as a record of the user's prior notes. See `former_source` in frontmatter for the original path.

Covers Go's primitive types, the three ways to declare a variable, constants, scoping (local vs global), and grouped `var`/`const` blocks.

## TL;DR

- Four common primitive types to start: `int`, `bool`, `float64`, `string`. See [[go-variables]].
- Three declaration syntaxes: `var name type` (zero value), `var name = expr` (type inferred), and `name := expr` (short form, **function scope only**).
- `const` works like `var` but produces an immutable binding.
- Variables declared inside a function are local; outside, they're package-global.
- `var (...)` and `const (...)` blocks group related declarations.

## Key takeaways

- **The walrus operator (`:=`) is the most common form** inside functions — it both declares and infers type. At package scope you must use `var`. See [[go-variables]].
- **Zero values are language-level, not runtime defaults.** `var year int` is `0`, not undefined or nil. This makes uninitialized state predictable and is why Go has no "undefined" concept.
- **Constants are declared with `const`** and follow the same scoping/inference rules as `var`.
- **Grouped declarations exist for readability** — `var ( ... )` and `const ( ... )` blocks let you batch related package-level state without repeating the keyword.

## Notable passages

> "Walrus operator can only be used inside a function scope i.e. as a local variable only."
> — *Go in One Evening*, ch. 01 (`raw/courses/Three Dots Labs Academy/Go in One Evening/01_variables.md`)

## Open questions

- What's the convention for when to use `var x = expr` vs `x := expr` inside a function? They're equivalent in semantics — is there a style guide rule?
- When does choosing `int` vs `int64` (or `float32` vs `float64`) actually matter in production?

## Cross-references

- [[three-dots-labs-go-00-hello]] — previous chapter.
- [[three-dots-labs-go-02-functions]] — next chapter, builds on variables for parameters and return values.
- Concepts introduced: [[go-variables]].
