---
title: "Monorepo Package Graph"
pillar: software-engineering
type: concept
tags: [monorepo, dependency-graph, build-system, topological-sort]
status: stable
sources: ["[[nx-dev-00-introduction]]", "[[turborepo-00-understanding-monorepos]]", "[[video-monorepos-fireship]]", "[[pnpm-io-overview]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Monorepo Package Graph

## Definition

The **package graph** of a monorepo is a directed acyclic graph (DAG) where nodes are workspace packages and edges represent "depends on" relationships from `package.json` dependencies. Build orchestrators (Turborepo, Nx) derive this graph from [[workspace-protocol|`workspace:*`]] declarations and use it to schedule tasks in topological order and determine the "affected" set on change.

## Why it matters

Almost every monorepo-tool feature — task pipelines, affected detection, parallel execution, module-boundary enforcement, dependency-of-dependency invalidation — is just a property of this graph. Understanding the graph is the first step to understanding why a particular build does what it does.

## How the graph is built

### Inputs

- **Workspace declaration**: `pnpm-workspace.yaml` (or `workspaces` field in npm/Yarn root `package.json`) tells the tool which directories are nodes.
- **Per-package `package.json`**: `dependencies` and `devDependencies` (and `peerDependencies`, sometimes) supply the edges — but only for entries that resolve to another workspace package (via [[workspace-protocol]] or matching name).

### Example

```
@workspace/ui      → depends on → @workspace/utils
@workspace/web     → depends on → @workspace/ui, @workspace/utils
@workspace/api     → depends on → @workspace/utils
```

The graph:

```
       utils
      /     \
     v       v
    ui      api
    |
    v
   web
```

Building `web` requires `ui` and `utils` to be built first. Building `api` is independent of `ui`.

## What the graph enables

### Topological build order

When you run `turbo run build` (or `nx run-many -t build`):

1. The tool sorts the graph topologically.
2. Leaves (packages with no workspace deps) build first.
3. Each node waits until its dependencies have completed.
4. Parallel where the graph allows.

### Affected detection

Given a changed file in `packages/utils/`, walk *upward* through the graph:

- `utils` changed.
- `ui` depends on `utils` → `ui` is affected.
- `web` depends on `ui` and `utils` → affected.
- `api` depends on `utils` → affected.

→ Run tasks only on `utils`, `ui`, `web`, `api`. Skip everything else.

This is the heart of [[nx-affected]] and Turborepo's `--filter` flag.

### Module-boundary enforcement

Some tools (Nx with `enforce-module-boundaries`) let you declare *allowed* graph edges:

- `apps/*` can depend on `packages/*`, never the reverse.
- `packages/ui` cannot depend on `packages/api-client`.
- `tools/*` is allowed everywhere.

These rules execute as lint errors on disallowed `import`s. Prevents architectural erosion.

## `dependsOn` — task graph vs package graph

Two related but distinct graphs:

- **Package graph** — `@app/web → @workspace/ui` based on `package.json` deps.
- **Task graph** — `build@web → build@ui` (or whatever task) based on `turbo.json` / Nx `dependsOn` config.

In `turbo.json`:

```json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"]   // before this build, build upstream packages first
    }
  }
}
```

`^` = "tasks of the same name on this package's dependencies." This is how task ordering follows package topology.

## Visualizing

- **Nx**: `nx graph` opens an interactive browser view.
- **Turborepo**: `turbo run build --graph` generates a Graphviz/Mermaid output.

For codebases over ~10 packages, looking at this graph monthly is worth the time. Surprising edges (circular dependencies, an `api` package importing UI) surface immediately.

## Pitfalls

- **Circular dependencies.** Most monorepo tools error fast on these; some (older Lerna) silently misbuild. Always fail builds on cycles.
- **Hidden runtime dependencies.** If `app/web` reads from `packages/api`'s output without declaring a dep, the graph misses the edge — and affected detection misses the change. Always declare workspace deps explicitly.
- **Cross-pillar edges.** A `tools/eslint-config` that `app/web` extends but doesn't `dependencies`-declare → graph misses it. Use `devDependencies: { "@workspace/eslint-config": "workspace:*" }` to make it visible.

## Related

- [[pnpm-workspaces]] — where the graph nodes come from.
- [[workspace-protocol]] — how edges are declared.
- [[nx-affected]] — graph-walking for change detection.
- [[turborepo-pipelines]] — task graph layered on top.
- [[task-orchestration]] — what the graph enables.
- [[monorepo]] (pattern) — the broader pattern this graph underpins.

## Sources

- [[nx-dev-00-introduction]] — project graph + dependsOn.
- [[turborepo-00-understanding-monorepos]] — turbo.json `dependsOn: ["^build"]`.
- [[video-monorepos-fireship]] — "both create a dependency tree."
- [[pnpm-io-overview]] — workspace package linking.
