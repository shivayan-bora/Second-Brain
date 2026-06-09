---
title: "JS Modules — Historical Arc"
pillar: software-engineering
type: concept
tags: [javascript, modules, history]
status: stable
sources: ["[[advanced-js-00-iifes-commonjs-es6-modules]]"]
created: 2026-06-09
updated: 2026-06-09
---

# JS Modules — Historical Arc

## Definition

JavaScript did not have a built-in module system until ES2015. The "module problem" — how to isolate scope, declare dependencies, and expose a public surface — was solved by a succession of community patterns and runtime conventions before the language itself took over the job.

## Why it matters

Every "weird" decision in modern JS tooling — why bundlers exist, why CJS↔ESM interop is awkward, why `import` is static and can't go inside an `if` — falls out of this history. Reading a modern `package.json` (with `"type": "module"`, `"exports"`, `"sideEffects"`) is easier when you know what each field is patching over.

## The arc

1. **Globals + script-tag ordering.** Every `<script>` shares `window`. Ordering matters; collisions are silent.
2. **Namespace object + wrapper functions.** Expose a single `APP = {}` global; attach everything else inside named functions that read/write to `APP`. Still global; still ordered.
3. **[[js-iife|IIFE pattern]].** Wrap each "module" in a self-invoking function expression so its locals stay private. Only the `APP` namespace leaks.
4. **[[js-commonjs|CommonJS]].** Node ships with `require` / `module.exports`. Each file gets its own scope. **Synchronous**, so browser-hostile.
5. **Module bundlers** (Webpack, Browserify). Walk the CJS dependency graph at build time, emit a single `bundle.js` the browser can load with one tag.
6. **[[js-es-modules|ES Modules]].** ES2015 bakes `import` / `export` into the language. Static analysis enables [[tree-shaking]]. Native in modern browsers and Node (via `"type": "module"` or `.mjs`).

## Why the order matters

- Each step solves the previous step's pain — but none of the earlier patterns disappear from the ecosystem overnight. Most npm packages today still ship CJS for compatibility; many ship both via dual builds.
- The "static imports" decision of ESM is the single biggest break from CJS. It rules out `require()`-inside-`if()` patterns, which is the price you pay for tree-shaking.

## Related

- [[js-iife]] — the pre-CJS module pattern.
- [[js-commonjs]] — Node's original module system.
- [[js-es-modules]] — the standardized successor.
- [[commonjs-vs-esm-interop]] — what to do when they meet.
- [[tree-shaking]] — the payoff for static imports.

## Sources

- [[advanced-js-00-iifes-commonjs-es6-modules]] — chapter is structured as this exact narrative.
