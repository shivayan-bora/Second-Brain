---
title: JavaScript Template Literals
pillar: software-engineering
type: concept
tags: [javascript, typescript, strings, syntax]
status: stable
sources: ["[[epic-web-pf-00-expressions-outputs]]"]
created: 2026-05-17
updated: 2026-05-17
---

# JavaScript Template Literals

## Definition

A **template literal** is a JavaScript string literal delimited by backticks (`` ` ``) rather than single or double quotes. It supports two features ordinary string literals do not:

1. **Multi-line strings** — newlines in the source are preserved literally; no `\n` escapes needed.
2. **Interpolation** — `${expression}` embeds the value of any JavaScript expression directly into the string.

## Why it matters

Template literals replace nearly all uses of string concatenation in modern JS/TS. They're also the foundation of **tagged templates**, which underpin libraries like `styled-components`, `graphql-tag`, lit-html, and many SQL builders. Being fluent here is table-stakes for reading modern JS code.

## Mechanics

- **Backticks delimit.** `` `hello` `` is identical to `'hello'` for a plain literal.
- **`${ expr }` interpolates.** The contents of `${...}` must be a single [[programming-expressions|expression]], not a statement. The result is converted to a string via the standard `ToString` algorithm.
- **Newlines are literal.** A line break in the source becomes a `\n` in the resulting string.
- **No quote-escaping headaches.** Both `'` and `"` can appear inside without escaping.
- **Tagged templates** (not covered in this chapter) — prefixing a template with a function call turns it into a structured parse: `` tag`Hello ${name}` `` calls `tag(['Hello ', ''], name)`. This is the basis for `css`, `html`, `gql`, etc.

## Examples

Plain interpolation:

```ts
const name = 'World'
console.log(`Hello, ${name}!`)        // Hello, World!
console.log(`2 + 2 = ${2 + 2}`)        // 2 + 2 = 4
```

Multi-line — no `\n` needed:

```ts
console.log(`Hello,
World!`)
// Equivalent to: console.log('Hello,\nWorld!')
```

Mixed quotes without escaping:

```ts
console.log(`She said "it's fine".`)   // She said "it's fine".
```

Any expression — including conditionals, calls, and property access:

```ts
console.log(`Status: ${user.isActive ? 'active' : 'inactive'}`)
console.log(`Total: $${(price * qty).toFixed(2)}`)
```

## Related

- [[programming-expressions]] — only expressions, not statements, fit inside `${...}`.
- [[js-variable-declarations]] — template literals are commonly the right-hand side of `const` bindings.

## Sources

- [[epic-web-pf-00-expressions-outputs]] (`raw/courses/Epic Web/Programming Foundations/00_Expressions and Outputs.md`)
