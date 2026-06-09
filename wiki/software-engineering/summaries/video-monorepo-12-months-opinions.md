---
title: "Video — Opinions After Using a Monorepo for 12 Months"
pillar: software-engineering
type: summary
tags: [video, monorepo, team-organization, opinions]
status: stable
source: "raw/videos/Opinions after using a monorepo for 12 months.md"
created: 2026-06-09
updated: 2026-06-09
---

# Video — Opinions After Using a Monorepo for 12 Months

Operational reflection after a year of running a monorepo. Surfaces the *team-organization* dimension that most monorepo content skips. Key takeaway: **"only a single team should be working on a monorepo"** — a load-bearing constraint that, if violated, undermines the benefits.

## TL;DR

- A *good* monorepo has:
  - **Easy-to-use frameworks** and shared libraries.
  - A **healthy build / CI/CD setup**.
  - **Developers familiar with monorepo tooling** — especially `affected triggers` and similar.
  - **Trunk-based development** and **pair programming** baked into the culture.
- **The dominant shortcoming**: people from other teams who aren't involved in your work accidentally break your code.
- **The author's strong rule**: **only a single team should be working on a monorepo.**
- **When to use a monorepo**:
  - Your team owns a specific set of services that no other team touches.
- **When NOT to**:
  - Multiple teams share/touch services in the monorepo.
  - Medium orgs with multiple teams can do either monorepo *per team* or polyrepo — both fine.

## Key takeaways

- **The team-boundary view is underrepresented in monorepo discourse.** Most articles ([[monorepos-for-developers]], [[turborepo-00-understanding-monorepos]]) pitch monorepo for "cross-team coordination." This video pushes back hard: cross-team monorepos cause more breakage than they prevent.
- **Trunk-based development pairs with monorepos.** Long-lived branches multiply the conflict surface; trunk-based + small PRs is the cultural prerequisite for monorepo benefits.
- **`affected` triggers** (Nx, Turborepo's `--filter`) are mentioned as critical for managing CI cost. Developer familiarity with these is itself a soft requirement.
- **Tension with starter advice**: [[turborepo-00-understanding-monorepos]] says "start with a monorepo." This video says "only single-team." Both can be true: start with a monorepo *if* the project is one team's; split when cross-team coordination becomes necessary.

## Notable passages

> "People from other team, who aren't involved in your work, accidentally breaking your code. Solution: Only a single team should be working on a monorepo."

> "If your team is only concerned about a specific set of services that only your team touches and no other team — then a monorepo can be the right choice for you."

## Open questions

- What's the operational rule for a "team"? 8 people? 15? When does a team become "multiple teams"?
- Are there cross-team-monorepo success stories where the operational discipline (code ownership rules, codeowners files, RFC processes) made it work?
- How do you handle the *transition* from single-team to multi-team monorepo — split? add CODEOWNERS? lock packages?

## Cross-references

- Companion (contrast): [[turborepo-00-understanding-monorepos]] ("start with a monorepo"), [[monorepos-for-developers]] ("monorepos enable cross-team coordination").
- Cross-pillar: this is the most leadership-flavored monorepo source — see [[monorepo-vs-polyrepo]] for the trade-off framing.
- Concepts: [[nx-affected]], [[monorepo-vs-polyrepo]].
- Pattern: [[monorepo]] — the team-boundary nuance belongs in Trade-offs.

## Source

- `raw/videos/Opinions after using a monorepo for 12 months.md`
