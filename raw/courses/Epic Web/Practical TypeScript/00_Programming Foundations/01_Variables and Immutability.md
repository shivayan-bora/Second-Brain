---
creation date: 2026-04-25 23:34
modification date: Saturday 25th April 2026 23:34:43
tags:
  - chapter
status:
  - completed
---
- Variables are containers for values.
- In [[TypeScript]] (and modern [[JavaScript]]), there are two main ways to declare them:
	- `let`: Can be reassigned
	- `const`: Can't be reassigned

```ts
const TAX_RATE = 0.08 // Never changes
let total = 0 // Will be updated

for (const item of items) {
	total += item.price // Reassigning total
}
```

```ts
const age = 25 // TypeScript knows this is a number
const name = 'Alice' // TypeScript knows this is a string
```

```ts
const age: number = 25
const name: string = 'Alice'
const isActive: boolean = true
```

- Whenever we're creating a variable, what's happening under the hood is that, the value is stored in a memory location and the variable is a pointer that points to that memory location.
	- In [[Dynamically Typed Programming Languages]], the memory gets allocated for the value at runtime.
	- `let` variables can point to other memory locations during runtime, but you can't do the same with `const` variables.

## Reassignment Vs Mutation

- **Reassignment** - Pointing the variable to a new value
- **Mutation** - Changing the contents of the existing value

```ts
let arr = [1, 2, 3]
arr = [4, 5, 6] // Reassignment - arr points to a NEW array
arr.push(7) // Mutation - modifying the SAME array
```

- `const` prevents reassignment but **NOT** mutation. You can still modify the contents of a `const` array or object.

## Exporting Variables

- `export` makes a variable available to other files.
- Exporting a single variable:

```ts
export const FAVORITE_COLOR = 'blue'
```

- Exporting multiple variables:

```ts
const FAVORITE_COLOR = 'blue'
let currentAge = 25

export { FAVORITE_COLOR, currentAge }
```

> [!NOTE]
> While denoting money in your code, you need to be extra careful as floating point precision can mess up the values. One way of solving this is when storing money, $14.99 can be written as 1499 cents. After that, just for display purposes, we can covert that into a dollar value without touching the other important aspects.
