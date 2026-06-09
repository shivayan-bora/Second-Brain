---
title: "Turborepo ch00 — Understanding Monorepos"
pillar: software-engineering
type: summary
tags: [documentation, chapter, turborepo, monorepo, task-orchestration]
status: stable
source: "raw/documentation/turborepo/00_Understanding Monorepos.md"
course: "Turborepo documentation"
created: 2026-06-09
updated: 2026-06-09
---

# Turborepo ch00 — Understanding Monorepos

Turborepo's opening chapter. Pitches the [[monorepo|monorepo pattern]] in concrete terms (coordination tax, atomic changes, version dependency chaos), then walks through a starter project layout: pnpm workspaces + `turbo.json` + `turbo run <task>` orchestration. Introduces the core Turborepo concepts: **content-addressed cache hashing**, **`dependsOn`** task pipelines, **local + remote caching**.

## TL;DR

- **Monorepos solve the coordination tax** of polyrepo — synchronizing changes, syncing dependencies, copying configs across repos. The TypeScript compiler catches breaking changes *instantly* across a monorepo; in polyrepos you find out at runtime in another service.
- **Choose monorepo when** apps share code, you make frequent cross-project changes, you want atomic commits across boundaries, or consistent tooling matters.
- **Choose polyrepo when** projects are truly independent, different tech stacks can't share tooling, strict access control matters, or teams have zero coordination need.
- **Rule of thumb**: if your projects share more than just configs, monorepo likely fits. **Start with a monorepo** — splitting later is painful but possible; merging multiple repos with git history is much harder.
- **The pattern: root orchestrates, apps implement.** Root `package.json` defines `"build": "turbo run build"`; each app's `package.json` defines its own `next build` etc. Turborepo wires them via `turbo.json`.
- **Turbo's cache is content-addressed** — hashes source files + dependencies + environment variables + configuration. Cache hit = restore instantly; cache miss = rebuild and add to cache.

## Key takeaways

- **`turbo.json` is the orchestration spec**. Per-task definitions for `dependsOn` (which tasks must run first), `outputs` (what to cache), `cache: false` (skip caching, e.g., `dev`), `persistent: true` (long-running watchers).
- **`dependsOn: ["^build"]`** — the canonical "build upstream packages first" syntax. The `^` means "tasks of the same name on this package's dependencies."
- **Two cache layers**:
  - **Local cache** (`.turbo/cache/`) — per-developer, per-CI-runner.
  - **Remote cache** (Vercel, self-hosted) — shared across machines / CI / preview deploys. Same hash hit on any machine = skip work.
- **Signals you're NOT linked to a remote cache**: no `.vercel` directory, no `~/.turbo`, no `TURBO_TOKEN`/`TURBO_TEAM` env vars.
- **Vercel auto-detects Turborepo** and enables remote caching automatically for projects deployed there.

## Notable passages

> "Start with a monorepo. If it doesn't fit, you'll know quickly and can adjust."

> "Splitting a monorepo into separate repos is painful but possible. Merging multiple repos while preserving git history can be challenging."

> "**The pattern to recognize here is that the root orchestrates and apps implement.**"

## Open questions

- The chapter mentions `globalDependencies: ["**/.env.*local"]` as a cache invalidator — what's the right list of inputs to ensure correctness without over-invalidating?
- How does Turborepo's caching interact with **TypeScript's incremental build** (`tsBuildInfo`)? Both are about "rebuild only what changed" — but do they compose?
- The "root orchestrates, apps implement" pattern is clean but means root scripts get long. At what scale does that pattern break down?
- For a small team, the chapter recommends "start with a monorepo." But [[video-monorepo-12-months-opinions]] argues "only a single team should be working on a monorepo." When do these conflict?

## Cross-references

- Companion: [[nx-dev-00-introduction]] (the competing tool), [[video-turborepo-monorepos-explained]] (overview), [[mastering-pnpm-workspaces]] (the layer beneath), [[monorepos-for-developers]] (the why).
- Concepts: [[turborepo-pipelines]], [[task-orchestration]], [[remote-caching]], [[monorepo-package-graph]].
- Pattern: [[monorepo]].

## Source

- `raw/documentation/turborepo/00_Understanding Monorepos.md`
