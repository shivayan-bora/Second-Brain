---
title: "pnpm.io — Overview"
pillar: software-engineering
type: summary
tags: [documentation, pnpm, npm, package-management, dependency-management]
status: stable
source: "raw/documentation/pnpm.io/pnpm.io.md"
created: 2026-06-09
updated: 2026-06-09
---

# pnpm.io — Overview

The user's running pnpm.io notes (treated as a docs-shaped summary). Covers pnpm's "why" — the structural problems with npm/Yarn that motivated pnpm — including [[dependency-hoisting|hoisting]] and [[phantom-dependencies|phantom dependencies]], plus the [[pnpm-content-addressable-store|content-addressable store]] model that solves them.

## TL;DR

- **pnpm = "performant npm"** — a package manager and competitor to npm. Three big wins: fast installs (reinstalls especially), readable YAML lock files, and a strict `node_modules` layout that eliminates phantom dependencies.
- **Two npm structural problems pnpm solves**:
  - **Disk waste** — 100 projects using lodash = 100 physical copies on disk.
  - **Dependency dishonesty** — npm's flat hoisted `node_modules` lifts transitive dependencies to the top, letting your code `import` packages you never declared (= [[phantom-dependencies]]).
- **The CAS model**: pnpm stores each package version once in a global content-addressable store (`~/.pnpm-store`). Per-project `node_modules` are populated via **hard links** to that store. New project, same dep version = no download, no extra disk. See [[pnpm-content-addressable-store]].
- **Strict layout** — pnpm's `node_modules` only contains your declared dependencies at the top level. Transitive deps live nested or in `.pnpm/`. If you `import "phantom-pkg"`, the import fails — exactly what you want.
- **Diff-friendly lock file** — `pnpm-lock.yaml` (YAML, not JSON) is line-oriented and rarely conflicts.

## Key takeaways

- **Phantom dependencies are silent bugs.** With npm's hoisted node_modules, you import a package that's "happened to be there" because some transitive dep brought it. The day that transitive dep removes its own dep, your code breaks for a reason that has nothing to do with anything you changed. See [[phantom-dependencies]].
- **Hard links vs copies are the magic of the CAS model.** Same inode on disk = no duplication, instant install for already-downloaded versions. See [[pnpm-content-addressable-store]].
- **The lock-file format choice (YAML) matters.** Theo's PR-conflict story (cited in the source) — different team members using different dep versions, no merge conflict due to the readable diff — is a real-world reflection of "lock files are code" maturity.
- **pnpm's strictness is the trade-off**: more "module not found" errors at install time, fewer "why does my prod build differ from dev" surprises later.

## Notable passages

> "pnpm exists to solve two main structural problems baked into npm and classic Yarn: Disk Waste — 100 projects with lodash = 100 physical copies; Dependency Dishonesty — npm's flat hoisted `node_modules`, where transitive dependencies get lifted to the top level, letting your code `import` packages you never declared."

## Open questions

- The CAS store is at `~/.pnpm-store` by default — what happens when it's shared across users (CI runners, Docker layers)?
- How does pnpm interact with **Yarn Plug'n'Play** mode (`.pnp.cjs`)? Both solve phantom dependencies; pnpm via strict layout, PnP via no `node_modules` at all.
- What's the right disk-space hygiene story long-term? `pnpm store prune` exists; when do you run it?

## Cross-references

- Companion: [[mastering-pnpm-workspaces]] (workspaces specifically), [[video-monorepos-fireship]] (positioning).
- Concepts: [[pnpm-workspaces]], [[pnpm-content-addressable-store]], [[phantom-dependencies]], [[dependency-hoisting]], [[workspace-protocol]].

## Source

- `raw/documentation/pnpm.io/pnpm.io.md`
