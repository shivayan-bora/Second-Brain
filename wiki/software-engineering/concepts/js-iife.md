---
title: "Immediately-Invoked Function Expression (IIFE)"
pillar: software-engineering
type: concept
tags: [javascript, modules, history, scope]
status: stable
sources: ["[[advanced-js-00-iifes-commonjs-es6-modules]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Immediately-Invoked Function Expression (IIFE)

## Definition

An IIFE is a function expression that is invoked the moment it's defined. Wrapping module-style code in an IIFE gives that code its own private scope without polluting the global namespace — which, before ES modules existed, was the canonical way to write "modules" in browser JS.

## Why it matters

The IIFE is the bridge between the bad old days (globals shared across script tags) and proper module systems. Recognizing the pattern in legacy code is important — it's all over jQuery-era libraries, and the shape (`(function () { ... })();`) still shows up in compiled output and module-bundler runtimes.

## Mechanics

```js
// users.js
(function () {
  var users = ["Tyler", "Sarah", "Dan"];

  function getUsers() {
    return users;
  }

  APP.getUsers = getUsers;   // attach to a shared namespace object
})();
```

- The outer `()` turns the function declaration into a **function expression** (parser-disambiguation trick).
- The trailing `()` invokes it immediately.
- Everything inside is local — `users` and `getUsers` are inaccessible from outside.
- The IIFE attaches its public surface (`getUsers`) to a global namespace object (`APP`) that all modules share.

## What it solved, what it didn't

**Solved:**
- Variable collisions between scripts.
- "Important" code (e.g., `users` array) being modifiable by other scripts.

**Did not solve:**
- The `APP` namespace itself is still global — another library claiming the same name still breaks.
- `<script>` tag **ordering** still matters: `app.js` must load before `users.js`, which must load before `dom.js`. The browser doesn't know the dependency graph.

These remaining pains are what [[js-commonjs|CommonJS]] (and later [[js-es-modules|ES modules]]) were designed to fix.

## Examples

The fireship example builds up from globals → namespace + wrapper functions → IIFE in three steps; the IIFE is the third step. See `raw/courses/fireship.dev/Advanced JavaScript/00_From IIFEs to CommonJS to ES6 Modules.md` for the full progression.

## Related

- [[js-modules-history]] — situates the IIFE in the broader arc.
- [[js-commonjs]] — the successor that solved script ordering.

## Sources

- [[advanced-js-00-iifes-commonjs-es6-modules]]
