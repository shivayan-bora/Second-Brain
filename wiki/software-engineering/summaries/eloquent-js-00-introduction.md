---
title: "Eloquent JavaScript ch00 — Introduction"
pillar: software-engineering
type: summary
tags: [book, chapter, javascript, programming]
status: stable
source: "raw/books/Eloquent JavaScript/00_Introduction.md"
book: "[[Eloquent JavaScript]]"
created: 2026-05-17
updated: 2026-06-09
---

# Eloquent JavaScript ch00 — Introduction

Opening framing of *Eloquent JavaScript* by Marijn Haverbeke. Defines programming and programming languages, and teases the lowest layer of representation (bits) before the next chapter dives into values, types, and operators.

## TL;DR

- **Programming** is the art of writing a program — a precise sequence of instructions that tells a computer what to do.
- **Programming languages** are *artificially constructed* languages designed to express those instructions unambiguously. See [[programming-languages]].
- Everything in a computer ultimately reduces to **bits** — `0`s and `1`s — interpreted positionally as numbers (or anything else) by convention.

## Key takeaways

- Programming is framed deliberately as an **art** — the chapter sets up the book's stance that good code is a craft, not just a mechanical activity.
- The distinction between *natural* and *artificial* languages matters: natural languages tolerate ambiguity, programming languages cannot. See [[programming-languages]].
- The binary table (`128 64 32 16 8 4 2 1`) introduces **positional binary representation** — each bit position is a power of two. This is the substrate everything else in the book will sit on, but the chapter only teases it before chapter 1 picks it up under "Values, Types and Operators."

## Notable passages

> "Programming is the art of constructing a program, which is a set of precise step of instructions to tell a computer what to do."
> — `raw/books/Eloquent JavaScript/00_Introduction.md`

## Open questions

- The intro names "Values, Types and Operators" but defers it to ch. 1 — revisit and create [[programming-values-types]] / `js-primitive-types` then.
- Bit-level representation gets only a teaser table. Once ch. 1 covers numbers/strings/booleans, a dedicated `js-bits-binary` concept page may be worth it; for now it's too thin.

## Cross-references

- Book index: [[Eloquent JavaScript]]
- Concepts introduced: [[programming-languages]]
- Related summaries: [[total-typescript-00-setup]] — the JavaScript-vs-TypeScript framing dovetails with this chapter's "what is a programming language" framing.
