---
title: Variables (as Named Bindings)
pillar: software-engineering
type: concept
tags: [programming, language-semantics, fundamentals, memory-model]
status: stable
sources: ["[[epic-web-pf-01-variables-immutability]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Variables (as Named Bindings)

## Definition

A **variable** is a named binding that associates an identifier with a location in memory holding a value. Writing `x` in code is shorthand for "the value stored at the location `x` currently refers to." The variable is not the value — it's a label on a slot that contains the value.

## Why it matters

The pointer model of variables ("a variable is a label on a memory slot") is the single most useful mental model in programming. Once internalized, it explains:

- **Reassignment vs. mutation.** See [[programming-immutability]].
- **Pass-by-reference vs. pass-by-value.** Most languages pass the *value of the binding* (which for reference types is a pointer to a heap object). This is why `function push(arr) { arr.push(1) }` mutates the caller's array in JS.
- **Closures.** A closure captures *bindings*, not values. Reassigning the captured variable changes what the closure sees.
- **`const` semantics across languages.** Java's `final`, JS's `const`, Rust's `let` (vs `let mut`), C++'s `const T*` vs `T* const` — all are statements about the *binding*, not the *value*.

For a staff engineer, mismodeling variables as "boxes containing values" rather than "labels on memory" is the root cause of an enormous number of bugs in code review.

## Mechanics

- **Binding.** Declaration creates the association: `const x = 5` binds `x` to a memory slot holding `5`.
- **Pointer.** The binding is a pointer; reading `x` dereferences it.
- **Reassignment** (if the language permits) updates the pointer to point at a different slot. The original value is untouched.
- **Mutation** updates the contents of the slot the pointer currently points to. The binding is untouched.
- **Allocation timing.**
  - In **dynamically typed languages** (JS, Python, Ruby): memory is allocated at runtime based on the value being stored.
  - In **statically typed compiled languages** (C, Rust, Go): the compiler often knows the size at compile time and can allocate on the stack.
  - In **statically typed managed languages** (Java, C#, TS-on-V8): a mix — primitives may be stack-allocated, objects are heap-allocated, with a JIT making decisions.

## Examples

Binding and the pointer model:

```ts
const age = 25
// `age` is a name pointing to a memory location holding 25.
// Reading `age` returns 25.
```

Reassignment with `let`:

```ts
let total = 0
total = total + 10
// `total` now points to a different memory location holding 10.
// The original 0 may be garbage-collected.
```

Pass-by-value-of-pointer (JS):

```ts
function rename(user) {
  user.name = 'Bob'   // mutates the caller's object
  user = { name: 'C' }  // rebinds the LOCAL parameter; caller unaffected
}
```

## Related

- [[programming-immutability]] — reassignment vs. mutation is built on the pointer model.
- [[js-variable-declarations]] — JS's specific `let` / `const` / `var` rules.
- [[programming-primitive-types]] — primitive values are typically compared/stored by value, not by reference.

## Sources

- [[epic-web-pf-01-variables-immutability]] (`raw/courses/Epic Web/Programming Foundations/01_Variables and Immutability.md`)
