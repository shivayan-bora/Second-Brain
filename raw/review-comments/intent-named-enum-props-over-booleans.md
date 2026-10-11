---
id: intent-named-enum-props-over-booleans
aliases: []
tags:
  - review-comments
  - react
  - component-api
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
Several boolean props that control one concern (`alignEnd`, `alignSelf`, `centered`) create combinations that mean nothing and names that leak the CSS mechanism into the API. This is [[Boolean Prop Proliferation]]. One enum prop, named for intent, has exactly the valid states and maps cleanly to [[class-variance-authority]] variants.

## Example
```tsx
// Trap
<Pagination alignEnd alignSelf />

// Better
type Placement = 'inline' | 'end' | 'stretch'
const pagination = cva('flex', {
  variants: { placement: { inline: '', end: 'justify-end', stretch: 'self-stretch' } },
  defaultVariants: { placement: 'inline' },
})
<Pagination placement="end" />
```

## Why it matters
Overlapping booleans are hard to document and easy to misuse, and every new option multiplies the combinations. Intent names survive a restyle, CSS names don't.

## Rule of thumb
If two booleans can't sensibly both be true, they should be one enum. Name props for what they mean, not for how they're styled.
