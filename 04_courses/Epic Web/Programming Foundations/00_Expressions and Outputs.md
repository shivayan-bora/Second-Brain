---
creation date: 2026-04-23 12:12
modification date: Thursday 23rd April 2026 12:12:47
tags:
  - course
source:
status:
  - completed
---
- **Expression** is any piece of code that produces a value.

```ts
// string expressions
'Hello'
'Hello' + 'World'

// number expressions
42
10 + 5
100 / 4
```

- **Statement** is a piece of code that performs some action.
	- It's a combination of expressions, function calls, syntax, keywords etc.
- You can pass any expression to `console.log()` to see it's value and this is a statement.

```ts
console.log(10 + 5) // Prints: 15
console.log('Hello' + ' ' + 'World') // Prints: Hello World
```

## Template Literals

- Created like the following:

```typescript
console.log(`Hello, World!`)
```

- You don't need to escape quotes or newline characters:

```ts
console.log(`Hello,
World!`)

// Prints the same thing as: console.log('Hello,\nWorld!')
```

- In addition, you can insert the result of a [[JavaScript]] expression inside the `${expression}` in the string. This is known as **interpolation**.

```ts
console.log(`2 + 2 = ${2 + 2}`) // Prints: 2 + 2 = 4
console.log(`Hello, ${'World'}!`) // Prints: Hello, World!
```
