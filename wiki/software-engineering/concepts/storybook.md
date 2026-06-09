---
title: "Storybook"
pillar: software-engineering
type: concept
tags: [storybook, design-systems, components, tooling, docs]
status: stable
sources: ["[[intro-to-storybook]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Storybook

## Definition

**Storybook** is a frontend workshop tool that renders components in isolation, displays them across their visual states, and doubles as documentation and a test runner. Each component gets a `.stories.tsx` file declaring its states ([[story|stories]]); Storybook discovers them and produces an interactive UI for browsing, tweaking props, and verifying behaviour.

## Why it matters

A design system's value depends on whether anyone can discover, understand, and correctly use its components. Storybook is the canonical answer for that problem: a single browsable surface for every component, every state, every variant — generated from the source-of-truth code, not maintained as separate docs.

For a staff engineer, Storybook adoption is a strong signal about a frontend team's design-system maturity. Teams with Storybook tend to have intentional component APIs; teams without often have prop-drilled visual chaos.

## What Storybook gives you

- **Isolated component rendering.** Run a component without the rest of the app, with controllable props.
- **Discovery.** A sidebar tree of every component and every state.
- **Documentation.** Auto-generated from TypeScript types + `argTypes` + (optionally) MDX docs.
- **Controls.** A UI panel for live-editing props (`args`) without reloading.
- **Actions.** A log of event-handler invocations and their arguments.
- **Theming switcher.** Toggle between light/dark/brand themes via `@storybook/addon-themes`.
- **Accessibility audit.** `@storybook/addon-a11y` runs axe-core on every story.
- **Testing.** Stories double as test fixtures; `@storybook/addon-vitest` runs them via Vitest.
- **Visual regression.** Via Chromatic (paid) or Lost Pixel / Playwright (DIY).

## How a Storybook project is organized

```
src/
  components/
    Button/
      Button.tsx
      Button.stories.tsx
      Button.docs.mdx        ← optional MDX docs
      Button.test.tsx        ← unit tests (can also be implied by stories)
.storybook/
  main.ts           ← config: stories glob, addons, framework
  preview.ts        ← global decorators (theme providers, etc.)
  manager.ts        ← Storybook UI customization (brand, theme)
```

## When to adopt Storybook

- **Building a design system / component library** (the obvious case).
- **A frontend team of >3 people** who'll need to discover each other's components.
- **Components with complex state surfaces** — disabled, loading, error variants explode quickly; Storybook makes them browsable.
- **External component delivery** — shipping a package to other teams; Storybook is the published docs.

## When to skip

- **Solo dev, simple app.** The tooling overhead may exceed the benefit.
- **App-shaped projects with few reusable components.** Most UI is one-off; Storybook is overkill.
- **Pages-heavy apps with no isolated components** — the components are too tied to their containers.

## Alternatives

- **Ladle** — much lighter CSF-compatible runner. Faster dev experience; fewer features.
- **Histoire** — Vue-focused alternative with similar concepts.
- **PlopJS templates + a custom showcase page** — DIY approach.

## Trade-offs

- **Pro:** standard, well-understood, huge ecosystem.
- **Pro:** stories become test fixtures, lowering testing-overhead.
- **Pro:** addon ecosystem covers a11y, theming, mocking, viewports.
- **Con:** non-trivial bundle size and dev-server cost.
- **Con:** Storybook config drift (`main.ts`, `preview.ts`) accumulates over time.
- **Con:** Stories that hit external dependencies need careful mocking.

## Related

- [[story]] — the unit Storybook displays.
- [[args-and-controls]] — props and the runtime control surface.
- [[component-driven-development]] — the methodology Storybook enables.
- [[react-components]], [[react-typescript]] — what stories describe.

## Sources

- [[intro-to-storybook]]
