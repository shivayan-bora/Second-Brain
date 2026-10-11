---
id: overlapping-state-variants-need-an-explicit-compound
aliases: []
tags:
  - review-comments
  - tailwind
  - css
creation date: 2026-10-06 20:59
modification date: Tuesday 6th October 2026 20:59:34
---

## The idea
Utility classes for different states, like `hover:` and `data-[state=active]:` or `aria-selected:`, each compile to one class plus one pseudo-class or attribute selector. They all have the same specificity (0,2,0). When an element is in both states at once, for example hovering the selected tab, CSS source order picks the winner. In Tailwind that order comes from the variant registration order. In v3, `data-*` and `aria-*` come after `hover`. That is a build detail, not a contract.

## Example
```tsx
// Works today only because data-* is emitted after hover
'text-muted hover:text-link-hover data-[state=active]:text-link'

// Says what the combined state should look like
'text-muted hover:text-link-hover data-[state=active]:text-link data-[state=active]:hover:text-link'
```
The stacked variant `data-[state=active]:hover:` produces `.x[data-state=active]:hover`, which has specificity 0,3,0. It wins no matter where it lands in the file.

## Why it matters
The hover color leaking onto the selected item is a common visual bug. It shows up after a Tailwind major upgrade, a custom variant plugin, or a switch between `data-*`, `aria-*` and `group-*` variants. Nothing in the markup changes, so code review and class-list tests won't catch it.

## Rule of thumb
If two state variants on one element can be true at the same time and set the same property, add the stacked variant for the combination. Don't rely on emit order to decide it.
