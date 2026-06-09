---
title: "Design Tokens"
pillar: software-engineering
type: concept
tags: [design-systems, css, theming, abstraction]
status: stable
sources: ["[[tailwind-core-concepts]]", "[[scrimba-learn-css-variables]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Design Tokens

## Definition

A **design token** is a named, semantic value that captures a design decision — a color, a spacing step, a font size, a border radius, a shadow elevation — independent of how it's rendered. `color.brand.500`, `spacing.4`, `radius.md` are tokens. They're the design system's "API" for visual choices.

## Why it matters

Tokens are the abstraction layer that lets a design system survive its second redesign. When the brand color changes from blue to purple, you change `--color-brand-500` in one place and every consumer updates. Without tokens, the same change is a codebase-wide find-and-replace of hardcoded hex values — and you'll miss some.

## The two-layer model

Most mature token systems split into two layers:

1. **Primitive tokens** — the raw palette. `blue.500 = #2563eb`, `spacing.4 = 16px`. These are stable across designs and themes.
2. **Semantic tokens** — the design *intent*. `color.brand.primary → blue.500`, `color.surface.bg → gray.50`. These swap when the theme or brand changes.

Components consume **semantic** tokens (`bg-brand-primary`), never primitives directly. Themes are then just remappings of semantic-to-primitive.

## Concrete vehicles

Tokens are an abstract concept; you need a *vehicle* to express them in code:

- **[[css-custom-properties|CSS custom properties]]** — `--color-brand-500: #2563eb;`. Runtime-mutable, JS-readable, cascade-aware. The native browser answer.
- **[[utility-first-css|Tailwind utility classes]]** — `bg-brand-500`, `p-4`. Compile-time-resolved; the class taxonomy *is* the token catalog. Tailwind v4 compiles to CSS variables internally, so you get both layers for free.
- **JS object exports** — `theme.colors.brand[500]`. Used by CSS-in-JS (styled-components, Emotion) and design-token tooling like **Style Dictionary** for cross-platform output (web, iOS, Android).
- **JSON tokens** — vendor-neutral source format, often the input to Style Dictionary, Tokens Studio, or Theo.

## Examples

```css
/* Primitive layer */
:root {
  --blue-500: #2563eb;
  --gray-50:  #f9fafb;
  --space-4:  1rem;
}

/* Semantic layer */
:root {
  --color-brand:    var(--blue-500);
  --color-surface:  var(--gray-50);
  --spacing-card-y: var(--space-4);
}

/* Component consumption */
.card {
  background: var(--color-surface);
  padding: var(--spacing-card-y);
  border-color: var(--color-brand);
}
```

```css
/* Dark theme — only the semantic layer changes */
[data-theme="dark"] {
  --color-brand:   var(--blue-400);   /* slightly lighter for contrast */
  --color-surface: var(--gray-900);
}
```

## Trade-offs

- **Pro:** the design system has a stable, named API.
- **Pro:** themes and rebrands become single-file changes.
- **Pro:** designers and engineers can share a vocabulary (`brand-primary`, not `#2563eb`).
- **Con:** two layers means an extra hop when debugging — "why is this button blue?" → "because `--color-brand` → `--blue-500`" → "and `--blue-500` is `#2563eb`".
- **Con:** token sprawl is real. Every new design need tempts adding a new semantic token; without curation you end up with `--color-card-button-hover-shadow-2`. Treat tokens like API surface.

## When tokens earn their keep

- Multiple themes (light/dark/high-contrast).
- Multiple brands sharing a codebase.
- Cross-platform output (web + native).
- A design team that talks in design language, not hex codes.

For a single-app project with no theming plans, hardcoded values are fine. Don't pay the token-system tax until you need its leverage.

## Related

- [[css-custom-properties]] — the cleanest CSS-native vehicle.
- [[utility-first-css]] — Tailwind's class taxonomy *is* a token vocabulary.
- [[tailwind-spacing-scale]] — concrete example of a primitive-token catalog.

## Sources

- [[tailwind-core-concepts]] — "encode your design tokens into a giant set of single-purpose utility CSS classes."
- [[scrimba-learn-css-variables]] — CSS variables as the runtime theming vehicle.
