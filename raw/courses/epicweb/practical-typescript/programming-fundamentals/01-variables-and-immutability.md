---
id: 01-variables-and-immutability
aliases: []
tags:
  - project
creation date: 2026-09-08 07:15
modification date: Tuesday 8th September 2026 07:15:57
repository:
status:
  - completed
---

## Let and Const

```ts
// Shopping Cart System
// Understanding when to use let vs const

// 🐨 Create a constant `TAX_RATE` set to 0.08 (8%)
const TAX_RATE = 0.08;

// 🐨 Create a variable `cartTotal` using `let`, starting at 0
let cartTotal = 0;

// 🐨 Create constants for product prices:
// - bookPrice is 15.99
// - muffinPrice is 4.5
// - laptopPrice is 999.99
// 💰 TypeScript doesn't know/care whether the number represents money or a
// count, so you don't use a dollar sign in the syntax
const bookPrice = 15.99;
const muffinPrice = 4.5;
const laptopPrice = 999.99;

// 🐨 Add the book to the cart (update cartTotal)
cartTotal += bookPrice;

// 🐨 Add the muffin to the cart (update cartTotal)
// 💰 Leave the laptop out of the cart for this exercise
cartTotal += muffinPrice;

// 🐨 Create `finalTotal` as cartTotal plus 8% tax using TAX_RATE
const finalTotal = cartTotal + cartTotal * TAX_RATE;

// 🐨 Try uncommenting the line below - what happens?
// TAX_RATE = 0.10

// Uncomment the following lines to see the results
console.log("Cart subtotal:", cartTotal);
console.log("Tax:", cartTotal * TAX_RATE);
console.log("Final total:", finalTotal);

// 🐨 Export TAX_RATE, cartTotal, and finalTotal so we can verify your work
export { TAX_RATE, cartTotal, finalTotal };
```

## Reassignment vs Mutation

- Reassignment: Pointing a variable to a completely new value

```ts
let x = 1;
x = 2; // x now points to a new value
```

- Mutation: Modifying the contents of an existing value

```ts
const obj = { count: 1 };
obj.count = 2; // The object itself is modified (mutated)
```

> [!NOTE]
> `const` prevents reassignment but NOT mutation! You can still change properties on a `const` object.

```ts
// Understanding Reassignment vs Mutation

// This object is declared with const
const person = { name: "Alice", age: 30, city: "Seattle" };

console.log("Original person:", person);

// 🐨 Try to reassign person to a new object:
// person = { name: 'Bob', age: 25, city: 'Portland' }
// 💣 Uncomment the line above and see the TypeScript error

// 🐨 Now try MUTATING the object by changing the age property to 31
person.age = 31;
// 🐨 Mutate again by changing the city to 'Portland'
person.city = "Portland";
console.log("Modified person:", person);

// 🦉 Key insight: const prevents reassignment, not mutation!
// The variable person always points to the SAME object,
// but the properties of that object can change.

// 🐨 Export person so we can verify your work
export { person };
```
