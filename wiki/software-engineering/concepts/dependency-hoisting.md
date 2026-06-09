---
title: "Dependency Hoisting"
pillar: software-engineering
type: concept
tags: [npm, yarn, pnpm, dependency-management, node-modules]
status: stable
sources: ["[[pnpm-io-overview]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Dependency Hoisting

## Definition

**Dependency hoisting** is the npm/Yarn optimization where transitive dependencies are lifted to the top level of `node_modules` to deduplicate them. If multiple packages depend on the same version of `lodash`, the hoisted layout puts `lodash` once at the top, accessible to all consumers via Node's module resolution.

## Why it matters

Hoisting solves a real problem (disk waste from duplicated transitive deps) but creates a worse one ([[phantom-dependencies]]). Understanding the trade-off is the foundation for understanding why pnpm exists and why its [[pnpm-content-addressable-store|strict layout]] is structured the way it is.

## The two layouts

### Without hoisting (theoretical)

```
node_modules/
├── package-a/
│   └── node_modules/
│       └── lodash/      ← copy #1
└── package-b/
    └── node_modules/
        └── lodash/      ← copy #2 (duplicate!)
```

Each package nests its own copy. No phantom deps (you can only import what you declared), but huge disk waste at scale.

### With hoisting (npm/Yarn default)

```
node_modules/
├── package-a/
├── package-b/
└── lodash/              ← lifted to the top, shared
```

One copy. Disk-efficient. But your application code can also `require('lodash')` even though *your* package never declared it — Node finds it at the top of `node_modules`. That's a [[phantom-dependencies|phantom dependency]].

## Why npm/Yarn chose hoisting

- **Disk space.** Before content-addressable stores, copies were the only option, and nesting multiplied them combinatorially.
- **Performance.** Reading one `lodash` from disk is faster than reading N copies, even for the OS's page cache.
- **Compatibility.** Many older tools (older Webpack, some Babel plugins) assume hoisted layouts.

## What hoisting breaks

- **Honest declarations.** Your `package.json` no longer reflects what you actually use.
- **Migration safety.** When a transitive dep changes, code you wrote ages ago can break.
- **Multi-version handling.** When two packages need different versions, hoisting picks one and nests the rest — which gets complex fast.
- **Plug-and-play workspaces.** Linking sibling workspace packages through hoisted `node_modules` becomes brittle.

## How pnpm avoids it

pnpm's layout is **strict**: each package's `node_modules` directory contains *only* what it declared. Transitive deps live nested under `.pnpm/` and are reachable only from inside that nested context.

Disk efficiency is achieved at a different layer — the [[pnpm-content-addressable-store|content-addressable store]] hard-links shared files. So you get the disk benefit *and* honest declarations.

## Mixed approaches

- **`shamefully-hoist=true`** (pnpm `.npmrc`) — emulate hoisting. Use sparingly, usually during migration.
- **`public-hoist-pattern`** — pnpm config for "always hoist these specific packages." Common for `@types/*` packages that some tooling expects at the top level.
- **Yarn PnP** — no `node_modules` at all; the resolver is replaced. Solves phantom deps by going further than pnpm.

## Comparison

| | Layout | Phantom deps? | Disk efficiency |
|---|---|---|---|
| npm | Hoisted | ✓ (problem) | Bad (one copy per project) |
| Yarn classic | Hoisted | ✓ (problem) | Bad |
| Yarn PnP | None — `.pnp.cjs` | ✗ | Good |
| pnpm | Strict + CAS | ✗ | Excellent (one copy globally) |

## Related

- [[phantom-dependencies]] — the failure mode hoisting enables.
- [[pnpm-workspaces]] — the strict-layout alternative.
- [[pnpm-content-addressable-store]] — how pnpm gets the disk-efficiency win another way.

## Sources

- [[pnpm-io-overview]]
