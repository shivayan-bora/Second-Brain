---
title: "Epic Web Programming Foundations 00 — Expressions and Outputs"
pillar: software-engineering
type: summary
tags: [course, chapter, javascript, typescript, expressions]
status: stable
source: "raw/courses/Epic Web/Programming Foundations/00_Expressions and Outputs.md"
course: "Epic Web — Programming Foundations (Kent C. Dodds)"
created: 2026-05-17
updated: 2026-05-17
---

# Epic Web Programming Foundations 00 — Expressions and Outputs

Opening chapter of Kent C. Dodds' *Programming Foundations*. Establishes the most fundamental code-vs-value distinction in any programming language: **expressions produce values, statements perform actions**. Introduces `console.log` as the canonical "show me the value" tool and JavaScript template literals as a richer string-construction syntax.

## TL;DR

- An **expression** evaluates to a value; a **statement** performs an action. Every program is built from these two primitives. See [[programming-expressions]].
- `console.log(expr)` is a *statement* that prints the *value* of an expression — the simplest possible feedback loop.
- **Template literals** (backtick strings) are JS's answer to string interpolation, multiline strings, and avoiding quote-escaping. See [[js-template-literals]].
- **Interpolation** (`${expr}`) embeds the value of any expression inside a template literal — note the word *expression*, not *statement*. This is a hard line you'll meet again everywhere (JSX, format strings, etc.).

## Key takeaways

- **Expression vs. statement is a load-bearing distinction.** It shows up in JSX (only expressions inside `{}`), in pattern matching, in lambdas vs. blocks, and in how languages design control flow (Rust makes `if` an expression; C makes it a statement). See [[programming-expressions]].
- **`console.log` is a statement that consumes an expression.** Naming this explicitly removes the confusion of "why can't I `console.log` an `if` block?".
- **Template literals replace string concatenation for almost everything.** No quote escaping, real multiline support, embedded expression interpolation. The closing claim — *"you can insert the result of a JavaScript expression"* — is precisely why JSX's `{}` syntax feels natural to JS developers. See [[js-template-literals]].

## Notable passages

> "**Expression** is any piece of code that produces a value."
> — Epic Web Programming Foundations ch. 00 (`raw/courses/Epic Web/Programming Foundations/00_Expressions and Outputs.md`)

> "**Statement** is a piece of code that performs some action. It's a combination of expressions, function calls, syntax, keywords etc."
> — same

## Open questions

- Languages disagree on what's an expression vs statement (Rust: `if` is an expression; Python: assignment is a statement; JS: assignment is technically an expression returning the assigned value). Worth a future page comparing these design choices.
- Tagged template literals (`` html`...` ``, `` sql`...` ``) — Kent doesn't introduce them here, but they're the obvious next step from plain interpolation. Note for later chapters.

## Cross-references

- Concepts introduced: [[programming-expressions]], [[js-template-literals]].
- Next chapter: [[epic-web-pf-01-variables-immutability]].
