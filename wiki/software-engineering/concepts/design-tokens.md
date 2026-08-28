---
title: Design Tokens
pillar: software-engineering
type: concept
tags: [design-systems, tokens, theming, css]
status: in-progress
sources: ["[[design-systems-storybook-v2]]"]
created: 2026-08-16
updated: 2026-08-16
---

## Definition

Design tokens are named abstractions over raw design values (colors, radii, shadows) that decouple *intent* from the literal value, arranged in layers: raw palette → semantic tokens (`primary`, `danger`) → component-specific aliases (`button-primary-hover`).

## Why it matters

Un-tokenized values (raw hex codes scattered through code) make theming and refactors brutal — every literal has to be found and reasoned about individually. Tokens are what let a design system support dark mode, high-contrast, or seasonal themes as a variable-swap instead of a component rewrite. This is one of the clearest levers a staff engineer has for turning a recurring, expensive manual process (re-theming) into a cheap, automatable one.

## Mechanics / details

- **Layering**: raw palette → semantic tokens (`primary`, `secondary`, `accent`, `info`, `success`, `warning`, `danger`) → component-color aliases (`button-primary-default`, `button-primary-hover`, `button-primary-active`, disabled/ghost/secondary variants).
- **Naming is the hard part.** No silver bullet — expect it to take real time (the source cites ~two months) and to differ per app.
- **Hide the raw palette.** If raw colors are reachable, they'll get used, undermining the whole system — restrict access to only the approved tokens.
- **Constrain choice generally**, not just for color — e.g. trim to a handful of border-radii and box-shadow options, since a large default set gets fully exploited and breaks visual consistency.
- **Implementation**: CSS variables are the mechanism — swapping variable values is what makes dark mode / high-contrast / seasonal themes cheap.
- **Design-to-code pipeline**: tokens generated from Figma variables via a variables-to-CSS plugin (with an "ignore aliases" step when introducing a new theme), keeping design and code from drifting apart.
- **Collaboration is foundational** — if designers use raw hex codes ad hoc, the token system breaks regardless of the engineering side. The convention has to be shared across design and engineering.
- **Payoff**: an initial ~six-week token refactor made a subsequent theme addition take ~6 hours (mostly tests + manual click-through); themes after that were nearly free.

## Examples

Tailwind dark-mode wiring driven by a token-style attribute switch, from the same source:

```ts
// tailwind.config.ts
darkMode: ["class", '[data-mode="dark"]'],
```

```ts
document.documentElement.setAttribute("data-mode", "dark"); // on
document.documentElement.removeAttribute("data-mode"); // off
```

Storybook documents a token layer directly via `ColorPalette`/`ColorItem` blocks, iterating over a `colors` token object.

## Related

- [[storybook]] — where token catalogs get documented/reviewed (`Tokens/Colors` doc pages).
- [[class-variance-authority]] — consumes semantic/component tokens as the values inside each variant's class list.

## Sources

- [[design-systems-storybook-v2]]
