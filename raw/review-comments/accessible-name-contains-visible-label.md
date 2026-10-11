---
id: accessible-name-contains-visible-label
aliases: []
tags:
  - review-comments
  - accessibility
creation date: 2026-10-01 14:30
modification date: Thursday 1st October 2026 14:30:11
---

## The idea
When a control shows text, its [[Accessible Name]] must include that text, ideally at the start (WCAG 2.5.3 Label in Name). `aria-label` does not add to the visible text, it replaces it as the name. So a button that shows "+3" but has `aria-label="Show 3 more categories"` is named only "Show 3 more categories".

## Example
```tsx
// Trap: the visible text is not part of the name
<button aria-label="Show 3 more categories">+3</button>

// Better: keep the visible text as the name, add context as a description
<button aria-describedby={hintId}>+3</button>
<span id={hintId} hidden>Show 3 more categories</span>

// Also fine: name starts with what is shown
<button>+3<span className="sr-only"> more categories</span></button>
```

## Why it matters
Voice-control users say what they see ("click plus three"). If the name doesn't contain the visible label, the command doesn't match. Sighted screen-reader users also get confused when what they hear differs from what they see.

## Rule of thumb
Use `aria-label` only for controls with no visible text (icon buttons). If there is visible text, let it be the name and put extra context in `aria-describedby` or visually hidden text appended after it. See [[WCAG]].
