---
title: "Tree-Shaking"
pillar: software-engineering
type: concept
tags: [javascript, bundlers, optimization, esm, dead-code-elimination]
status: stable
sources: ["[[advanced-js-00-iifes-commonjs-es6-modules]]", "[[article-js-es6-modules-vs-commonjs]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Tree-Shaking

## Definition

Tree-shaking is the build-time elimination of unused exports from the final bundle. It works by statically walking the [[js-es-modules|ESM]] import graph from the entry point, marking which named exports are reached, and stripping the rest.

## Why it matters

The whole point of shipping a design-system or utility library as ESM is so consumers only pay for what they actually use. A consumer that imports `{ Button }` from a 100-component library should download bytes for `Button` and nothing else — that promise is only deliverable when tree-shaking works.

## Mechanics

1. **The bundler parses the entry point** and follows every `import`.
2. Because [[js-es-modules|ESM]] imports are static and top-level, the bundler can build a complete graph at build time without running the code.
3. Exports not reachable from the entry point are marked dead.
4. The bundler emits only the reachable code.

## What breaks tree-shaking

- **Side effects.** If a module mutates state at top level (DOM, prototype monkey-patching, registry registration), the bundler has to keep it even if no named export is used — because removing it would change runtime behavior.
- **[[js-commonjs|CommonJS]] in the graph.** `require()` is dynamic, so its outputs may resist static analysis. Mixed-system codebases tree-shake poorly.
- **Dynamic property access on namespace imports.** `import * as m from "./mod"; m[name]()` defeats reachability tracking.

## How to make a package tree-shakeable

```json
// package.json
{
  "name": "@acme/ui",
  "type": "module",
  "sideEffects": false   // or list the safe files: ["./src/polyfill.ts"]
}
```

- `"sideEffects": false` tells the bundler: "every module in this package is pure — feel free to drop any unused export."
- Pair with [[js-barrel-files|barrel files]] that re-export from siblings rather than executing code.
- Avoid top-level mutation. Wrap any side effect (analytics init, DOM mutation) in a function the consumer calls explicitly.

## Examples

```js
// utils/index.js
export { first } from "./first.js";
export { last }  from "./last.js";
export { map }   from "./map.js";

// consumer
import { first } from "@acme/utils";
// bundler drops last and map from the output
```

If `first.js` happened to do `document.body.dataset.firstLoaded = "true"` at top level, the bundler would have to keep it loaded even though no `first` call uses that side effect.

## Related

- [[js-es-modules]] — the statics that make tree-shaking possible.
- [[js-commonjs]] — what defeats it.
- [[js-barrel-files]] — the re-export pattern that needs side-effect discipline.
- [[js-dynamic-imports]] — combines with tree-shaking for code splitting.

## Sources

- [[advanced-js-00-iifes-commonjs-es6-modules]] — explains *why* the static constraint exists.
- [[article-js-es6-modules-vs-commonjs]] — the `"sideEffects": false` recipe in a design-system context.
