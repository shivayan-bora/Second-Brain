---
id: 00-expressions-and-output
aliases: []
tags:
  - project
creation date: 2026-09-08 07:01
modification date: Tuesday 8th September 2026 07:01:55
repository:
status:
  - completed
---

- Understanding programming with [[JavaScript]]

## Hello World

```ts
// Your First Program
// Let's print some messages to the console!

// 🐨 Use console.log() to print the exact string "Hello, World!"
console.log("Hello World");

// 🐨 Use console.log() to print your name (as a string) on a second line
console.log("Shivayan Bora");
```

## Escaping Strings

```ts
// Escaping Strings
// Learn to include special characters in strings

// 🐨 Log exactly: It's working! (single-quoted string; escape the apostrophe)
console.log("It's working!");

// 🐨 Log exactly: She said "Hi" (double-quoted string; escape the inner quotes)
console.log('She said "Hi"');

// 🐨 Log "Hello" and "World" on separate lines using a single string with a newline escape
console.log("Hello\nWorld");

// 🐨 Log exactly: Name: [tab] Age: [tab] City:
console.log("Name:\tAge:\tCity:\t");
```

## String Expressions

```ts
// String Expressions
// Learn to work with text data

// 🐨 Log the concatenation of "Hello", a space, and "TypeScript"
console.log("Hello" + " " + "TypeScript");

// 🐨 Log your first name and last name concatenated together with a space
console.log("Shivayan" + " " + "Bora");

// 🐨 Log the sentence "I am learning to code" by concatenating multiple strings
// 💰 Build the sentence from small pieces and include spaces where needed
console.log("I" + " " + "am" + " " + "learning" + " " + "to" + " " + "code");
```

## Number Expressions

```ts
// Number Expressions
// Learn arithmetic operations

// 🐨 Use console.log to show the result of 25 added to 17
console.log(25 + 17);

// 🐨 Use console.log to show the result of 8 multiplied by 6
console.log(8 * 6);

// 🐨 Use console.log to show the result of 100 divided by 4
console.log(100 / 4);

// 🐨 Use console.log to show the result of adding 10 and 5, then multiplying by 2
// 💰 Use parentheses so the addition happens before the multiplication
console.log((10 + 5) * 2);
```

## Template Literals

```ts
// Template Literals
// A better way to build strings

// 🐨 Log "The answer is 42" using a template literal
// 💰 Embed a calculation that evaluates to 42
console.log(`The answer is ${21 * 2}`);

// 🐨 Log a greeting that includes "Hello" and "TypeScript" using a template literal
console.log(`Hello TypeScript`);

// 🐨 Log a math sentence whose answer is 50 (embed the multiplication)
console.log(`${(20 + 5) * 2}`);
```
