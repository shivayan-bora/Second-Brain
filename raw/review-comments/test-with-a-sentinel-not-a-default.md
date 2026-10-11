---
id: test-with-a-sentinel-not-a-default
aliases: []
tags:
  - review-comments
  - testing
creation date: 2026-09-30 23:45
modification date: Wednesday 30th September 2026 23:45:51
---

## The idea
To prove a prop is forwarded, pass a value the component could never produce on its own (a sentinel) and assert that. If the value you pass equals something the component already renders by default, the assertion passes whether or not the prop is wired up, so the test proves nothing.

## Example
```tsx
// Trap: the label already has font-medium by default
render(<Tags labelClassName='font-medium' />)
expect(label).toHaveClass('font-medium') // passes even if labelClassName is ignored

// Better: a value only the prop can introduce
render(<Tags labelClassName='test-label-class' />)
expect(label).toHaveClass('test-label-class')
```
The same applies to callbacks (assert on a unique argument), ids and text (use a value that doesn't appear in the component's defaults or fixtures).

## Why it matters
These tests show up as green coverage for a code path nobody is actually protecting. They usually come from copying a realistic value out of the production call site, which is often the default itself.

## Rule of thumb
Before trusting a "forwards X" test, ask whether it would still pass if X were deleted. If it would, change the input to a sentinel.
