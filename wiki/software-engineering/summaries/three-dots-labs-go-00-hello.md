---
title: "Three Dots Labs — Go in One Evening 00: Hello, World"
pillar: software-engineering
type: summary
tags: [course, chapter, go, hello-world]
status: stable
source: "raw/courses/Three Dots Labs Academy/Go in One Evening/00_hello.md"
course: "Three Dots Labs — Go in One Evening"
created: 2026-05-17
updated: 2026-05-17
---

# Three Dots Labs — Go in One Evening 00: Hello, World

First chapter of the *Go in One Evening* course. The canonical Go entry point: a `package main`, an `import "fmt"`, and a `func main()` that prints `"Hello, World!"`.

## TL;DR

- Every Go file declares a [[go-packages|package]]. The executable's entry point lives in `package main`.
- Other packages — like the standard library's `fmt` — are pulled in with `import`. See [[go-packages]].
- `func main()` is the program's entry point. No `main` in the `main` package = no executable.
- Comments use `//` for single-line and `/* ... */` for multi-line, identical to C/Java/JS.

## Key takeaways

- **Code is grouped into packages, not files.** A package is the unit of compilation and namespacing in Go. See [[go-packages]].
- **The standard library is import-by-string.** `import "fmt"` references the format package by its import path, not by a global name. The Tour of Go expands on this in [[tour-of-go-00-packages]].
- **Minimal ceremony to a runnable program** — a five-line file is a complete, compilable Go program. Compare to Java's class-wrapped `psvm`.

## Notable passages

> "Go code can be grouped into packages. You can use other packages by importing them."
> — *Go in One Evening*, ch. 00 (`raw/courses/Three Dots Labs Academy/Go in One Evening/00_hello.md`)

## Open questions

- How does Go's package model compare to a Python package or a Java package — especially around cyclic imports? Worth following up when later chapters introduce custom packages.

## Cross-references

- [[tour-of-go-00-packages]] — same idea, different source.
- [[three-dots-labs-go-01-variables]] — next chapter, introduces types and variables.
- Concepts introduced: [[go-packages]].
