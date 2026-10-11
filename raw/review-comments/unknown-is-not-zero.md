---
id: unknown-is-not-zero
aliases:
  - loading is not zero
tags:
  - review-comments
  - ux
  - react
creation date: 2026-10-02 12:08
modification date: Tuesday 6th October 2026 23:11:16
---

## The idea
`data?.total ?? 0` turns "we don't know yet" into "there are none". For a count, a total or a balance, `0` is a real answer, so a UI that shows it while the request is in flight (or after it failed) is stating something false. Keep "unknown" as its own value (`undefined`, or a separate loading/error state) and render it differently: hide the badge, show a skeleton, or show a dash.

## Example
```tsx
// Trap: zero while loading, then a jump to the real number
const count = query.data?.total ?? 0
return <Badge>{count}</Badge>

// Better: unknown stays unknown until the server answers
const count = query.data?.total // number | undefined
return count === undefined ? null : <Badge>{count}</Badge>
```
The same applies to empty lists: `items ?? []` is fine for mapping, but "no items yet" and "loaded, zero items" should not render the same empty state.

## Why it matters
Users read numbers literally. A tab that flashes "0" makes people think their data is gone, and a test that asserts `0` while loading locks the wrong behavior in. Treating loading and error the same way (both are "unknown") also keeps the component logic to one branch.

## Backend defaults hide "unknown" too
The same trap can come from the server. A non-null boolean whose column isn't populated yet arrives as `false`. A nullable date can mean both "never happened" and "the source doesn't report it". Render `false` as "No", or count `null` as "never", and the UI states as fact something nobody measured. Before writing labels like "Not risky" or "Never rotated", read the field's schema doc for what `false` and `null` actually mean. If they include "not reported", say "no X reported" or show a dash.

```tsx
// Trap: unscored rows look assessed and safe
cell: ({ value }) => (value ? 'Yes' : 'No')

// Better while the field isn't populated yet: say it's unknown
cell: () => '-' // with a tooltip like "Not available yet"
```

## Rule of thumb
Only coalesce to `0` when zero is the true answer. Otherwise carry `undefined` to the render and decide there. See [[Loading States]].
