---
title: Monorepo vs Polyrepo
pillar: software-engineering
type: concept
tags: [architecture, repos, tooling, frontend, backend, monorepo]
status: stable
sources: ["[[fm-enterprise-ui-00-architecture-patterns]]", "[[monorepos-for-developers]]", "[[turborepo-00-understanding-monorepos]]", "[[video-monorepo-12-months-opinions]]", "[[mastering-pnpm-workspaces]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Monorepo vs Polyrepo

## Definition

A **monorepo** is one source repository that holds many applications and libraries. A **polyrepo** gives each project its own repository. The distinction is purely about source-code organization — it says **nothing** by itself about how the code is built, bundled, or deployed.

## Why it matters

Repo topology is one of the [[ui-arch-three-axes|three independent axes]] of frontend (and backend) architecture. Engineers routinely conflate "polyrepo" with "independent services" — but a polyrepo whose outputs all get bundled into one shipped artifact is still a [[monolithic-frontend|monolith]] for every operational purpose that matters.

## Mechanics

### Monorepo

- **Pro:** Code sharing is cheap — internal libraries are just another directory.
- **Pro:** One source of truth for tooling, lint config, CI configuration, dependency versions.
- **Pro:** Cross-cutting refactors (rename an API, bump a shared lib) can be a single atomic commit.
- **Con:** Requires real tooling investment as it grows — Nx, Turborepo, Bazel, Lerna, pnpm/yarn workspaces — to keep builds and CI fast.
- **Con:** Default CI may rebuild everything on every change; affected-graph computation is mandatory at scale.

### Polyrepo

- **Pro:** Each team owns their organizational decisions — tooling, release cadence, conventions.
- **Pro:** Smaller surface area per repo; faster local clones, faster targeted CI.
- **Con (per the course):** Code sharing is harder — shared libs need versioning, publishing, and a consumer-update story.
- **Con:** Maintenance multiplies — every repo needs its own CI config, lint setup, dependency updates.

## What it does NOT determine

- **Whether you ship as a monolith.** A polyrepo whose pieces are all bundled into one app at build time is a monolith. A monorepo can produce N independent deployables.
- **Whether teams have autonomy.** Autonomy comes from the [[deployment-topology|deployment topology]] and the org chart, not from how many `.git` directories exist.

## Examples

- **Google / Meta** — famously vast monorepos with very heavy custom tooling (Blaze/Bazel, Buck).
- **Babel, Jest, React, Storybook** — open-source monorepos using Lerna/Nx workspaces.
- **Many startup setups** — Nx or Turborepo monorepo with `apps/web`, `apps/admin`, `packages/ui`, `packages/api-client`.
- **Microservices-heavy companies** — often polyrepo, with internal package registries to share libs.

## Additional considerations (from later sources)

- **Coordination tax is real.** Polyrepo's hidden cost: every cross-cutting change needs coordinated PRs across N repos. Monorepo collapses this to one commit. See [[monorepos-for-developers]].
- **Cross-repo TypeScript can't catch breakage at compile time.** Monorepos let `tsc` check the whole tree atomically. Polyrepos find out at runtime in another service.
- **AI agent context loss** is a growing factor — cross-repo reasoning degrades agent effectiveness. Monorepos give agents one tree to reason about.
- **Start with a monorepo** if uncertain — *splitting* is painful but possible; *merging* multiple repos while preserving git history is much harder. See [[turborepo-00-understanding-monorepos]].
- **The single-team rule**: per [[video-monorepo-12-months-opinions]], a monorepo works best when one team owns all the projects in it. Cross-team monorepos require heavy investment in CODEOWNERS, RFC processes, and module-boundary enforcement. Without that investment, the atomic-change benefit becomes a coordination cost.
- **You can outgrow pnpm-only monorepo support.** [[mastering-pnpm-workspaces]] suggests pnpm alone is "all the monorepo support you need"; [[nx-dev-00-introduction]] and [[turborepo-00-understanding-monorepos]] argue that at scale you need a task orchestrator for caching, affected-only execution, and remote cache. The crossover happens around 5-10 packages or whenever CI times bother developers.

## Related

- [[ui-arch-three-axes]] — repo topology is axis #2.
- [[monolithic-frontend]] — orthogonal to repo choice.
- [[micro-frontends]] — orthogonal to repo choice.
- [[deployment-topology]] — the axis that *actually* determines autonomy.
- [[monorepo]] (pattern) — Context/Problem/Solution/Trade-offs framing.
- [[pnpm-workspaces]], [[task-orchestration]], [[monorepo-package-graph]] — the implementation layers.

## Sources

- [[fm-enterprise-ui-00-architecture-patterns]] (`raw/courses/Frontend Masters/Enterprise UI Development/00_UI Architecture Patterns.md`)
- [[monorepos-for-developers]] — coordination tax framing, well-defined-relationships criterion.
- [[turborepo-00-understanding-monorepos]] — "start with a monorepo" advice.
- [[video-monorepo-12-months-opinions]] — single-team rule.
- [[mastering-pnpm-workspaces]] — practical pnpm-workspaces layer.
