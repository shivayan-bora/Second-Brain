---
title: "Article — Monorepos for Developers (monorepo.tools)"
pillar: software-engineering
type: summary
tags: [article, monorepo, polyrepo, architecture]
status: stable
source: "raw/articles/Monorepos for Developers.md"
created: 2026-06-09
updated: 2026-06-09
---

# Article — Monorepos for Developers (monorepo.tools)

Short framing piece from monorepo.tools (Nx team). Defines what makes a monorepo *actually* a monorepo (well-defined relationships, not just colocation), contrasts with polyrepos, and lists the hidden costs of polyrepo split.

## TL;DR

- A **monorepo** is a single version-controlled repository containing **multiple distinct projects with well-defined relationships**, sharing dependencies, types, configurations, and tooling.
- A repo with multiple projects but *no well-defined relationships between them* isn't really a monorepo — just colocation.
- **Polyrepo** is the opposite: each project in its own repo, its own tooling, its own CI/CD, its own cadence. Promotes team autonomy at hidden costs: cumbersome code sharing, code duplication, cross-functional change overhead, hard to enforce conventions.
- **Tools that help**: Lerna, Turborepo, Nx.
- A useful AI-era angle: **loss of context across multiple repositories for AI agents and developers** is real and growing. Cross-repo changes are difficult and usually require manual intervention.

## Key takeaways

- **The "well-defined relationships" criterion** is the distinguishing feature. Without it, you don't have a monorepo — you have a folder.
- **Polyrepo hidden costs**: code duplication, cross-functional change overhead, hard convention enforcement, type sharing impossibility.
- **Monorepo wins**: single source of truth, centralized dependency management, type sharing across projects, easy config sharing (lint, format).
- **AI agents** as a stakeholder: cross-repo context loss is a real new cost in the AI-assisted dev era. Monorepos give agents a single tree to reason about.

## Notable passages

> "A monorepo is a single version controlled repository consisting of multiple distinct projects, with **well defined relationships**."

> "If we have a single repository with multiple projects, but there's no well defined relationships between them, even though the code is colocated, we still wouldn't call it a monorepo."

## Open questions

- "Well-defined relationships" — what's the operational test for whether your colocated projects qualify? Likely something like "share at least one dependency" or "share at least one tooling config."
- How do shared types break down in the monorepo era of [[turborepo-pipelines|build orchestration]] and [[nx-affected]] task graphs?
- The AI-context angle is mentioned but not developed — would be worth a future ingest of more recent sources on this.

## Cross-references

- Companion: [[mastering-pnpm-workspaces]] (the practical setup), [[nx-dev-00-introduction]] and [[turborepo-00-understanding-monorepos]] (the orchestration layers).
- Concepts: [[monorepo-vs-polyrepo]], [[task-orchestration]].
- Pattern: [[monorepo]].

## Source

- `raw/articles/Monorepos for Developers.md`
