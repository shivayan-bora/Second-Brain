---
id: palette-colors-dont-follow-the-theme
aliases: []
tags:
  - review-comments
  - css
  - tailwind
  - design-tokens
creation date: 2026-09-30 10:17
modification date: Wednesday 7th October 2026 18:22:52
---

## The idea
A palette class like `bg-amber-3` or `bg-sand-2` is a fixed color. It stays the same when the theme switches, so in dark mode that surface stays light while everything around it goes dark. A [[Design Tokens|semantic token]] (`bg-surface-warning`, `text-muted`) names a **role**, and each theme maps the role to a different palette step. The workshop note [[tailwind-css-color-tokens]] covers how to set up the token layer; this note is about catching the leak in review.

## Example
```css
/* Token layer: one role, a value per theme */
:root { --surface-warning: var(--amber-3); }
.dark { --surface-warning: var(--amber-dark-3); }
```
```tsx
// Trap: correct in light mode, wrong in dark mode
<span className="bg-amber-3 text-amber-11">Pending</span>

// Better
<span className="bg-surface-warning text-on-warning">Pending</span>
```

## Why it matters
A redesign built only in light mode looks finished until someone switches themes. Categorical colors (chart series, tags by type) are where this most often slips through, because there's often no semantic token for them yet. If there isn't one, add the role (`--category-1`) with values for each theme instead of hard-coding the palette step.

## Swapping a palette class for a role changes the theme that already worked
When you replace a palette class to fix dark mode, the new role has a value in light mode too, and it is rarely the same step. Swapping `text-stone-11` (a mid grey) for `text-primary` (near-black) fixes dark mode and quietly darkens every light-mode label that used it. In a shared component that means every caller.
```tsx
// Trap: fixes dark mode, also changes light mode from grey to near-black
const heading = cva('', { variants: { level: { h100: 'text-primary' } } })

// Better: pick the role whose LIGHT value matches the old palette step,
// then check its dark value for contrast (or ask design for the role)
const heading = cva('', { variants: { level: { h100: 'text-secondary' } } })
```
Before approving a swap, compare old and new for both themes: the theme that looked right should look the same afterwards.

## Rule of thumb
In components, reach for roles, never palette steps. When reviewing a restyle, grep for raw palette classes and toggle dark mode once before you approve. When swapping a palette class for a role, check that the role resolves to the same value in the theme that already looked right.
