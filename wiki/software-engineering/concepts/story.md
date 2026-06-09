---
title: "Story (Storybook CSF)"
pillar: software-engineering
type: concept
tags: [storybook, csf, components, testing]
status: stable
sources: ["[[intro-to-storybook]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Story (Storybook CSF)

## Definition

A **story** is a named, isolated visual state of a component — `Primary`, `Disabled`, `WithIcon`, `Loading`. It's expressed in **Component Story Format (CSF)**: a TypeScript module that default-exports a `meta` object (which component, its title, optional decorators) and named-exports one story per visual state.

## Why it matters

Stories are the smallest unit of "design intent that can be inspected, tested, and demoed." They're not just docs and not just tests — they're the canonical declarations of *"what does this component look like when X?"*, which is exactly the question a design system's consumers (and reviewers) need answered.

## Mechanics

### File shape — CSF

```tsx
// Button.stories.tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./Button";

const meta: Meta<typeof Button> = {
  title: "Components/Button",   // sidebar location
  component: Button,
  tags: ["autodocs"],            // generate docs page
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: {
    variant: "primary",
    children: "Primary Button",
  },
};

export const Secondary: Story = {
  args: { variant: "secondary", children: "Secondary Button" },
};
```

### The two halves

- **Default export (`meta`)** — what this file is about. Component reference, title (sidebar path), shared decorators, shared args, autodocs opt-in.
- **Named exports** — each is one story. Each names a visual state via [[args-and-controls|`args`]] (props to pass) and optional per-story decorators.

### What makes a "good" story

- **One clear visual state per story** — don't bundle multiple variants into one.
- **Args reflect realistic data** — not `"lorem ipsum"` for a Card that displays user info; use plausible fake data.
- **Named for the state, not the component** — `Loading`, `WithError`, `WithIcon` — not `Test1`, `Example`.
- **Args drive the difference, not custom render functions** — composability comes from the args/argTypes surface.

## Story-as-test-fixture

The Vitest addon (`@storybook/addon-vitest`) treats each story as a smoke test — it must mount without throwing. Optional `play` functions run interaction scripts:

```tsx
export const ClickToOpen: Story = {
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    await userEvent.click(canvas.getByRole("button"));
    expect(canvas.getByText("Opened")).toBeInTheDocument();
  },
};
```

The boundary between "story" and "test" blurs — stories without `play` are smoke tests; stories with `play` are interaction tests. Same file, both.

### Mock-handler `args` via `fn()`

```tsx
import { fn } from "storybook/test";

const meta = {
  component: Task,
  args: { onArchiveTask: fn(), onPinTask: fn() },
} satisfies Meta<typeof Task>;
```

`fn()` creates a callback that logs to the Actions panel and can be asserted in `play` functions.

### Excluding non-story exports

```tsx
export const ActionsData = { onArchiveTask: fn(), onPinTask: fn() };

const meta = {
  excludeStories: /.*Data%/,    // anything ending in "Data" isn't a story
};
```

## Trade-offs

- **Pro:** declarative — "what should it look like in state X" is just a value, not a procedure.
- **Pro:** stories survive component refactors that don't change the prop API.
- **Pro:** TypeScript-typed via `StoryObj<typeof Component>`.
- **Con:** can drift from real usage — a story shows a state that the actual app never produces.
- **Con:** writing stories for every meaningful state is real work; teams skip it.

## Related

- [[storybook]] — the host environment.
- [[args-and-controls]] — what makes stories tweakable.
- [[component-driven-development]] — the methodology that thrives on stories.
- [[react-components]] — what stories describe.

## Sources

- [[intro-to-storybook]]
