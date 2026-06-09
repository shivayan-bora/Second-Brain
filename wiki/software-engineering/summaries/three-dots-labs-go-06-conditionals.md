---
title: "Three Dots Labs — Go in One Evening 06: Conditionals"
pillar: software-engineering
type: summary
tags: [course, chapter, go, control-flow]
status: stable
former_source: "raw/courses/Three Dots Labs Academy/Go in One Evening/06_conditionals.md"
source_status: deleted
course: "Three Dots Labs — Go in One Evening"
created: 2026-05-17
updated: 2026-06-09
---

# Three Dots Labs — Go in One Evening 06: Conditionals

> [!NOTE] Raw source deleted
> The raw note this summary was ingested from has since been deleted from the vault during a cleanup. The wiki page below is retained as a record of the user's prior notes. See `former_source` in frontmatter for the original path.

`if / else if / else` and `switch / case` in Go. Two small but consequential syntactic choices: **no parentheses around `if` conditions**, and **no fallthrough by default in `switch`**.

## TL;DR

- `if cond { ... } else if cond { ... } else { ... }` — condition has **no parentheses** around it, unlike C/Java/JS.
- `switch x { case 0: ... case 1: ... default: ... }` — **no `break` needed**, cases don't fall through by default. Opt back into fallthrough with the explicit `fallthrough` keyword (not shown in the source).
- See [[go-conditionals]].

## Key takeaways

- **No parens around `if` is a small ergonomic win.** It reads cleaner and removes a class of "where did I forget the parens" typos. Braces are mandatory even for single statements — no `if x == 1 doThing()`. See [[go-conditionals]].
- **`switch` default is no-fallthrough**, matching Python (`match`/`if-elif`) and Rust. C/Java/JS require an explicit `break` to *prevent* fallthrough; Go inverts the default. This eliminates the classic "forgot the `break`" bug.
- **No ternary operator in Go.** Not covered in this chapter, but worth flagging — Go forces `if/else` blocks where other languages allow `cond ? a : b`. The team's stance is that ternaries hurt readability.

## Notable passages

> "Unlike languages like C, JavaScript and Java, in Go doesn't need to define it's condition inside brackets `()`."
> — *Go in One Evening*, ch. 06 (`raw/courses/Three Dots Labs Academy/Go in One Evening/06_conditionals.md`)

> "Like Python and unlike some other languages like C, Java and JavaScript, Go doesn't need explicit `break` statements to prevent fallover."
> — *Go in One Evening*, ch. 06

## Open questions

- The "if with statement" form (`if v, err := f(); err != nil { ... }`) — common Go idiom that scopes a variable to the `if`. Not in this chapter; very common in real code.
- `switch` without an expression (`switch { case cond1: ... }`) as a `if/else if` alternative — also missing here.
- Type switches (`switch x.(type)`) — a whole different beast.

## Cross-references

- [[three-dots-labs-go-03-http-server]] — uses an `if name == ""` guard in the handler.
- [[three-dots-labs-go-07-errors]] — Go error handling is largely `if err != nil` chains.
- Concepts introduced: [[go-conditionals]].
