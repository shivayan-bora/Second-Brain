---
id: absence-assertions-need-a-positive-twin
aliases: []
tags:
  - review-comments
  - testing
creation date: 2026-09-30 10:15
modification date: Friday 9th October 2026 19:41:00
---

## The idea
`expect(queryByText('X')).not.toBeInTheDocument()` passes if X is hidden correctly, but it also passes if X was renamed, removed everywhere, or never rendered at all. On its own, an absence assertion proves almost nothing. Pair it with a presence assertion for the case where X should appear (the other flag state, the other prop value).

## Example
```tsx
it.each([
  [true, 1],
  [false, 0],
])('with flag=%s shows %i unit labels', (flag, count) => {
  render(<Tiles flag={flag} />)
  expect(screen.queryAllByText('items')).toHaveLength(count)
})
```

## Why it matters
Tests that were moved or restructured often lose the positive twin and keep the negative one, and the suite stays green. An absence test for a deleted feature only fails if someone re-adds the exact old label.

Waiting for a loading marker to disappear has the same hole. `await waitFor(() => expect(container.querySelector('[aria-busy="true"]')).not.toBeInTheDocument())` passes on the first tick if the selector never matches anything, for example because the skeleton stopped setting that attribute. The test then asserts against a half-loaded screen. Wait for the loaded content to appear instead:

```tsx
render(<Dashboard />)
expect(await screen.findByText('512')).toBeInTheDocument() // the data, not the spinner
```

Renames cause a quieter version of this. When a label becomes flag-dependent (old text with the flag off, new text with it on), a mechanical find-and-replace updates the "hidden when gated off" test to query the new label. In the flag-off state only the old label could ever render, so the assertion can't fail, and the visibility gate it used to protect is now untested.

Delayed UI is another way to get a check that can't fail. Most tooltip libraries wait a few hundred milliseconds after the pointer arrives before opening (Radix defaults to 700ms), and toasts, debounced search results and hover cards behave the same way. A test that hovers and then immediately asserts "no tooltip" runs before the code that decides whether to open has even been called, so it passes whether or not that code works. Advance past the delay first, then assert:

```tsx
vi.useFakeTimers({ shouldAdvanceTime: true })
render(<Subtitle text="fits" />)

await user.hover(screen.getByText('fits'))
await vi.advanceTimersByTimeAsync(TOOLTIP_OPEN_DELAY_MS)

expect(screen.queryByRole('tooltip')).not.toBeInTheDocument()
```

The quick proof is to break the guard on purpose (always open) and confirm the test turns red. This trap often appears when a slow `await expect(findByRole(...)).rejects` is "simplified" into a sync `queryBy` right after the trigger: faster, but no longer testing anything.

## Rule of thumb
Every "does not render X" needs a "does render X" somewhere. When you move tests between `describe`s, diff the list of test names before and after. After a rename, check that each absence assertion queries the text that would actually render in that test's state. To wait for loading to finish, wait for the loaded content to appear, not for a loading marker to go away. For anything that appears after a delay, move the clock past the delay before asserting it is absent.
