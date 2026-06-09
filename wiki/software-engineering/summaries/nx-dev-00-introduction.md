---
title: "nx.dev ch00 — Introduction to Nx"
pillar: software-engineering
type: summary
tags: [documentation, chapter, nx, monorepo, task-orchestration, caching]
status: stable
source: "raw/documentation/nx.dev/00_Introduction to Nx.md"
course: "nx.dev documentation"
created: 2026-06-09
updated: 2026-06-09
---

# nx.dev ch00 — Introduction to Nx

Nx's self-introduction. Frames Nx as an **integrated** monorepo build system — task running, caching, parallelization, scaffolding, dependency-graph awareness, and migration tooling all in one. Walks through tasks, the inference model, the project + task graph, and the automated dependency-upgrade workflow.

## TL;DR

- **Nx is a Rust-based task runner** with caching, parallel execution, and project-graph awareness. Scales monorepos that pnpm workspaces alone can't.
- **Four monorepo failure modes Nx targets**: slow builds/tests, complex task pipelines, flaky CI, architectural erosion (no module boundaries).
- **Five core features**: [[task-orchestration|task caching]] (never rebuild same code twice), project + task graph (`nx graph`), [[task-orchestration|intelligent ordering]] (`dependsOn`), [[module-boundary-rules]] (prevent unwanted deps), flaky-task auto-retry.
- **[[nx-affected|`nx affected`]] command**: only run tasks for projects affected by a change. The single most-leverage CI optimization Nx provides.
- **Four-layer product**: Nx Core (free), Nx Plugins (technology-specific generators), Nx Console (IDE extension), Nx Cloud (paid, remote cache + self-healing CI).
- **`nx migrate latest`** — automated dependency + config upgrade workflow. Three-step process: update deps & generate migrations, run migrations, clean up.

## Key takeaways

- **Tasks are inferred from tooling**, not declared. Nx plugins (`@nx/vite`, `@nx/eslint`, `@nx/jest`) read `vite.config.ts` / `.eslintrc` / `jest.config.js` and create corresponding tasks automatically. Configuration in `nx.json` is the lightest setup of the three options (package.json scripts, project.json, inferred).
- **`dependsOn: ["^build"]`** is the canonical task-pipeline shape: "before this `build`, build all upstream packages first." See [[task-orchestration]] and [[turborepo-pipelines]] — the same idea in both tools.
- **Caching is content-addressed.** Nx hashes the *inputs* (source + deps + env + config) — same hash = restore from cache; different hash = rebuild.
- **Plugin order matters.** Multiple plugins creating tasks with the same name → last-defined wins. Worth checking in any non-trivial workspace.
- **Migration tooling is unusual.** Most build systems let you upgrade and figure out breakages yourself. Nx ships per-version migration scripts that adjust config, code, and dependencies — opinionated but reduces upgrade pain.

## Notable passages

> "Nx reduces friction across your entire development cycle with intelligent caching, task orchestration and deep understanding of your codebase."

> "Caches results so you never rebuild the same code twice."

> "When you add a new plugin, use `nx add <plugin>` to automatically install the version that matches your repository's version of Nx."

## Open questions

- The `nx.json` task-inference setup looks magical until you have two plugins creating same-named tasks — what does the debug story look like?
- How does Nx interact with **pnpm `workspace:*`** dependencies? Does Nx treat workspace-protocol versions specially in its project graph?
- For a small team with one main app + a couple of shared libs, where's the ROI threshold for Nx over plain pnpm workspaces?
- **Nx Cloud** is the paid layer with remote caching + self-healing CI. How essential vs. nice-to-have?

## Cross-references

- Companion: [[turborepo-00-understanding-monorepos]] (the competing tool), [[mastering-pnpm-workspaces]] (the layer underneath), [[video-monorepos-fireship]] (the tool comparison at a glance), [[video-monorepo-12-months-opinions]].
- Concepts: [[task-orchestration]], [[remote-caching]], [[nx-affected]], [[monorepo-package-graph]].
- Pattern: [[monorepo]].

## Source

- `raw/documentation/nx.dev/00_Introduction to Nx.md`
