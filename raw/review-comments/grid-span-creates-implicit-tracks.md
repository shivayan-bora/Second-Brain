---
id: grid-span-creates-implicit-tracks
aliases: []
tags:
  - review-comments
  - css
  - responsive-design
creation date: 2026-10-01 14:30
modification date: Friday 2nd October 2026 23:34:59
---

## The idea
In [[CSS Grid]], `grid-column: span 2` is not clamped to the number of columns you defined. If the grid only has one explicit column, the browser adds an implicit second column to fit the item. That implicit track is sized by `grid-auto-columns` (default `auto`), so the grid becomes wider than its container and the page scrolls sideways.

## Example
```html
<!-- Trap: one column on phones, but the featured card always spans two -->
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4">
  <article class="col-span-2">Featured</article>
  <article>Regular</article>
</div>

<!-- Better: only span once there are at least two columns -->
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4">
  <article class="sm:col-span-2">Featured</article>
  <article>Regular</article>
</div>
```
Plain CSS equivalent: put `grid-column: span 2` inside the same media query that sets `grid-template-columns: repeat(2, 1fr)`.

Dense packing makes it worse. With `grid-auto-flow: row dense` (Tailwind `grid-flow-row-dense`), the implicit column isn't left empty. Auto-placement treats it as a real track and backfills ordinary items into it, so a one-column phone layout becomes a lopsided two-column layout with an `auto`-sized second column. Adding `dense` to fix holes at wide widths can therefore break the narrowest width if the span isn't breakpoint-prefixed.

## Why it matters
The bug only appears at narrow widths (phones, split-screen windows, high browser zoom), so it slips past desktop testing. WCAG 1.4.10 Reflow expects content to work at 320 CSS pixels without horizontal scrolling. Spanning items also leave holes in the layout when auto-placement can't fit them, unless you use `grid-auto-flow: dense`.

## Rule of thumb
Every layout claim on a grid item (span, start line) needs the same breakpoint prefix as the column count it depends on. Test responsive grids at the narrowest breakpoint, not just the widest. See [[Responsive Design]].
