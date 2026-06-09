---
id: Opinions after using a monorepo for 12 months
aliases: []
tags:
  - video
creation date: 2026-06-02 14:14
modification date: Tuesday 2nd June 2026 14:14:56
source: https://www.youtube.com/watch?v=rcmdyQL2DUM
status:
  - in-progress
---

- What would a good [[Monorepo]] look like?
  - Easy to use frameworks and share libraries.
  - Healthy build and CI/CD setup.
  - Developers familiar with monorepo tooling e.g. commands like `affected triggers`.
  - Making use of trunk-based development and pair programming.

![[Pasted image 20260602142602.png]]

- Shortcomings:
  - People from other team, who aren't involved in your work, accidentally breaking your code.
    - Solution: Only a single team should be working on a monorepo.

- When to use monorepos?
  - If your team is only concerned about a specific set of services that only your team touches and no other team - then a monorepo can be the right choice for you.
  - If you have a set of services and devs from multiple teams work on them, then don't use a monorepo.
  - Same for the medium organizations with fewer teams or smaller teams, but polyrepos are also fine as long as the number of services doesn't get out of control
