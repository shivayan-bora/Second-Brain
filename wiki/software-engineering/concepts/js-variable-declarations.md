---
title: JavaScript Variable Declarations (`let`, `const`, `var`)
pillar: software-engineering
type: concept
tags: [javascript, typescript, variables, syntax, modules]
status: stable
sources: ["[[epic-web-pf-01-variables-immutability]]"]
created: 2026-05-17
updated: 2026-05-17
---

# JavaScript Variable Declarations (`let`, `const`, `var`)

## Definition

Modern JavaScript (and therefore TypeScript) has three keywords for declaring variables: `var` (legacy), `let` (reassignable, block-scoped), and `const` (non-reassignable, block-scoped). Each makes a slightly different statement about the *binding* — none of them, by itself, says anything about the *value*.

## Why it matters

Choosing between `let` and `const` is a stylistic dial that affects every code review. The widely-adopted convention — *prefer `const`, fall back to `let` when reassignment is intrinsic* — is one of the lowest-cost discipline improvements available to a JS codebase. Knowing why the convention exists (and what it doesn't buy you) matters more than memorizing the syntax.

## Mechanics

### `const`

- **Block-scoped.** Visible only within `{ ... }`.
- **Must be initialized at declaration.** `const x;` is a syntax error.
- **Cannot be reassigned.** `x = ...` after declaration is a `TypeError`.
- **Does not prevent mutation** of the underlying value — see [[programming-immutability]].

### `let`

- **Block-scoped.**
- **May be declared without initialization** (defaults to `undefined`).
- **May be reassigned.**

### `var` (legacy — avoid)

- **Function-scoped**, not block-scoped — leaks out of `if`/`for` blocks.
- **Hoisted** — usable before its declaration (as `undefined`).
- **Permits redeclaration** in the same scope.
- In any new code, `var` should be replaced by `let` or `const`.

### Style convention

The dominant style guide (and Kent's example) is:

```ts
const TAX_RATE = 0.08    // fixed config — never reassigned
let total = 0            // mutation is intrinsic to the algorithm

for (const item of items) {
  total += item.price    // reassigning `total` here is the whole point
}
```

A reassignable variable is a maintenance liability: readers must trace the binding through the scope to know its current value. `const` localizes reasoning.

### TypeScript type inference

Type annotations are optional but legal:

```ts
const age = 25             // inferred: number
const age: number = 25     // explicit, same effect

const isActive: boolean = true
```

Even with inference, **types are fixed** — `let x = 5; x = 'five';` is a TS error. This contrasts with vanilla JS where rebinding to a different type is silent.

### ES module exports

Declarations become module exports by prefixing `export` or by using a named export list:

```ts
// Single export
export const FAVORITE_COLOR = 'blue'

// Multiple exports at end of file
const FAVORITE_COLOR = 'blue'
let currentAge = 25
export { FAVORITE_COLOR, currentAge }
```

`export` exposes the **binding** — not a value snapshot — so live updates within the exporting module are visible to importers (with the caveat that importers receive read-only views).

## Examples

Prefer `const`:

```ts
// Good — intent is clear; reassignment is impossible
const config = loadConfig()
const items = await fetchItems()

// Use `let` only where the value must change
let attempts = 0
while (attempts < 3 && !done) {
  attempts++
  // ...
}
```

The "but it changed!" gotcha:

```ts
const user = { name: 'Alice' }
user.name = 'Bob'        // legal — mutation, not reassignment
user = { name: 'C' }     // ERROR — reassignment is what `const` forbids
```

## Related

- [[programming-variables]] — the underlying pointer model.
- [[programming-immutability]] — the reassignment vs. mutation distinction these keywords participate in.
- [[programming-expressions]] — `const x = expr` binds the *value of an expression*.

## Sources

- [[epic-web-pf-01-variables-immutability]] (`raw/courses/Epic Web/Programming Foundations/01_Variables and Immutability.md`)
