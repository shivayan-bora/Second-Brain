---
title: Storybook
pillar: software-engineering
type: concept
tags: [storybook, design-systems, testing, a11y, ui-components]
status: in-progress
sources: ["[[design-systems-storybook-v2]]"]
created: 2026-08-16
updated: 2026-08-16
---

## Definition

[[Storybook]] is a framework-agnostic tool for building UI components in isolation. Its core unit is the **story** — a component rendered with a specific set of props/state (a "variant"), addressable independently of the app it lives in.

## Why it matters

Design systems live or die on whether components are documented, visually consistent, and regression-tested in isolation from the app that consumes them. Storybook is the vehicle that makes a component catalog inspectable, testable, and shareable with design — it's the concrete tool behind the abstract goal of "a design system."

## Mechanics / details

**Configuration** splits into two files under `.storybook/`:
- `main.ts` (build-time): `framework`, `stories` (glob for story files), `addons`, `viteFinal`/`webpackFinal` bundler escape hatches, plus `typescript`/`staticDirs`/`core`/`docs`/`features`/`env`.
- `preview.ts` (run-time): `decorators` (wrap every story, e.g. theme/router providers), `parameters` (global config like `controls.matchers` for auto-detecting color/date controls), `globalTypes` (toolbar inputs — theme/locale switchers), `options.storySort`.

**Stories** are defined via a default-exported `meta` object (`title`, `component`, shared `args`, `argTypes` for how controls render — boolean toggle vs. select dropdown) plus named exports, each a `Story` with its own `args` or a custom `render`.

**Deciding whether to write a story**: write one when you need automated testing (visual/integration/a11y) against a specific prop combination, or the component has had a bug before. Otherwise, exposing controls for manual exploration may be enough.

**Decorators vs. loaders** (both used for mocking context/dependencies a component needs):
- Decorators wrap a story in extra markup/context (e.g. a provider), can be set globally in `preview.ts` or per-story in `meta`.
- Loaders run *before* a story renders, typically to fetch async data; the result lands on `context.loaded` for a decorator to consume.

**Documentation** is authored via `@storybook/blocks` (`Title`, `Meta`, `Primary`, `Controls`, `Stories` for a component's docs page; `ColorPalette`/`ColorItem` for token pages, `Typeset`/`IconGallery` for type/icons).

**Testing**:
- Unit/interaction tests live in a story's `play` function, using `within`/`userEvent`/`expect` from `@storybook/test`. These run when the story opens in the browser, or headlessly in CI via Playwright (`pnpm dlx playwright install` + `pnpm dlx test-storybook`).
- Accessibility testing is the `@storybook/addon-a11y` addon; folding a11y into the CI test-runner requires a `.storybook/test-runner.ts` with `injectAxe`/`checkA11y` hooks (from `axe-playwright`).
- [[Chromatic]] covers visual regression testing but is a paid product.

## Examples

```tsx
// src/components/button.stories.tsx
const meta = {
  title: "Button",
  component: Button,
  args: { children: "Primary" },
} satisfies Meta;

export default meta;
type Story = StoryObj<typeof Button>;

export const Primary: Story = { args: { variant: "primary" } };
export const Secondary: Story = { args: { variant: "secondary", children: "Secondary" } };
```

```tsx
// per-story dark mode + viewport override
export const Dark: Story = {
  parameters: { themes: { themeOverride: "dark" } },
};
export const Mobile: Story = {
  parameters: { viewport: { defaultViewport: "mobile1" } },
};
```

## Related

- [[design-tokens]] — Storybook's `ColorPalette` blocks are how token systems get documented.
- [[class-variance-authority]] — the variant logic that a story's `argTypes`/`args` typically drive.

## Sources

- [[design-systems-storybook-v2]]
