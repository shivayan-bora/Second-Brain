---
id: override-size-through-the-component-api
aliases: []
tags:
  - review-comments
  - design-system
  - css
  - tailwind
creation date: 2026-09-30 23:48
modification date: Wednesday 30th September 2026 23:48:43
---

## The idea
When a design-system component has a size scale (`size="sm" | "md"`), its height is usually tied to other parts: input padding, chip height, icon size. Forcing one dimension from the outside with a utility class (`className="min-h-8"`) changes the box without changing those parts. It also only works while the caller's class wins the merge against the component's own variant classes. If two primitives that sit side by side (a select and a combobox) come out at different heights by default, that's a gap in the scale, and the fix belongs in the component.

## Example
```tsx
// Trap: one caller patches the height; every other caller keeps the gap
<Combobox.Trigger className="min-h-8">...</Combobox.Trigger>

// Better: pick a size the component already knows about...
<Combobox size="md">...</Combobox>

// ...or fix the scale once, in the component, so defaults line up
compoundVariants: [{ refreshed: true, size: 'sm', className: 'min-h-8' }]
```
With [[class-variance-authority]] plus [[tailwind-merge]], the caller's class "wins" only because the merge puts `className` last. If the component later moves the class onto a wrapper, or adds a more specific selector, the override stops working and nothing errors.

## Why it matters
Per-caller overrides fork the design system. The same primitive renders at different heights on different screens, and fixing the underlying gap later means hunting down every override. It also hides the problem from the component's owners, who never learn their defaults don't line up.

## Rule of thumb
Before overriding a component's size with a class, check whether a size prop already produces what you need. If none does, fix the scale in the component, or leave a comment and a ticket where you override it. See [[classname-prop-styles-one-element]].
