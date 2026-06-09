---
title: "Learn Go with Tests ch00 — Install Go"
pillar: software-engineering
type: summary
tags: [course, chapter, go, setup, modules]
status: stable
source: "raw/courses/Learn Go with Tests/00_Install Go.md"
course: "Learn Go with Tests (quii / github.com/quii/learn-go-with-tests)"
created: 2026-06-09
updated: 2026-06-09
---

# Learn Go with Tests ch00 — Install Go

Setup chapter. Light coverage — almost entirely a `go mod init` walkthrough that defers to [[go-modules]] and [[go-toolchain]] for the substance. Notable mainly for the user's repo-naming convention and a reminder that Go modules are the default since Go 1.16.

## TL;DR

- `go mod init <module-path>` is the canonical initializer; user's path: `shivayan-bora/Learn-Go-With-Tests` (mirrors a GitHub URL).
- Modules are the default build mode since **Go 1.16** — `GOPATH` is officially no longer recommended for new projects.
- `go.mod` is Go's `package.json` / `requirements.txt` analogue: declares module identity and the Go toolchain version.

## Key takeaways

- This chapter is effectively a thinner version of [[learning-go-ch00-environment-setup]] — same module concept, less depth on toolchain commands.
- The course's setup story is module-first from page one; tests in later chapters won't run without `go.mod` (see the "cannot find main module" error in [[learn-go-with-tests-01-hello-world]]).

## Open questions

- The chapter shows `go 1.26.3` in the generated `go.mod` — does the course discuss the `go` directive's role beyond version-pinning (toolchain selection, language-feature gating)?

## Cross-references

- Duplicate-topic summary: [[learning-go-ch00-environment-setup]] — denser coverage of the same setup.
- Concepts: [[go-modules]], [[go-toolchain]], [[go-packages]].

## Source

- `raw/courses/Learn Go with Tests/00_Install Go.md`
