---
title: Immutability (Reassignment vs Mutation)
pillar: software-engineering
type: concept
tags: [programming, language-semantics, immutability, fundamentals]
status: stable
sources: ["[[epic-web-pf-01-variables-immutability]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Immutability (Reassignment vs Mutation)

## Definition

**Immutability** is the property that a value, once created, cannot change. The term applies at two distinct levels — confusing them is one of the most common bugs in mainstream code:

- **Binding immutability**: the *variable* cannot be made to point at a different value. (JS `const`, Java `final`, Rust `let` without `mut`.)
- **Value immutability**: the *value itself* cannot be modified in place. (JS strings, Rust `&T`, Clojure's persistent collections, frozen objects.)

## Why it matters

Immutability is the lever that pays for itself many times over in real systems:

- **Reasoning locality.** An immutable value passed to a function cannot be changed by that function — you don't have to read the function to know what it might do to your data.
- **Concurrency.** Immutable values are inherently thread-safe; no synchronization needed.
- **Caching, memoization, structural sharing.** Persistent data structures only work because of immutability.
- **Time-travel and undo.** Redux, event sourcing, and CRDTs all rely on the ability to keep old states around — only possible if they don't mutate.
- **Equality.** Value-based equality is well-defined only for immutable values.

The staff-eng instinct is to make the *binding* immutable by default (`const`) and to keep *values* immutable where the architecture benefits — but to recognize that JS gives you only the first half for free.

## Mechanics

### Reassignment vs. mutation

- **Reassignment**: pointing the variable to a new value.
- **Mutation**: changing the contents of the existing value.

```ts
let arr = [1, 2, 3]
arr = [4, 5, 6]   // Reassignment — `arr` points to a NEW array
arr.push(7)       // Mutation — same array, now [4, 5, 6, 7]
```

### What `const` does and doesn't do in JS

- `const` prevents **reassignment**. `const x = 1; x = 2;` is a `TypeError`.
- `const` does **not** prevent **mutation**. `const arr = [1,2,3]; arr.push(4)` is legal.

This trips up nearly everyone learning JS. The right mental model: `const` is a guarantee about the *label*, not the *object*.

### Achieving value immutability in JS / TS

| Mechanism | Effect |
|---|---|
| `Object.freeze(obj)` | Shallow runtime freeze — top-level properties become read-only. |
| `readonly` (TS) | Compile-time check; no runtime effect. |
| `as const` (TS) | Marks a literal as deeply readonly at the type level. |
| Persistent libs (Immer, Immutable.js) | Structural sharing; updates return new objects. |
| TC39 Records & Tuples (proposal) | Deeply immutable primitive-like composites. |

### Across languages

- **Rust**: bindings are immutable by default (`let`); mutation requires `let mut`. Aliased mutation is statically prevented by the borrow checker.
- **Go**: no `const` for non-primitive values; immutability is a convention.
- **Clojure**: all built-in collections are persistent (value-immutable).
- **Java**: `final` is binding-immutable; value immutability requires careful class design (no setters, defensive copies).

## Examples

The classic "I used `const`, why did my array change?" bug:

```ts
const items = []
function add(item) {
  items.push(item)   // legal — mutates contents
}
add('a')
// items is now ['a']
```

Defensive copy as a pattern:

```ts
function addImmutably(items, item) {
  return [...items, item]  // returns a NEW array; caller's is untouched
}
```

Floating-point money — a related "values are not what you think" gotcha (per the chapter's `> [!NOTE]` callout):

```ts
0.1 + 0.2 === 0.3        // false — IEEE-754 strikes again
// Fix: store as integer cents.
const price = 1499        // $14.99
```

## Related

- [[programming-variables]] — the pointer model is what makes reassignment vs. mutation a meaningful distinction.
- [[js-variable-declarations]] — `let` and `const` are the JS knobs for binding mutability.
- [[programming-primitive-types]] — primitives are value-immutable by definition in most languages.

## Sources

- [[epic-web-pf-01-variables-immutability]] (`raw/courses/Epic Web/Programming Foundations/01_Variables and Immutability.md`)
