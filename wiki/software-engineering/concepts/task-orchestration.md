---
title: "Task Orchestration (Monorepo Build Systems)"
pillar: software-engineering
type: concept
tags: [monorepo, build-system, nx, turborepo, caching]
status: stable
sources: ["[[nx-dev-00-introduction]]", "[[turborepo-00-understanding-monorepos]]", "[[video-monorepos-fireship]]", "[[video-turborepo-monorepos-explained]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Task Orchestration (Monorepo Build Systems)

## Definition

**Task orchestration** is the layer above a package manager that decides *what* tasks to run, *in what order*, *in parallel where possible*, and *whether the cache already has the answer*. Nx and Turborepo are the dominant JS-ecosystem implementations; both share the same conceptual primitives.

## Why it matters

[[pnpm-workspaces|pnpm workspaces]] (and the npm/yarn equivalents) give you a project structure and dependency dedup. Running `pnpm -r build` blindly builds everything — slow at scale, redundant when most packages haven't changed. Task orchestration adds the missing intelligence: a dependency graph, content-aware caching, and selective execution.

## The shared model

Both Nx and Turborepo agree on the core ideas:

1. **The [[monorepo-package-graph|package graph]]** comes from `pnpm-workspace.yaml` + `package.json` dependencies.
2. **A task graph** layers on top — for each task, declare what other tasks must run first.
3. **Content-addressed caching** — hash the inputs (source + deps + config + env), restore outputs if the hash hits.
4. **Selective execution** — only run tasks for packages affected by a change.
5. **Parallel execution** where the graph permits.
6. **Remote caching** (paid layer in Nx Cloud / Vercel Remote Cache) — share artifacts across machines / CI.

## Task pipeline syntax

### Turborepo (`turbo.json`)

```json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**"]
    },
    "test": {
      "dependsOn": ["build"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

- `^build` = "build all upstream package dependencies first."
- `build` = "before this task, run this package's own build."
- `outputs` declares what to cache.
- `cache: false` skips caching (for dev servers, long-running watchers).
- `persistent: true` declares a non-terminating task (dev server).

### Nx (`nx.json`)

```json
{
  "targetDefaults": {
    "build": {
      "dependsOn": ["^build"]
    }
  }
}
```

Same semantics, different syntax. `^build` means the same thing.

## Caching as the core mechanism

The win is **never rebuild the same code twice**. The cache key is a hash of:

- Source files (the package and, transitively, its inputs).
- Dependencies (`package.json`, lockfile).
- Tool configuration (`tsconfig.json`, `webpack.config.js`, etc.).
- Environment variables that affect the build (declared explicitly).

Same hash on any machine → restore from cache. Different hash → rebuild and add to cache.

This is what makes a 100-package CI pipeline feasible: change one package, the orchestrator runs tasks on that one + its dependents, and pulls 95 other packages' outputs from the [[remote-caching|remote cache]].

## What the orchestration enables

- **Fast CI**: only changed packages and their dependents rebuild/test.
- **Local dev parity**: same task definitions on dev machines and CI; same cache.
- **Per-PR previews**: build the affected app and preview-deploy in seconds.
- **Predictable parallelism**: the graph defines what can run together.
- **Architectural enforcement** (Nx): module-boundary rules layered on the graph.

## Nx vs Turborepo, at a glance

| | Turborepo | Nx |
|---|---|---|
| Core caching + parallel + remote | ✓ | ✓ |
| Config weight | minimal | larger |
| Code generators | ✗ | ✓ |
| Plugin ecosystem | small | large |
| IDE extension | ✗ | ✓ |
| Distributed task execution (Nx Cloud) | ✗ | ✓ (paid) |
| Migration tooling (`migrate latest`) | ✗ | ✓ |
| Language | Rust | Rust + JS |

Both are framework-agnostic-ish (Turborepo even more so) and integrate with pnpm/yarn/npm workspaces.

## When task orchestration earns its keep

- Monorepo with **5+ packages** and growing.
- Build times that bother developers or CI.
- Frequent cross-package changes that require multi-package re-test.
- Multi-machine team (remote caching becomes valuable).
- Speculatively: even small monorepos benefit if you anticipate growth.

## When it doesn't

- Single-app project; no monorepo at all.
- 2-3 packages with fast builds; `pnpm -r build` is fine.
- One-team, low-frequency build, no CI pain.

The video framing: *"Both build a dependency tree between applications and packages, allowing tooling to understand what to test and rebuild on change."* That tree, plus the cache, is the whole game.

## Related

- [[monorepo-package-graph]] — the substrate.
- [[turborepo-pipelines]] — Turborepo's specific config surface.
- [[nx-affected]] — Nx's change-aware execution.
- [[remote-caching]] — the cross-machine payoff.
- [[pnpm-workspaces]] — what task orchestration sits on top of.
- [[monorepo]] (pattern) — the broader pattern this enables.

## Sources

- [[nx-dev-00-introduction]] — Nx's full surface.
- [[turborepo-00-understanding-monorepos]] — Turborepo's task pipeline + caching.
- [[video-monorepos-fireship]] — Nx vs Turborepo comparison.
- [[video-turborepo-monorepos-explained]] — minimal Turborepo intro.
