---
title: "Tailwind Spacing Scale"
pillar: software-engineering
type: concept
tags: [css, tailwind, spacing, design-tokens, rem]
status: stable
sources: ["[[tailwind-core-concepts]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Tailwind Spacing Scale

## Definition

Tailwind exposes spacing (padding, margin, width, height, gap, inset, etc.) as a **discrete numeric scale**: `1` = `0.25rem` = `4px` at default browser settings. Every spacing utility — `p-1`, `m-8`, `gap-12`, `w-64` — resolves to a value on this scale.

## Why it matters

The scale is what makes utility-first CSS deliver design-token consistency for free. You can't accidentally write `padding: 13px`; the closest legal value is `p-3` (12px) or `p-3.5` (14px). The grid lines up because everyone's stuck on the same scale.

## The unit math

| Class | Value (default `1rem` = `16px`) |
|---|---|
| `p-0`   | `0` |
| `p-px`  | `1px` |
| `p-0.5` | `0.125rem` = `2px` |
| `p-1`   | `0.25rem`  = `4px` |
| `p-2`   | `0.5rem`   = `8px` |
| `p-4`   | `1rem`     = `16px` |
| `p-8`   | `2rem`     = `32px` |
| `p-16`  | `4rem`     = `64px` |
| `p-64`  | `16rem`    = `256px` |

The relationship: `p-N` → `N * 0.25rem`.

`rem` (not `px`) means the scale **respects user font-size preferences**. A user who bumps their browser default from 16px to 20px sees a proportionally larger UI — accessibility wins for free.

## Categories

- **Padding** — `p-*`, `px-*` (x-axis), `py-*` (y-axis), `pt-*`/`pr-*`/`pb-*`/`pl-*` (per-side).
- **Margin** — `m-*`, with the same single-/per-side variants.
- **Gap** (flex/grid) — `gap-*`, `gap-x-*`, `gap-y-*`.
- **Space-between** (siblings without per-child margin) — `space-x-*`, `space-y-*`.
- **Width/height** — `w-*`, `h-*`, plus `min-w-*`, `max-w-*`, etc.
- **Inset** — `inset-*` (all four sides shorthand), `top-*`/`right-*`/`bottom-*`/`left-*`.

## Beyond the fixed scale

### Relative sizes

```html
<div class="w-1/2 h-full" />     <!-- 50%, 100% of parent -->
<div class="w-1/3" />             <!-- 33.333...% -->
```

### Viewport sizes

```html
<div class="w-screen h-screen" />  <!-- 100vw, 100vh -->
```

### Arbitrary values (escape hatch)

```html
<div class="p-[13px] w-[37.5%]" />
```

Use sparingly — every `[arbitrary]` value is a tiny defection from the design system. Reserve for cases where the design genuinely demands an off-scale value.

## `space-y-*` vs. parent gap — when to choose which

- **Use `gap-*`** when the parent is `flex` or `grid` — modern, no margin collapsing issues, supported everywhere relevant.
- **Use `space-y-*`** when the parent isn't `flex`/`grid` and you need vertical rhythm. The utility adds `margin-top` to all-but-first child via `:not(:first-child)`.

```tsx
function Stack({ children }) {
  return <div className="space-y-4">{children}</div>;
}
```

## Related

- [[utility-first-css]] — the spacing scale is the canonical "design tokens become utilities" example.
- [[design-tokens]] — spacing is one of the most token-friendly dimensions.
- [[tailwind-variants]] — `md:p-8` for responsive spacing.

## Sources

- [[tailwind-core-concepts]]
