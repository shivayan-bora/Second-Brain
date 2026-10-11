---
id: empty-elements-still-take-gap
aliases:
  - empty placeholder adds spacing
tags:
  - review-comments
  - css
  - layout
creation date: 2026-10-01 12:57
modification date: Thursday 1st October 2026 12:57:42
---

## The idea
An empty `<div />` has no content and zero height, but it is still a box in the layout. In a flex or grid container it is an item, so `gap` puts space on both sides of it. In a block stack that uses the "lobotomized owl" sibling margin (`> * + *`, which is what Tailwind's `space-y-*` does), the element *after* the empty one still gets its top margin. A placeholder that is harmless in the layout it was made for, like a spacer that keeps `justify-content: space-between` pushing the next item to the right, adds unwanted space anywhere else.

## Example
```html
<!-- intended use: keeps the button on the right when there are no filters -->
<div style="display:flex; justify-content:space-between">
  <div></div>            <!-- placeholder -->
  <button>Export</button>
</div>

<!-- reused in a stack: the table is now pushed down by one gap -->
<div style="display:flex; flex-direction:column; gap:1rem">
  <div></div>            <!-- same placeholder, now an extra 1rem above the table -->
  <table>...</table>
</div>
```
In React, rendering `null` (or `false`) produces no DOM node, so it doesn't take part in spacing. An empty element does.

## Why it matters
These bugs are small, a stray 8 to 16px, but they make sibling pages look slightly inconsistent, and reviewers miss them because the element is invisible in DevTools' rendered view. They also usually come from a component meant for one layout being reused in another.

## Rule of thumb
To leave something out, render `null`, not an empty element. If a component returns a layout placeholder, document which [[flexbox]] layout it exists for, and use it only inside that layout. `:empty { display: none }` is a CSS-only escape hatch, but it hides the coupling instead of fixing it.
