---
title: Programming Languages
pillar: software-engineering
type: concept
tags: [programming, languages, fundamentals]
status: stable
sources: ["[[eloquent-js-00-introduction]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Programming Languages

## Definition

A **programming language** is an artificially constructed language used to give a computer a precise sequence of instructions — a *program*. Programming itself is the act of composing those instructions; the language is the medium.

## Why it matters

Programming languages sit between human intent and machine execution. Every language picks a place on the spectrum from "close to the hardware" (assembly, C) to "close to human intent" (Python, SQL). Understanding that the *language is a deliberate trade-off*, not a neutral tool, is foundational to picking the right one for a problem and to reading critique of language design (e.g. why TypeScript exists on top of JavaScript — see [[ts-vs-js]]).

For a staff engineer, knowing the *shape* of the language landscape — what each language was designed to optimize for — matters more than fluency in any single one.

## Mechanics

- A **program** is a set of precise, step-by-step instructions for a computer.
- Programming languages are **artificial** — designed, not evolved — and therefore have unambiguous grammars and semantics (unlike natural language).
- All programming languages eventually reduce to machine code (binary instructions the CPU can execute). The path from source to machine code is the language's *execution model*:
  - **Compiled** — translated ahead of time to machine code (C, Go, Rust).
  - **Interpreted** — read and executed at runtime by another program (Python, classic JavaScript).
  - **Transpiled** — translated to another high-level language first (TypeScript → JavaScript; see [[ts-compiler-tsc]]).
  - **JIT-compiled** — compiled at runtime by a VM (Java, modern JavaScript engines).
- All of them ultimately operate on **bits** — sequences of `0` and `1` — interpreted as numbers, characters, instructions, or addresses depending on context.

## Examples

A trivial program in three different languages, expressing the same intent ("print hello"):

```python
print("hello")             # Python — interpreted
```

```javascript
console.log("hello");      // JavaScript — JIT-compiled in modern engines
```

```go
fmt.Println("hello")       // Go — compiled ahead of time
```

The instructions are different surface syntax over the same underlying idea: produce output via the OS's standard-output stream.

## Related

- [[ts-vs-js]] — a concrete case of one language being designed as a layer over another.
- [[ts-compiler-tsc]] — how a transpiled language reaches the runtime.
- [[go-toolchain]] — the compile/format/check workflow of a typical compiled language.

## Sources

- [[eloquent-js-00-introduction]] (`raw/books/Eloquent JavaScript/00_Introduction.md`)
