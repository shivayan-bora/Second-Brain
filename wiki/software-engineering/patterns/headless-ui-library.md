---
title: "Headless UI Library"
pillar: software-engineering
type: pattern
tags: [library-design, react, design-systems, headless-ui]
status: stable
sources: ["[[article-building-components-radix-ui]]", "[[build-ui-radix-00-animated-switch]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Headless UI Library

## Context

You're building a reusable UI component library — internal design system, npm package, framework — and the consumers will have different styling stacks (Tailwind, CSS Modules, CSS-in-JS, vanilla CSS) and different visual identities (one consumer's `Button` is rounded with shadow; another's is sharp and flat).

Meanwhile, the *behavior* parts of UI components (focus management, keyboard navigation, ARIA labelling, state machines, click-outside, mobile touch) are objectively hard to get right and surprisingly uniform across visual designs.

## Problem

Two failure modes you want to avoid:

### Failure mode 1 — pre-styled libraries with rigid theming

Material UI, Bootstrap, Chakra — they ship components with default styles that are *opinionated*. Customizing them deeply means:
- Fighting the theme system (which only goes so far before you're using `sx` overrides).
- Re-implementing the styles on top of the library's CSS (specificity wars).
- Eventually, ejecting the library entirely.

The library wins on speed-to-MVP and loses on long-run flexibility.

### Failure mode 2 — DIY components

Hand-roll your Dialog, Combobox, Tabs. You control styling. But:
- The accessibility surface is large; you'll forget keyboard nav, focus trap, ARIA roles, label associations.
- Every component is a fresh chance to ship a11y bugs.
- Maintenance is forever.

Wins on flexibility, loses on quality.

## Solution

Build (or adopt) a **headless UI library**: components that ship behavior, state, and accessibility — but *no styles*. Consumers bring their own styling stack and apply it via `className`, `data-*` attributes, and slot APIs.

### The shape

- **No CSS shipped** with the library.
- **State machine inside** — open/closed, selected/unselected, focused/blurred — managed correctly.
- **Accessibility correct by default** — ARIA roles, keyboard, focus management.
- **[[compound-component-pattern|Compound-component API]]** — `<Dialog.Root>`, `<Dialog.Trigger>`, etc.
- **[[aschild-and-slot|`asChild` / Slot]]** — let consumers swap the wrapper element with their own.
- **Both [[controlled-vs-uncontrolled|controlled and uncontrolled modes]]** for stateful components.
- **`data-state` attributes** for CSS-driven state styling (`data-[state=open]`, `data-[state=checked]`).
- **TypeScript-first** with strong types and ref-forwarding.

### Consumers compose

```tsx
// app code
<Dialog.Root>
  <Dialog.Trigger asChild>
    <MyDesignSystemButton variant="primary">Open</MyDesignSystemButton>
  </Dialog.Trigger>
  <Dialog.Portal>
    <Dialog.Overlay className="fixed inset-0 bg-black/50 data-[state=open]:animate-fadeIn" />
    <Dialog.Content className="fixed inset-0 m-auto h-fit w-96 rounded-lg bg-white p-6 shadow-xl">
      ...
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>
```

The library handles the hard parts (focus trap, Escape handling, click-outside, ARIA labels); the app handles the easy/taste parts (visual design).

## Trade-offs

### Pros

- **Quality bar.** Accessibility done right, once.
- **Style flexibility.** No theme-system fights; any styling stack works.
- **Long-lived.** Behavior changes slowly; visual styles change often. Headless libs age well.
- **Composable with motion, theme, and other libraries.** Add `<motion.div asChild>`, swap CSS for Tailwind, etc.
- **The library can be tiny per component.** Just behavior, no styles, no theme tokens.

### Cons

- **Verbose at the call site.** Long className strings everywhere — mitigation: wrap each compound in your own pre-styled component, expose that as the team-facing API.
- **Steeper onboarding.** New devs need to know both the library's compound shape *and* the team's styling conventions.
- **Less out-of-the-box opinionated.** Teams without design-system experience may flounder; the library doesn't tell them what looks good.

### When to use

- **Building a design system that needs custom visual identity.**
- **Components where accessibility correctness is critical (production user-facing UI).**
- **Want long-term flexibility over short-term speed.**

### When to skip

- **Speed-to-MVP over visual identity** — use [[radix-themes|Radix Themes]], Mantine, or Chakra.
- **Internal tools or rapid prototyping** — pre-styled libraries earn their keep.
- **You have neither design-system experience nor design support** — the freedom will produce inconsistency.

## Examples in the wild

- **Radix Primitives** — the React canonical example.
- **React Aria / React Aria Components** — Adobe's variant; lower-level (hooks-based) or higher-level (component-based).
- **Headless UI** — Tailwind Labs's smaller alternative.
- **TanStack Table / Virtual / Form** — same pattern applied to non-visual concerns.
- **Downshift / cmdk / vaul** — domain-specific headless components.
- **shadcn/ui** — not technically a library (it's copy-paste templates), but it sits on top of Radix Primitives and is the de-facto "headless + Tailwind" recipe.

## Related

- [[headless-component]] — the unit being shipped.
- [[radix-primitives]] — the canonical library implementing the pattern.
- [[compound-component-pattern]] — the API shape headless libraries use.
- [[aschild-and-slot]] — the slot-customization mechanism.

## Sources

- [[article-building-components-radix-ui]]
- [[build-ui-radix-00-animated-switch]]
