---
title: "Epic Web Programming Foundations 02 — Primitive Types"
pillar: software-engineering
type: summary
tags: [course, chapter, javascript, typescript, types, type-systems]
status: stable
source: "raw/courses/Epic Web/Programming Foundations/02_Primitive Types.md"
course: "Epic Web — Programming Foundations (Kent C. Dodds)"
created: 2026-05-17
updated: 2026-05-17
---

# Epic Web Programming Foundations 02 — Primitive Types

Third chapter of Epic Web *Programming Foundations* (in-progress in the raw notes). Enumerates JavaScript / TypeScript's seven primitive types, motivates static typing via a `double('hello')` example, and distinguishes `null` (intentional absence) from `undefined` (uninitialized).

## TL;DR

- JS/TS has seven primitive types: `number`, `string`, `boolean`, `null`, `undefined`, `bigint`, `symbol`. See [[programming-primitive-types]].
- **Types matter because errors caught at compile time are infinitely cheaper than errors caught at runtime.** TS's `double(x: number)` rejects `double('hello')` before the code runs.
- **Type annotations are documentation the compiler verifies.** This is the right mental model — annotations aren't ceremony, they're machine-checked specs.
- **`null` is intentional absence; `undefined` is "not yet assigned."** They mean different things; treating them as synonyms is a frequent source of bugs.

## Key takeaways

- **A primitive type is one whose values are immutable and compared by value.** It's a category, not just a list — useful for contrast with reference types (objects, arrays, functions). See [[programming-primitive-types]].
- **Static types are a force multiplier for refactoring.** The `double('hello')` example understates this — at staff scale, the value of TS is less "no `NaN` bugs" and more "I can change a function signature and the compiler enumerates every caller that needs updating."
- **`null` vs `undefined` is a real distinction.** `undefined` = the system hasn't filled this in; `null` = the programmer chose "no value." TypeScript's `strictNullChecks` makes you handle them as distinct types. JSON has only `null`. Many languages collapse them (Python's `None`, Go's `nil`, Java's `null`); JS keeps both, which is occasionally useful and frequently confusing.
- **Even with type inference, you can't change types later in TS.** Inferred types are still types — `const age = 25` is `number`, and `age = 'old'` is a compile error. This contrasts with vanilla JS where rebinding to a different type is silent.

## Notable passages

> "TypeScript's type annotations are like documentation that the compiler can verify. They tell other developers (and future you) exactly what kind of data your code expects."
> — Epic Web Programming Foundations ch. 02 (`raw/courses/Epic Web/Programming Foundations/02_Primitive Types.md`)

> "`undefined`: a variable that hasn't been assigned a value. `null`: an intentional absence of any value. You need to explicitly assign `null` to a variable."
> — same

## Open questions

- When should one reach for `bigint` vs accepting `number`'s 2^53 - 1 ceiling? Money in cents fits in `number` for almost all realistic balances; cryptographic primes do not. Worth a dedicated page on numeric-range gotchas.
- `symbol` gets a one-line mention — what are its real-world uses (well-known symbols, branded types, library-private keys)? Note for future ingest.
- How do these primitives compare to other languages' type taxonomies (Go's basic types, Rust's scalar types, Python's built-ins)? Future cross-language synthesis.

## Cross-references

- Previous chapter: [[epic-web-pf-01-variables-immutability]].
- Concepts introduced: [[programming-primitive-types]].
- Related concepts: [[programming-variables]], [[programming-immutability]].
