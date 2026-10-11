---
id: flattening-a-wrapper-changes-style-precedence
aliases: []
tags:
  - review-comments
  - css
  - component-api
  - tailwind
creation date: 2026-09-30 23:49
modification date: Wednesday 30th September 2026 23:49:21
---

## The idea
A nested element is a precedence boundary. Styles set on the child itself always beat anything the parent sets or passes down by inheritance. So when a component puts its own typography on an inner wrapper and the caller's `className` on the outer element, the component wins every conflict. If you "simplify" by moving the component's classes onto the outer element and merging them with the caller's `className`, the caller's classes start winning instead, because merge helpers (`clsx` + `tailwind-merge`, cva's `className`) keep the last class in each group.

## Example
```tsx
// Before: component typography on the child, so caller's text-sm can't override it
<span className={cn('truncate', className)}>
  <span className="text-xs text-primary">{children}</span>
</span>

// After "flattening": the caller's text-sm is appended last and replaces text-xs
<span className={cn('truncate text-xs text-primary', className)}>{children}</span>
```

## Why it matters
The refactor looks like a no-op (the same classes, one fewer span), yet every caller that passed a conflicting class changes appearance. Those callers are usually not in the PR or its screenshots, so nobody notices.

## Rule of thumb
Moving styles between elements is a behavior change, not a cleanup. Before flattening, grep every caller that passes `className` and check for conflicts, or keep the inner element. It costs almost nothing and makes the component's styles non-overridable on purpose.
