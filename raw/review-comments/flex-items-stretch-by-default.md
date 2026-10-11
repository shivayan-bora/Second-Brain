---
id: flex-items-stretch-by-default
aliases: []
tags:
  - review-comments
  - css
  - layout
creation date: 2026-09-30 23:45
modification date: Wednesday 7th October 2026 18:00:13
---

## The idea
A flex container defaults to `align-items: stretch`. Any child without an explicit cross-axis size (height in a row) grows to match the tallest item on its line. Inline elements also get blockified, so `display: inline-block` on a flex child doesn't matter. If one sibling becomes taller (say a pill goes from 20px to 28px), every sibling without its own height stretches with it, and its content stays at the top, where its padding puts it.

## Example
```html
<div class="flex flex-wrap gap-2">
  <span class="h-7 inline-flex items-center">a@x.com</span>
  <span class="h-7 inline-flex items-center">b@x.com</span>
  <!-- no height: stretches to 28px, text sits at the top because of py-0.5 -->
  <button class="inline-block py-0.5 text-xxs">+2 more</button>
</div>
```
Fixes: give the odd sibling the same height and centering (`h-7 inline-flex items-center`), or set `items-center` on the container so children keep their own height and sit centered.

### The reverse trap: an explicit height switches stretch off
Stretch only applies when the item's cross size is `auto`. `height: 100%` (`h-full`) is not `auto`, so the item does not stretch. And because the row's own height is auto (it comes from its content), the percentage has nothing to resolve against, so the item ends up at its content height. The classic symptom is "equal-height cards" that aren't equal:
```html
<!-- Trap: each wrapper is its own content height, so the card's h-full fills nothing extra -->
<div class="flex gap-2">
  <div class="relative flex-1 h-full"><article class="h-full">short</article></div>
  <div class="relative flex-1 h-full"><article class="h-full">much longer text...</article></div>
</div>

<!-- Better: let the wrapper stretch, make it a flex row, and let the card stretch inside it -->
<div class="flex gap-2">
  <div class="relative flex flex-1"><article class="flex-1">short</article></div>
  <div class="relative flex flex-1"><article class="flex-1">much longer text...</article></div>
</div>
```
Absolutely positioned children of the wrapper (a decorative border overlay, say) are out of flow, so turning the wrapper into a flex container doesn't move them. Prefer nesting flex containers over chaining `h-full`: a percentage height on a stretched grandchild only resolves when the browser treats the stretched size as definite, which depends on the container having a definite height.

## Why it matters
Resizing one kind of child in a row often looks right in the common case and wrong only when the extra sibling shows up (overflow counters, badges, "more" buttons). jsdom tests won't catch it because they have no layout.

## Rule of thumb
When you change the height of some children in a flex row, check every other child type that can appear in that row, and decide explicitly between `items-center` on the container and a matching height on each child. To make items match the tallest sibling, remove their explicit heights and let stretch do it; to fill a stretched item, make it a flex container instead of adding `h-full` to its child.
