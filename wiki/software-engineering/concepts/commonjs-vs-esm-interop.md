---
title: "CommonJS ↔ ESM Interop"
pillar: software-engineering
type: concept
tags: [javascript, modules, commonjs, esm, interop, node]
status: stable
sources: ["[[article-js-es6-modules-vs-commonjs]]"]
created: 2026-06-09
updated: 2026-06-09
---

# CommonJS ↔ ESM Interop

## Definition

The rules and sharp edges that come up when [[js-es-modules|ESM]] and [[js-commonjs|CJS]] modules need to talk to each other. The interop is **asymmetric**: ESM-importing-CJS is well-supported with a small quirk; CJS-requiring-ESM is awkward and usually requires build-time help.

## Why it matters

Most npm packages still ship CJS — sometimes only CJS, sometimes a dual build. A new project written in ESM will hit interop on day one. Getting the rules wrong shows up as cryptic errors like `ERR_REQUIRE_ESM`, "default is not a function", or "module has no default export."

## The signals you're in interop territory

- `package.json` has `"type": "module"` and `require()` errors fire.
- A library mixes `.cjs` and `.mjs` files.
- A bundler config says "externals" or "noExternal" for one specific package.
- TypeScript compiler errors about `esModuleInterop` and `allowSyntheticDefaultImports`.

## The rules

### ESM importing CJS

Node and bundlers expose `module.exports` as the **default** export:

```js
// math.cjs
module.exports = { PI: 3.14 };

// consumer.mjs
import math from "./math.cjs";
console.log(math.PI);          // 3.14
```

Named-import shape sometimes works (`import { PI } from "./math.cjs"`) depending on the runtime's static-analysis heuristics — but defaulting to the namespace-default form is the safest bet.

### CJS requiring ESM

Synchronous `require()` of an ESM file fails by design — ESM evaluation is asynchronous. The workarounds:

- **`await import("./esm-only-pkg")`** inside an async function — but only if the CJS host can use top-level await (Node ≥ 14 with conditions) or runs inside an async context.
- **Dual builds.** Ship both `.cjs` and `.mjs` for your package and resolve via `package.json` `"exports"`:

```json
"exports": {
  ".": {
    "import": "./dist/index.mjs",
    "require": "./dist/index.cjs"
  }
}
```

## File-extension and config knobs

- `.cjs` → always CJS, regardless of `"type"`.
- `.mjs` → always ESM, regardless of `"type"`.
- `.js` → depends on the nearest `package.json` `"type"` (default: `"commonjs"`).
- `"type": "module"` flips `.js` to ESM for that package subtree.

## File extensions in `import` paths

ESM requires the explicit file extension in import paths (`import x from "./mod.js"`), even in TypeScript. CJS infers it. This is one of the most common pain points in migration: TypeScript projects with `module: "NodeNext"` or `"Node16"` enforce the `.js` extension in `.ts` source files.

## Open questions / pitfalls

- Some legacy CJS packages mutate `module.exports` after the export statement; ESM importers see only the *initial* assignment. Caching, decorators, and lazy bindings are common culprits.
- Vite, esbuild, and Rollup all handle interop slightly differently. A library that works in Vite may break in a Webpack consumer.

## Related

- [[js-commonjs]]
- [[js-es-modules]]
- [[js-modules-history]] — why this awkward middle period exists.

## Sources

- [[article-js-es6-modules-vs-commonjs]] — covers `import math from "./math.cjs"` shape and the dual-build pattern.
