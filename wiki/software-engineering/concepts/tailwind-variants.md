---
title: "Tailwind Variants (`hover:`, `md:`, `dark:`)"
pillar: software-engineering
type: concept
tags: [css, tailwind, variants, responsive, states]
status: stable
sources: ["[[tailwind-core-concepts]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Tailwind Variants (`hover:`, `md:`, `dark:`)

## Definition

**Variants** in Tailwind are prefixes that gate a utility class on a state, media query, attribute, or child selector. `hover:bg-sky-700` applies `background-color: var(--color-sky-700)` only when the element is hovered. Variants stack: `dark:md:hover:bg-fuchsia-600` chains three conditions.

## Why it matters

Variants are the mechanism that scales [[utility-first-css|utility-first]] to real-world UI. Without them, you'd need separate stylesheets for hover, dark mode, breakpoints, and ARIA states — re-introducing the multi-file cascade that utility-first set out to flatten.

## The variant categories

| Category | Examples | Maps to |
|---|---|---|
| **Pseudo-classes** | `hover:`, `focus:`, `active:`, `disabled:`, `first-child:` | `:hover`, `:focus`, etc. |
| **Pseudo-elements** | `before:`, `after:`, `placeholder:`, `selection:` | `::before`, `::after`, etc. |
| **Media / feature queries** | `sm:`, `md:`, `lg:`, `xl:`, `dark:`, `motion-reduce:` | Responsive breakpoints, dark mode, accessibility prefs |
| **Attribute selectors** | `[dir="rtl"]:`, `[open]:`, `aria-disabled:` | `[attr]` |
| **Child / sibling** | `*:`, `[&>*]:` | descendant/sibling combinators |

## Mechanics

A variant prefix compiles to a scoped CSS rule:

```html
<button class="bg-sky-500 hover:bg-sky-700">Save</button>
```

```css
.hover\:bg-sky-700 {
  &:hover { background-color: var(--color-sky-700); }
}
```

The compiled rule is **only** active under the prefix's condition. The base class (`bg-sky-500`) remains active otherwise; CSS specificity / source order resolves which wins when both apply.

## Stacking

Variants chain by prefix-stacking:

```html
<button class="dark:md:hover:bg-fuchsia-600">Save</button>
```

Compiles to:

```css
.dark\:md\:hover\:bg-fuchsia-600 {
  @media (min-width: 768px) {
    .dark & { &:hover { background-color: ...; } }
  }
}
```

In dark mode, at ≥768px, on hover → fuchsia. Conditions AND together.

### Order matters (mostly)

The conventional order is **`dark:` → media (`md:`) → state (`hover:`) → utility**. The compiled CSS is equivalent regardless, but the team-readable order helps reviewers.

## Common patterns

```html
<!-- Responsive layout -->
<div class="flex flex-col md:flex-row gap-4 md:gap-8" />

<!-- Dark mode -->
<div class="bg-white dark:bg-slate-900 text-slate-900 dark:text-white" />

<!-- Focus + hover -->
<button class="bg-blue-500 hover:bg-blue-600
               focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2" />

<!-- RTL handling -->
<div class="ml-4 [dir=rtl]:ml-0 [dir=rtl]:mr-4" />
```

## Pitfalls

- **Overstacking** kills readability. `dark:md:hover:focus-visible:peer-checked:[&>img]:scale-105` is technically legal and nearly unreadable. Refactor to a component if you reach four levels.
- **State variants do not mean state ownership** — `hover:bg-blue-500` is still purely visual. For actual interactive logic (open/closed, selected), use React state or `data-*` attributes and `data-[state=open]:` variants.

## Related

- [[utility-first-css]] — variants are how utility-first handles the full CSS state model.
- [[tailwind-spacing-scale]] — variants compose freely with the scale (`md:p-8`).
- [[tailwind-class-composition]] — composition helpers preserve variant prefixes correctly.

## Sources

- [[tailwind-core-concepts]]
