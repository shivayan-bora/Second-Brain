---
title: "Continuous Integration (CI)"
pillar: software-engineering
type: concept
tags: [ci, cd, automation, devops, monorepo]
status: in-progress
sources: ["[[deployment-topology]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Continuous Integration (CI)

## Definition

**Continuous Integration** is the practice of merging developers' work into a shared mainline frequently — typically multiple times per day — and verifying each merge with an automated build + test pipeline. The goal is to catch integration problems while they're still small, and to keep the mainline always in a deployable state.

The companion concept, **Continuous Delivery / Deployment (CD)**, extends CI by automating the path from merged code to production-ready artifact (CD = "deployable") or to actual production (CDeploy = "deployed").

## Why it matters

For a staff engineer, CI/CD is often the highest-leverage thing to invest in. Slow CI lengthens the feedback loop, which lengthens every other loop downstream. Brittle CI erodes trust, which leads to bypass culture (`--no-verify`, manual deploys). For a [[monorepo]], CI is where [[task-orchestration|task orchestration]], [[remote-caching|remote caching]], and [[nx-affected|affected]]-aware execution earn their keep.

## Why this page is brief

This page exists as a wikilink anchor — the concept comes up in [[deployment-topology]], [[monorepo]], [[turborepo-pipelines]], [[nx-affected]], and [[task-orchestration]]. The wiki has no dedicated CI/CD source yet; this page is a stub that will grow when those sources are ingested.

## The CI pipeline (canonical shape)

```
push  →  install deps  →  type check  →  lint  →  unit test  →  build  →  e2e test  →  artifact
```

- **Install deps** — the time-sink without caching; with [[pnpm-content-addressable-store|pnpm + store caching]], near-instant.
- **Type check** — `tsc --noEmit` (decoupled from compilation; faster).
- **Lint** — `eslint` + `prettier --check`.
- **Unit test** — Vitest/Jest; usually fast.
- **Build** — output artifact (bundle, container, etc.).
- **E2E test** — Playwright/Cypress; the long-pole, often gated to main branch only.
- **Artifact** — uploaded to artifact store; consumed by the deploy step.

For a [[monorepo]], the entire pipeline runs **only on affected packages** (via [[nx-affected]] or `turbo --filter='[main..HEAD]'`), and most steps hit [[remote-caching|cache]] for unchanged packages.

## Health metrics

A few signals that say more about CI than build-status badges:

- **Median PR CI time.** ≤10 minutes is healthy; ≥25 minutes [costs you decisions per day](https://wiki/software-engineering/summaries/fm-enterprise-ui-00-architecture-patterns#tldr) (the Enterprise UI argument).
- **Flaky-test rate.** % of runs where re-running with no code change flips pass/fail. >2% is bad.
- **% of PRs that bypass CI** (`--no-verify`, merge-without-checks). >0% is a culture problem.
- **Time-to-revert.** From "we broke main" to "main is green again." Should be <30 min.

## Common pitfalls

- **Tests that depend on each other.** Flaky in parallel, breaks affected-only execution.
- **No cache between runs.** Most CI providers offer it; configure it.
- **Bypassing on hook failure.** Fix the hook, don't `--no-verify`.
- **CI as the *only* test surface.** If developers can't run the same tests locally, CI failures are slow to debug.
- **Long-running tests on every PR.** Gate expensive checks (E2E, visual regression, security scans) to main or to a nightly schedule.

## Open questions

- The wiki has no first-class CI source yet. Worth ingesting: a CircleCI/GitHub Actions tutorial, *Continuous Delivery* (Humble & Farley), or a practical CD-pipeline article.
- How does CI interact with **trunk-based development** ([[video-monorepo-12-months-opinions]] mentions both as monorepo prerequisites)?
- For monorepos: when does CI time get so long that a separate "fast CI" + "full CI" split becomes worth the operational cost?

## Related

- [[deployment-topology]] — CI's downstream.
- [[monorepo]] — CI is where monorepo orchestration pays off.
- [[task-orchestration]], [[nx-affected]], [[turborepo-pipelines]], [[remote-caching]] — the CI-cost optimizers.
- [[tdd-red-green-refactor]] — local feedback loop CI extends to team scale.

## Sources

- [[deployment-topology]] — referenced as part of the deployment story.
