---
id: descendant-selector-specificity
aliases: []
tags:
  - review-comments
  - css
  - tailwind
creation date: 2026-09-30 12:05
modification date: Wednesday 7th October 2026 13:23:55
---

## The idea
Styling children from a parent with a descendant selector (in [[Tailwind CSS]], an arbitrary variant like `[&_td]:px-4` or `[&>li]:mb-2`) produces a rule with higher [[CSS Specificity]] than a single utility class on the child. The rule `.parent-class td:first-child` scores class + element + pseudo-class, while `.pl-2` on the `td` scores one class. The parent always wins. A class-merging helper can't help either, because the two classes live on different elements.

## Example
```tsx
// Trap: the table decides padding for every first cell, forever
<table className="[&_td:first-child]:pl-4">
  <tbody>
    <tr>
      {/* consumer wants a tighter checkbox column: ignored, pl-4 wins */}
      <td className="pl-2"><input type="checkbox" /></td>
    </tr>
  </tbody>
</table>

// Better: the cell owns its default, so a consumer class can replace it
const Cell = ({ className, ...props }) => (
  <td className={merge('first:pl-4', className)} {...props} />
)
<Cell className="pl-2" /> // merge() keeps pl-2 and drops pl-4
```

## Why it matters
Consumers end up reaching for `!important` to undo a default. The selector also matches elements you didn't mean to match, such as a nested table inside a cell or an empty-state cell that spans every column. The dependency is invisible from the child's code.

A variant of this trap keys the selector on an ARIA attribute, for example `[&>[role=status]]:pt-6` on a panel to push its loading skeleton down. That silently overrides a loader's own `pt-4`, pads any other status child (an empty state, a live message), and turns an accessibility attribute into a layout hook. A later a11y fix to the child then moves the layout. Let the loader own its spacing.

## Rule of thumb
Put a default on the element that owns it (`first:`, `last:`, `odd:` on the child itself). Use a parent-to-descendant selector only when consumers will never need to override it.
