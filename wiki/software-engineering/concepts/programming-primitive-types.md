---
title: Primitive Types
pillar: software-engineering
type: concept
tags: [programming, type-systems, javascript, typescript, fundamentals]
status: stable
sources: ["[[epic-web-pf-02-primitive-types]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Primitive Types

## Definition

A **primitive type** is a built-in type whose values are atomic (not composed of other values), immutable, and compared by value rather than by reference. Primitives are the leaf categories of a language's type taxonomy — every more complex type (object, array, struct, class) is ultimately built out of primitive values plus references.

## Why it matters

Type-system literacy compounds across a career:

- **Static types catch errors before runtime.** A `double(x: number)` annotation rejects `double('hello')` at compile time. At staff scale, the real payoff isn't catching `NaN` bugs — it's that the compiler enumerates every caller affected by a signature change.
- **Type annotations are machine-checked documentation.** They express intent in a form the compiler can verify. Treat them as specs, not ceremony.
- **Primitive boundaries reveal hidden constants.** Money, time, identifiers — these are domain concepts that often masquerade as primitives. Choosing whether `userId` is `string`, `number`, or a branded type is a design decision with real consequences.
- **Numeric precision is a recurring footgun.** `0.1 + 0.2 !== 0.3` (IEEE-754), `Number.MAX_SAFE_INTEGER = 2^53 - 1`, integer overflow in fixed-width types — primitive-type literacy is what keeps these from biting in production.

## Mechanics

### JavaScript / TypeScript primitives

| Type | Description | Example |
|---|---|---|
| `number` | IEEE-754 double-precision float — covers integers, decimals, negatives | `42`, `-3.14` |
| `string` | UTF-16 text | `'hello'`, `` `hi` `` |
| `boolean` | True / false | `true`, `false` |
| `null` | **Intentional** absence of a value | `null` |
| `undefined` | Variable has not been assigned | `undefined` |
| `bigint` | Arbitrary-precision integers | `9007199254740993n` |
| `symbol` | Unique, opaque identifiers | `Symbol('id')` |

Everything else in JS — objects, arrays, functions, classes, dates — is a **reference type**, compared by identity.

### `null` vs `undefined`

Two distinct ways to mean "no value":

- **`undefined`**: the binding has never been assigned, or a property doesn't exist, or a function didn't return.
- **`null`**: a programmer explicitly chose "no value here."

JSON has only `null`. Many languages collapse the distinction (Python `None`, Go `nil`, Java `null`). JS keeps both — confusing in the small, occasionally useful in the large (e.g. distinguishing "field omitted from PATCH" from "field explicitly cleared"). TypeScript's `strictNullChecks` forces you to handle them as distinct types in the type system.

### Why static types help — the `double` example

```js
// JavaScript — silent failure at runtime
function double(x) { return x * 2 }
double('hello')   // Returns NaN; bug surfaces later, far from cause
```

```ts
// TypeScript — error at compile time
function double(x: number): number { return x * 2 }
double('hello')   // Error: Argument of type 'string' is not assignable
```

### Inference still freezes the type

Even without an explicit annotation, TS picks a type at declaration and enforces it:

```ts
const age = 25      // inferred as `number`
age = 'old'         // Compile error — types are fixed once inferred
```

This contrasts with vanilla JS, where rebinding to a different type is silent — a small but persistent class of bugs.

### Cross-language note (informal)

| Language | Numeric primitives | Optional / null type |
|---|---|---|
| JS / TS | `number`, `bigint` | `null`, `undefined` |
| Go | `int`, `int64`, `float64`, etc. (no implicit conversion) | `nil` (only for ref types) |
| Rust | `i32`, `i64`, `u32`, `f64`, etc. | `Option<T>` (no nulls) |
| Python | `int` (arbitrary precision), `float` | `None` |

Cross-language patterns worth tracking: arbitrary-precision integers (Python, JS `bigint`), `Option`/`Maybe` types (Rust, Haskell, Swift, TS via discriminated unions), and the absence of implicit numeric conversion (Go, Rust).

## Examples

The implicit-coercion footgun TS prevents:

```js
function add(x, y) { return x + y }
add('1', 2)    // '12' — string concatenation
```

```ts
function add(x: number, y: number): number { return x + y }
add('1', 2)    // Compile error
```

The floating-point money footgun (per [[epic-web-pf-01-variables-immutability]]):

```ts
0.1 + 0.2 === 0.3   // false
// Store integer minor units: $14.99 -> 1499 cents
const priceCents = 1499
```

## Related

- [[programming-variables]] — variables hold values of primitive (or reference) types.
- [[programming-immutability]] — primitives are value-immutable by definition; strings, numbers, etc. cannot be modified in place.
- [[programming-expressions]] — every expression has a type, often a primitive.
- [[js-variable-declarations]] — TypeScript annotations on `const`/`let` bindings.

## Sources

- [[epic-web-pf-02-primitive-types]] (`raw/courses/Epic Web/Programming Foundations/02_Primitive Types.md`)
