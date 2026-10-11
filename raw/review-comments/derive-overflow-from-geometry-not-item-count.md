---
id: derive-overflow-from-geometry-not-item-count
aliases:
  - carousel arrows
tags:
  - review-comments
  - responsive-design
  - css
creation date: 2026-10-02 23:34
modification date: Friday 2nd October 2026 23:34:59
---

## The idea
In a responsive layout, "how many items fit" changes with the breakpoint. Any logic like "show the arrows / More button / fade when there are more than N items" encodes one breakpoint's answer. Overflow is a geometric fact, so read it from geometry: `scrollWidth > clientWidth`, plus `scrollLeft` for each end.

## Example
```ts
// Trap: right only where 5 cards fit per view
const canScrollNext = track.children.length > 5
  && track.scrollLeft + track.clientWidth < track.scrollWidth;

// Better: geometry alone, correct at every width
const canScrollPrev = track.scrollLeft > 1;
const canScrollNext = track.scrollLeft + track.clientWidth < track.scrollWidth - 1;

// Keep it fresh when the width or content changes
const ro = new ResizeObserver(update);
ro.observe(track);
track.addEventListener('scroll', update, { passive: true });
```
The 1px tolerance absorbs sub-pixel scroll positions at the end of the track.

## Why it matters
The count version fails silently on medium screens. Items sit off-screen while the controls say there is nothing more, and if the scrollbar is hidden (a common carousel style), mouse users have no way to reach those items. Item counts also lie when some children render nothing, for example items that hide themselves.

## Rule of thumb
If a UI decision depends on "does it fit?", measure fit: compare scroll size to client size, keep it fresh with a `ResizeObserver`, and test it in a real browser (jsdom reports 0 for all geometry). See [[ResizeObserver]] and [[Responsive Design]].
