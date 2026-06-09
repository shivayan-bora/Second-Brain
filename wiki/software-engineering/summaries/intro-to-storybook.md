---
title: "Intro to Storybook"
pillar: software-engineering
type: summary
tags: [documentation, course, storybook, design-systems, cdd, components]
status: stable
source: "raw/documentation/storybook.js.org/Intro to Storybook.md"
course: "Intro to Storybook (storybook.js.org)"
created: 2026-06-09
updated: 2026-06-09
---

# Intro to Storybook

Storybook's official tutorial. Builds a Taskbox app using **Component-Driven Development (CDD)** — bottom-up from atomic components to screens. Covers stories (CSF format), args/controls, decorators, MDX docs, theming, addon-themes, story-based testing, and accessibility checking.

## TL;DR

- **A [[story]] is a named, isolated visual state of a component** — `Primary`, `Disabled`, `WithIcon`. Written in **Component Story Format (CSF)**: a `meta` default export + one named export per state.
- **[[args-and-controls|`args`]] are the runtime values you pass to a story**; the **Controls panel** auto-generates a form UI for tweaking them at runtime. `argTypes` customizes the controls (radio vs dropdown, default values, actions).
- **Decorators wrap stories** with extra markup or context — theme providers, routers, layout padding. Hierarchy: global → component-level → story-level.
- **Component-Driven Development**: build from the smallest leaves (Task) up through composites (TaskList) to whole screens (InboxScreen). Each level is built in Storybook in isolation, then composed.
- **MDX docs** layer narrative documentation onto stories: `Meta`, `Story`, and `ArgsTable` blocks let you embed live components into prose.
- **Story-based testing** is the underrated payoff: stories double as test fixtures. The Vitest plugin (`@storybook/addon-vitest`) runs every story as a smoke test.

## Key takeaways

- **Storybook is the design system's workshop.** It's where you build components in isolation, document their API, demonstrate states, and increasingly, test them. For a design system shipped as a package, Storybook is the published-doc-and-demo site.
- **CSF over Component-level state machines** — each story is a *static* declaration of "what does this component look like given these args?" State machines belong inside the component, not the story.
- **`tags: ["autodocs"]`** auto-generates docs pages from stories — minimal-cost public API documentation.
- **Addons are the extensibility layer**: `@storybook/addon-themes`, `@storybook/addon-a11y`, `@storybook/addon-vitest`, `@storybook/addon-controls`. The Storybook brand is really "the addons that ship by default."
- **Test integration**: with `@storybook/addon-vitest`, story files become test files. A story that mounts without exception passes a smoke test; play functions (`play: async ({ canvasElement }) => {...}`) run interaction scripts.

## The CDD method, in a sentence

Start with the smallest indivisible visual unit (`Task`). Build it in Storybook against its data states. Compose into the next layer (`TaskList`). Build *that* in Storybook against its data states. Continue up to the screen.

## Notable passages

> "We will build our UI following the Component-Driven Development (CDD) methodology. It's a process that builds UIs from the bottom-up starting with components and ending with screens."

> "A story is a named, isolated state of a component (e.g. `Primary`, `Disabled`, `WithIcon`) written using Component Story Format (CSF)."

> "Actions are used to show that an event handler (callback) has been called, and to display its arguments."

## Open questions

- How does Storybook compare to **Ladle** (a much lighter-weight CSF runner) and **Histoire** (Vue-focused) for use cases that don't need the full Storybook ecosystem?
- For a small design system (5-10 components), does Storybook earn its keep, or is documenting via the consuming app sufficient?
- The MDX docs flow is powerful but adds a tooling dependency (MDX, blocks). Tradeoff vs plain markdown + linked Storybook stories?
- For server-component-heavy projects (Next.js App Router), how does Storybook handle stories that need server-only data?

## Cross-references

- Concepts: [[storybook]], [[story]], [[args-and-controls]], [[component-driven-development]].
- Pattern: [[headless-ui-library]] — both Radix and Storybook reward unstyled/composable components.
- Cross-ref: [[react-components]], [[react-typescript]].

## Source

- `raw/documentation/storybook.js.org/Intro to Storybook.md`
