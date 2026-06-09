---
title: "Storybook Args and Controls"
pillar: software-engineering
type: concept
tags: [storybook, csf, props, devx]
status: stable
sources: ["[[intro-to-storybook]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Storybook Args and Controls

## Definition

**`args`** are the runtime values passed to a component within a [[story]] — essentially "pre-filled props for this visual state." The **Controls panel** is Storybook's auto-generated UI for tweaking those args at runtime, re-rendering the story as you change them. **`argTypes`** customize how each control renders (radio vs select, defaults, descriptions, actions).

## Why it matters

`args` + Controls turn a static story into an interactive playground. Designers can adjust `variant="primary"` to `variant="secondary"` with a click; developers can twiddle a `loading` boolean to see all four states without recompiling. The result: stories double as the documentation site's "try it" widget.

## Mechanics

### `args` — the data

```tsx
export const Primary: Story = {
  args: {
    variant: "primary",
    children: "Click me",
    disabled: false,
  },
};
```

`args` is a plain props object passed to the component when the story renders.

### Sharing args across stories

`meta`-level args apply to every story in the file:

```tsx
const meta: Meta<typeof Button> = {
  component: Button,
  args: {
    onClick: fn(),     // shared across all stories
    size: "md",
  },
};
```

Per-story args override `meta` args.

### Composing args from another story

```tsx
export const Pinned: Story = {
  args: {
    task: { ...Default.args.task, state: "TASK_PINNED" },
  },
};
```

Stories can read each other's args, letting variants extend a baseline rather than duplicate.

### `argTypes` — control customization

```tsx
const meta = {
  component: Button,
  argTypes: {
    variant: {
      control: { type: "radio" },
      options: ["primary", "secondary", "ghost"],
    },
    size: {
      control: { type: "select" },
      options: ["sm", "md", "lg"],
    },
    onClick: {
      action: "clicked",   // logs to Actions panel; no real handler needed
    },
  },
};
```

Storybook auto-infers `argTypes` from TypeScript types, but explicit `argTypes` give you finer control over the UI.

### Actions — capturing event handlers

```tsx
import { fn } from "storybook/test";

const meta = {
  args: {
    onClick: fn(),     // 👈 spy-like; logs invocation + arguments
  },
};
```

`fn()` creates a callback that:
- Shows up in the Actions panel when called.
- Records its arguments for inspection.
- Can be asserted in `play` functions (`expect(args.onClick).toHaveBeenCalled()`).

## The auto-generated Props table

For a TypeScript component, Storybook reads the prop types and renders a docs table with:
- Each prop's name, type, default, and description (from JSDoc).
- A live control for each prop.

This is the "free documentation" payoff: write `tags: ["autodocs"]` once, get a per-component docs page.

## Trade-offs

- **Pro:** zero ceremony — `args` is just an object.
- **Pro:** Controls UI is a designer-friendly way to explore the prop surface.
- **Pro:** Actions panel + `fn()` makes event handling visible without test infrastructure.
- **Con:** TypeScript inference for `argTypes` doesn't cover every shape (recursive types, complex unions); manual overrides needed.
- **Con:** `args` doesn't capture *implicit* state (a controlled component still needs the parent's `useState` story-side).

## Related

- [[story]] — the unit args belong to.
- [[storybook]] — the host environment.
- [[component-driven-development]] — args are how stories stay composable.

## Sources

- [[intro-to-storybook]]
