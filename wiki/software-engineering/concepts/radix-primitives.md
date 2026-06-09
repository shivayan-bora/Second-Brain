---
title: "Radix Primitives"
pillar: software-engineering
type: concept
tags: [radix, react, headless-ui, accessibility, primitives]
status: stable
sources: ["[[article-building-components-radix-ui]]", "[[build-ui-radix-00-animated-switch]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Radix Primitives

## Definition

**Radix Primitives** is a collection of unstyled, accessible React components covering common UI elements: Dialog, Popover, Tooltip, Switch, Slider, Tabs, Dropdown Menu, Accordion, Select, and ~20 more. Each Primitive ships behavior (state machine, keyboard, focus management) and accessibility (ARIA, screen-reader announcements) — and **zero styling**.

## Why it matters

Primitives are the de-facto foundation of modern React design systems. Building a Dialog or Combobox correctly is genuinely hard — keyboard trap, focus restoration, ARIA labelling, Escape handling, click-outside, mobile touch. Radix ships all of that as composable hooks-free APIs; you bring the styles. This is the standard recipe behind **shadcn/ui**, **Mantine**, and most enterprise React design systems built since 2022.

## Mechanics

### Install per Primitive

```bash
pnpm install @radix-ui/react-dialog
pnpm install @radix-ui/react-switch
# or the meta-package — still tree-shakes
pnpm install @radix-ui/react
```

### [[compound-components|Compound component]] API

Each Primitive exposes a namespace of sub-components:

```tsx
import * as Dialog from "@radix-ui/react-dialog";

<Dialog.Root>
  <Dialog.Trigger>Open</Dialog.Trigger>
  <Dialog.Portal>
    <Dialog.Overlay />
    <Dialog.Content>
      <Dialog.Title>Title</Dialog.Title>
      <Dialog.Description>...</Dialog.Description>
      <Dialog.Close>Close</Dialog.Close>
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>
```

Each piece does one thing. You can omit ones you don't need (e.g., no `<Portal>` if you want inline rendering), and Radix handles the wiring.

### Styling hook: `data-state`

```html
<button data-state="open">…</button>
```

Tailwind reads it:

```html
<Dialog.Overlay class="data-[state=open]:animate-fadeIn data-[state=closed]:animate-fadeOut" />
```

Vanilla CSS reads it:

```css
[data-state="open"] { ... }
[data-state="closed"] { ... }
```

This is how style follows state — no React state needed in the styling layer.

### [[aschild-and-slot|`asChild` prop]]

Every Primitive trigger / content accepts `asChild`, which forwards its props and behavior to the child element instead of rendering its own wrapper:

```tsx
<Dialog.Trigger asChild>
  <button className="my-custom-button">Open</button>
</Dialog.Trigger>
```

See [[aschild-and-slot]] for why this matters.

### [[controlled-vs-uncontrolled|Controlled and uncontrolled]] modes

Every stateful Primitive exposes both. See [[controlled-vs-uncontrolled]] for the pattern.

## Features

- **Accessibility-first**: Keyboard navigation, focus management, ARIA roles, screen-reader announcements — built in.
- **Unstyled**: No CSS shipped. You apply Tailwind / CSS-in-JS / vanilla CSS / CSS Modules.
- **Tree-shakeable**: Import only what you use. The meta-package doesn't bloat the bundle.
- **Fully-typed**: TypeScript-first. Component props, events, ref-forwarding all typed.
- **Portal-friendly**: `Portal` sub-components escape stacking contexts cleanly.

## When to use vs alternatives

- ✅ Building a custom design system on top of unstyled primitives.
- ✅ Combining with Tailwind for utility-driven styling.
- ✅ Replacing hand-rolled Dialog/Combobox/Tooltip — Radix handles the accessibility you keep forgetting.
- ❌ Want pre-styled components out of the box → use [[radix-themes|Radix Themes]] or a styled library like Mantine, Chakra.
- ❌ Vue/Svelte/Solid project → look at framework-specific equivalents (radix-vue, Bits UI, Kobalte).

## Related

- [[radix-themes]] — pre-styled layer on top.
- [[headless-component]] — Radix is the canonical example.
- [[aschild-and-slot]] — the composition trick.
- [[compound-components]] — the API shape.
- [[controlled-vs-uncontrolled]] — every Primitive supports both.

## Sources

- [[article-building-components-radix-ui]] — full surface tour.
- [[build-ui-radix-00-animated-switch]] — applied Switch example.
