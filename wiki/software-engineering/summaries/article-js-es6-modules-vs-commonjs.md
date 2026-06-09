---
title: "Article — JavaScript ES6 Modules vs CommonJS"
pillar: software-engineering
type: summary
tags: [article, javascript, modules, commonjs, esm, tree-shaking, design-systems]
status: stable
source: "raw/articles/JavaScript ES6 Modules vs CommonJS.md"
created: 2026-06-09
updated: 2026-06-09
---

# Article — JavaScript ES6 Modules vs CommonJS

Perplexity-sourced article framed around a design-system component library. Less historical than [[advanced-js-00-iifes-commonjs-es6-modules]] and more practical: how the module choice shapes the public API of a package.

## TL;DR

- A module is just **a file with its own scope** and an explicit public surface via `export`. Anything not exported is private. See [[js-es-modules]].
- **Imports are static and hoisted** — the module graph is known at build time. That's what makes [[tree-shaking]] possible.
- **Named exports** beat default exports for libraries: better autocomplete, better tree-shaking, easier to re-export through [[js-barrel-files|barrel files]]. Default exports are best reserved for single-config-object or legacy-compat cases.
- ESM has **live bindings** — an `import`ed value is a live view of the export, not a copy. Mutating the exporter changes what the importer sees.
- CJS↔ESM interop has sharp edges: `import math from "./math.cjs"` exposes `module.exports` as `default`; CJS requiring ESM usually needs `import()` or a dual build. See [[commonjs-vs-esm-interop]].

## Key takeaways

- **Barrel files (`index.ts` re-exports) shape your package's public API.** Pair them with `"exports"` in `package.json` to control which deep paths consumers can reach. See [[js-barrel-files]].
- **Side-effects defeat tree-shaking.** Top-level mutations (DOM, registry registration, etc.) force the bundler to keep the module. Mark `"sideEffects": false` in `package.json` (or list the safe files) to unlock dead-code elimination. See [[tree-shaking]].
- **Dynamic imports are the loading-strategy escape hatch.** `import("./heavy")` returns a Promise; combined with `React.lazy` or framework code-splitting, it defers loading until the component is actually used. See [[js-dynamic-imports]].
- **The CJS↔ESM gap is asymmetric.** ESM-importing-CJS is well-supported; CJS-requiring-ESM is awkward and usually needs build-time help.

## Notable passages

> "Imports are static and hoisted – the module graph is known at build time, which enables tree-shaking."

> "ES6 Module imports are live views of the exported values and not copies."

> "CommonJS is harder to analyze because `require` is just a function; what's required can depend on runtime logic."

## Open questions

- How does Vite/esbuild handle the CJS→ESM dance under the hood — are `.cjs` deps pre-bundled to ESM at dev-server start?
- Are there real-world examples where live bindings cause surprising bugs (e.g., stale-closure-style issues across module boundaries)?
- Where does `package.json` `"exports"` enforcement bite hardest — and is it worth the deep-import lockdown for an internal design system?

## Cross-references

- Companion: [[advanced-js-00-iifes-commonjs-es6-modules]] — historical narrative.
- Concepts introduced: [[js-es-modules]], [[js-commonjs]], [[js-barrel-files]], [[js-dynamic-imports]], [[tree-shaking]], [[commonjs-vs-esm-interop]].

## Source

- `raw/articles/JavaScript ES6 Modules vs CommonJS.md`
