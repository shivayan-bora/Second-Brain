---
title: "Total TypeScript ch00 — Kickstart your TypeScript Setup"
pillar: software-engineering
type: summary
tags: [course, chapter, typescript, javascript, tooling]
status: stable
source: "raw/courses/Total TypeScript/00_Kickstart your TypeScript Setup.md"
course: "[[Total TypeScript]]"
created: 2026-05-17
updated: 2026-05-17
---

# Total TypeScript ch00 — Kickstart your TypeScript Setup

Opening chapter of Matt Pocock's *Total TypeScript*. Frames TypeScript's relationship to JavaScript and walks through how the two languages differ in the build pipeline. No code yet — this is the conceptual setup before tooling and syntax start in later chapters.

## TL;DR

- **TypeScript is a superset of JavaScript** — every `.js` file is valid `.ts`. TS adds a type system that exists only at compile time. See [[ts-vs-js]].
- **The runtime doesn't understand TypeScript.** Browsers and Node.js run JavaScript only; `.ts` files are compiled down by [[ts-compiler-tsc|`tsc`]] (or an equivalent like esbuild/swc) into `.js` first.
- **TypeScript's primary win is tooling**, not runtime safety: autocomplete, type-checking, and reliable refactors — things JavaScript's dynamic nature can't give you at the IDE layer.
- **Origin story:** Microsoft built ScriptSharp (typed C# → JS) internally in 2010, then productized the idea as TypeScript.

## Key takeaways

- **The two pipelines look like this:**
  - Plain JS: `.js` → browser/Node directly.
  - TS: `.ts` → IDE's TypeScript LSP gives live feedback → `tsc` compiles to `.js` → browser/Node consumes it. See [[ts-compiler-tsc]] for the diagram and detail.
- **JavaScript's tooling pain was the original motivation.** Without static types, IDEs cannot reliably offer autocomplete or safe rename — every refactor in a large JS codebase was manual. TypeScript's whole reason for being is to fix that. See [[ts-vs-js]].
- **The LSP is half the value.** A lot of "TypeScript benefit" is actually IDE-time benefit delivered by the TypeScript Language Server — error squiggles, hover types, jump-to-definition — *before* `tsc` ever runs. The compile-step `tsc` mostly enforces what the LSP was already showing.
- **`tsc` is a CLI tool**, typically wired into the build pipeline. The course implies but doesn't yet detail `tsconfig.json` — that comes later.

## Notable passages

> "[[TypeScript]] is syntactic sugar sprinkled on top of [[JavaScript]] (also known as a superset of [[JavaScript]]), to help build stronger, performant and robust applications."
> — `raw/courses/Total TypeScript/00_Kickstart your TypeScript Setup.md`

> "The tooling for JavaScript is quite shitty and even though IDEs helped, you didn't have features available like in other typed languages like: autocomplete, type checking."
> — `raw/courses/Total TypeScript/00_Kickstart your TypeScript Setup.md`

## Open questions

- The course teases `tsc` but doesn't yet cover `tsconfig.json`. When a later chapter does, create `ts-tsconfig.md` and link it from [[ts-compiler-tsc]].
- "Syntactic sugar" undersells TypeScript — types are not just syntax, they're a separate static analysis pass. Worth flagging if a later chapter doubles down on that framing.
- Modern teams often split emit (esbuild/swc) from type-checking (`tsc --noEmit`). Does *Total TypeScript* cover this split, or stay on vanilla `tsc`?

## Cross-references

- Course index: [[Total TypeScript]]
- Concepts introduced: [[ts-vs-js]], [[ts-compiler-tsc]]
- Related summaries: [[eloquent-js-00-introduction]] — sister "what is a programming language" framing from the JavaScript side.
