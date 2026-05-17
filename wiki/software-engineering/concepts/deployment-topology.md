---
title: Deployment Topology
pillar: software-engineering
type: concept
tags: [architecture, deployment, ci-cd, frontend, micro-frontends]
status: stable
sources: ["[[fm-enterprise-ui-00-architecture-patterns]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Deployment Topology

## Definition

**Deployment topology** is the third of the [[ui-arch-three-axes|three independent axes]] of frontend architecture: it describes *how many artifacts ship to production and whether they ship together or independently*. Three positions on this axis:

1. **One deployable** — single artifact, single deploy.
2. **Lockstep deployables** — multiple artifacts that all must be released together.
3. **Independent deployables** — multiple artifacts that each ship on their own schedule.

## Why it matters

Deployment topology — not runtime architecture, not repo topology — is what determines whether your teams can actually release autonomously. It is the axis most often skipped in micro-frontend conversations, and skipping it is how teams end up paying the complexity tax of [[micro-frontends]] without ever cashing in the autonomy reward.

> **Build-time micro-frontends lose the autonomy in deployments, as everything gets deployed at once. If the main goal of adopting microfrontends is to achieve autonomous deploys, build-time microfrontends would not achieve that goal despite taking on the complexity of a microfrontend architecture.**

## Mechanics

### One deployable

- One artifact, one release pipeline, one rollback button.
- Simplest operational model; the default starting point.
- Every change is a whole-product release; blast radius is the entire app.

### Lockstep deployables

- Multiple artifacts (CDN bundles, services, micro-frontend remotes) — but they must be released as a set.
- Common cause: shared types, shared compile-time dependencies, or build-time module-federation setups where the host expects exact remote versions.
- **Looks like** distributed architecture, **operates like** a monolith for release purposes.

### Independent deployables

- Each artifact ships on its own cadence, with its own pipeline, its own rollout, its own rollback.
- Requires runtime composition — slices must be late-bound (runtime Module Federation, iframes, runtime registry, etc.) — and a contract (API, props, event schema) that allows independent versioning.
- Real benefit: **autonomous teams.** Team A's release does not block or risk Team B's product surface.

## How to tell which one you have

Ask: *if Team A wants to release a fix at 14:03 on Tuesday, do they need Team B to coordinate?*

- **No** → independent.
- **Yes, but for an unrelated process reason (change-freeze, etc.)** → still independent architecturally, just blocked by process.
- **Yes, because we have to rebuild and re-deploy together** → lockstep.
- **There's only one artifact and one team** → one deployable.

## Related

- [[ui-arch-three-axes]] — deployment is axis #3.
- [[micro-frontends]] — the only runtime architecture that *supports* independent deployables.
- [[monolithic-frontend]] — always one (or trivially lockstep) deployable.
- [[continuous-integration]] — the pipeline machinery these decisions ride on.

## Sources

- [[fm-enterprise-ui-00-architecture-patterns]] (`raw/courses/Frontend Masters/Enterprise UI Development/00_UI Architecture Patterns.md`)
