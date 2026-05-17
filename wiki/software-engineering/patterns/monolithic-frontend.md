---
title: Monolithic Frontend
pillar: software-engineering
type: pattern
tags: [frontend, architecture, monolith, pattern]
status: stable
sources: ["[[fm-enterprise-ui-00-architecture-patterns]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Monolithic Frontend

## Context

You are building or running a frontend application. You have a choice between a single-unit runtime (everything compiled and shipped together) and a composed runtime built from independently deliverable slices (see [[micro-frontends]]). Most teams default — correctly — to the first.

Note that "monolith" here refers to **runtime architecture**, the first of the [[ui-arch-three-axes|three axes]]. A monolith can live in a [[monorepo-vs-polyrepo|monorepo or a polyrepo]]; what makes it a monolith is that everything is assembled into one deliverable.

## Problem

How do you build a frontend that maximizes developer productivity and operational simplicity at small-to-medium scale, without prematurely paying the complexity tax of micro-frontends?

## Solution

Ship a single application, built and deployed as one unit.

- **One codebase, one build, one deploy.** Every change goes through the same pipeline and arrives in production together.
- **No cross-system coordination.** No version negotiation between independently-deployed slices, no API migration choreography, no runtime-composition machinery.
- **One dependency graph.** A single React, a single bundler, a single TypeScript config.
- **Even with a polyrepo,** if all repos build into one bundle, you still have a monolithic runtime — and most of the operational benefits — even though you've taken on some of the polyrepo costs.

The recommended default: **start here**. Upgrade to [[micro-frontends]] only when concrete pain shows up.

## Trade-offs

### What it buys you

- **Simplicity.** One pipeline, one rollback, one dependency tree.
- **Atomic refactors.** Rename an API, bump a shared lib, change a route — all in one commit.
- **Strong consistency.** No version skew between user-facing surfaces; the user never sees two versions of the same component.

### What it costs you (the "hard parts")

These are the failure modes the course flags as signals to consider splitting:

- **Team collisions.** Multiple teams editing the same files, blocked by merge conflicts and stepping on each other's work.
- **Build times.** A one-line change rebuilds and retests everything. Once CI passes ~25 minutes, the feedback loop is broken — see *Important question* below.
- **Blast radius.** A bug in Settings can take down Authentication. Every change risks the whole product.
- **Dependency hell.** Upgrading [[React]] means upgrading *everything* at once. So nobody upgrades anything.

### When the trade-off flips

Two main signals from the source material that it's time to move:

1. **Multiple teams editing the same files**, creating merge-conflict nightmares.
2. **CI/CD feedback loop > ~25 minutes**, drastically reducing the number of decisions a team can make in a day.

> "When the feedback loop for determining if something is ready for production becomes excessively long (such as 2 hours), the number of decisions you can make to fix issues begins to drop precipitously."

## When *not* to leave the monolith

- Single team, single product surface.
- CI under control (build < 10–15 min, tests reliable).
- No clear bounded contexts begging to be released independently.
- No deployment-autonomy requirement from the business.

A solo developer or small team will almost never have a good reason to leave the monolith — and even for solo work, the *internal* boundary discipline of the monolith (clear directories, clear modules) matters: it constrains AI tools from going on "side quests" into unrelated parts of the codebase.

## Related

- [[ui-arch-three-axes]] — frames where the monolith decision lives.
- [[micro-frontends]] — the alternative when the trade-off flips.
- [[monorepo-vs-polyrepo]] — orthogonal choice; you can be monolithic in either.
- [[deployment-topology]] — the monolith is always "one deployable".

## Sources

- [[fm-enterprise-ui-00-architecture-patterns]] (`raw/courses/Frontend Masters/Enterprise UI Development/00_UI Architecture Patterns.md`)
