---
id: Design Systems with Storybook v2
aliases: []
tags:
  - course
creation date: 2026-05-27 08:43
modification date: Wednesday 27th May 2026 08:43:20
source: https://frontendmasters.com/courses/design-systems-v2/
status:
  - completed
---

- Framework agnostic.
- [[Storybook]] uses the concept of a story which is a version of your component with a specific state and props, also known as variants.
- Links:
  - [Course Website](https://stevekinney.com/courses/storybook)
  - [Course Repository](https://github.com/stevekinney/anthology)
  - [Figma Designs](https://www.figma.com/design/Qhb4PJucNK8bgvf4N65Jrm/Anthology?node-id=2-2152&p=f&t=HFoDTuMiXaKmhLoQ-0)

## Initialization and Configuration

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

## Building a Basic Story

### Button Component

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

### Button Styles using CSS Modules

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

### Button Stories

```tsx
// src/components/button.stories.tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./button";

// 👇 Metadata for the collection of stories
const meta = {
  title: "Button",
  component: Button,
  // 👇 set of props handed to your component to determine how it should render
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
    children: "Secondary", // 👈 props to pass to the component for this story
  },
};

export const Destructive: Story = {
  args: {
    variant: "destructive",
    children: "Destructive", // 👈 props to pass to the component for this story
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

## Composing Class Names with clsx

```tsx
import { ComponentProps } from "react";
import styles from "./button.module.css";
import clsx from "clsx"; // 👈 utility for composing classnames

export type ButtonProps = ComponentProps<"button"> & {
  variant: "primary" | "secondary" | "destructive";
};

export const Button = ({ variant, ...props }: ButtonProps) => {
  let className = clsx(
    styles.button,
    variant === "secondary" && styles.secondary,
    variant === "destructive" && styles.destructive,
  );

  return <button className={className} {...props} />;
};
```

- Can also be written as:

```tsx
import { ComponentProps } from "react";
import styles from "./button.module.css";
import clsx from "clsx"; // 👈 utility for composing classnames

export type ButtonProps = ComponentProps<"button"> & {
  variant: "primary" | "secondary" | "destructive";
};

export const Button = ({ variant, className, ...props }: ButtonProps) => {
  let classes = clsx(styles.button, styles[variant], className);

  return <button {...props} className={classes} />; // 👈 If you want the consumers to be able to pass their own classes: Makes sense for atoms but not molecules and organisms
};
```

## Adding Controls with argTypes

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./button";

// 👇 Metadata for the collection of stories
const meta = {
  title: "Button",
  component: Button,
  // 👇 set of props handed to your component to determine how it should render
  args: {
    children: "Primary", // 👈 props passed on to the component for all the stories
    disabled: false, // 👈 if you don't give this, the default value is taken as `undefined` and it first asks if we want to render the toggle and on clicking, then it renders the toggle
  },
  // 👇 specify the behaviour of args: how should it get displayed in the controls tab. as a toggle-switch (boolean) or a dropdown (select)?
  argTypes: {
    disabled: {
      control: "boolean",
    },
    variant: {
      control: "select",
    },
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

## Styling with Tailwind CSS

### Adding the index.css in the preview

```ts
import type { Preview } from "@storybook/react";
import "../src/index.css"; // 👈 Adds the styles from index.css to the preview area: can import tailwind css now!

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

### Theming

```ts
// tailwind.config.css
import type { Config } from "tailwindcss";

export default {
  content: ["./src/**/*.tsx", "./src/**/*.ts", "./src/**/*.mdx"],
  // 👇 how the `dark:` variant enables.
  // use a css selector and toggle it when data-mode is `dark`.
  darkMode: ["class", '[data-mode="dark"]'],
  plugins: [],
} satisfies Config;
```

- In [[Tailwind CSS]], `darkMode` controls how the `dark:` variant activates.
- `['class', '[data-mode="dark"]']` = selector strategy w/ custom selector:
  - `'class'` → use a CSS selector (not media query), so you toggle manually.
  - `'[data-mode="dark"]'` → custom selector overriding the default `.dark` class.
- So `dark:bg-black` etc. apply whenever an ancestor (usually `<html>`) has `data-mode="dark"`.
- To toggle it:

```ts
document.documentElement.setAttribute("data-mode", "dark"); // on
document.documentElement.removeAttribute("data-mode"); // off
```

- vs default `.dark` class approach (`classList.add('dark')`) — same idea, just attribute instead of class.
- single-string forms also valid — `darkMode: 'class'` (`.dark`), `darkMode: 'selector'` (v3.4.1+, also `.dark`), `darkMode: 'media'` (OS).

```ts
// .storybook/preview.ts
import type { Preview } from "@storybook/react";
import { withThemeByDataAttribute } from "@storybook/addon-themes"; // 👈 used for toggling themes with data-attribute
import "../src/index.css"; // 👈 Adds the styles from index.css to the preview area: can import tailwind css now!

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
  decorators: [
    withThemeByDataAttribute({
      defaultTheme: "light", // 👈 default value for data-mode
      // 👇 two different values for data-mode
      themes: {
        light: "light",
        dark: "dark",
          {/* 👈 for capturing task data from the loader */}
      },
      attributeName: "data-mode", // 👈 the data-attribute used for toggling the dark and light mode
    }),
  ],
};

export default preview;
```

- At the story level, if you want to force `dark` mode and force a specific viewport:

```tsx
export const Dark: Story = {
  parameters: {
    themes: {
      themeOverride: "dark",
    },
  },
};

export const Mobile: Story = {
  parameters: {
    viewport: {
      defaultViewport: "mobile1",
    },
  },
};
```

## Color Naming Conventions

- Don't reference raw colors in code. Literal names like red or blue accumulate conflicting meanings, making refactors and theming brutal.
- Move to semantic tokens. Use primary, secondary, accent, info, success, warning, and danger so intent is decoupled from the actual hex value.
- Add a component-color layer. Alias semantic tokens into specific names like button-primary-default, button-primary-hover, button-primary-active, and disabled/ghost/secondary variants.
- Naming is the hard part. The team spent ~two months finding a naming convention that didn't drive them insane; there's no silver bullet, and it'll differ per app.
- Hide the raw palette entirely. If engineers (or "you on a bad day") can access raw colors, they will use them, so restrict access and expose only approved tokens.
- Constrain the surface area of choice. This applies beyond color, too. Trim the default 8–9 border-radii and 8–9 box-shadows, because teams will use every option and break visual consistency.
- Use CSS variables for theming. Dark mode, high-contrast, or seasonal themes become a matter of swapping variable values, not editing components.
- Automate the design-to-code pipeline. They generate tokens from Figma via a variables-to-CSS plugin (with an "ignore aliases" step for new themes), keeping design and code in sync.
- Collaboration with design is foundational. If designers use hex codes "willy-nilly," the system breaks; the structure must be shared across both design and engineering.
- The payoff is dramatic. A six-week initial refactor turned a future theme addition into roughly six hours (mostly tests plus manual click-through), with subsequent themes being nearly free.

## Class Variance Authority

- [[Class Variance Authority (cva)]] is a [[CSS]] library that allows you to structure your styles in a way that supports the idea of having variants of components e.g. primary and secondary variant of a button.

```ts
import { cva, type VariantProps } from "class-variance-authority";

export const variants = cva(
  // 👇 base styles for all variants
  [
    "font-semibold",
    "border",
    "rounded",
    "shadow-sm",
    "inline-flex",
    "items-center",
    "cursor-pointer",
    "gap-1.5",
    "focus-visible:outline",
    "focus-visible:outline-2",
    "focus-visible:outline-offset-2",
    "transition-colors",
    "disabled:opacity-50",
    "disabled:cursor-not-allowed",
    "disabled:pointer-events-none",
  ],
  {
    variants: {
      // 👇 button type variants
      variant: {
        primary: [
          "bg-primary-600",
          "text-white",
          "border-transparent",
          "hover:bg-primary-500",
          "active:bg-primary-400",
        ],
        secondary: [
          "bg-white",
          "text-slate-900",
          "border-slate-300",
          "hover:bg-slate-50",
          "active:bg-slate-100",
        ],
        destructive: [
          "bg-danger-600",
          "text-white",
          "border-transparent",
          "hover:bg-danger-500",
          "active:bg-danger-400",
        ],
      },
      // 👇 size variants
      size: {
        small: ["px-2.5", "py-1.5", "text-xs"],
        medium: ["px-3", "py-2", "text-sm"],
        large: ["px-4", "py-2.5", "text-base"],
      },
    },
    // 👇 default values of the type of variant we want to apply to our button
    defaultVariants: {
      variant: "secondary",
      size: "medium",
    },
  },
);

// 👇 export variants as types
export type ButtonVariants = VariantProps<typeof variants>;
```

```tsx
import { ComponentProps } from "react";
import { ButtonVariants, variants } from "./button-variant";

// 👇 our button will take the props of all button props and the button variants
export type ButtonProps = ComponentProps<"button"> & ButtonVariants;

export const Button = ({
  variant = "primary",
  size = "medium",
  className,
  ...props
}: ButtonProps) => {
  // 👇 apply the variant to our button
  return <button {...props} className={variants({ variant, size })} />;
};
```

## Adding Documentation for Stories

- For the button story:

```tsx
import { Button } from './button';
import { Meta, Title, Primary, Stories, Controls } from '@storybook/blocks';
import ButtonStories from './button.stories';

<Title>Button</Title> {/* 👈 Title of the document */}

<Meta of={ButtonStories} /> {/* 👈 Tells for which story does this documentation belong to */}

Here is notes on how to use the Button component.

<Primary /> {/* 👈 Primary story of the component */}

<Controls /> {/* 👈 Shows the controls for the primary story, allowing users to interact with the component's props. */}

## Other Variations

<Stories /> {/* 👈 Shows all stories for the component */}
```

- For the color tokens:

```tsx
import { Meta, ColorPalette, ColorItem } from '@storybook/blocks';
import { colors } from './tokens/colors';

<Meta title="Tokens/Colors" /> {/* 👈 Title of the document also used to categorize */}

{/* Here we are creating a color palette by iterating over the colors object and rendering a ColorItem for each color group. We filter out any entries that are simple strings, as we only want to display groups of colors (like primary, secondary, etc.) that contain multiple shades. Each ColorItem will display the name of the color group and its corresponding colors. */ }
<ColorPalette>
  {Object.entries(colors)
    .filter(([, value]) => typeof value !== 'string')
    .map(([name, value]) => (
      <ColorItem key={name} title={name} colors={value} />
    ))}
</ColorPalette>
```

- Check out `Typeset` for typography and `IconGallery` for iconography. (Checkout the [Storybook Documentation](https://storybook.js.org/docs/writing-docs/autodocs))

## Testing and Interactions

### Unit Tests

```tsx
// src/callout/callout.stories.tsx
import type { Meta, StoryObj } from "@storybook/react";
import { TextArea } from "./text-area";

import { userEvent, within, expect } from "@storybook/test";

const meta = {
  title: "Components/TextArea",
  component: TextArea,
  args: {
    label: "Text Area Label",
    placeholder: "Enter some text here…",
    disabled: false,
    required: false,
  },
  argTypes: {
    label: {
      name: "Label",
      control: "text",
      description: "Label of the text area",
    },
    placeholder: {
      name: "Placeholder",
      control: "text",
      description: "Placeholder text of the text area",
    },
    disabled: {
      name: "Disabled",
      control: "boolean",
      description: "Disables the text area",
      table: {
        defaultValue: {
          summary: "",
        },
      },
    },
    required: {
      name: "Required",
      control: "boolean",
      description: "Marks the text area as required",
      table: {
        defaultValue: {
          summary: "",
        },
      },
    },
  },
} as Meta<typeof TextArea>;

export default meta;
type Story = StoryObj<typeof TextArea>;

export const Default: Story = {};

export const Disabled: Story = {
  args: {
    disabled: true,
  },
  // 👇 plays the tests when you open this story. canvasElement is the canvas area in storybook where the component stories are rendered
  play: async ({ canvasElement }) => {
    // 👇 capture the area within the canvas element where we want to run the tests
    const canvas = within(canvasElement);
    const textArea = canvas.getByRole("textbox"); // 👈 capture the element to be tested
    const inputValue = "Hello, World!";

    expect(textArea).toBeDisabled();
    await userEvent.type(textArea, inputValue); // 👈 always await user interactions since events in general are asynchronous by nature
    expect(textArea).toBeEmptyDOMElement();
  },
};

export const WithCount: Story = {
  args: {
    maxLength: 140,
  },
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    const textArea = canvas.getByRole("textbox");
    const count = canvas.getByTestId("length");
    const inputValue = "Hello, World!";

    await userEvent.type(textArea, inputValue);
    expect(count).toHaveTextContent(inputValue.length.toString());
  },
};

export const WithLengthTooLong: Story = {
  args: {
    maxLength: 140,
  },
  play: async ({ canvasElement, args }) => {
    const canvas = within(canvasElement);
    const textArea = canvas.getByRole("textbox");
    const count = canvas.getByTestId("length");
    const inputValue = "Y" + "o".repeat(args.maxLength || 140) + "!";

    await userEvent.type(textArea, inputValue);
    expect(count).toHaveTextContent(inputValue.length.toString());
    expect(textArea).toHaveAttribute("aria-invalid", "true");
    expect(textArea).toHaveClass("ring-danger-500");
    expect(count).toHaveStyle({ color: "rgb(237, 70, 86)" });
    expect(textArea).toHaveStyle({ borderColor: "rgb(237, 70, 86)" });
  },
};
```

- These tests will only run when you open the story one by one in order.
- In order to run these tests in a headless fashion so that it can be a part of our CI/CD pipelines, there are two steps:
  - `pnpm dlx playwright install`: Installs headless browsers and configures [[Playwright]].
  - `pnpm dlx test-storybook`: Run the test suite using the above headless browser.
- You can [check out](https://stevekinney.com/courses/storybook/visual-tests) [[Chromatic]] for visual regression testing but that's a paid product.

### Accessibility Testing

- We need to install the accessibility addon for storybook: `pnpm dlx storybook@latest add @storybook/addon-a11y`
- It adds an entry as follows in your `.storybook/main.ts`:

```ts
import type { StorybookConfig } from "@storybook/react-vite";

const config: StorybookConfig = {
  stories: ["../src/**/*.mdx", "../src/**/*.stories.@(js|jsx|mjs|ts|tsx)"],
  addons: [
    "@storybook/addon-onboarding",
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    "@chromatic-com/storybook",
    "@storybook/addon-interactions",
    "@storybook/addon-themes",
    "@storybook/addon-a11y", // 👈 Accessibility testing
  ],
  framework: {
    name: "@storybook/react-vite",
    options: {},
  },
  docs: {
    autodocs: "tag",
  },
  core: {
    disableTelemetry: true,
  },
};
export default config;
```

- To make a11y tests to your test runner as well, create a file inside `.storybook` named `test-runner.ts` which is basically configuring your test runner.

```ts
// .storybook/test-runner.ts
import type { TestRunnerConfig } from "@storybook/test-runner";
import { injectAxe, checkA11y } from "axe-playwright";

const config: TestRunnerConfig = {
  async preVisit(page) {
    await injectAxe(page);
  },
  async postVisit(page) {
    await checkA11y(page, "#storybook-root", {
      detailedReport: true,
      detailedReportOptions: {
        html: true,
      },
    });
  },
};

export default config;
```

## APIs, Context, and External Dependencies

### Using Decorators for Context

- For mimicking context, we can use `decorators` either in `.storybook/preview.ts` if we want to provide the context to all our storybook components or we can even provide it to specific stories as follows:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { TaskList } from "./task-list";
import { TaskListProvider } from "./task-list-context";

const meta = {
  title: "Components/TaskList",
  component: TaskList,
  // 👇 an array since you may have multiple decorators
  decorators: [
    // 👇 Story is the story (duh!?!) and context is the runtime metadata object or also we can say the execution context for that specific story instance
    (Story, context) => {
      return (
        <TaskListProvider
          tasks={[
            { id: "1", title: "Task 1", completed: false },
            { id: "2", title: "Task 2", completed: true },
            { id: "3", title: "Task 3", completed: false },
          ]}
        >
          <Story {...context} />
        </TaskListProvider>
      );
    },
  ],
} as Meta<typeof TaskList>;

export default meta;
type Story = StoryObj<typeof TaskList>;

export const Default: Story = {};
```

### Using Loaders for Fetching from an API

- For getting a response from an API, we can use `loaders` which always run before rendering the story.

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { TaskList } from "./task-list";
import { TaskListProvider } from "./task-list-context";

const meta = {
  title: "Components/TaskList",
  component: TaskList,
  // 👇 an array since you may have multiple loaders
  loaders: [
    async () => {
      const tasks = await fetch(
        "https://jsonplaceholder.typicode.com/todos",
      ).then((res) => res.json());
      return { tasks }; //
    },
  ],
  decorators: [
    (Story, context) => {
      return (
        {/* 👇 for capturing task data from the loader */}
        <TaskListProvider tasks={context.loaded.tasks}>
          <Story {...context} />
        </TaskListProvider>
      );
    },
  ],
} as Meta<typeof TaskList>;

export default meta;
type Story = StoryObj<typeof TaskList>;

export const Default: Story = {};
```
