---
title: "Learning Go ch00 — Setting up your Go environment"
pillar: software-engineering
type: summary
tags: [book, chapter, go, tooling]
status: stable
source: "raw/books/Learning Go/00_Setting up your go environment.md"
book: "[[Learning Go]]"
created: 2026-05-17
updated: 2026-05-17
---

# Learning Go ch00 — Setting up your Go environment

First chapter of *Learning Go, 2nd Edition* by Jon Bodner. Covers the minimum tooling needed to compile, format, and lint a Go program, plus Makefiles as a way to standardize those steps.

## TL;DR

- A Go project is a **module**, initialized with `go mod init <name>`. The module is described by a `go.mod` file at its root — the rough equivalent of `package.json` / `requirements.txt` / `Gemfile`. See [[go-modules]].
- The Go toolchain ships with `go build`, `go fmt`, and `go vet` — compile, format, and static-check. You almost always run them together. See [[go-toolchain]].
- `go fmt` is not just cosmetic — it inserts the implicit semicolons Go's lexer requires. Misplaced braces (e.g. `func main()` on its own line, `{` on the next) become invalid Go after `fmt` rewrites them.
- [[makefiles|Makefiles]] are the canonical way to chain `fmt → vet → build` into a single `make` invocation, with `.DEFAULT_GOAL` and `.PHONY` keeping the workflow honest.

## Key takeaways

- **A module is a unit of distribution, not just a folder.** It includes both source code *and* the exact dependency spec. Don't hand-edit `go.mod`; use `go get` and `go mod tidy`. See [[go-modules]].
- **The Go binary defaults to the module name** — `go build` produces `hello_world` if the module is `hello_world`. Override with `go build -o hello`.
- **`go fmt` is mandatory discipline, not style.** Bodner's advice: if you forget, make a *separate commit* that runs only `go fmt ./...` so formatting churn doesn't hide real changes in code review. See [[go-toolchain]].
- **`go vet` catches syntactically-valid-but-wrong code** — e.g. a `fmt.Printf` with a `%s` placeholder and no arguments. Always run before commit.
- **Makefile basics carry across languages.** Targets, prerequisites, `.PHONY` to avoid file/target collisions, `.DEFAULT_GOAL` to set the default — same primitives whether you're driving Go, C, or shell. See [[makefiles]].

## Notable passages

> "Remember to run `go fmt` before you compile your code, and, at the very least, before you commit source code changes to your repository! If you forget, make a separate commit that does only `go fmt ./...` so you don't hide logic changes in an avalanche of formatting changes."
> — Bodner, *Learning Go* ch. 0

> "You can't run `make` on Windows machines before installing `make` to your system."
> — Bodner, *Learning Go* ch. 0

## Open questions

- How does `go mod tidy` actually decide what to prune vs. keep? Worth a dedicated page once a later chapter or a deeper source covers it.
- What's the modern recommended replacement for `make` in Go shops that find it crufty (e.g. `task`, `just`, `mage`)? Note for future ingest.

## Cross-references

- Book index: [[Learning Go]]
- Concepts introduced: [[go-modules]], [[go-toolchain]], [[makefiles]]
