---
title: "Remote Caching"
pillar: software-engineering
type: concept
tags: [monorepo, ci-cd, build-system, caching]
status: stable
sources: ["[[turborepo-00-understanding-monorepos]]", "[[nx-dev-00-introduction]]", "[[video-monorepos-fireship]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Remote Caching

## Definition

**Remote caching** is the practice of storing build outputs (the artifacts produced by [[task-orchestration|task orchestrators]] like Turborepo and Nx) on a shared HTTP backend so they can be restored by other machines — typically teammates' dev machines, CI runners, and preview-deploy workers. Same content-hash on any machine → skip the work, download the result.

## Why it matters

Local caching (per-machine `.turbo/cache/`) makes *your* second build fast. Remote caching makes your *first* build fast — because someone (a teammate, the main branch CI) has already built it, and you download instead of rebuild. At team and CI scale, this is the single highest-leverage performance multiplier in a monorepo.

## How it works

1. **Build a package locally**. The orchestrator hashes inputs (source, deps, config, env vars) → a content-addressed key.
2. **Outputs are uploaded** to a remote cache backend, keyed by that hash.
3. **Another machine builds the same package** with the same inputs → same hash.
4. **Cache hit**: download the prebuilt outputs. Skip the work entirely.

The hash is deterministic, so different machines (assuming the same OS / Node version / inputs) get the same key.

## The two cache layers

| Layer | Location | Scope |
|---|---|---|
| **Local cache** | `.turbo/cache/` or `.nx/cache/` | Your machine, your branch, your builds |
| **Remote cache** | HTTP backend (Vercel, Nx Cloud, self-hosted) | All machines configured to use it |

When a build runs:

1. Check local cache → hit, restore, done.
2. Miss → check remote cache → hit, download + populate local, done.
3. Miss → run the task, upload outputs to remote + local cache.

## Backends

### Turborepo

- **Vercel Remote Cache** — automatic if you deploy to Vercel.
- **Self-hosted** — `TURBO_API` env var pointing to your own implementation (e.g., a Cloudflare R2 backend).
- Configured via `~/.turbo/config.json` or env vars (`TURBO_TOKEN`, `TURBO_TEAM`).

### Nx Cloud

- Paid service from Nx team.
- Adds **distributed task execution** on top (split a build across multiple CI machines).
- Configured via `nx.json` + `nx-cloud.env` / env vars.
- Self-hosted option for enterprise.

## What gets cached

- **Build outputs**: declared via `outputs` in `turbo.json` or inferred by Nx plugins from tool configs.
- **Test results**: pass/fail + log output. Pulling a cached "pass" lets CI report green without re-running.
- **Lint results**: similar.

What's typically *not* cached: `dev` servers (long-running, no defined output), one-shot scripts marked `cache: false`.

## Signals you're (or are NOT) using remote caching

Per [[turborepo-00-understanding-monorepos]], the absence signals:

- No `.vercel` directory in the repo root (`turbo link` would create one).
- No `~/.turbo` directory in the home folder (`turbo login` writes an auth token there).
- No `TURBO_TOKEN` / `TURBO_TEAM` environment variables set.

When `turbo run build` starts in this state, it prints "Remote caching disabled" and falls back to local-only.

## When remote caching pays off

- **Team of 3+ developers** working on the same monorepo. Each saves the rebuild time across machines.
- **CI runs multiple times per day** on the same branch base. PR build pulls from main's cache.
- **Multiple CI workers** in parallel. Workers share results via the remote cache.
- **Preview deploys per PR**. Avoid rebuilding common chunks per PR.

## When it doesn't

- **Solo dev**, single CI runner. Local caching is enough.
- **Small monorepo**, fast builds. The download might be slower than rebuilding.
- **Privacy-sensitive builds** where you can't use a third-party backend. Self-host or skip.

## Pitfalls

- **Cache key collisions across OSes.** A build artifact on macOS isn't always interchangeable with one on Linux. Some teams scope caches per-OS.
- **Environment variables not declared as inputs.** If your build depends on `API_KEY` but `turbo.json` doesn't mention it, two machines with different keys share a cache entry → silent prod bug.
- **Cache poisoning.** A bad build uploaded by a misconfigured machine, served to everyone afterwards. Mitigation: sign + verify cache entries (some backends), or use branch-scoped caches.
- **Network costs.** Large monorepos can have multi-GB caches; remote downloads aren't free.

## Related

- [[task-orchestration]] — what remote caching plugs into.
- [[turborepo-pipelines]] — Turborepo-specific config.
- [[nx-affected]] — pairs naturally with remote caching for "skip the unchanged."
- [[monorepo-package-graph]] — the graph that defines what's cacheable.

## Sources

- [[turborepo-00-understanding-monorepos]] — local + remote layers, hashing, Vercel integration, "no `.vercel`/`~/.turbo`/env vars" signals.
- [[nx-dev-00-introduction]] — Nx Cloud's remote-caching offering.
- [[video-monorepos-fireship]] — explicit "huge time savings" framing.
