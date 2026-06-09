---
title: "Video — Turborepo and Monorepos Clearly Explained"
pillar: software-engineering
type: summary
tags: [video, monorepo, turborepo, intro]
status: stable
source: "raw/videos/Turborepo and Monorepos clearly explained.md"
created: 2026-06-09
updated: 2026-06-09
---

# Video — Turborepo and Monorepos Clearly Explained

Compact intro video. Defines monorepo, pros/cons at a glance, then introduces Turborepo's core capabilities: incremental builds via content-aware hashing, parallel execution, remote caching.

## TL;DR

- **Monorepo = one project containing multiple sub-projects.**
- **Pros**: easier collaboration, easier dependency management, easier refactoring.
- **Cons**: git performance degradation, increased build times, complicated pipeline configuration.
- **Turborepo** is a high-performance build orchestrator for JS/TS codebases. Four pillars:
  - **Incremental builds** — remember what's been built; only rebuild what changed.
  - **Content-aware hashing** — hashes content, not timestamps, to detect change.
  - **Parallel execution** — run tasks concurrently for speed.
  - **Remote caching** — share build artifacts across machines/CI.
- **Standard layout**:
  - `apps/` — standalone deployable projects.
  - `packages/` — shared utilities, configurations, libraries.
- **Configuration** in `turbo.json`.

## Key takeaways

- **Content-aware hashing > timestamps.** A file mtime can change without content changing (touched, re-saved); content hashing only triggers a rebuild when the bytes actually differ. This is the same approach Bazel and Buck use; modern JS tooling caught up.
- **Apps vs packages naming convention is universal** across monorepo tools (Turborepo, Nx, plain pnpm workspaces). Worth treating as a default unless there's a reason to deviate.
- **Git performance degradation** is the under-discussed monorepo con. At scale (millions of files), `git status` and `git log` slow down. Tools like Git LFS, partial clone, and sparse checkout help.

## Notable passages

> "Incremental Builds: Remember what has been built and only rebuild what has been changed. It does that by using Content Aware Hashing — hashes the content and not timestamp to know what has been built."

## Open questions

- At what size does git performance actually start to degrade for typical web monorepos? (Probably ≥100k files.)
- Is Turborepo's caching deterministic across OSes? Same hash on Linux + macOS? (Important for shared remote caches.)

## Cross-references

- Companion (deeper): [[turborepo-00-understanding-monorepos]], [[video-monorepos-fireship]] (Nx vs Turbo comparison).
- Concepts: [[turborepo-pipelines]], [[remote-caching]], [[task-orchestration]].

## Source

- `raw/videos/Turborepo and Monorepos clearly explained.md`
