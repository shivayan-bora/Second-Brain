---
id: Monorepos - fireship.dev
aliases: []
tags:
  - video
creation date: 2026-05-31 20:55
modification date: Sunday 31st May 2026 20:55:23
source: https://www.youtube.com/watch?v=9iU_IE6vnJ8
status:
  - in-progress
---

- [[Google]]'s [[Monorepo]] is the largest monorepo today and it takes an extra-ordinary effort to scale.
- [[Vercel]] acquired [[Turborepo]] which is written in [[Rust]] and makes it really easy to manage multiple applications and packages inside a single [[Git]] [[Git Repository|repository]].

![[Pasted image 20260531205817.png]]

- Why monorepo?
  - Gives visibility of the entire company's codebase without the need to track down and clone a bunch of different repositories.
  - Provides consistency: Because you can share your [[ESLint]] configuration and UI components from your [[Design System]], utility libraries, documentation and so on.
  - Makes dependency management much easier: Makes it easier for you to visualize your dependency graph.
    - Monorepo can dedupe packages that are used in multiple applications.
  - Also ideal for CI/CD.

- As a downside, as the monorepo grows larger in size, it becomes difficult to build, test and store artifacts as a result.
  - So to run a monorepo at scale, you need to have a good tooling to manage it.
- To start with, we can use workspaces which is available in all popular package managers like [[npm]], [[Yarn]] and [[pnpm]] with [[pnpm Workspaces]] being one of the most popular one.
  - It dedupes dependencies used in multiple packages inside your monorepo so any dependency is only installed once.
    - [[pnpm]] takes it a step further by using hard-links and symlinks to a central dependency store which further boosts disk space optimizations, faster installations and prevent phantom dependencies.
  - It allows you to orchestrate complex compile, build and test scripts.
- We however need to use various tools which optimizes this orchestration pipeline (recompile, rebuild and retest) like [[Lerna]], [[Nx]], [[Turborepo]] to name a few.
- The most popular ones are [[Nx]] and [[Turborepo]] which are also known as smart build systems.

## Nx vs Turborepo

- Both of them create a dependency tree between all your applications and packages which allows the tooling to understand what needs to be tested and what needs to be rebuilt whenever there's a change to the codebase.
- They cache any files or artifacts that have already been built and can also run jobs in parallel to execute everything much faster.
- Turborepo is quite minimal:
  - Computation caching
  - Parallel task execution
  - Remote Caching
- Nx is much more bigger with the same thing as above but also with:
  - CLI to automatically generate boiler plate code.
  - Plugin ecosystem
  - VS Code extension
  - Distributed Task Execution: Allows you to distribute work across multiple continuous integration servers.
- Cons of Nx:
  - Too much bloat
  - Too much configuration
    - Caveat: if you're using the core Nx features, that configuration is actually minimal.
- Remote Caching: If someone already builds the application once, it's stored in the cloud and that cache can be downloaded by someone else to save a huge amount of time building those artifacts.
- Turborepo needs minimal setup to work properly and provides speed.

## Turborepo Quickstart

- Run command: `npx create-turbo@latest turboapp`
- Contains two main folders:
  - `apps`: Applications
  - `packages`: Common utilities and configurations
- `turbo` configuration in `package.json`
- To link dependencies from `packages` in mono repo use `'*`
- First build takes time but subsequent builds take lesser time because of remote caching.
