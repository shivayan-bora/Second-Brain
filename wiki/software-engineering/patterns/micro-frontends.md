---
title: Micro-Frontends
pillar: software-engineering
type: pattern
tags: [frontend, architecture, micro-frontends, pattern, distributed]
status: stable
sources: ["[[fm-enterprise-ui-00-architecture-patterns]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Micro-Frontends

## Context

A [[monolithic-frontend|frontend monolith]] is showing its limits:

- Multiple teams collide on the same files.
- CI/CD feedback loops have ballooned (the rough threshold the course flags is ~25 minutes).
- A bug in one feature area threatens the whole product (blast radius).
- Shared dependencies (e.g., React) are stuck because upgrading them means upgrading everything at once.

You're working with multiple autonomous teams and you want them to ship without lockstep coordination.

## Problem

How do you let independent teams build, version, and ship parts of a single user-facing product on their own cadence — without users perceiving the seams?

## Solution

Build the frontend as **many independently deliverable slices composed into a single user experience**. Each slice — team-owned, separately developed, separately versioned, ideally separately deployed — appears to the user as part of one coherent product.

Key elements:

- **Slice boundaries follow team / domain boundaries** (Conway's Law applied deliberately).
- **Composition happens at runtime** (Module Federation, runtime registry, iframes, web components) — not at build time. **Build-time composition defeats the point**, see the trap below.
- **Slices share a UX contract** — design system, layout shell, navigation — so users don't see version skew, font drift, or behavior inconsistencies.
- **Each slice has its own pipeline and its own deployable**, satisfying the "independent deployables" position on the [[deployment-topology]] axis.

## Trade-offs

### What it buys you

- **Team autonomy.** Team A ships when Team A is ready; Team B is not blocked.
- **Bounded blast radius.** A bug in one slice can be rolled back independently; it doesn't take down the whole app.
- **Independent dependency upgrades.** Slice X can adopt a new React version on its own timeline.
- **Targeted CI.** Each slice's pipeline only rebuilds and tests its own code.

### What it costs you

- **UX consistency is now your problem.** Backend [[microservices]] don't have to look like each other; frontend slices do. Users expect one product, not a patchwork.
- **Runtime composition machinery.** Module Federation, shared dependency negotiation, host/remote contracts — all non-trivial.
- **Cross-slice refactors get hard.** A change that spans slices now spans repos/pipelines/versions instead of being a single commit.
- **Observability and debugging get harder.** A failure on a page composed of N slices needs to be triangulated across N pipelines.
- **Org-chart precondition.** You need genuinely autonomous teams. Micro-frontends without team autonomy is all cost, no benefit.

### The build-time trap

> "Build-time microfrontends lose the autonomy in deployments, as everything gets deployed at once. If the main goal of adopting microfrontends is to achieve autonomous deploys, build-time microfrontends would not achieve that goal despite taking on the complexity of a microfrontend architecture."

If you "go micro-frontend" but everything still gets bundled and deployed in one pipeline, you have **paid the complexity tax of micro-frontends and bought nothing**. The deployment topology must actually be independent — see [[deployment-topology]].

## Anti-patterns

- **Premature splitting** — adopting micro-frontends before the monolith pain is real.
- **One repo per micro-frontend "because microservices do that"** — repo topology and runtime architecture are independent axes. See [[monorepo-vs-polyrepo]].
- **Visible seams** — letting each slice ship its own header, fonts, button style, etc. The frontend equivalent of "microservices but they all return different error formats".
- **Build-time-only composition** (covered above).

## Related

- [[monolithic-frontend]] — the alternative; the recommended default.
- [[ui-arch-three-axes]] — micro-frontend is a *runtime* choice; the other two axes still need to be decided.
- [[deployment-topology]] — independent deployables is what makes micro-frontends worthwhile.
- [[monorepo-vs-polyrepo]] — orthogonal; can be done either way.
- [[microservices]] — analogous backend pattern, but with very different UX constraints.

## Sources

- [[fm-enterprise-ui-00-architecture-patterns]] (`raw/courses/Frontend Masters/Enterprise UI Development/00_UI Architecture Patterns.md`)
