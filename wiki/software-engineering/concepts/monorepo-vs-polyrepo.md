---
title: Monorepo vs Polyrepo
pillar: software-engineering
type: concept
tags: [architecture, repos, tooling, frontend, backend]
status: in-progress
sources: ["[[fm-enterprise-ui-00-architecture-patterns]]"]
created: 2026-05-17
updated: 2026-05-17
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
- **Babel, Jest, React** — open-source monorepos using Lerna/Nx workspaces.
- **Many startup setups** — Nx or Turborepo monorepo with `apps/web`, `apps/admin`, `packages/ui`, `packages/api-client`.
- **Microservices-heavy companies** — often polyrepo, with internal package registries to share libs.

## Related

- [[ui-arch-three-axes]] — repo topology is axis #2.
- [[monolithic-frontend]] — orthogonal to repo choice.
- [[micro-frontends]] — orthogonal to repo choice.
- [[deployment-topology]] — the axis that *actually* determines autonomy.

## Sources

- [[fm-enterprise-ui-00-architecture-patterns]] (`raw/courses/Frontend Masters/Enterprise UI Development/00_UI Architecture Patterns.md`)
