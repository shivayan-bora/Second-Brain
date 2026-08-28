---
title: Class Variance Authority (cva)
pillar: software-engineering
type: concept
tags: [css, cva, tailwind, component-variants]
status: in-progress
sources: ["[[design-systems-storybook-v2]]"]
created: 2026-08-16
updated: 2026-08-16
---

## Definition

[[Class Variance Authority (cva)]] is a [[CSS]] library for declaring a component's style variants (e.g. a button's `primary`/`secondary`/`destructive` and `small`/`medium`/`large`) as a structured schema — base classes plus a `variants` map plus `defaultVariants` — rather than hand-rolled conditional class strings.

## Why it matters

Manually composing variant class strings (even with `clsx`) scales poorly once a component has more than one variant axis (visual style × size × state). cva makes the variant surface declarative and typed, so the variant schema itself becomes the documentation and the type (`VariantProps`) instead of living implicitly in `if` branches.

## Mechanics / details

- `cva(baseClasses, { variants, defaultVariants })`: base classes always apply; `variants` is a map of variant-axis name → option name → class list; `defaultVariants` picks the option used when a prop is omitted.
- `VariantProps<typeof variants>` derives a component's variant prop types directly from the cva config — no separate type to keep in sync.
- The generated function (`variants({ variant, size })`) returns the composed class string for a given combination, typically fed straight into `className`.
- This sits one step up from `clsx`: `clsx` composes classes conditionally; cva adds the variant *schema* (named axes, defaults, derived types) on top.

## Examples

```ts
export const variants = cva(
  ["font-semibold", "border", "rounded", "shadow-sm", /* ...base */],
  {
    variants: {
      variant: {
        primary: ["bg-primary-600", "text-white", "hover:bg-primary-500"],
        secondary: ["bg-white", "text-slate-900", "hover:bg-slate-50"],
        destructive: ["bg-danger-600", "text-white", "hover:bg-danger-500"],
      },
      size: {
        small: ["px-2.5", "py-1.5", "text-xs"],
        medium: ["px-3", "py-2", "text-sm"],
        large: ["px-4", "py-2.5", "text-base"],
      },
    },
    defaultVariants: { variant: "secondary", size: "medium" },
  },
);
export type ButtonVariants = VariantProps<typeof variants>;
```

```tsx
export const Button = ({ variant = "primary", size = "medium", className, ...props }: ButtonProps) => (
  <button {...props} className={variants({ variant, size })} />
);
```

## Related

- [[design-tokens]] — the class values inside each cva variant are typically semantic/component tokens, not raw hex/utility values.
- [[storybook]] — a component's cva variants map naturally onto a story's `argTypes` (`variant` → `select`, etc.).

## Sources

- [[design-systems-storybook-v2]]
