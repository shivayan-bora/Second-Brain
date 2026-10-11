---
id: overflow-hidden-clips-focus-rings
aliases: []
tags:
  - review-comments
  - a11y
  - css
creation date: 2026-10-05 22:31
modification date: Monday 5th October 2026 22:31:15
---

## The idea
Focus rings are usually drawn outside the element, with `box-shadow` (Tailwind `ring-*`, `ring-offset-*`) or with `outline` plus a positive offset. Any ancestor with `overflow: hidden` (or `clip`, or `auto`/`scroll`) clips whatever extends past its padding box. Items flush against that ancestor's edge lose that part of the ring. In a tight grid (1px gaps), later siblings also paint over the earlier item's ring, because siblings paint in DOM order.

## Example
```html
<!-- Trap: a single row of focusable tiles inside a clipping frame -->
<div class="overflow-hidden border-y">
  <div class="grid grid-cols-5 gap-px">
    <button class="focus-visible:ring-1 focus-visible:ring-offset-1">A</button>
    <!-- top/bottom of every ring clipped; first tile's left clipped; right side covered by B -->
    <button class="focus-visible:ring-1 focus-visible:ring-offset-1">B</button>
  </div>
</div>

<!-- Better: draw the ring inside the item so no ancestor can clip it -->
<button class="focus-visible:ring-1 focus-visible:ring-inset">A</button>
```
Plain CSS equivalent: `box-shadow: inset 0 0 0 2px var(--focus)` or `outline-offset: -2px`.

## Why it matters
Focus visibility is a WCAG requirement (2.4.7). The bug only shows up with keyboard navigation in a real browser. jsdom has no layout or painting, so unit tests pass. It often arrives indirectly, when someone adds `overflow-hidden` for a visual trick (clipping edge borders, rounded corners) without noticing it now wraps interactive content.

## Rule of thumb
Before adding `overflow: hidden` around interactive children, tab through them. Inside clipped or tightly packed containers, use inset focus rings.
