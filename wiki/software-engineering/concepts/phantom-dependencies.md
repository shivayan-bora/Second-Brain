---
title: "Phantom Dependencies"
pillar: software-engineering
type: concept
tags: [npm, yarn, pnpm, dependency-management, anti-pattern]
status: stable
sources: ["[[pnpm-io-overview]]", "[[mastering-pnpm-workspaces]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Phantom Dependencies

## Definition

A **phantom dependency** is a package your code imports but does not declare in its `package.json`. The import works at runtime because the package "happens to be" in `node_modules` — installed as a transitive dependency of something you actually depend on. The day that transitive dep removes the package, your code breaks for no apparent reason.

## Why it matters

Phantom dependencies are silent failures waiting to happen. They look like normal imports until the underlying dependency tree shifts. They're the single most common dependency-related production bug pattern in npm/Yarn-style projects. pnpm's [[pnpm-content-addressable-store|strict `node_modules`]] layout exists to make them impossible.

## How they happen

### The setup

You install `react-data-table`. It depends on `lodash`. With npm/Yarn's flat hoisted `node_modules`:

```
node_modules/
├── react-data-table/
└── lodash/                  ← hoisted to the top by npm
```

You write:

```ts
import _ from 'lodash';   // works! lodash is in node_modules
```

But `lodash` is *not* in your `package.json`. You never declared it. It happens to be there because `react-data-table` brought it.

### The break

Six months later, `react-data-table` updates and switches to its own implementation; it no longer depends on `lodash`. You upgrade. Now:

```
node_modules/
└── react-data-table/      ← no more lodash
```

Your `import _ from 'lodash'` breaks. Stack trace points at your code, but the bug is in the dep tree. Hours of debugging.

### Why npm/Yarn allow this

npm and Yarn use **[[dependency-hoisting|dependency hoisting]]**: transitive dependencies get lifted to the top of `node_modules` to dedupe. Since Node's module resolution walks up the file tree, your code can `require('lodash')` and Node finds the top-level `node_modules/lodash`. There's no "your package.json says this is yours" check at runtime.

## How pnpm prevents it

pnpm's `node_modules` layout is **strict**: only your declared dependencies appear at the top level. Transitive deps live nested under `.pnpm/` and are inaccessible to direct imports.

```
node_modules/
├── react-data-table -> ../.pnpm/react-data-table@1.0/...
└── .pnpm/
    ├── react-data-table@1.0/
    │   └── node_modules/
    │       ├── react-data-table -> ...
    │       └── lodash -> ../../lodash@4.17/...
    └── lodash@4.17/
        └── node_modules/
            └── lodash/  ← only accessible to packages that declared it
```

`import _ from 'lodash'` from your code? `MODULE_NOT_FOUND`. You're forced to add `lodash` to your `package.json`.

## How to detect them in an existing npm/Yarn project

- **`depcheck`** — finds undeclared used dependencies + declared unused ones.
- **`eslint-plugin-import`** with `import/no-extraneous-dependencies` rule.
- **Switch to pnpm** — installation breaks loudly on phantom deps.

## Trade-offs of strictness

- **Pro:** never get bitten by silent dep-tree changes.
- **Pro:** dependencies are honest — `package.json` reflects reality.
- **Con:** migrating an existing project to pnpm often surfaces 5-30 missing declarations on day one.
- **Con:** some tooling (older Webpack configs, some monorepo plugins) assumes hoisted layout and stumbles on strict.

## Common mitigations during pnpm adoption

- **`pnpm install`** and let errors surface. Fix each missing dep by adding it to the appropriate `package.json`.
- **`shamefully-hoist=true`** in `.npmrc` — temporarily mimic npm's hoisted layout while fixing. Treat as a migration aid, not a permanent setting.
- **`public-hoist-pattern`** — selectively hoist specific patterns (`@types/*`, etc.) for tools that need them at top level.

## Related

- [[pnpm-workspaces]] — pnpm's strict layout context.
- [[pnpm-content-addressable-store]] — the underlying CAS model.
- [[dependency-hoisting]] — what causes phantom deps.

## Sources

- [[pnpm-io-overview]] — explicit definition + npm/Yarn problem framing.
- [[mastering-pnpm-workspaces]] — strict-layout positioning.
