---
title: "Tailwind Class Composition (`clsx`, `tailwind-merge`, `cn`)"
pillar: software-engineering
type: concept
tags: [css, tailwind, react, composition, helpers]
status: stable
sources: ["[[tailwind-core-concepts]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Tailwind Class Composition (`clsx`, `tailwind-merge`, `cn`)

## Definition

In a real Tailwind codebase, class lists are conditionally constructed from props and state, and consumer-supplied classes need to *override* the component's defaults rather than just sitting alongside them. **`clsx`** does the conditional concatenation; **`tailwind-merge`** resolves Tailwind-specific conflicts so the last-declared class wins per conflict group; the canonical **`cn()`** helper combines both.

## Why it matters

Without `tailwind-merge`, a component with `className="px-2"` whose consumer passes `className="px-4"` ends up with `class="px-2 px-4"` in the DOM. Browsers pick the *last-declared* per the stylesheet's source order — which is decided by Tailwind's build, not the order you wrote. The result: unpredictable overrides. The `cn()` helper is the small piece of glue that makes "consumer className wins" actually work.

## Mechanics

### `clsx` — conditional concatenation

```ts
import { clsx } from 'clsx';

clsx(
  'base',
  condition && 'extra',
  { 'bg-red-500': hasError, 'bg-green-500': !hasError }
);
// → "base extra bg-red-500"  (if condition && hasError)
```

- Strings: kept as-is.
- Falsy: dropped (`null`, `undefined`, `false`, `0`, `""`).
- Objects: keys are emitted only when the value is truthy.

`classnames` is an older alternative with the same API; `clsx` is slightly faster and smaller, which is why it's the de facto pick.

### `tailwind-merge` — conflict resolution

```ts
import { twMerge } from 'tailwind-merge';

twMerge('px-2 py-1', 'px-4');   // → "py-1 px-4"
twMerge('bg-red-500', 'bg-blue-500'); // → "bg-blue-500"
twMerge('px-2', 'p-4');         // → "p-4"   (p-* overrides px-* + py-*)
```

`tailwind-merge` knows Tailwind's conflict groups: `px-*` and `p-*` overlap, `bg-*` is a single group, `text-{size}` is separate from `text-{color}`, etc. It keeps the **last-declared** member of each group and drops the earlier ones.

### The canonical `cn()` helper

Most codebases combine the two:

```ts
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

This is the helper you'll see in shadcn/ui starter templates and most production Tailwind codebases.

### Usage in a component

```tsx
export function Button({
  className,
  variant = 'primary',
  ...props
}: ButtonProps) {
  return (
    <button
      {...props}
      className={cn(
        // base
        'inline-flex items-center justify-center rounded-md px-3 py-2',
        // variant
        variant === 'primary' && 'bg-brand-600 text-white hover:bg-brand-500',
        variant === 'ghost'   && 'bg-transparent text-slate-900 hover:bg-slate-100',
        // consumer override — must come LAST
        className,
      )}
    />
  );
}
```

Critical detail: `className` from props is the **last** argument so consumers can override defaults via Tailwind's conflict groups.

## Trade-offs

- **Pro:** consumers get predictable override semantics; conditional logic stays expressive.
- **Pro:** `tailwind-merge` is a few KB and runtime-cheap.
- **Con:** the conflict-group table can lag behind Tailwind plugin features — verify if you use custom utilities.
- **Con:** `cn(... className)` only works if you remember to put consumer className **last**. A common bug.

## Related

- [[utility-first-css]] — `cn()` is the runtime composition layer for utility-first.
- [[tailwind-variants]] — variants survive merging correctly (`hover:bg-red-500` and `hover:bg-blue-500` are one group).
- [[react-styling-options]] — for non-Tailwind class composition, the manual `\`box ${className}\`` pattern from Epic React applies.

## Sources

- [[tailwind-core-concepts]]
