---
id: line-box-strut-sets-a-minimum-height
aliases: []
tags:
  - review-comments
  - css
  - typography
creation date: 2026-09-30 23:49
modification date: Wednesday 30th September 2026 23:49:21
---

## The idea
Every line inside a block container starts with an invisible zero-width "strut" that uses the container's own `font-size` and `line-height`. The line box can't be shorter than that strut, even when all the visible text is in a smaller inline child. So `<label style="font-size:14px; line-height:1.5"><span style="font-size:12px">Text</span></label>` is about 21px tall, not the 12px text's natural height.

## Example
```html
<!-- ~21px tall: the strut uses the label's 14px x 1.5 -->
<label class="text-sm leading-normal"><span class="text-xs leading-snug">All apps</span></label>

<!-- ~16.5px tall: the strut now uses 12px x 1.375 -->
<label class="text-xs leading-snug">All apps</label>
```

## Why it matters
Removing a wrapper and moving the typography onto the parent looks like a pure refactor, but the element's height changes. That shifts vertical alignment next to radios and checkboxes, and changes row rhythm in lists. The same effect explains "why is my icon row taller than the icon?": the parent's inherited font-size makes the strut taller.

## Rule of thumb
If a container's own font-size or line-height differs from its content's, the container sets the minimum line height. When flattening typography wrappers, compare the element's height, not just its classes. To stop a parent from inflating a line, set the parent's `line-height` (or `font-size`) to match its content, or use `display: flex`, which gets rid of the anonymous line box.
