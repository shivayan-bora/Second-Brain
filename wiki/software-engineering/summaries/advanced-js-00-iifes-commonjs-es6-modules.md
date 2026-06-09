---
title: "Advanced JavaScript ch00 — From IIFEs to CommonJS to ES6 Modules"
pillar: software-engineering
type: summary
tags: [course, chapter, javascript, modules, history]
status: stable
source: "raw/courses/fireship.dev/Advanced JavaScript/00_From IIFEs to CommonJS to ES6 Modules.md"
course: "Advanced JavaScript (fireship.dev)"
created: 2026-06-09
updated: 2026-06-09
---

# Advanced JavaScript ch00 — From IIFEs to CommonJS to ES6 Modules

Historical narrative of how JavaScript got modules: globals → `APP`-namespace + wrapper functions → IIFEs → CommonJS → ES modules. Each step solved a real pain from the previous one.

## TL;DR

- A module is a unit with three parts: **imports**, **code**, **exports**. The benefits — reusability, composability, isolation, organization — are the same across every module system; only the syntax and loading model change. See [[js-modules-history]].
- Pre-modules, every `<script>` shared the global `window`. The fix was the **[[js-iife|IIFE pattern]]**: a single namespace object (`APP`) plus self-invoking functions that attach to it.
- IIFEs still left script-tag ordering as a global concern. **[[js-commonjs|CommonJS]]** (`require` / `module.exports`) solved that for Node by giving each file its own scope and a synchronous resolver — but synchronous loading is a non-starter in browsers.
- Bundlers (Webpack) bridged the gap: walk the CJS graph at build time, emit one `bundle.js`. The browser sees one script tag.
- **[[js-es-modules|ES modules]]** (`import` / `export`) bake the module system into the language. Imports are static, which is what enables **[[tree-shaking]]**.

## Key takeaways

- **The IIFE pattern was the first real module pattern in JS** — a function expression invoked immediately, isolating its locals while exposing a handful to a shared namespace object. See [[js-iife]].
- **CommonJS's synchronous `require` was a deal-breaker for browsers.** It works fine in Node because the filesystem is local; in a browser, blocking on a network fetch per `require()` would freeze the page. See [[js-commonjs]].
- **Module bundlers exist because of CJS's browser problem.** They flatten the dependency graph offline so the browser only ever loads one (or a few code-split) bundles. See `[[module-bundlers]]` _(future)_.
- **ESM `import` is intentionally static.** You cannot put `import` inside an `if`. This constraint is what lets the bundler statically analyze the tree and tree-shake unused exports. Conditional dynamic loads use `import()` (function form). See [[js-es-modules]] and [[js-dynamic-imports]].

## Notable passages

> "The CommonJS group defined a module format to solve JavaScript scope issues by making sure each module is executed in its own namespace."
> — Advanced JavaScript, *From IIFEs to CommonJS to ES6 Modules*

> "By forcing modules to be static, the loader can statically analyze the module tree, figure out which code is actually being used, and drop the unused code from your bundle."
> — Advanced JavaScript, *From IIFEs to CommonJS to ES6 Modules*

## Open questions

- The chapter mentions Webpack but doesn't cover ESM-aware bundlers (esbuild, Vite, Rollup) — how do they differ in their tree-shaking guarantees?
- AMD and UMD are skipped entirely. Worth a future ingest for historical completeness?
- What does "live bindings" mean for ESM, and how does it differ from CJS's exported-object-snapshot? (The companion article covers this — see [[article-js-es6-modules-vs-commonjs]].)

## Cross-references

- Companion: [[article-js-es6-modules-vs-commonjs]] — comparison-focused, picks up interop and barrel files.
- Concepts introduced: [[js-modules-history]], [[js-iife]], [[js-commonjs]], [[js-es-modules]], [[tree-shaking]].

## Source

- `raw/courses/fireship.dev/Advanced JavaScript/00_From IIFEs to CommonJS to ES6 Modules.md`
