---
creation date: 2026-04-25 23:34
modification date: Saturday 25th April 2026 23:34:43
tags:
  - chapter
status:
  - in-progress
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

## Reassignment Vs Mutation

- **Reassignment** - Pointing the variable to a new value
- **Mutation** - Changing the contents of the existing value

```ts
let arr = [1, 2, 3]
arr = [4, 5, 6] // Reassignment - arr points to a NEW array
arr.push(7) // Mutation - modifying the SAME array
```

- `const` prevents reassignment but NOT mutation. You can still modify the contents of a `const` array or object.

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
