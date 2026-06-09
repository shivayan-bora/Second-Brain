---
title: "Storybook Config — `main.ts` and `preview.ts`"
pillar: software-engineering
type: concept
tags: [storybook, configuration, tooling]
status: stable
sources: ["[[fm-design-systems-storybook-v2]]", "[[intro-to-storybook]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Storybook Config — `main.ts` and `preview.ts`

## Definition

Storybook's project configuration is split between two files in `.storybook/`:

- **`main.ts`** — **build-time** config: framework, story-file glob, addons, builder customizations, TypeScript options.
- **`preview.ts`** — **run-time** config: global decorators, parameters, `globalTypes` for toolbar inputs, story sort order.

A third (`manager.ts`) configures the Storybook UI itself (sidebar theme, brand) — used less often.

## Why it matters

The main/preview split is the cleanest expression of the build-vs-runtime distinction in Storybook. Everything that runs in your dev/build pipeline (loaders, builder config, story discovery) goes in `main.ts`; everything that runs alongside the rendered stories (theme providers, mocked routers, decorators) goes in `preview.ts`. Mixing these is the most common Storybook misconfiguration.

## `main.ts` — build-time

```ts
// .storybook/main.ts
import type { StorybookConfig } from "@storybook/react-vite";

const config: StorybookConfig = {
  stories: [
    "../src/**/*.mdx",
    "../src/**/*.stories.@(js|jsx|mjs|ts|tsx)",
  ],
  addons: [
    "@storybook/addon-onboarding",
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    "@chromatic-com/storybook",
    "@storybook/addon-interactions",
    "@storybook/addon-themes",
    "@storybook/addon-a11y",
  ],
  framework: { name: "@storybook/react-vite", options: {} },
  docs: { autodocs: "tag" },
  core: { disableTelemetry: true },
};
export default config;
```

### Key fields

- **`framework`** — `{ name, options }`. The renderer + builder pair. `@storybook/react-vite`, `@storybook/react-webpack5`, `@storybook/vue3-vite`, etc.
- **`stories`** — glob(s) for story discovery. The default colocates stories with components.
- **`addons`** — string IDs of addon packages to load.
- **`viteFinal` / `webpackFinal`** — escape hatch to customize the underlying builder's config. Receives the builder config, returns a modified version.
- **`typescript`** — typechecker settings, react-docgen options.
- **`staticDirs`** — directories served as static assets.
- **`core`** — `{ disableTelemetry: true }` silences update prompts.
- **`docs`** — `{ autodocs: 'tag' }` enables auto-docs for stories tagged `autodocs`.
- **`features`** — opt-in to experimental features.
- **`env`** — env vars exposed to the dev server.

## `preview.ts` — run-time

```ts
// .storybook/preview.ts
import type { Preview } from "@storybook/react";

const preview: Preview = {
  decorators: [
    (Story) => (
      <ThemeProvider>
        <Story />
      </ThemeProvider>
    ),
  ],
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
  },
  globalTypes: {
    theme: {
      name: "Theme",
      description: "Global theme for components",
      defaultValue: "light",
      toolbar: {
        items: ["light", "dark"],
      },
    },
  },
};

export default preview;
```

### Key fields

- **`decorators`** — array of global decorators wrapping every story. Use for theme providers, routers, i18n, fixed-state mocks.
- **`parameters`** — global parameters applied to all stories. `controls.matchers` auto-detects color/date controls; `actions.argTypesRegex` auto-creates actions for `on*` props.
- **`globalTypes`** — definitions for toolbar inputs (theme switcher, locale picker, viewport selector).
- **`options.storySort`** — customizes the sidebar ordering of stories.

## The escape hatch — `viteFinal` / `webpackFinal`

```ts
// main.ts
viteFinal: async (config) => {
  // Mutate or merge with mergeConfig
  return { ...config, plugins: [...config.plugins, myPlugin()] };
}
```

Use when the addons don't cover your need — adding custom Vite plugins, path aliases that mirror your app config, special webpack loaders.

## Common pitfalls

- **`decorators` in `main.ts`** — won't run. Decorators are runtime.
- **Addons listed but not installed** — Storybook fails to start with a less-than-helpful error. `addons: ["@storybook/addon-a11y"]` requires `@storybook/addon-a11y` in `package.json`.
- **Story-glob misses your files** — adjust the glob, restart Storybook, check the sidebar.
- **`viteFinal` merging by spread** — overwrites `plugins` array if you're not careful. Use Vite's `mergeConfig` for safe merging.
- **`manager.ts` confusion** — that's for branding the Storybook UI itself, *not* for theming your stories.

## Related

- [[storybook]] — the host environment.
- [[story]] — what `stories` glob discovers.
- [[args-and-controls]] — `parameters.controls.matchers` configures the controls panel.
- [[component-driven-development]] — what the config enables.

## Sources

- [[fm-design-systems-storybook-v2]] — explicit main.ts/preview.ts walkthrough.
- [[intro-to-storybook]] — same patterns from a different angle.
