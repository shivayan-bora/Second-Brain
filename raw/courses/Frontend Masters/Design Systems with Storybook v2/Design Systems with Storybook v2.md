---
id: Design Systems with Storybook v2
aliases: []
tags:
  - course
creation date: 2026-05-27 08:43
modification date: Wednesday 27th May 2026 08:43:20
source: https://frontendmasters.com/courses/design-systems-v2/
status:
  - in-progress
---

- Framework agnostic.
- [[Storybook]] uses the concept of a story which is a version of your component with a specific state and props, also known as variants.

## Storybook Project

### Initialization and Configuration

- To initialize: `npx storybook@latest`
- In the project, the folder `.storybook` contains the configuration for the storybook. Two main files:
  - `main.ts`: Build-time configuration
    - Defines project's overall behaviour, including where stories live, which addons load, feature flags, and framework specific settings.
      - `framework`: rendering framework and builder.
      - `stories`: glob pattern where to find the story files
      - `addons`: list of add-ons to register
      - `viteFinal` / `webpackFinal` — escape hatches to customize the underlying builder's bundler configuration.
      - `typescript`, `staticDirs`, `core`, `docs`, `features`, `env` — additional project-level settings.
  - `preview.ts`: Run-time configuration
    - decorators — an array of global decorators that wrap every story with extra markup or context, e.g. a theme provider or router mock.
    - `parameters` — global parameters applied across all stories, such as the controls.matchers configuration that auto-detects color and date controls.
    - `globalTypes` — definitions for global toolbar inputs, like a theme or locale switcher.
    - `options.storySort` — customizes the ordering of stories in the sidebar.

```ts
// .storybook/main.ts
import type { StorybookConfig } from "@storybook/react-vite";

const config: StorybookConfig = {
  stories: ["../src/**/*.mdx", "../src/**/*.stories.@(js|jsx|mjs|ts|tsx)"], // Which files to pick up for the storybook
  addons: [
    "@storybook/addon-onboarding", // helpful tour
    "@storybook/addon-links",
    "@storybook/addon-essentials", // Essential pieces of the storybook
    "@chromatic-com/storybook", // Visual Regression Testing
    "@storybook/addon-interactions", // Interactions with the webpage like clicks etc.
    "@storybook/addon-themes", // Themes
    "@storybook/addon-a11y", // Accessibility testing
  ],
  framework: {
    name: "@storybook/react-vite",
    options: {},
  },
  docs: {
    autodocs: "tag",
  },
  core: {
    disableTelemetry: true, // 👈 Used to ignore update notifications.
  },
};
export default config;
```

```ts
// .storybook/preview.ts
import type { Preview } from "@storybook/react";

// Components that we see in the canvas area
// It's configuration
// For any dependencies to run your application
const preview: Preview = {
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
  },
};

export default preview;
```

### Basic Story

- Component:

```tsx
// src/components/button.tsx
import { ComponentProps } from "react";
import styles from "./button.module.css";

export type ButtonProps = ComponentProps<"button"> & {
  variant: "primary" | "secondary" | "destructive";
};

export const Button = ({ variant, ...props }: ButtonProps) => {
  let className = styles.button;

  if (variant === "secondary") className += " " + styles.secondary;
  if (variant === "destructive") className += " " + styles.destructive;

  return <button className={className} {...props} />;
};
```

- Styles:

```css
/* src/components/button.module.css */
.button {
  align-items: center;
  background-color: #4f46e5;
  border-color: transparent;
  border-radius: 0.25rem;
  border-width: 1px;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  color: white;
  cursor: pointer;
  display: inline-flex;
  font-weight: 600;
  gap: 0.375rem;
  padding: 0.375rem 0.75rem;
  transition: background-color 0.2s;
}

/* Focus visible styles */
.button:focus-visible {
  outline: 2px solid;
  outline-offset: 2px;
}

/* Disabled styles */
.button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.button:hover {
  background-color: #4338ca;
}

.button:active {
  background-color: #3730a3;
}

/* Variant: secondary */
.secondary {
  background-color: white;
  color: #1f2937;
  border-color: #94a3b8;
}

.secondary:hover {
  background-color: #f1f5f9;
}

.secondary:active {
  background-color: #e2e8f0;
}

/* Variant: destructive */
.destructive {
  background-color: #dc2626;
  color: white;
  border-color: transparent;
}

.destructive:hover {
  background-color: #b91c1c;
}

.destructive:active {
  background-color: #991b1b;
}

/* Variant: ghost */
.ghost {
  background-color: transparent;
  color: #4f46e5;
  border-color: transparent;
  box-shadow: none;
}

.ghost:hover {
  background-color: #f1f5f9;
}

.ghost:active {
  background-color: #e2e8f0;
}
```

- Story

```tsx
// src/components/button.stories.tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./button";

// 👇 Metadata for the collection of stories
const meta = {
  title: "Button",
  component: Button,
  args: {
    children: "Primary", // 👈 props passed on to the component for all the stories
  },
} satisfies Meta;

export default meta; // 👈 mandatory default export

type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: {
    variant: "primary",
  },
};

export const EscapeHatch: Story = {
  args: {
    variant: "primary",
  },
  render: () => <Button variant="destructive">Escape Hatch</Button>, // 👈 escape hatch: render a custom component
};

export const Secondary: Story = {
  args: {
    variant: "secondary",
    children: "Secondary", // 👈 props to pass to the component
  },
};

export const Destructive: Story = {
  args: {
    variant: "destructive",
    children: "Destructive", // 👈 props to pass to the component
  },
};
```

> [!NOTE]
> Q. When do we create stories vs give user the controls to control the component.
>
> A. Whether or not you will write a story depends on the following:
>
> - Whether you want to perform a test automatically in any fashion (e.g. visual or integration or accessibility) on that component for a specific set of `props`.
> - Did we get a bug on this in the past.

### Composing Class Names with clsx
