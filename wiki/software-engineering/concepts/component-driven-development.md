---
title: "Component-Driven Development (CDD)"
pillar: software-engineering
type: concept
tags: [methodology, design-systems, components, frontend]
status: stable
sources: ["[[intro-to-storybook]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Component-Driven Development (CDD)

## Definition

**Component-Driven Development (CDD)** is a methodology that builds UIs from the **bottom up**: start with the smallest, most-reusable units (Button, Input, Avatar), compose them into mid-level components (TaskCard, FormField, Header), then assemble those into screens. Each layer is developed in isolation — typically in [[storybook|Storybook]] — before being integrated into the next layer.

## Why it matters

The default top-down approach (start with screens, extract components as you go) tends to produce components whose APIs are shaped by their first caller — making them awkward to reuse. CDD inverts this: design the component's API in isolation, where its callers don't constrain it yet, then trust that good leaves compose into good trees.

For staff engineers reviewing frontend codebases, CDD is a strong organizing principle. Codebases with CDD show clear separation between primitive, composite, and screen-level components; codebases without it tend to have giant page components and inconsistent shared primitives.

## The layered model

| Layer | Description | Example |
|---|---|---|
| **Atoms** (primitives) | Smallest indivisible units | `Button`, `Input`, `Icon`, `Avatar` |
| **Molecules** | Small groupings of atoms | `FormField`, `SearchBox`, `MenuItem` |
| **Organisms** | Larger composites | `TaskCard`, `Navbar`, `TaskList` |
| **Templates** | Page-shaped layouts without real data | `DashboardLayout` |
| **Pages / Screens** | Templates wired to data | `InboxScreen`, `UserSettingsPage` |

This is roughly Brad Frost's *Atomic Design* taxonomy applied to component code. The exact layer names matter less than the *direction*: build smaller things first.

## The CDD workflow with Storybook

1. **Identify the smallest component the design needs.** A Button, say.
2. **Implement it in isolation** — `Button.tsx` with no external dependencies.
3. **Write stories for every meaningful state** — `Primary`, `Secondary`, `Disabled`, `Loading`, `WithIcon`.
4. **Verify in Storybook** — does the API feel right? Are the args sufficient? Does it accessibility-pass?
5. **Repeat for the next layer up.** A `FormField` that uses `Input` + `Label`. Stories for `Default`, `WithError`, `Required`.
6. **Continue until you're at the screen.** The screen composes finished, tested, documented components.

## What CDD does well

- **API design under low pressure.** Without the screen's needs constraining you, you can make the component's API genuinely good for *all* its callers.
- **Reuse by default.** Components built bottom-up are designed for reuse; components extracted top-down often aren't.
- **Parallel work.** Multiple developers can build different leaves in isolation.
- **Visual review.** Designers can review Storybook without a working backend.
- **Documentation by construction.** Stories are the docs.

## When CDD struggles

- **Speculation cost.** Building a `Button` with five variants you might need takes longer than building the one variant you need *right now*.
- **Composition gaps surface late.** A perfectly-built atom might not compose well at the screen layer; this is hard to know without trying.
- **Mocking complexity.** Connected components (need data, auth, routing) require decorators and mocks in Storybook, which becomes ceremony.

## A pragmatic version

Most teams don't do pure CDD; they do:

- **CDD for the design system itself** — shared atoms and molecules built in isolation, published as a package.
- **Top-down within apps** — screens are built first; components are extracted into the design system when they prove reusable.

This middle path captures most of the CDD benefit without the speculation cost.

## Related

- [[storybook]] — the canonical CDD environment.
- [[story]] — the per-state declaration.
- [[react-components]], [[react-composition]] — the underlying mechanics.
- [[headless-ui-library]] — many CDD design systems sit on top of a headless library.

## Sources

- [[intro-to-storybook]] — explicit CDD framing for the Taskbox build.
