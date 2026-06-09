---
title: "pnpm Workspaces"
pillar: software-engineering
type: concept
tags: [pnpm, monorepo, workspaces, package-management]
status: stable
sources: ["[[mastering-pnpm-workspaces]]", "[[pnpm-io-overview]]", "[[video-monorepos-fireship]]"]
created: 2026-06-09
updated: 2026-06-09
---

# pnpm Workspaces

## Definition

**pnpm workspaces** is pnpm's built-in monorepo support. A `pnpm-workspace.yaml` file at the repository root declares which directories are workspace packages. pnpm then resolves intra-monorepo dependencies via symlinks (the [[workspace-protocol|`workspace:` protocol]]) and operates on the whole tree via recursive flags (`-r`).

## Why it matters

pnpm workspaces is the simplest viable monorepo backbone for most JS/TS projects. It handles dependency dedup, the [[pnpm-content-addressable-store|CAS-based]] disk efficiency, [[phantom-dependencies|phantom-dependency]] prevention, and intra-monorepo dep linking — all in the package manager. For many teams it's enough on its own; for larger teams, it pairs with [[turborepo-pipelines|Turborepo]] or [[task-orchestration|Nx]] for task orchestration on top.

## Mechanics

### `pnpm-workspace.yaml`

```yaml
packages:
  - "apps/*"
  - "packages/*"
  - "tools/*"
```

Each glob matches workspace package directories. Order doesn't matter for resolution.

### Canonical layout

```
my-workspace/
├── apps/                    # Deployable applications
│   ├── web/                 # Next.js / React app
│   └── api/                 # Node.js backend
├── packages/                # Shared libraries
│   ├── ui/                  # Design system
│   ├── utils/               # Utility functions
│   └── api-client/          # Generated API client
├── tools/                   # Shared config packages
│   └── eslint-config/
├── package.json             # Root: only orchestration scripts + dev deps
├── pnpm-workspace.yaml
└── pnpm-lock.yaml
```

### Intra-monorepo dependency — `workspace:*`

```json
// apps/web/package.json
{
  "dependencies": {
    "@workspace/ui": "workspace:*"
  }
}
```

`workspace:*` tells pnpm "the local in-monorepo version, please" — symlinked to the package, not downloaded from the registry. See [[workspace-protocol]].

### Recursive operations — `-r`

```bash
pnpm -r build              # build in every workspace
pnpm -r --parallel dev     # dev in all, concurrently
pnpm -r test
pnpm -r lint
```

### Filtering

```bash
pnpm --filter @workspace/ui build      # one package
pnpm --filter "./apps/*" build          # all apps
pnpm --filter "...@workspace/ui" build  # ui and everything that depends on it
```

The `--filter` syntax is the workhorse for "do this to a subset" — running tests on the changed package plus its dependents, deploying one app's chain, etc.

### Adding a workspace dependency

```bash
pnpm add @workspace/ui --filter @app/web
```

Adds `"@workspace/ui": "workspace:*"` to `apps/web/package.json`.

## What you get out of the box

- **Dependency dedup** across workspaces.
- **CAS-based disk efficiency** ([[pnpm-content-addressable-store]]).
- **Strict node_modules** preventing [[phantom-dependencies]].
- **`workspace:*` resolution** without registry roundtrip.
- **Recursive + filtered scripts** for orchestration.
- **Diff-friendly YAML lockfile** (`pnpm-lock.yaml`).

## What you don't get (and may need extra tools for)

- **Task caching** — pnpm runs the script every time. Use [[turborepo-pipelines|Turborepo]] or [[task-orchestration|Nx]] for content-addressed task caching.
- **Affected-only execution** — `pnpm -r build` builds *everything*. Use [[nx-affected|`nx affected`]] or `turbo --filter` for change-aware execution.
- **Project graph visualization** — not built-in. Both Turborepo and Nx provide it.
- **Code generation / scaffolding** — Nx ships generators; pnpm doesn't.

## When pnpm workspaces alone is enough

- Small-to-medium monorepo (≤10 packages).
- Build times manageable without caching.
- Team comfortable with `package.json` scripts as orchestration.

## When to layer Turborepo/Nx on top

- Build times warrant content-addressed caching.
- You want CI to skip unchanged packages.
- You want remote caching across team / CI machines.
- You're scaling toward many packages and need a project graph.

## Related

- [[pnpm-content-addressable-store]] — what makes pnpm fast.
- [[phantom-dependencies]] — what pnpm's strict layout prevents.
- [[dependency-hoisting]] — npm/Yarn's anti-pattern, pnpm avoids.
- [[workspace-protocol]] — the `workspace:*` mechanism.
- [[task-orchestration]] — pair with Turborepo / Nx for caching.
- [[monorepo-package-graph]] — what build orchestrators derive from workspaces.

## Sources

- [[mastering-pnpm-workspaces]] — workspace setup, layout, `workspace:*`, filtering.
- [[pnpm-io-overview]] — pnpm's "why" and structural advantages.
- [[video-monorepos-fireship]] — positioning in the broader monorepo-tool landscape.
