---
id: Cn, twMerge, clsx, cva
aliases: []
tags:
  - video
creation date: 2026-06-15 09:32
modification date: Monday 15th June 2026 09:32:36
source: https://www.youtube.com/watch?v=h3s47owx8io
status:
  - in-progress
---

## clsx

- Helps us construct class names conditionally.

```ts
const classes = clsx({
  "bg-green-500": isCorrect,
  "bg-red-500": !isCorrect,
});
```

## twMerge

- Resolves conflicts on duplicate class names and it decides on the priority.

```ts
twMerge("border border-black p-4 border-red", props.className);
```

## cn

- Merges the functionality of `clsx` and `twMerge` allowing you to merge classes effectively and adding classes conditionally.

```ts
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

## cva

- `cva` or Class Variance Authority allows you to manage different variants of your components.
- A variant of a component is the various styles applied to a component changing it's look and feel without affecting it's functionality. e.g. you may have primary, secondary, ghost variants of a button etc.
