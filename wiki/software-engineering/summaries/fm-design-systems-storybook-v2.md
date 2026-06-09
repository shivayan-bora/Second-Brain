---
title: "Frontend Masters — Design Systems with Storybook v2"
pillar: software-engineering
type: summary
tags: [course, frontend-masters, storybook, design-systems, vite]
status: stable
source: "raw/courses/Frontend Masters/Design Systems with Storybook v2/Design Systems with Storybook v2.md"
course: "Design Systems with Storybook v2 (Frontend Masters)"
created: 2026-06-09
updated: 2026-06-09
---

# Frontend Masters — Design Systems with Storybook v2

Initialization + configuration walkthrough for a Storybook 8+ project. Focuses on the `.storybook/main.ts` build-time config and `.storybook/preview.ts` runtime config, then introduces the basic CSF [[story]] shape.

## TL;DR

- **Storybook is framework-agnostic.** Stories are versions of a component with specific props/state — variants. See [[story]].
- **`npx storybook@latest`** initializes the project; a `.storybook/` directory is created with two key files.
- **Two configuration files**:
  - **`main.ts` (build-time)**: framework, story-file glob, addons, builder customization (`viteFinal`/`webpackFinal`), TypeScript settings, static dirs, core/docs/features/env settings.
  - **`preview.ts` (run-time)**: global decorators, parameters, `globalTypes` for toolbar inputs (theme/locale), story sort order.
- **The canonical addon set**: `@storybook/addon-onboarding`, `addon-links`, `addon-essentials`, `@chromatic-com/storybook` (visual regression), `addon-interactions`, `addon-themes`, `addon-a11y`.
- **`core.disableTelemetry: true`** is a worth-knowing knob to silence Storybook's update-prompt nags.

## Key takeaways

- **The main.ts / preview.ts split mirrors build vs runtime.** Anything that runs in your dev/build pipeline goes in `main.ts`; anything that runs alongside the rendered stories goes in `preview.ts`.
- **The default story-file glob** — `["../src/**/*.mdx", "../src/**/*.stories.@(js|jsx|mjs|ts|tsx)"]` — is what makes Storybook find your stories without explicit registration. Stories co-locate with components.
- **`controls.matchers`** in `preview.ts` auto-detects color (background/color) and date (matching `/Date$/i`) controls — small DX win that surfaces visual props as live editors.
- **Basic story shape** mirrors `intro-to-storybook`: a `meta` default export + named `Primary`/`Secondary` exports with `args`. The `render` field is a per-story escape hatch when args alone can't express the state (e.g., wiring children imperatively).
- **`satisfies Meta`** is the recommended typing — preserves the literal type rather than widening to `Meta<...>`. Pairs with `type Story = StoryObj<typeof Button>` for full inference.

## Notable passages

> "Storybook uses the concept of a story which is a version of your component with a specific state and props, also known as variants."

> "`main.ts` defines project's overall behaviour, including where stories live, which addons load, feature flags, and framework specific settings."

> "`preview.ts` run-time configuration: decorators, parameters, globalTypes, options.storySort."

## Open questions

- The course foreshadows but doesn't deeply walk through `globalTypes` for toolbar inputs (theme/locale). When does it cover the visual flow of wiring an addon-themes toolbar?
- `viteFinal` / `webpackFinal` are mentioned as escape hatches — what's the recommended path when you need to customize the builder? Is there a common pattern (e.g., merge with `mergeConfig` from Vite)?
- The course is co-located with [[intro-to-storybook]] in coverage — when do they diverge in advice?

## Cross-references

- Companion: [[intro-to-storybook]] (storybook.js.org tutorial), same patterns from a different angle.
- Concepts: [[storybook]], [[story]], [[args-and-controls]], [[component-driven-development]], [[storybook-config]].
- Cross-link: [[fm-design-systems-storybook-v2-hub]] for course hub.

## Source

- `raw/courses/Frontend Masters/Design Systems with Storybook v2/Design Systems with Storybook v2.md`
