---
title: "Headless Component"
pillar: software-engineering
type: concept
tags: [react, design-systems, headless-ui, patterns, library-design]
status: stable
sources: ["[[article-building-components-radix-ui]]", "[[build-ui-radix-00-animated-switch]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Headless Component

## Definition

A **headless component** ships *behavior* — state management, accessibility (ARIA, keyboard, focus), event handling — but **no styles**. Its consumers bring their own visual layer. The canonical examples are [[radix-primitives|Radix Primitives]], React Aria, TanStack Table, and Headless UI.

## Why it matters

The "behavior is hard, styling is taste" split is one of the most useful axes in component library design. Hand-rolling a Dialog correctly (focus trap, ARIA labelling, Escape handling, click-outside, mobile touch, screen-reader announcements) is genuinely hard. Styling it is mostly taste. Headless libraries let you buy the hard part and own the easy part.

## Properties of a headless component

- **No CSS shipped.** No `style` props with defaults, no opinionated class names, no theme system inside.
- **State machine inside.** Open/closed, selected/unselected, focused/blurred — managed correctly.
- **Accessibility correct.** ARIA roles, keyboard nav, focus management — done right by default.
- **Composition-friendly.** Compound components or render-props for slot APIs; `asChild`-style escape hatches for wrapper customization.
- **Both [[controlled-vs-uncontrolled|controlled and uncontrolled]] modes.**

## Examples in the ecosystem

| Library | Domain | Notes |
|---|---|---|
| **Radix Primitives** | General UI | Compound-component API, `asChild` |
| **React Aria** | General UI | Hooks-based (more low-level than Radix) |
| **Headless UI** | Tailwind ecosystem | Made by Tailwind Labs |
| **TanStack Table** | Data tables | Hooks-based API |
| **Downshift** | Comboboxes/autocomplete | Render-props API |
| **TanStack Virtual** | Virtualized lists | Hooks-based |
| **cmdk** | Command palettes | Composable like Radix |

## Trade-offs

### Pros

- **Hard things, done right.** The accessibility surface of a Dialog/Combobox/Tooltip is non-trivial; ceding it to a library is a clear win.
- **Style freedom.** Your design system, your tokens, your CSS architecture — all yours.
- **Composable across teams.** Two teams using Radix Dialog can share zero CSS but identical behavior.
- **Long-lived.** Behavior changes slowly; styles change often. Headless libraries age well.

### Cons

- **Verbose at the call site.** You write the full `className=` (or styled component, or...) every time, vs. a pre-styled `<Button variant="primary">`.
- **Mitigation: wrap them in your own pre-styled components** (`<MyButton>` that internally uses Radix + your styles), exposed to consumers as the friendly API. **shadcn/ui** is essentially this template applied to every Radix Primitive.
- **Versioning surface.** When the library updates its props or compound shape, your wrapper has to adapt.

## When to choose headless vs. pre-styled

- **Headless** — when you have (or are building) a design system, when your brand needs custom visual identity, when team taste in styling needs latitude.
- **Pre-styled** ([[radix-themes|Radix Themes]], Mantine, Chakra) — when speed matters more than visual identity, when there's no design team, for internal tools.

## Patterns built on top

- **shadcn/ui** = Radix Primitives + Tailwind + copy-paste recipes. Not a library you install; a code template you keep.
- **CVA (`class-variance-authority`)** — pair with headless components for typed variant tables.
- **tailwind-variants** — same idea, different DX.

## Related

- [[radix-primitives]] — the canonical headless library.
- [[headless-ui-library]] (pattern) — the design pattern formalized.
- [[aschild-and-slot]] — the composition trick most headless libs converge on.
- [[compound-components]] — the API shape most headless libs use.
- [[react-composition]] — composition as the orchestration mechanism.

## Sources

- [[article-building-components-radix-ui]]
- [[build-ui-radix-00-animated-switch]]
