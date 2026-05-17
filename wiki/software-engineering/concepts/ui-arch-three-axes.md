---
title: The Three Axes of Frontend Architecture
pillar: software-engineering
type: concept
tags: [frontend, architecture, micro-frontends, monolith, monorepo]
status: stable
sources: ["[[fm-enterprise-ui-00-architecture-patterns]]"]
created: 2026-05-17
updated: 2026-05-17
---

# The Three Axes of Frontend Architecture

## Definition

Frontend architecture is not a single monolith-vs-microfrontend slider. It is **three independent axes**, and any real system is a point in that 3-D space:

1. **Runtime architecture** — is the app assembled into one unit at runtime, or composed from independently-deliverable slices?
2. **Repository topology** — does the source live in one repo or many? See [[monorepo-vs-polyrepo]].
3. **Deployment topology** — is there one deployable, many lockstep deployables, or many genuinely independent deployables? See [[deployment-topology]].

## Why it matters

The default mental model — "we're either a monolith or we're doing micro-frontends" — collapses three orthogonal decisions into one and leads to predictable mistakes:

- Teams adopt micro-frontend tooling (Module Federation, etc.) but keep a **single lockstep deploy**, paying complexity tax with no autonomy reward.
- Teams move to a **polyrepo** assuming it means autonomy, then discover that everything still has to be released together because of a shared bundle.
- Teams stay on a single repo and assume that rules out independent deployables — it doesn't.

Naming the three axes lets you ask precise questions: *which axis am I trying to change, and why?*

## The axes in detail

### Runtime architecture

- **Frontend monolith** — one application, built and deployed as a single unit. Even a polyrepo setup is a monolith if all repos build into one shipped bundle. See [[monolithic-frontend]].
- **Micro-frontend** — many independently deliverable slices composed into one UX. Unlike backend [[microservices]], the seams must be invisible to the user — they expect one product. See [[micro-frontends]].

### Repository topology

- **Monorepo** — one repo holding many apps and libraries.
- **Polyrepo** — each project gets its own repo. Pro: teams own their decisions. Trade-off: code sharing is harder, maintenance is duplicated.
- See [[monorepo-vs-polyrepo]] for the comparison.

### Deployment topology

- **One deployable** — single artifact, single deploy.
- **Lockstep deployables** — multiple artifacts that must all ship together. This is what **build-time micro-frontends** produce — and it defeats the main reason to adopt micro-frontends.
- **Independent deployables** — each slice ships on its own schedule. This is the only configuration that delivers autonomous-deploy benefits.
- See [[deployment-topology]].

## Why the axes are independent

| Axis | Example value | Compatible with... |
|---|---|---|
| Runtime | monolith | monorepo OR polyrepo; always 1 deployable |
| Runtime | micro-frontend | monorepo OR polyrepo; lockstep OR independent deploys |
| Repo | monorepo | any runtime; any deployment topology |
| Deploy | independent | requires micro-frontend runtime |

The only hard constraint is that *independent deployment* requires a *micro-frontend runtime* — you can't independently deploy slices of a bundle that gets compiled together.

## Examples

- **Classic Create-React-App project in one repo** — monolith / monorepo (trivially) / one deployable.
- **Big company with `web-checkout/`, `web-search/`, `web-home/` repos all built into one Next.js bundle** — monolith / polyrepo / one deployable. The polyrepo bought nothing.
- **Module Federation with `host` and `checkout` micro-frontends, each deployed to its own CDN URL** — micro-frontend / either repo style / independent deployables. This is the configuration that pays off.
- **Build-time Module Federation in CI where all remotes get rebuilt together** — micro-frontend / either repo style / lockstep deployables. Complexity without autonomy.

## Related

- [[monolithic-frontend]] — when one runtime unit is the right call.
- [[micro-frontends]] — when and how to split.
- [[monorepo-vs-polyrepo]] — repo-topology trade-offs.
- [[deployment-topology]] — the under-discussed third axis.

## Sources

- [[fm-enterprise-ui-00-architecture-patterns]] (`raw/courses/Frontend Masters/Enterprise UI Development/00_UI Architecture Patterns.md`)
