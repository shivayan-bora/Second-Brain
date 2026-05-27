---
creation date: 2026-04-27 11:16
modification date: Monday 27th April 2026 11:16:43
tags:
  - chapter
status:
  - completed
aliases: []
id: 02_Primitive Types
---

- The core types we use most often:
  - **`number`** - All numeric values (integers, decimals, negatives)
  - **`string`** - Text data (always in quotes)
  - **`boolean`** - True or false values
  - **`null`** - Intentional absence of a value
  - **`undefined`** - Variable not yet assigned
  - **`bigint`** - Arbitrarily large integers
  - **`symbol`** - Unique identifiers

## Why Types Matter?

- To catch errors statically:

```js
// JavaScript - no error until runtime
function double(x) {
  return x * 2;
}
double("hello"); // Returns NaN at runtime 😱
```

```ts
function double(x: number): number {
  return x * 2;
}
double("hello"); // ❌ Error: Argument of type 'string' is not assignable
```

- [[TypeScript]]'s type annotations are like documentation that the compiler can verify. They tell other developers (and future you) exactly what kind of data your code expects.
- In [[TypeScript]], even with type inference, you can't change types later.

## Null and Undefined

- [[TypeScript]] also has two special types for representing **absence of value**:
  - `undefined`: a variable that hasn't been assigned a value (default for uninitialized variables)
  - `null`: an intentional absence of any value.
    - You need to explicitly assign `null` to a variable.
- You can't create an uninitialized `const` varriable, however, you can assign `null` to a `const` variable:

```ts
let myUndefinedVar: undefined; // This is valid, but it will be undefined until assigned
const myUndefinedConst: undefined; // ❌ Error: 'const' declarations must be initialized
const myUndefinedConstValid: undefined = undefined; // This is valid
const myNullConstValid: string | null = null; // This is valid
```

## Equality Operators

- [[JavaScript]] has two kinds of equality operators:
  - `==` or loose equality: Compares values after [[Type Coercion]]
  - `===` or strict equality: Compares values without type conversion

## BigInt and Symbol

- Regular `number` has limits i.e. it can't accurately represent integers larger than `Number.MAX_SAFE_INTEGER` (2^53 - 1). For larger integers, we can use `bigint`:

```ts
const big: bigint = 9007199254740993n; // Note the 'n' suffix
const alsoBig: bigint = BigInt("9007199254740993");

// BigInt arithmetic
const sum = 1000000000000000000n + 1n; // Works correctly!
```

- However, `bigint` cannot be mixed with `number` in operations without explicit conversion:

```ts
let num: number = 10;
let big: bigint = 20n;

console.log(num + big); // ❌ Error: Cannot mix BigInt and other types
```

- Symbols are unique identifiers, often used for object properties to avoid name collisions:

```ts
const id: symbol = Symbol("userId");
const anotherId: symbol = Symbol("userId");

id === anotherId; // false - each Symbol() creates a unique value!
```

- Symbols are often used for `hidden` object properties or library internal keys.

## Truthy and Falsy Values

- We often need to decide if a value `exists` without comparing it to `numm` or `undefined`. JavaScript treast some value as falsy, and everything else as truthy:
  - Falsy values: `false`, `0`, `-0`, `0n`, `""` (empty string), `null`, `undefined`, and `NaN`
  - Truthy values: Everything else (including all objects, non-empty strings, and non-zero numbers)
- To convert a value to a boolean, you can use the double negation `!!` or `Boolean()`:
