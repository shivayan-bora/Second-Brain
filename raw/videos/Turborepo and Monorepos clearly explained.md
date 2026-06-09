---
id: Turborepo and Monorepos clearly explained
aliases: []
tags:
  - video
creation date: 2026-06-02 14:39
modification date: Tuesday 2nd June 2026 14:39:23
source: https://www.youtube.com/watch?v=nE-6UnaPHWs
status:
  - in-progress
---

- Monorepo is one project containing multiple sub-projects.
- Pros:
  - Easier collaboration
  - Easier dependency management
  - Easier refactoring
- Cons:
  - [[Git]] performance degradation
  - Increased build times
  - Complicated pipeline configuration

## What is Turborepo?

- High performance build orchestration tool for [[JavaScript]] and [[TypeScript]] codebases.
  - Incremental Builds: Remember what has been built and only rebuild what has been changed. It does that by using the below.
  - Content Aware Hashing: Hashes the content and not timestamp to know what has been built.
  - Parallel Execution: Build stuff in parallel to be ore performant
  - Remote Caching
- Contains two main folders:
  - `apps`: standalone projects
  - `packages`: shared utilities, configurations and libraries
- Configuration in `turbo.json`
