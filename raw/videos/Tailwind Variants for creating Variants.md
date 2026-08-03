---
id: Tailwind Variants for creating Variants
aliases: []
tags:
  - video
creation date: 2026-06-14 19:35
modification date: Sunday 14th June 2026 19:35:18
source: https://www.youtube.com/watch?v=I5U4hq0CAR4
status:
  - in-progress
---

## Introduction

- Variants are multiple versions of the same component. e.g. in our design system, we might have different kinds of buttons like primary, secondary, ghost etc.
- [[Tailwind Variants]] allows us to define base styles using [[Tailwind CSS]] to have a consistent visual design of those different buttons but with specific styles for specific versions or variants.

## Installation

- To use Tailwind Variants, install the following packages: `pnpm install tailwind-variants tailwind-merge`
  - `tailwind-merge` allows us to merge classes together where it takes care of conflicting styles e.g. if we use two utility classes targeting the same [[CSS]] property.

## Usage

- To define variants:

```ts
const variants = tv({
  base: "w-24 rounded-lg hover:cursor-pointer", // 👈 base styles common to all variants
  // 👇 styles specific to each variant
  variants: {
    variant: {
      confirm: "bg-green-500",
      ghost: "border border-purple-500 text-purple-500",
      caution: "bg-yellow-500",
      danger: "bg-red-500",
    },
    size: {
      sm: "text-sm p-2",
      md: "text-lg p-4",
      lg: "text-2xl p-6",
    },
    disabled: {
      true: "opacity-25", // 👈 add this utility class when `disabled` is set to `true` : boolean variant
    },
  },
  // 👇 added when we want to add specific classes on a combination of multiple variants
  compoundVariants: [
    {
      variant: "confirm",
      disabled: true,
      class: "bg-green-100 text-green-700 dark:text-green-800", // You can also use "className"
    },
  ],
  // 👇 sets the default value of the variants in case a value isn't passed
  defaultVariants: {
    variant: "confirm",
    size: "md",
    disabled: false,
  },
});

type ButtonVariants = VariantProps<typeof variants>; // 👈 derive types from the variants
```

- To use these variants in a component:

```tsx
// 👇 add all props from the `button` HTML element, the variants and a `title` as well
type ButtonProps = ComponentProps<"button"> &
  ButtonVariants & {
    title: string;
  };

function Button({ title, ...props }: ButtonProps) {
  return (
    <button {...props} className={buttonVariants({ ...props })}>
      {title}
    </button>
  );
}
```
