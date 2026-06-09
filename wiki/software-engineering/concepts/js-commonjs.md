---
title: "CommonJS (CJS)"
pillar: software-engineering
type: concept
tags: [javascript, modules, commonjs, node]
status: stable
sources: ["[[advanced-js-00-iifes-commonjs-es6-modules]]", "[[article-js-es6-modules-vs-commonjs]]"]
created: 2026-06-09
updated: 2026-06-09
---

# CommonJS (CJS)

## Definition

CommonJS is the module system Node.js shipped with: each file is its own scope, exports are attached to `module.exports`, and dependencies are pulled in synchronously with `require()`. It pre-dates ES modules by years and remains the most common shape in the npm ecosystem.

## Why it matters

Even in 2026, the average npm package still ships at least a CJS build for compatibility. Most "weird" tooling fields in `package.json` (`"main"`, `"exports"`, `"type"`) exist to mediate between CJS and [[js-es-modules|ESM]]. Knowing CJS's loading model is what lets you read [[commonjs-vs-esm-interop|interop bugs]].

## Mechanics

```js
// math.js
const PI = 3.14;

function area(radius) {
  return PI * radius * radius;
}

module.exports = { PI, area };
```

```js
// consumer.js
const { PI, area } = require("./math");
```

- `require()` is **synchronous** — it blocks until the dependency is loaded and executed.
- The dependency graph is **dynamic**: `require()` is just a function, so you can put it inside an `if`, a loop, or a function body.
- `module.exports` is a mutable object. The exporter can replace or mutate it at any point during module execution.

## What this enables — and what it costs

**Enabled:**
- Conditional loading: `if (devMode) require("./dev-tools")`.
- Simple mental model: it's just a function call.

**Costs:**
- **Browser-hostile.** Synchronous network fetches per `require()` would freeze the UI. CJS for browsers requires a [[module-bundlers|bundler]].
- **Hostile to static analysis.** Because `require()` is just a function, bundlers can't always know what gets loaded — which hobbles [[tree-shaking]].
- **No live bindings.** What you `require()` is the value of `module.exports` at the moment of import. Subsequent mutations by the exporter are invisible.

## Examples

```js
// conditional require — legal in CJS, illegal in ESM
if (process.env.NODE_ENV === "development") {
  const { installDevTools } = require("./dev-tools");
  installDevTools();
}
```

The ESM equivalent must use the function form [[js-dynamic-imports|`import()`]] instead.

## Related

- [[js-es-modules]] — the standardized successor.
- [[commonjs-vs-esm-interop]] — the cross-system rules.
- [[tree-shaking]] — what CJS makes hard.
- [[js-modules-history]] — where CJS sits in the arc.

## Sources

- [[advanced-js-00-iifes-commonjs-es6-modules]] — covers syntax and the browser-incompatibility problem that motivated bundlers.
- [[article-js-es6-modules-vs-commonjs]] — comparison with ESM, interop rules.
