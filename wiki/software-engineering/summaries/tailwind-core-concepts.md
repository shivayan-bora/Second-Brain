---
title: "Tailwind CSS — Core Concepts"
pillar: software-engineering
type: summary
tags: [documentation, tailwind, css, utility-first, design-tokens]
status: stable
source: "raw/documentation/tailwindcss.com/Tailwind CSS Core Concepts.md"
course: "Tailwind CSS documentation"
created: 2026-06-09
updated: 2026-06-09
---

# Tailwind CSS — Core Concepts

The conceptual anchor for the Tailwind cluster. Covers the [[utility-first-css|utility-first philosophy]], the Vite v4 install path, the "Big Four" utility categories (layout, spacing, typography, color), variants (`hover:`, `dark:`, `md:`), the [[tailwind-spacing-scale|spacing scale]], and the `clsx` + `tailwind-merge` composition pattern for component libraries.

## TL;DR

- **Utility-first**: encode your design tokens and a few patterns into single-purpose classes; compose them in JSX/HTML. See [[utility-first-css]].
- **Tailwind v4 install** is a Vite plugin + a single `@import "tailwindcss";` in your root CSS. No `tailwind.config.js` needed for the default theme.
- **Big Four utility categories**:
  1. **Layout & display** — `flex`, `grid`, `block`, `justify-*`, `items-*`, `gap-*`.
  2. **Spacing** — `p-*`, `m-*`, `px-*`/`py-*`, `space-y-*` between siblings.
  3. **Typography** — `text-*`, `font-*`, `leading-*`, text colors.
  4. **Color & background** — `bg-*`, `text-*`, `border-*`, `ring-*` for focus.
- **[[tailwind-variants|Variants]]** prefix utilities to gate them on state/media/attribute: `hover:bg-sky-700`, `dark:bg-slate-900`, `md:text-lg`, `[dir="rtl"]:text-right`. Stackable: `dark:md:hover:bg-fuchsia-600`.
- **[[tailwind-spacing-scale|Spacing scale]]**: `1 unit = 0.25rem = 4px`. Relative (`w-1/2`, `w-full`) and viewport (`w-screen`) variants also available.
- **[[tailwind-class-composition|Class composition]]**: `clsx` for conditional concatenation; `tailwind-merge` for resolving Tailwind-specific conflicts; the canonical `cn()` helper combines both.

## Key takeaways

- **Tradeoff acknowledged honestly**: verbose HTML and a learning curve are real costs of utility-first. The Big-Four mental map and consistent design tokens are the payoffs.
- **Variants compose by stacking** — order matters (`md:hover:` ≠ `hover:md:` in some edge cases; check generated CSS when surprised).
- **`@apply` and custom utilities** are mentioned implicitly (via `@import "tailwindcss"`) but not deeply covered here; they're the escape hatches when class lists get truly long.
- **Tailwind v4 uses CSS variables internally** — variants like `hover:bg-sky-700` compile to `&:hover { background-color: var(--color-sky-700); }`. This is the bridge to the [[css-custom-properties]] cluster.

## Notable passages

> "Encode your design tokens and a few patterns into a giant set of single-purpose utility CSS classes, and then compose them in JSX/HTML."
> — Tailwind CSS Core Concepts

> "Tailwind CSS goes through your files to figure out which classes you aren't using and then purges them from the resulting CSS file."

## Open questions

- The page mentions `tailwind-merge` resolves conflicts by [[css-specificity|specificity]]. The deeper rule is "later wins per conflict group" — what's the actual group definition? (E.g., `px-2 px-4` is one group; `px-2 py-4` is two.)
- When does a Tailwind class list grow long enough to justify extracting a CSS Module or a `cva`/`tailwind-variants` library? The doc doesn't draw the line.
- What does the `@apply` escape hatch cost in terms of generated CSS size? Tailwind purges per-utility, but `@apply`-expanded rules might survive even when unused in markup.

## Cross-references

- Concepts: [[utility-first-css]], [[tailwind-variants]], [[tailwind-spacing-scale]], [[tailwind-class-composition]], [[design-tokens]].
- Applied: [[tailwind-build-uis-that-dont-suck]] — the stretched-`<span>` pattern uses these primitives.
- Bridge: [[css-custom-properties]] — Tailwind v4 generates CSS variables internally.

## Source

- `raw/documentation/tailwindcss.com/Tailwind CSS Core Concepts.md`
