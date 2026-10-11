---
id: exclusive-variants-over-class-merge-overrides
aliases: []
tags:
  - review-comments
  - tailwind
  - css
  - component-api
creation date: 2026-09-30 23:49
modification date: Tuesday 6th October 2026 23:11:09
---

## The idea
With Tailwind plus `tailwind-merge`, it's tempting to always emit the "default" classes and add the alternative mode's classes on top, relying on the merge to delete the losers. That is additive styling. It only works while the merge config knows every class group involved and the override is appended last. Exclusive styling is safer: each mode emits only its own classes (or passes only its own component props), so nothing needs to be deleted.

## Example
```tsx
// Additive: always emits text-sm, then hopes text-xs removes it
<Text size="small" className={isCompact ? 'text-xs leading-snug' : ''} />

// Exclusive: each mode passes only what it needs
<Text {...(isCompact ? { variant: 'body2' } : { size: 'small' })} />
```
The same applies to design-system props. `className="h-6"` layered over a `size="md"` button or select only works because the merge removes `h-8`. `size="sm"` says what you mean and picks up future changes to that size.

A bigger version of the same smell: a caller passes a long `className` that replaces most of a library component's base look (display, width, padding, background, border, radius, shadow) to get a new design. That is a new variant built outside the library. Anything the merge doesn't replace, such as `gap-4` or `max-w-2xl`, still applies quietly, and the next screen copies the string. If the restyle also needs internal state (for example a minimize action), exporting the component's internal store so the caller can reach it makes things worse. Add the variant, plus an `asChild`/slot for the custom control, inside the library instead.
```tsx
// Smell: restyling a library panel wholesale from the call site
<Panel.Content className="flex w-auto px-4 py-2 rounded bg-surface shadow-md" />

// Better: the library owns the look
<Panel.Content variant="compact" />
```

## Why it matters
Additive styling breaks silently. A custom token missing from the merge config, a caller's class arriving later, or a component changing its default emits both classes, and CSS source order then decides the result. That can differ between builds.

## Rule of thumb
Switch styling at the prop or variant level, with one branch per mode. Use the class merger to resolve caller overrides, not to undo your own defaults. A ternary on a prop is fine when it's what keeps the branches exclusive.
