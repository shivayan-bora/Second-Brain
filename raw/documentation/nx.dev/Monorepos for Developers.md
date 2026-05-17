---
id: Monorepos for Developers
aliases: []
tags:
  - documentation
creation date: 2026-05-17 15:17
modification date: Sunday 17th May 2026 15:17:49
source: https://monorepo.tools/
status:
  - in-progress
---

## Introduction to Monorepos

### What is a Monorepo?

![[Pasted image 20260517153334.png]]

- A [[Monorepo]] is a single version controlled repository consisting of multiple distinct projects, with **well defined relationships**.
	- It contains shared dependencies, types, configurations etc. shared between all it's consisting projects.
	- It has a unified build, testing and deployment workflow.
	- It has a single source of truth for collaboration.
- If we have a single repository with multiple projects, but there's *no well defined relationships* between them, even though the code is colocated, we still *wouldn't call it a monorepo*.
- Some tools which help you create monorepos are [[Lerna]], [[Turborepo]], [[Nx]] etc.

#### Polyrepos

- This is the opposite of a monorepo i.e. each application lives in it's own repository with it's own dependencies, tooling, build artifact, CI/CD ([[Continuous Integration]] and [[Continuous Delivery]]) pipeline and build cadence.
- While this promotes team autonomy, this introduces some hidden costs:
	- Cumbersome code sharing.
	- Code duplication.
	- Cross-functional requirements has a lot of overhead and need some major manual intervention.
	- Difficult to enforce conventions.

![[Pasted image 20260517191447.png]]

#### Monorepo Vs Monoliths

- Read: [https://nx.dev/blog/monorepo-is-not-monolith](https://nx.dev/blog/monorepo-is-not-monolith)

### Why Use a Monorepo?

- Single source of truth and a centralized dependency management.
	- No need of duplicate setup.
- Loss of context across multiple repositories for AI Agents and developers.
- Cross-repo changes is difficult for both AI Agents and developers and usually manual intervention is needed.
- You can share types across various projects to have a more robust system.
- You can share configurations, linting and formatting rules across various projects easily.
