---
title: "Barrel Files"
pillar: software-engineering
type: concept
tags: [javascript, modules, package-design, design-systems]
status: stable
sources: ["[[article-js-es6-modules-vs-commonjs]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Barrel Files

## Definition

A barrel is a module — conventionally `index.ts` / `index.js` — that re-exports symbols from sibling modules. The barrel gives consumers a single, stable import path while letting the package author refactor the internal file structure freely.

## Why it matters

For a design-system library, the barrel **is** the public API. What you re-export, you're committing to. What you don't, you can rearrange. Combined with `package.json` `"exports"`, barrels let you choose whether to expose deep paths (`@acme/ui/button`) or force everything through the root (`@acme/ui`).

## Mechanics

```
src/
  button/
    Button.tsx
    IconButton.tsx
    index.ts          ← component-level barrel
  input/
    TextField.tsx
    PasswordField.tsx
    index.ts
  index.ts            ← root barrel
```

```ts
// src/button/index.ts
export { Button }     from "./Button";
export { IconButton } from "./IconButton";
export type { ButtonProps } from "./Button";
```

```ts
// src/index.ts
export * from "./button";
export * from "./input";
export * from "./theme";
```

Consumer:

```ts
import { Button, TextField, lightTheme } from "@acme/ui";
```

## The trade-offs

**Pro:**
- One canonical import path; consumers don't learn your file tree.
- Refactor-friendly: moving `Button.tsx` requires only an `index.ts` edit.
- Plays well with [[tree-shaking]] **if** modules stay side-effect-free.

**Con:**
- Naïve barrels (`export *`) can hurt dev-server cold-start times because each `import { Button }` resolution still has to parse every re-export to know what `Button` is.
- Easy to leak internals if you barrel-export aggressively.
- In some bundler/CJS configs, deep barrel chains defeat tree-shaking. Always verify the production bundle.

## Pairing with `package.json` `"exports"`

```json
{
  "exports": {
    ".":        "./dist/index.js",
    "./button": "./dist/button/index.js",
    "./input":  "./dist/input/index.js"
  }
}
```

The `"exports"` field acts as an allow-list: consumers can only reach the paths you list. Useful for an internal design system where you want the deep paths *available* but the root barrel preferred.

## Examples

A typical design-system layout: per-component folders with their own barrel, a root barrel that re-exports everything, and `"exports"` exposing both root and deep paths.

## Related

- [[js-es-modules]] — barrels are an ESM-shaped pattern (you can do them in CJS but you lose tree-shakeability).
- [[tree-shaking]] — barrels work cleanly only when source modules have no top-level side effects.

## Sources

- [[article-js-es6-modules-vs-commonjs]] — full barrel layout for a design system.
