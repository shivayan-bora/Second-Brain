---
title: "Tour of Go 00 — Packages"
pillar: software-engineering
type: summary
tags: [documentation, chapter, go, packages]
status: stable
former_source: "raw/documentation/Tour of Go/00_Packages.md"
source_status: deleted
documentation: "Tour of Go"
created: 2026-05-17
updated: 2026-06-09
---

# Tour of Go 00 — Packages

> [!NOTE] Raw source deleted
> The raw note this summary was ingested from has since been deleted from the vault during a cleanup. The wiki page below is retained as a record of the user's prior notes. See `former_source` in frontmatter for the original path.

The opening page of the official *Tour of Go*. Reinforces the same point as [[three-dots-labs-go-00-hello]]: a Go program is a tree of packages, with `package main` as the entry point.

## TL;DR

- All Go programs are made of [[go-packages|packages]].
- `package main` is the entry-point package for any executable.
- The example imports both `fmt` and `math/rand` — the latter showing a **slash-separated import path** for a sub-package.

## Key takeaways

- **Import paths are hierarchical strings.** `math/rand` ≠ `math` — you import the sub-package directly. See [[go-packages]].
- **Standard-library packages live in the same import-path namespace as third-party.** There's no special syntax distinguishing `fmt` (stdlib) from `github.com/foo/bar` (third-party) at the import-statement level — only the path string differs.
- This page is a single-screen overview; the substance is the example itself.

## Notable passages

> "All Go programs are made of packages. This program is the part of the `main` package which is the entry point of a Go application."
> — *Tour of Go*, "Packages" (`raw/documentation/Tour of Go/00_Packages.md`)

## Open questions

- The Tour presumably walks through imports, exported names, and visibility next — those will deepen [[go-packages]] when ingested.
- How does `math/rand` differ from `crypto/rand`? Worth noting for the security-mindful staff engineer: `math/rand` is **not** cryptographically secure.

## Cross-references

- [[three-dots-labs-go-00-hello]] — same concept, different source.
- [[go-modules]] — modules group packages for distribution.
- Concepts introduced: [[go-packages]].
