---
id: extract-when-copies-differ-only-in-data
aliases: []
tags:
  - review-comments
  - react
  - composition
  - maintainability
creation date: 2026-10-06 22:30
modification date: Wednesday 7th October 2026 18:22:52
---

## The idea
If two components have the same structure and differ only in the data they plug in (an image, a string, an icon), they are one component with props, not two components. You don't need to extract at the first copy. The second copy is the moment to do it, especially when you know more are coming. Also, don't solve it by bolting a variant onto a widely used primitive. Changing a primitive that many callers depend on restyles all of them. Add a small sibling component that builds on the primitive instead.

## Example
```tsx
// Trap: one file per page, identical apart from data
export const OrdersEmptyRow = ({ colSpan }: { readonly colSpan: number }) => (
  <tr><td colSpan={colSpan}><Empty image={ordersSvg} title={t`No orders yet`} /></td></tr>
)
export const UsersEmptyRow = ({ colSpan }: { readonly colSpan: number }) => (
  <tr><td colSpan={colSpan}><Empty image={usersSvg} title={t`No users found`} /></td></tr>
)

// Better: one component, data as props, tested once
interface IllustratedEmptyRowProps {
  readonly colSpan: number
  readonly imageSrc: string
  readonly title: string
}
export const IllustratedEmptyRow = ({ colSpan, imageSrc, title }: IllustratedEmptyRowProps) => (
  <tr><td colSpan={colSpan}><Empty image={imageSrc} title={title} /></td></tr>
)

// Call sites stay one line
<IllustratedEmptyRow colSpan={cols} imageSrc={ordersSvg} title={strings.noOrders} />
```

Copies also bite when the thing *around* them changes. If several pages paste the same floating box over a shared canvas and you restyle the canvas (say, for dark mode), every pasted copy has to be restyled in the same change. Update only the copy on the page you are working on and the others become the one mismatched element on their pages, on screens nobody re-checked.
```tsx
// Six pages each paste this over the shared <Chart />
<div className="absolute top-4 left-6 border rounded bg-white">...</div>

// One shared overlay, restyled once, adopted everywhere
export const ChartPagination = ({ children }: { readonly children: React.ReactNode }) => (
  <div className="absolute top-4 left-6 border rounded bg-surface border-default">{children}</div>
)
```

## Why it matters
Every copy comes with its own test file that asserts the same thing, so the cost grows with each new page. The copies also drift (different import paths, slightly different padding). The next design change then has to be applied N times, and the copy someone misses becomes a visible inconsistency. Leaving the base primitive untouched keeps the blast radius small, because only the callers that opt into the new component change.

## Rule of thumb
At the second copy, diff the two files. If only data differs, extract a component that takes that data as props, and put it next to the primitive it builds on, not inside it. Related: [[Composition Over Duplication]], [[Rule of Three]].
