---
id: dont-cancel-parent-gap-with-magic-margin
aliases: []
tags:
  - review-comments
  - css
  - layout
creation date: 2026-10-05 22:31
modification date: Wednesday 7th October 2026 20:55:00
---

## The idea
When two siblings need to touch (for example, so their 1px rules overlap) but the parent spaces its children with `gap` or `space-y`, it's tempting to give one child a negative margin equal to the parent's spacing plus the overlap (`-mb-[17px]` for `gap-4` + 1px). That hardcodes the parent's spacing value into the child. Change the parent's gap and the overlap silently becomes a gap or a double rule.

## Example
```html
<!-- Trap: the child knows the parent's gap -->
<main class="flex flex-col gap-4">
  <header class="border-b -mb-[17px]">...</header>
  <section class="border-y">...</section>
  <nav>...</nav>
</main>

<!-- Better: group the elements that must touch, so the gap doesn't apply between them -->
<main class="flex flex-col gap-4">
  <div>
    <header class="border-b">...</header>
    <section class="border-y -mt-px">...</section>
  </div>
  <nav>...</nav>
</main>
```
Watch the mechanism, too. In a flex or grid container, `gap` and margins add up. In normal block flow, `space-y` is a margin on the next sibling, and adjacent vertical margins collapse (largest positive plus most negative). The same hack can work for different reasons on two pages, and break differently.

A tell that you're fighting the layout is reaching for `!important`. With Tailwind v3, `space-y-6` compiles to `.space-y-6 > :not([hidden]) ~ :not([hidden]) { margin-top: 1.5rem }`. That selector has specificity (0,3,0), so a plain `mt-0` (0,1,0) on the child loses, and the "fix" becomes `!mt-0 !-mb-6`. Now the child depends on the parent's spacing value *and* beats every later override. If the parent switches to `flex flex-col gap-6`, the same child needs no `!` at all. When one shared component needs a different hack on each page that uses it, make those pages' containers consistent instead.

## Why it matters
The coupling is invisible, unit tests can't catch it (no layout in jsdom), and the arbitrary pixel value skips the spacing scale.

## Rule of thumb
If a child's margin is computed from its parent's spacing, restructure the layout instead. The only negative margin left should be the overlap itself (`-mt-px`).
