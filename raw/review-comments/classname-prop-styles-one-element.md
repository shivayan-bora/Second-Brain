---
id: classname-prop-styles-one-element
aliases: []
tags:
  - review-comments
  - react
  - component-api
  - css
creation date: 2026-09-30 10:15
modification date: Monday 5th October 2026 22:31:15
---

## The idea
A `className` prop is a promise about **which** element gets styled. If a component sometimes adds a wrapper `<div className>` only when `className` is passed, callers can't predict what they're styling, and a styling prop changes the DOM shape.

## Example
```tsx
// Trap
return className ? <div className={className}><Callout /></div> : <Callout />

// Better: forward to the root that already merges it
return <Callout className={className} />
```

A related trap is adding one className prop per internal part (`tagClassName`, `labelClassName`, ...) so a caller can restyle a shared component. Callers then need to know the component's internals, and any part without a prop (an overflow "+N more" button, say) keeps the old look. When a caller needs a different presentation, a semantic prop (`size="comfortable"`) that the component maps to every part's styles holds up better.

The same question comes up when a component grows a permanent wrapper (say, a clipping frame around a grid). If `className`, `ref` and rest props stay on the inner element, a caller's layout class (`mt-4`, `col-span-2`) now lands inside the wrapper instead of on the box that takes part in the parent's layout, and `ref` no longer points at the outermost node. Either move them to the new root (and add a semantic prop for the inner part), or document clearly which element they target.

## Why it matters
Changing the DOM shape based on a styling prop breaks layout (flex/grid children change), selectors and tests in surprising ways.

## Rule of thumb
`className` always goes on one known element, usually the root. Forward it, don't wrap with it. If callers need to restyle the inner parts, add a semantic variant, not a className per part.
