---
id: pin-a-fix-with-a-regression-test
aliases: []
tags:
  - review-comments
  - testing
  - regressions
creation date: 2026-10-06 22:30
modification date: Wednesday 7th October 2026 20:46:04
---

## The idea
A bug that got through once already showed that no test covers that state. Fixing it by eye, or reverting the change that caused it, puts the code right but leaves the gap open. Add the smallest test that fails before the fix and passes after it. The test should describe the intended contract ("exactly one illustration on the empty screen"), not the markup.

## Example
```tsx
it('should show a single illustration before anything is generated', () => {
  render(<Generator />, { wrapper: NewDesignProvider })

  // decorative <img alt=""> has role "presentation"
  expect(screen.getAllByRole('presentation')).toHaveLength(1)
})
```
Run it against the pre-fix code once to confirm it really fails there.

When the fix is a revert of an earlier change, the earlier change's test already knows how to set up the tricky state (flags, mode, fixtures). Flip its expectation instead of deleting it:
```ts
// was: expect(screen.getByText('New Name')).toBeInTheDocument()
expect(screen.getByText('Old Name')).toBeInTheDocument()
expect(screen.queryByText('New Name')).not.toBeInTheDocument()
```

## Why it matters
Visual regressions often come from broad sweeps (a redesign, a new shared component rolled out to many screens) where nobody looks closely at each screen. Without a test, the next sweep can bring the same bug back, and the second time costs more because it's in production. When you claim a revert, check it too: compare blob hashes (`git rev-parse <old-sha>:<path>` vs `<new-sha>:<path>`) and grep for the assets or strings the reverted code stops using.

## Rule of thumb
Every bug fix ships with a test that would have caught the bug, written against the mode or configuration where it happened. Prefer role and count queries over class or structure checks. See [[Testing Observable Behavior]].
