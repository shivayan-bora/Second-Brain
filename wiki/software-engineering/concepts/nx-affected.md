---
title: "Nx Affected"
pillar: software-engineering
type: concept
tags: [nx, monorepo, ci, task-orchestration]
status: stable
sources: ["[[nx-dev-00-introduction]]", "[[video-monorepo-12-months-opinions]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Nx Affected

## Definition

**`nx affected`** is Nx's command for running tasks only on the packages affected by a given change. It walks the [[monorepo-package-graph|package graph]] from the changed files upward (to all consumers, transitively) and executes the target task on that subset.

```bash
nx affected -t test          # test only the affected packages
nx affected -t build lint    # build + lint affected
```

Turborepo's equivalent is `turbo run build --filter='[main..HEAD]'`.

## Why it matters

In a 50-package monorepo, running all tests on every PR is wasteful — 95% of the work re-checks code that didn't change. `nx affected` is *the* mechanism that makes monorepo CI fast. It's the single most-referenced feature when teams talk about why they adopted Nx.

## How it determines "affected"

1. **Compute the diff** between two git refs (default: `--base=main --head=HEAD`).
2. **Map changed files to workspace packages** — which packages contain at least one changed file?
3. **Walk the [[monorepo-package-graph|package graph]] upward** from each changed package — every consumer (and consumer's consumer) is also affected.
4. **Run the target task** on the resulting set.

```
Changed: packages/utils/src/format.ts
       │
       └──> packages/utils (directly affected)
              │
              ├──> packages/ui (depends on utils) → affected
              └──> apps/api (depends on utils)   → affected
                     │
                     └──> packages/api-client doesn't depend on utils → NOT affected
```

`nx affected -t test` runs tests on `utils`, `ui`, `api` — and skips `api-client`.

## Configuration knobs

### Base/head

```bash
nx affected -t test --base=origin/main --head=HEAD
```

- `--base` is the comparison point. For PR CI: typically `origin/main`.
- `--head` is what you're comparing. For PR CI: typically `HEAD`.
- On main branch CI: `--base=HEAD~1` (compare to the previous commit).

### `nx.json` `affected` configuration

```json
{
  "affected": {
    "defaultBase": "main"
  }
}
```

Sets the default comparison base so you don't need `--base` on every call.

### Implicit dependencies

Sometimes a change affects packages that aren't in the package graph (e.g., a global config file change). `nx.json`'s `implicitDependencies` declares these:

```json
{
  "implicitDependencies": {
    "tsconfig.base.json": "*",
    "package.json": "*"
  }
}
```

`tsconfig.base.json` changed → every project is affected.

## In CI

```yaml
# GitHub Actions
- run: npx nx affected -t lint test build --base=origin/main
```

The PR CI runs lint/test/build only on affected projects, dramatically reducing CI time on large monorepos.

## Combine with remote caching

`nx affected` + [[remote-caching]] is the killer combo: only affected packages re-run, and if any of them have an exact hash hit in the remote cache (from a teammate or earlier CI run), they don't actually rebuild — just download. Result: PRs that touch one package complete CI in seconds.

## Common pitfalls

- **`base` set wrong on main-branch CI.** If `--base=HEAD~1` isn't set on main pushes, affected can default wrong and either re-test everything or nothing.
- **Forgetting implicit dependencies.** A change to `eslint.config.js` doesn't "affect" anything per the graph, so affected misses lint runs. Add to `implicitDependencies`.
- **Long-running PRs with stale base.** If `main` has moved since branching and the PR's base isn't refreshed, affected calculation could be wrong. Pull main into the PR periodically.
- **Manual file moves.** Renaming a file from `packages/utils/src/a.ts` to `packages/utils/src/b.ts` registers as a change in `utils` — fine. But moving across packages can confuse affected detection until the move is committed.

## Turborepo equivalent — `--filter`

```bash
turbo run build --filter='...[origin/main]'   # build everything affected since main
```

Same idea, different syntax. Turborepo's filter language is broader (filter by name, path, git ref) but the affected-by-git-diff use case is the most-used variant.

## Per [[video-monorepo-12-months-opinions]]

> *"Developers familiar with monorepo tooling — especially `affected triggers`."*

The video flags `affected` familiarity as a soft prerequisite for monorepo success — without it, devs over-run CI and over-rebuild locally.

## Related

- [[task-orchestration]] — the umbrella concept.
- [[monorepo-package-graph]] — what affected walks.
- [[remote-caching]] — pairs naturally; affected scopes the work, cache eliminates the work that remains.
- [[turborepo-pipelines]] — Turborepo's `--filter` equivalent.

## Sources

- [[nx-dev-00-introduction]] — `nx affected -t test` command surface.
- [[video-monorepo-12-months-opinions]] — `affected triggers` as a developer-familiarity prerequisite.
