---
title: "Three Dots Labs — Go in One Evening 07: Errors"
pillar: software-engineering
type: summary
tags: [course, chapter, go, errors, error-handling]
status: in-progress
source: "raw/courses/Three Dots Labs Academy/Go in One Evening/07_errors.md"
course: "Three Dots Labs — Go in One Evening"
created: 2026-05-17
updated: 2026-05-17
---

# Three Dots Labs — Go in One Evening 07: Errors

> [!WARNING]
> The raw source file for this chapter is essentially empty of Go content — it contains an empty code block followed by an unrelated PR description (Karma test fixes). This summary is therefore a **placeholder** that records what the chapter *would* cover based on its title and Go's well-known conventions, pending re-ingest when the user fills in the source.

## TL;DR

- Go errors are **values, not exceptions** — functions return an `error` as their last return value, and callers check it with `if err != nil { ... }`.
- This convention is built on [[go-functions|multiple return values]] and [[go-conditionals|conditionals]]: idiomatic Go is a chain of `result, err := f(); if err != nil { return err }`.
- See [[go-error-handling]].

## Key takeaways

- *Pending source content.* The summary will be expanded when the raw source is populated. The placeholder concept page [[go-error-handling]] captures what's known from adjacent Go literature and the rest of this course.

## Notable passages

*(none — source is empty)*

## Open questions

- The whole chapter, essentially. To be filled in once the raw source is updated:
  - The `error` interface and how to construct errors (`errors.New`, `fmt.Errorf`).
  - Error wrapping with `%w` and `errors.Is` / `errors.As`.
  - Sentinel errors vs typed errors vs opaque errors.
  - `panic` / `recover` and when (rarely) to use them.

## Cross-references

- [[three-dots-labs-go-02-functions]] — multi-return is the substrate of `result, err`.
- [[three-dots-labs-go-06-conditionals]] — `if err != nil` is the canonical check.
- Concepts introduced: [[go-error-handling]] (placeholder).
