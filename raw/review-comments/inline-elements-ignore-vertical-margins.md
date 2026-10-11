---
id: inline-elements-ignore-vertical-margins
aliases: []
tags:
  - review-comments
  - css
  - layout
creation date: 2026-10-09 19:19
modification date: Friday 9th October 2026 19:25:00
---

## The idea
`margin-top` and `margin-bottom` have no effect on non-replaced inline elements (`span`, `a`, `strong`, ...). The line box ignores them. So `className="mb-6"` on a `span` is dead code that looks alive.

The moment that element becomes block-level (you swap `span` for `p`, swap a `Text` component for a `Paragraph` component, or add `block`/`flex`), the margin starts applying. Block margins between siblings also **collapse**: the gap is the larger of the two margins, not their sum.

## Example
```html
<!-- Before: the 24px bottom margin is ignored, gap = 16px from the div -->
<span class="mb-6">Intro text</span>
<div class="mt-4">Email field</div>

<!-- After: 24px and 16px collapse to 24px, so the gap grows by 8px -->
<p class="mb-6">Intro text</p>
<div class="mt-4">Email field</div>
```

## Why it matters
An element swap reads like a semantic or typography change in a diff, but it quietly revives styles that were doing nothing and changes spacing on every screen that renders it. It is easy to miss in review because the class list didn't change.

## Rule of thumb
When you change an element's display type, re-read every margin and width class on it as if it were new. Delete margins that were dead before, or confirm the new spacing on purpose.
