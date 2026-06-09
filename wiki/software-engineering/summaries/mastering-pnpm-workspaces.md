---
title: "Article — Mastering pnpm Workspaces"
pillar: software-engineering
type: summary
tags: [article, pnpm, monorepo, workspaces, package-management]
status: stable
source: "raw/articles/Mastering pnpm Workspaces.md"
created: 2026-06-09
updated: 2026-06-09
---

# Article — Mastering pnpm Workspaces

Long-form guide to building a monorepo with pnpm workspaces — directory layout, `pnpm-workspace.yaml`, the `workspace:*` protocol, the `-r`/`--filter` recursive flags, and the package-publishing story. Anchor source for [[pnpm-workspaces]] and [[workspace-protocol]] concepts.

## TL;DR

- **pnpm workspaces is a monorepo solution built into pnpm.** No additional tool needed for workspace management. See [[pnpm-workspaces]].
- **Canonical layout**: `apps/*` for deployables, `packages/*` for shared libraries, `tools/*` for shared configs (eslint, tsconfig, prettier presets).
- **The `workspace:*` protocol** in `dependencies` resolves to the in-monorepo package rather than the npm registry — atomic refactors stay atomic. See [[workspace-protocol]].
- **Recursive scripts**: `pnpm -r build` runs `build` in every workspace; `pnpm -r --parallel dev` runs them concurrently.
- **The big four pnpm advantages over npm/yarn**: disk efficiency (one copy of each version system-wide), fast install (hard-links not copies), [[phantom-dependencies|phantom-dependency]] prevention (strict node_modules layout), built-in workspace support.

## Key takeaways

- **`workspace:*` is the killer feature** of pnpm workspaces. It tells pnpm: "this is an in-monorepo dep; ignore the npm registry; use the local copy via a symlink." Compared to file-path imports, it preserves package semantics (publishable, versionable) while staying local.
- **`peerDependencies` for library packages** — for `@workspace/ui-components` consuming `react`, mark React as `peer`, not `dependency`, so consumer apps don't get duplicate React instances.
- **Build per package**: each library has its own `tsup`/`tsc` build emitting CJS + ESM + `.d.ts`. Workspaces share `tsconfig` via `extends: "../../tsconfig.json"`.
- **Filter syntax**: `pnpm --filter "@workspace/ui-components" build` runs `build` in one package only. Combine with `--filter "./apps/*"` for app-only operations.

## Notable passages

> "Unlike npm or Yarn, pnpm uses a unique content-addressable store that creates hard-links to shared dependencies, dramatically reducing disk usage and installation time."

> "Prevents phantom dependencies and version conflicts."

## Open questions

- The article briefly mentions versioning + publishing but doesn't go deep — what's the recommended cut between `changesets`, `release-please`, and Lerna for pnpm workspaces?
- For multi-team monorepos, where's the line where pnpm-only stops being enough and you need Turborepo/Nx layered on top for [[task-orchestration]]?
- The article suggests `peerDependencies` for shared React libraries — how does this interact with strict pnpm `node_modules` and React 19's strict-mode hooks?

## Cross-references

- Companion: [[pnpm-io-overview]] (the docs), [[monorepos-for-developers]] (the why), [[turborepo-00-understanding-monorepos]] (the orchestration layer).
- Concepts: [[pnpm-workspaces]], [[pnpm-content-addressable-store]], [[phantom-dependencies]], [[dependency-hoisting]], [[workspace-protocol]].

## Source

- `raw/articles/Mastering pnpm Workspaces.md`
