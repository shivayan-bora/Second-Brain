---
title: "Video — Monorepos (fireship.dev)"
pillar: software-engineering
type: summary
tags: [video, monorepo, nx, turborepo, comparison]
status: stable
source: "raw/videos/Monorepos - fireship.dev.md"
created: 2026-06-09
updated: 2026-06-09
---

# Video — Monorepos (fireship.dev)

Fireship's overview of monorepos. Frames the pattern, the workspace-tools layer (pnpm/yarn/npm workspaces), and the smart-build-system layer (Nx vs Turborepo). Quick comparison: Nx is the kitchen-sink toolkit, Turborepo is the minimal task runner.

## TL;DR

- **Google's monorepo is the largest in the world** — and takes extraordinary effort to scale. Vercel acquired Turborepo (written in Rust) to make monorepos approachable for normal teams.
- **The four monorepo benefits**:
  1. **Visibility** of the entire company's codebase without cloning many repos.
  2. **Consistency** — shared ESLint, design system, utility libs, docs.
  3. **Easier dependency management** — single dependency graph; dedup across packages.
  4. **CI/CD-friendly** when paired with the right orchestration.
- **The downside**: at scale, builds, tests, and artifact storage all become harder. You need good tooling.
- **Tool layers**:
  1. **Workspaces** — pnpm/yarn/npm. Dedup deps, share between packages. `[[pnpm-workspaces]]` uses hard-links + symlinks for further disk wins and to prevent [[phantom-dependencies]].
  2. **Smart build systems** — Lerna, Nx, Turborepo. Add caching, parallel execution, project graphs.

## Nx vs Turborepo at a glance

| | Turborepo | Nx |
|---|---|---|
| **Computation caching** | ✓ | ✓ |
| **Parallel task execution** | ✓ | ✓ |
| **Remote caching** | ✓ | ✓ |
| **Code generators (boilerplate)** | ✗ | ✓ |
| **Plugin ecosystem** | small | large |
| **VS Code extension** | ✗ | ✓ |
| **Distributed task execution** (across CI servers) | ✗ | ✓ |
| **Configuration weight** | minimal | larger |

## Key takeaways

- **Both Nx and Turborepo build a [[monorepo-package-graph|project dependency graph]]** to know what to rebuild and re-test on change. The graph + content-aware hashing is the core of "smart build systems."
- **[[remote-caching]] is the killer CI feature** — if a teammate or CI already built it, your machine downloads the artifact instead of rebuilding. Huge time savings at scale.
- **Pick by need**: Turborepo for speed + minimal config; Nx when you want generators, plugins, and IDE integration. Both can wrap pnpm workspaces.
- **"Too much bloat" is the common Nx complaint** — but the video notes if you use core Nx features only, the configuration is actually minimal.

## Notable passages

> "Both [Nx and Turborepo] create a dependency tree between all your applications and packages which allows the tooling to understand what needs to be tested and what needs to be rebuilt whenever there's a change to the codebase."

> "If someone already builds the application once, it's stored in the cloud and that cache can be downloaded by someone else to save a huge amount of time building those artifacts."

## Open questions

- For a 5-10 package monorepo, do you actually *need* Nx or Turborepo? Or are pnpm workspaces + a few well-written package.json scripts enough?
- Turborepo has caught up significantly to Nx — is the gap closing or do they remain distinct categories?
- How does **Bazel** compare? Mentioned in passing in [[monorepo-vs-polyrepo]] as Google's tool but rarely covered in JS-ecosystem content.

## Cross-references

- Companion: [[nx-dev-00-introduction]] (the deeper Nx dive), [[turborepo-00-understanding-monorepos]] (the deeper Turbo dive), [[video-turborepo-monorepos-explained]] (compact recap), [[video-monorepo-12-months-opinions]] (the operational caveats).
- Concepts: [[task-orchestration]], [[remote-caching]], [[monorepo-package-graph]], [[pnpm-workspaces]].

## Source

- `raw/videos/Monorepos - fireship.dev.md`
