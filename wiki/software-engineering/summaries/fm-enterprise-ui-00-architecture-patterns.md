---
title: "Enterprise UI Development ch00 — UI Architecture Patterns"
pillar: software-engineering
type: summary
tags: [course, chapter, frontend, architecture, micro-frontends, monolith, monorepo]
status: stable
source: "raw/courses/Frontend Masters/Enterprise UI Development/00_UI Architecture Patterns.md"
course: "Enterprise UI Development (Frontend Masters)"
created: 2026-05-17
updated: 2026-05-17
---

# Enterprise UI Development ch00 — UI Architecture Patterns

Opening chapter of the *Enterprise UI Development* Frontend Masters course. Frames the design space for large frontend systems as **three independent axes** rather than the usual monolith-vs-microfrontend binary, then digs into the pain points of monoliths that push teams toward splitting up.

## TL;DR

- "Monolith vs micro-frontend" is the wrong dichotomy. Evaluate frontend architecture along **three independent axes**: runtime assembly, repository topology, and deployment topology. See [[ui-arch-three-axes]].
- A polyrepo that still ships as one bundle is *still a monolith*. Conversely, a monorepo can host genuinely independent micro-frontend deployables. The axes don't move together. See [[monolithic-frontend]] and [[micro-frontends]].
- **Build-time micro-frontends defeat the main reason to adopt micro-frontends.** If everything must be re-built and re-deployed together, you've paid the complexity tax without buying deployment autonomy.
- Default to a [[monolithic-frontend|monolith]]. Switch only when concrete pain — team collisions, slow CI, blast radius, dependency hell — forces the move.
- The trigger isn't size, it's **feedback-loop length**. Once CI/CD blows past ~25 minutes the number of decisions a team can make per day drops precipitously.

## Key takeaways

- **Runtime architecture** describes *how the app is assembled when the user loads it*: one unit, or many independently deliverable slices composed into one UX. Backend [[microservices]] hide their seams; frontend slices must not — users expect one coherent product. See [[micro-frontends]].
- **Repository topology** is orthogonal: [[monorepo-vs-polyrepo|monorepo vs polyrepo]]. Polyrepos give teams autonomy at the cost of code-sharing friction and duplicated maintenance.
- **Deployment topology** is the *third* axis: one deployable, many lockstep deployables, or many genuinely independent deployables. Only the last one delivers autonomous-deploy benefits. See [[deployment-topology]].
- **Monolith pain shows up as four failure modes** — team collisions on shared files, ballooning CI/build times, blast radius from one feature taking down another, and dependency hell where nobody dares upgrade React. These are the *signals* to consider micro-frontends, not the size of the codebase per se.
- **Even solo developers benefit from clear boundaries** — constraining work to specific areas keeps AI tools from going on "side quests" and refactoring unrelated code.

## Notable passages

> "It's almost always a no-brainer to start with a monolith and then upgrade to a microfrontend as and when the situation arises."
> — Frontend Masters, *Enterprise UI Development* ch. 0

> "Unlike backend microservices, where each service is designed to be independent and isolated... frontend developers need to be mindful of the fact that we need to create a consistent user experience which hides this separation."
> — Frontend Masters, *Enterprise UI Development* ch. 0

> "Build-time microfrontends lose the autonomy in deployments, as everything gets deployed at once. If the main goal of adopting microfrontends is to achieve autonomous deploys, build-time microfrontends would not achieve that goal despite taking on the complexity of a microfrontend architecture."
> — Frontend Masters, *Enterprise UI Development* ch. 0

## Open questions

- What does **runtime composition** of micro-frontends actually look like in practice? Module Federation, iframes, web components — to be covered in later chapters.
- How do you keep design-system / UX consistency across truly independent micro-frontends without a lockstep release?
- Where's the empirical line between "CI is slow, optimize it" and "CI is slow because the architecture is wrong"?
- What does the **org-chart precondition** for micro-frontends look like? Conway's Law suggests you need autonomous teams *before* autonomous deployables make sense.

## Cross-references

- Concepts introduced: [[ui-arch-three-axes]], [[monorepo-vs-polyrepo]], [[deployment-topology]]
- Patterns introduced: [[monolithic-frontend]], [[micro-frontends]]
- Source path: `raw/courses/Frontend Masters/Enterprise UI Development/00_UI Architecture Patterns.md`
