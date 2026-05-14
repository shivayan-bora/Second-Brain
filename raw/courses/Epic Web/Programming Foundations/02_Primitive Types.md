---
creation date: 2026-04-27 11:16
modification date: Monday 27th April 2026 11:16:43
tags:
  - chapter
status:
  - in-progress
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
	return x * 2
}
double('hello') // Returns NaN at runtime 😱
```

```ts
function double(x: number): number {
	return x * 2
}
double('hello') // ❌ Error: Argument of type 'string' is not assignable
```

- [[TypeScript]]'s type annotations are like documentation that the compiler can verify. They tell other developers (and future you) exactly what kind of data your code expects.
- In [[TypeScript]], even with type inference, you can't change types later.

## Null and Undefined

- [[TypeScript]] also has two special types for representing **absence of value**:
	- `undefined`: a variable that hasn't been assigned a value
	- `null`: an intentional absence of any value.
		- You need to explicitly assign `null` to a variable.
