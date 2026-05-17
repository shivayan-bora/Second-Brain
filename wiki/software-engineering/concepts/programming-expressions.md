---
title: Expressions and Statements
pillar: software-engineering
type: concept
tags: [programming, language-semantics, fundamentals]
status: in-progress
sources: ["[[epic-web-pf-00-expressions-outputs]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Expressions and Statements

## Definition

An **expression** is any piece of code that evaluates to a value. A **statement** is a piece of code that performs an action — it may contain expressions, function calls, keywords, and syntactic structure, but it doesn't itself produce a value usable as input to another expression.

> Expression: `2 + 2`, `'hello'`, `user.name`, `fn(x)`. All produce values.
> Statement: `if (...) { ... }`, `for (...) { ... }`, `return x;`, `let x = 5;`. All perform actions.

## Why it matters

The expression-vs-statement boundary is one of the most consequential design choices in any language, and a fluent grasp of it pays compounding dividends:

- **Language ergonomics.** "Expression languages" (Rust, Scala, Ruby) make almost everything an expression, including `if`, `match`, and blocks — this enables terse functional style and `let x = if cond { a } else { b }`. "Statement-heavy languages" (C, Java pre-records, Python) force you into temporaries or ternaries.
- **JSX and template DSLs.** JSX permits *expressions* inside `{}` — not statements. The rule "you can't put an `if` statement in JSX" is just a corollary of the expression/statement distinction. The fix is to use a ternary or `&&`, which *are* expressions.
- **Refactoring.** "Extract variable" only works on expressions. "Extract function" works on statement sequences. Knowing which you have determines the move.
- **Functional programming.** Pure FP is built on expressions; effects (which act on the world) are statements. The boundary is the boundary of purity.

## Mechanics

- **Every expression has a value and a type.** `42` is `number`. `'hi'` is `string`. `2 + 2` is `number` with value `4`. `console.log('hi')` is also an expression — it returns `undefined` — but it's almost always used as a statement (as `console.log('hi');`).
- **A statement may *contain* expressions.** `if (x > 0) { ... }` is a statement; `x > 0` inside it is an expression.
- **Assignment is a tricky case.**
  - In JavaScript, `x = 5` is technically an *expression* that produces `5` (which is why `if (x = 5)` accidentally works and is a famous footgun).
  - In Python, `x = 5` is a *statement* — you can't write `if x = 5`. The walrus `:=` was added in 3.8 as an explicit expression-form assignment.
  - In Rust, `let x = 5` is a statement; the binding is not an expression.
- **Some languages make blocks expressions.** Rust's `{ let x = 1; x + 1 }` evaluates to `2`. JavaScript's `{ ... }` is a statement block and has no value.

## Examples

JavaScript:

```js
// Expressions
'hello'                    // string expression, value: 'hello'
2 + 2                      // number expression, value: 4
user.isActive              // boolean expression
fn(x, y)                   // function-call expression

// Statements
let total = 0;             // declaration statement
if (cond) { doIt(); }      // if statement
for (const x of xs) { ... } // for statement
return result;             // return statement

// console.log is a statement that consumes an expression:
console.log(2 + 2);        // prints 4
```

JSX consequence — only expressions are allowed inside braces:

```jsx
// Works: ternary is an expression
{ isLoggedIn ? <Dashboard/> : <Login/> }

// Fails: if is a statement
{ if (isLoggedIn) <Dashboard/> else <Login/> }   // SyntaxError
```

## Related

- [[js-template-literals]] — string interpolation `${...}` accepts any expression (not statements).
- [[programming-variables]] — variable declarations are statements that bind a name to the value of an expression.
- [[programming-primitive-types]] — every expression has a type; primitive types are the leaf categories.

## Sources

- [[epic-web-pf-00-expressions-outputs]] (`raw/courses/Epic Web/Programming Foundations/00_Expressions and Outputs.md`)
