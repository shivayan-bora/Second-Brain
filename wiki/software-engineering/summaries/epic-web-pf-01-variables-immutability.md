---
title: "Epic Web Programming Foundations 01 — Variables and Immutability"
pillar: software-engineering
type: summary
tags: [course, chapter, javascript, typescript, variables, immutability]
status: stable
source: "raw/courses/Epic Web/Programming Foundations/01_Variables and Immutability.md"
course: "Epic Web — Programming Foundations (Kent C. Dodds)"
created: 2026-05-17
updated: 2026-05-17
---

# Epic Web Programming Foundations 01 — Variables and Immutability

Second chapter of Epic Web *Programming Foundations*. Defines variables as named pointers to memory locations, distinguishes **reassignment** from **mutation**, and covers JS's `let` / `const` and ES module exports. Ends with a money-storage gotcha that's the perfect illustration of why "primitive type semantics" matters in production.

## TL;DR

- A variable is a **named pointer to a memory location** — not the value itself. See [[programming-variables]].
- `let` allows reassignment (the pointer can move); `const` does not. Both can point to mutable contents. See [[js-variable-declarations]].
- **Reassignment ≠ mutation.** `const` prevents the former but not the latter. Mistaking these is one of the most common JS bugs. See [[programming-immutability]].
- In dynamically-typed languages, **memory is allocated at runtime** based on the value. TypeScript's annotations are a static layer on top of this runtime behavior.
- `export` (and `export { ... }`) is how ES modules expose bindings to other files.
- **Money should not be stored as floating point.** Use integer cents and format for display.

## Key takeaways

- **The pointer model unlocks everything.** Once you internalize "variable = label on a memory slot," the rest of `const`/`let` semantics, pass-by-reference behavior, and the reassignment/mutation distinction all fall out naturally. See [[programming-variables]].
- **`const` is about the binding, not the value.** `const arr = [1,2,3]; arr.push(4)` is legal and frequently surprising. Strict immutability requires `Object.freeze`, `readonly` (TS), or value types like records/tuples. See [[programming-immutability]].
- **Prefer `const` by default.** A reassignable variable is a maintenance liability — it forces readers to trace the binding through scope. Kent's example uses `const TAX_RATE` for fixed values, `let total` only where mutation is intrinsic to the algorithm. See [[js-variable-declarations]].
- **Floating-point money is a footgun.** `0.1 + 0.2 !== 0.3` because IEEE-754. Store integer minor-units (cents, paise, satoshis); format at the display boundary. This is the universal advice — and a great example of "primitive-type literacy" being a staff-eng concern, not a beginner one.
- **Exports are first-class bindings.** `export const FAVORITE_COLOR = 'blue'` exports a *binding*, not a value snapshot — re-exports and live updates work because of this.

## Notable passages

> "Whenever we're creating a variable, what's happening under the hood is that, the value is stored in a memory location and the variable is a pointer that points to that memory location."
> — Epic Web Programming Foundations ch. 01 (`raw/courses/Epic Web/Programming Foundations/01_Variables and Immutability.md`)

> "**Reassignment** - Pointing the variable to a new value. **Mutation** - Changing the contents of the existing value. `const` prevents reassignment but **NOT** mutation."
> — same

> "While denoting money in your code, you need to be extra careful as floating point precision can mess up the values. One way of solving this is when storing money, $14.99 can be written as 1499 cents."
> — same, `> [!NOTE]` callout

## Open questions

- What's the right level of immutability discipline for a JS/TS codebase? `const` everywhere + lint rules? Immer? Immutable.js? Records & tuples (TC39)? Future investigation.
- How does this pointer model differ in languages with value semantics (Rust, Swift, Go for primitives)? Cross-reference with future Go notes on assignment.

## Cross-references

- Previous chapter: [[epic-web-pf-00-expressions-outputs]].
- Next chapter: [[epic-web-pf-02-primitive-types]].
- Concepts introduced: [[programming-variables]], [[programming-immutability]], [[js-variable-declarations]].
