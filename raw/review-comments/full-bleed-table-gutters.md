---
id: full-bleed-table-gutters
aliases: []
tags:
  - review-comments
  - css
  - layout
creation date: 2026-09-30 23:18
modification date: Wednesday 30th September 2026 23:18:00
---

## The idea
A "full-bleed" table runs edge to edge so row borders, hover backgrounds and sticky headers span the whole width. Content above and below it (toolbar, pagination) keeps a page gutter. For the text to line up, the table can't pad its container (that would shrink the borders and backgrounds too). Instead, it insets the **first and last cells** by the same gutter. Both edges matter: if only the first cell is inset, left edges align but the last column's content ends closer to the edge than the toolbar's right-hand buttons.

## Example
```tsx
const GUTTER = 'px-4'            // page gutter used by toolbar and pagination
const CELL_INSET = 'first:pl-4 last:pr-4' // keep in sync with GUTTER

<div className={GUTTER}><Toolbar /></div>
<table className="w-full">
  <tbody>
    <tr className="border-b hover:bg-gray-50">   {/* spans edge to edge */}
      <td className={`px-2 ${CELL_INSET}`}>Name</td>
      <td className={`px-2 ${CELL_INSET}`}>Role</td>
      <td className={`px-2 text-right ${CELL_INSET}`}>Actions</td>
    </tr>
  </tbody>
</table>
<div className={GUTTER}><Pagination /></div>
```
Put the inset on the cell (`first:`/`last:`), not on the table through `[&_td:first-child]`, so a column that needs different padding can override it.

## Why it matters
Misaligned edges of a few pixels are easy to miss in code review and in unit tests (jsdom has no layout), but they're obvious on screen. A one-sided inset also leaves every right-aligned action column hand-padding itself, which is the scattered per-call-site styling the full-bleed pattern was meant to remove.

## Rule of thumb
Full-bleed table = full-width rows + first/last cell inset equal to the page gutter, on both sides, defined next to the gutter constant.
