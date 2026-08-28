---
title: Design Systems with Storybook v2
pillar: software-engineering
type: summary
tags: [course, storybook, design-systems, tokens, cva, testing, a11y]
status: stable
source: "raw/courses/Frontend Masters/Design Systems with Storybook v2/Design Systems with Storybook v2.md"
created: 2026-08-16
updated: 2026-08-16
---

## TL;DR

- [[storybook]] is a framework-agnostic tool for building, documenting, and testing UI components in isolation via "stories" — variants of a component with specific props/state.
- Config splits into build-time (`main.ts`) and run-time (`preview.ts`); decorators and loaders let stories mock context and async data.
- Raw hex colors don't scale — [[design-tokens]] (semantic → component-color layers) are the fix, and naming them well is the hard part.
- [[class-variance-authority]] (cva) gives a structured way to define component variants (visual + size) with a default.
- Storybook doubles as a test runner: `play` functions for interaction/unit tests, an a11y addon for accessibility checks, both runnable headlessly in CI.

## Key takeaways

- A story is a component rendered with a specific set of props/args — [[storybook]] treats these as first-class, addressable units for docs, visual regression, and testing.
- Whether to bother writing a story (vs. just exposing controls) hinges on: do you need automated testing (visual/integration/a11y) on this prop combination, or has this component had a bug before.
- `.storybook/main.ts` is build-time (framework, story globs, addons, bundler escape hatches); `.storybook/preview.ts` is run-time (decorators, global parameters, toolbar globalTypes, story sort order).
- Class composition utilities (`clsx`) and [[class-variance-authority]] solve the same underlying problem — conditionally combining classes for variants — with cva adding a declarative variant schema and default values on top.
- [[design-tokens]]: move from raw colors → semantic tokens (primary/secondary/accent/success/warning/danger) → component-specific aliases (`button-primary-hover`). Hiding the raw palette from engineers is what actually enforces this in practice.
- Constraining choice (fewer border-radii, fewer shadows options) is a general design-system lever, not just a color one — more options reliably gets used and breaks consistency.
- Automating design→code token generation (Figma variables → CSS) keeps design and engineering in sync; the token refactor's ROI compounds — a ~6-week initial investment turned each subsequent theme into ~6 hours of work.
- Storybook decorators can wrap a story in context providers (mocking app-level context); loaders run async fetches before a story renders and hand data to decorators via `context.loaded`.
- Testing story `play` functions run via Testing Library-style queries (`within`, `userEvent`, `expect`) and can be executed headlessly via Playwright + `test-storybook` for CI.
- Accessibility testing is an addon (`@storybook/addon-a11y`) plus a `test-runner.ts` hook (`injectAxe`/`checkA11y`) to fold a11y checks into the same CI run.

## Notable quotes / passages

> Naming is the hard part. The team spent ~two months finding a naming convention that didn't drive them insane; there's no silver bullet, and it'll differ per app.
— raw/courses/Frontend Masters/Design Systems with Storybook v2/Design Systems with Storybook v2.md

> A six-week initial refactor turned a future theme addition into roughly six hours (mostly tests plus manual click-through), with subsequent themes being nearly free.
— raw/courses/Frontend Masters/Design Systems with Storybook v2/Design Systems with Storybook v2.md

## Open questions

- How does this token/cva approach compare to other variant-styling libraries (e.g. `tailwind-variants`, vanilla-extract recipes)? Not covered by this source.
- No detail yet on how the "ignore aliases" Figma-to-CSS token pipeline step actually works — worth a dedicated source if one turns up.

## Cross-references

- [[storybook]]
- [[design-tokens]]
- [[class-variance-authority]]
