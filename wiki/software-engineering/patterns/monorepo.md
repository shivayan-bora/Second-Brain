---
title: "Monorepo"
pillar: software-engineering
type: pattern
tags: [monorepo, polyrepo, architecture, team-organization]
status: stable
sources: ["[[monorepos-for-developers]]", "[[turborepo-00-understanding-monorepos]]", "[[video-monorepo-12-months-opinions]]", "[[mastering-pnpm-workspaces]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Monorepo

## Context

You're managing more than one related project — apps, services, or libraries — that share code, types, or tooling. Today they might live in separate repositories (polyrepo) or in one big repo without organization. You're considering how to structure the source-code layout for long-term productivity.

The decision affects everything downstream: how you ship code changes, how CI runs, how teams collaborate, what tooling you adopt, and how AI agents reason about your codebase.

## Problem

The default — one repo per project — has hidden coordination costs that grow with the number of projects:

- **Code sharing is cumbersome.** Want to share a type, a utility, a UI component? You publish a package, bump the version, update consumers, fight version drift.
- **Cross-repo changes are painful.** A change to a shared interface requires coordinated PRs across N repositories, each with its own review cycle.
- **Convention enforcement is hard.** ESLint config, TypeScript config, formatting, CI templates — every repo can drift from the standard.
- **Atomicity is impossible.** "Rename API + update all callers" must span multiple PRs across repos, with a window where the system is inconsistent.
- **AI agent context loss.** Cross-repo reasoning requires checking out and reading multiple repos — degrades agent effectiveness significantly.
- **TypeScript can't catch cross-repo breaking changes** at compile time; you find out at runtime in another service.

But a single repo without structure has its own problems: builds get slow, CI takes forever, unrelated changes block on each other, and the architecture erodes.

## Solution

Adopt the **monorepo pattern**: a single version-controlled repository containing multiple distinct projects, **with well-defined relationships**.

### The structural elements

1. **Workspaces** — a folder layout that declares which sub-directories are independent packages. Canonical:

   ```
   my-org/
   ├── apps/                  # Deployable applications
   ├── packages/              # Shared libraries
   ├── tools/                 # Shared configs (eslint, tsconfig, etc.)
   ├── package.json           # Root: orchestration only
   ├── pnpm-workspace.yaml    # Declares workspace packages
   └── turbo.json | nx.json   # Task orchestration config
   ```

2. **Package manager with workspace support** — pnpm (recommended), Yarn, or npm workspaces. Handles dependency dedup, the [[workspace-protocol|`workspace:*` protocol]], and per-package `node_modules`. See [[pnpm-workspaces]].

3. **Task orchestrator** (when scale demands) — Turborepo or Nx on top. Provides [[task-orchestration|caching, parallel execution, project graph awareness, and affected-only execution]].

4. **The "root orchestrates, apps implement" pattern** — root scripts delegate to the orchestrator; each app/package's own `package.json` defines what it actually does.

5. **Architectural rules**:
   - `apps/*` can depend on `packages/*`.
   - `packages/*` can depend on `packages/*` (no cycles).
   - `apps/*` cannot depend on each other.
   - `tools/*` is allowed everywhere.

### Concrete benefits

- **Atomic cross-project changes.** Rename a shared type + update every caller in one commit.
- **TypeScript catches breaking changes** across the whole codebase at compile time.
- **Single source of truth** for shared deps, configs, CI templates, tooling.
- **Code sharing is just an import** (`workspace:*` + import path).
- **AI agents have full context.** Cross-package reasoning works.
- **Visibility.** A new engineer (or agent) clones one thing and sees the whole picture.

## Trade-offs

### When to use a monorepo

- Multiple apps/services that share code (UI components, utilities, configs, types).
- Frequent cross-project changes.
- Single team owning all projects in the monorepo (see the "single-team rule" below).
- Consistent tooling matters (TypeScript, ESLint, tests).
- Want atomic commits across project boundaries.
- AI-agent-assisted development (cross-repo context loss is a real cost).

### When to use polyrepos

- Projects are truly independent (no shared code).
- Different tech stacks that can't share tooling.
- Strict access control (teams can't see each other's code).
- Multiple teams owning the projects with different release cadences and zero coordination need.
- Open-source projects with clear independence (and outside contributors that wouldn't navigate a monorepo).

### The single-team rule

Per [[video-monorepo-12-months-opinions]]:

> *"Only a single team should be working on a monorepo."*

The reasoning: cross-team contributors don't know your code's invariants. When team B refactors a shared utility and accidentally breaks team A's app, the monorepo's atomic-change benefit becomes a coordination cost. The "all teams in one monorepo" Google model requires Google-scale tooling investment.

**Operational rule of thumb:** if your team owns all the apps and packages in the monorepo, the pattern works. As soon as another team starts contributing, either give them their own monorepo or accept the coordination overhead and invest in it (CODEOWNERS, RFC processes, build-system enforcement).

### Costs

- **Git performance** degrades at very large scale (millions of files).
- **CI cost without orchestration** explodes; you need caching/affected.
- **Initial setup overhead** higher than "just clone four repos."
- **Tool maturity required** — pnpm + Turborepo/Nx familiarity matters.
- **Build complexity** if you don't follow conventions.

## Rule of thumb

> Start with a monorepo. If it doesn't fit, you'll know quickly and can adjust. *Splitting* a monorepo is painful but possible; *merging* multiple repos while preserving git history is much harder.

> If your projects share more than just configs, monorepo likely fits. If they're truly independent, polyrepo might work better.

## Examples

- **Vercel** — Next.js + Turborepo + adjacent packages in a monorepo (`vercel/next.js`).
- **Babel, Jest, React, Storybook** — open-source monorepos using Nx, Lerna, or Yarn workspaces.
- **Most startup setups** — pnpm + Turborepo or Nx with `apps/` for products and `packages/` for shared internals.

## Related

- [[monorepo-vs-polyrepo]] — repo-topology trade-offs (one axis of UI architecture).
- [[ui-arch-three-axes]] — repo topology is one of three independent axes.
- [[pnpm-workspaces]] — the canonical package-manager layer.
- [[task-orchestration]] — what to put on top at scale.
- [[turborepo-pipelines]], [[nx-affected]] — orchestrator-specific surfaces.
- [[monorepo-package-graph]] — the structural model.

## Sources

- [[monorepos-for-developers]] — definition and polyrepo costs.
- [[turborepo-00-understanding-monorepos]] — "start with a monorepo" advice; coordination tax framing.
- [[video-monorepo-12-months-opinions]] — single-team rule.
- [[mastering-pnpm-workspaces]] — practical structure and layout.
