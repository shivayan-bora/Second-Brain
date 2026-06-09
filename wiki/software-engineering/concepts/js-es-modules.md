---
title: "ES Modules (ESM)"
pillar: software-engineering
type: concept
tags: [javascript, modules, esm, esnext]
status: stable
sources: ["[[advanced-js-00-iifes-commonjs-es6-modules]]", "[[article-js-es6-modules-vs-commonjs]]"]
created: 2026-06-09
updated: 2026-06-09
---

# ES Modules (ESM)

## Definition

ES Modules — `import` / `export` — are JavaScript's standardized, language-level module system, introduced in ES2015. Each module is a file with its own scope, in strict mode by default. Exports are declared statically and imports are hoisted, so the entire module graph is knowable at parse time.

## Why it matters

ESM is the modern default for new code. Its **static** nature is what enables [[tree-shaking]], the build-time guarantee that unused exports get dropped from the bundle. This single property is why design-system libraries strongly prefer ESM — consumers only pay for what they import.

## Mechanics

### Named exports (the recommended default)

```js
// utils.js
export function first(arr) { return arr[0]; }
export function last(arr)  { return arr[arr.length - 1]; }

import { first }     from "./utils";
import * as utils    from "./utils";
```

### Default export (use sparingly)

```js
export default function leftpad(str, len, ch) { ... }

import leftpad from "./leftpad";
```

### Combining

```js
import leftpad, { first, last } from "./utils";
```

### In HTML

```html
<script type="module" src="dom.js"></script>
```

### In Node

Either `.mjs` extension or `"type": "module"` in `package.json`.

## The properties that matter

- **Static.** `import` is a top-level declaration, not a function call. You **cannot** put it inside an `if`. For conditional loading, use [[js-dynamic-imports|`import()`]].
- **Hoisted.** All imports are resolved before any module code runs.
- **Strict mode by default.** No accidental globals; `this` at module top level is `undefined`.
- **Live bindings.** An `import`ed value is a live reference to the export, not a snapshot. If the exporter mutates the binding later, importers see the new value.
- **Module scope.** Top-level `let`/`const` are not on `window`; only `export`ed names are visible elsewhere.

### Live bindings — a small example

```js
// currentTheme.js
export let currentTheme = "light";
export function setTheme(name) { currentTheme = name; }

// app.js
import { currentTheme, setTheme } from "./currentTheme.js";
console.log(currentTheme);  // "light"
setTheme("dark");
console.log(currentTheme);  // "dark"
```

This is the property that genuinely differs from CJS — in CJS, `const { currentTheme } = require(...)` would destructure a snapshot.

## Why the static constraint?

By forcing imports to be statically analyzable, the loader/bundler can walk the entire dependency graph at build time and:
- Drop unused exports ([[tree-shaking]]).
- Detect circular imports up-front.
- Plan code splits and prefetches.

You give up the freedom to `require()` inside an `if`; you get back a much more capable build pipeline.

## Related

- [[js-modules-history]] — situates ESM as the endpoint of the arc.
- [[js-commonjs]] — predecessor, dynamic mirror of ESM's static.
- [[js-dynamic-imports]] — escape hatch for runtime-conditional loading.
- [[tree-shaking]] — the payoff for being static.
- [[commonjs-vs-esm-interop]] — the meeting rules.
- [[js-barrel-files]] — how packages shape their public surface in ESM.

## Sources

- [[advanced-js-00-iifes-commonjs-es6-modules]] — syntax, the tree-shaking-via-static argument.
- [[article-js-es6-modules-vs-commonjs]] — live bindings, design-system framing, named vs default trade-offs.
