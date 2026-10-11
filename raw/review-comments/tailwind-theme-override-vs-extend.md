---
id: tailwind-theme-override-vs-extend
aliases: []
tags:
  - review-comments
  - css
  - tailwind
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
In a [[Tailwind CSS]] config, keys under `theme` **replace** that whole scale, and keys under `theme.extend` **add** to it. If a preset sets `theme.lineHeight` to custom names, the default numeric scale disappears and `leading-5` quietly generates no CSS. There's no error, the class just does nothing.

## Example
```js
// Replaces: leading-4 / leading-5 no longer exist
theme: { lineHeight: { tight: '1.1', body: '1.5' } }

// Adds: defaults kept, custom names available too
theme: { extend: { lineHeight: { tight: '1.1', body: '1.5' } } }
```

## Why it matters
A class that emits nothing looks right in code review and shows up as "the fix didn't work" in the browser. In Tailwind v4 the same idea applies to `@theme` namespaces you reset with `--*: initial`.

## Rule of thumb
If a Tailwind class seems to do nothing, check whether the config replaced that scale instead of extending it. Inspect the generated CSS, don't trust the class name.
