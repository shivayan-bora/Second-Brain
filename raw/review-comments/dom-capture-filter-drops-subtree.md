---
id: dom-capture-filter-drops-subtree
aliases: []
tags:
  - review-comments
  - dom
  - browser
creation date: 2026-09-30 10:23
modification date: Wednesday 30th September 2026 10:23:15
---

## The idea
DOM-to-image libraries such as `html-to-image` and `dom-to-image` clone the DOM tree and accept a `filter(node)` callback. When the filter returns `false` for a node, the clone skips that node **and all its descendants**, the same way `display: none` hides a whole branch. So an "exclude from export" marker affects everything under the element that carries it, not just that element.

## Example
```tsx
// Trap: meant to drop only the logo, but the marker sits on the row,
// so the label disappears from the exported image too
<div data-no-export>
  <img src={logoUrl} alt="" />
  <span>{label}</span>
</div>

// Better: mark the smallest element that should disappear
<div>
  <span data-no-export><img src={logoUrl} alt="" /></span>
  <span>{label}</span>
</div>

toBlob(node, {
  filter: (el) => !(el instanceof HTMLElement && el.dataset.noExport === 'true'),
});
```

## Why it matters
The live page looks fine, and unit tests in jsdom don't render images, so the missing text only shows up when someone pastes the exported PNG and finds unlabeled bars or empty rows. It is easy to hit when you add the marker to a wrapper "because it was convenient" or to cover a conditionally rendered child.

## Rule of thumb
A capture filter works on subtrees, so put the exclusion marker on the smallest element you want gone and check the exported image by eye. See [[DOM to Image Capture]].
