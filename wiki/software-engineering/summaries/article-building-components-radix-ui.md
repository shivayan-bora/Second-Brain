---
title: "Article — Building Components with Radix UI"
pillar: software-engineering
type: summary
tags: [article, radix, react, design-systems, headless-ui, primitives]
status: stable
source: "raw/articles/Building Components with Radix UI.md"
created: 2026-06-09
updated: 2026-06-09
---

# Article — Building Components with Radix UI

Refine.dev tour of Radix UI's four "building blocks" — **Primitives**, **Colors**, **Icons**, **Themes** — with concrete usage examples (Popover, Dialog, Slider, motion-animated Dialog).

## TL;DR

- Radix UI ships **four independent product lines**:
  - **[[radix-primitives|Primitives]]** — unstyled, accessible, low-level component behaviors (Dialog, Popover, Slider, Switch, Tabs…).
  - **Colors** — a 12-scale, semantically grouped palette in CSS + JS forms.
  - **Icons** — 300+ 15×15 SVG icons as React components.
  - **[[radix-themes|Themes]]** — a *pre-styled* component layer that sits on top of Primitives.
- **[[headless-component|Headless]]**: Primitives are styled by you. They handle accessibility (ARIA, focus management, keyboard) and state machines (open/closed, controlled/uncontrolled) — nothing visual.
- **[[compound-components|Compound components]]** are Radix's API shape: `<Dialog.Root>` containing `<Dialog.Trigger>`, `<Dialog.Portal>`, `<Dialog.Overlay>`, `<Dialog.Content>`, `<Dialog.Title>`, `<Dialog.Description>`, `<Dialog.Close>` — each piece focused on one slot.
- **Themes vs Primitives is a key choice.** Primitives = total control + your styling system. Themes = pre-styled + token-customization via CSS variables.

## Key takeaways

- **Radix's separation of behavior from style** is what makes it ubiquitous in modern React design systems. You compose: Radix Primitives (behavior) + Tailwind/CSS-in-JS (style) + Framer Motion (animation) + lucide/Radix Icons (graphics). Each layer is replaceable.
- **`data-state` attributes** are the styling hook for Radix state. `data-[state=open]:animate-fadeIn`, `data-[state=checked]:bg-sky-500` — your CSS reads Radix's state machine without prop-drilling.
- **Themes can nest.** `<Theme accentColor="cyan">` inside another `<Theme>` overrides for its subtree. Useful for "this side panel uses a different accent" without rebuilding components.
- **Reset and Slot** (under the Themes package) collapse opinionated browser defaults and forward children through wrappers. These pair with [[aschild-and-slot|`asChild`]] to merge wrappers with their child.

## Notable passages

> "Being a headless UI library means that Radix UI doesn't come shipped with any styles. Instead, we can use our preferred styling solutions to style the headless UI components to fit our brand and website requirements."

> "Radix Primitives focuses on a component's behavior rather than its style. Instead, we are in control of styling Radix components to match our taste and project requirements."

## Open questions

- How does Radix compare to **shadcn/ui** (which is essentially "Radix Primitives + Tailwind + copy-paste recipes")? Probably worth a future ingest on shadcn.
- Where's the line between "Radix Primitives + my styles" and "use Radix Themes"? The article suggests Themes for fast onboarding; Primitives when you have an existing design system.
- The article shows verbose `className` strings on the EditProfileDialog example. In a real codebase, what extracts these — [[tailwind-class-composition|cn() helpers]], CVA, Tailwind variants library?

## Cross-references

- Companion: [[build-ui-radix-00-animated-switch]] — applied Primitive with `data-state` styling.
- Concepts: [[radix-primitives]], [[radix-themes]], [[headless-component]], [[aschild-and-slot]], [[compound-components]], [[controlled-vs-uncontrolled]].
- Patterns: [[compound-component-pattern]], [[headless-ui-library]].

## Source

- `raw/articles/Building Components with Radix UI.md`
