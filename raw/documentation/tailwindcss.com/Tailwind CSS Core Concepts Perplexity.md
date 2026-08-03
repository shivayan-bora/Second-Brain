---
id: Tailwind CSS Core Concepts Perplexity
aliases: []
tags:
  - chapter
creation date: 2026-06-06 15:45
modification date: Saturday 6th June 2026 15:45:33
status:
  - in-progress
---

## What is Tailwind CSS?

- It's a utility first [[CSS]] framework that allows us to style our [[HTML]] elements directly in our markup.
- The mental model of [[Tailwind CSS]] is `encode your design tokens and a few patterns into a giant set of single-purpose utility CSS classes, and then compose them in JSX/HTML`.
- Tailwind CSS goes through your files to figure out which classes yyou aren't using and then purges them from the resulting [[CSS]] file.

#### Advantages

- Rapid Prototyping: Style elements directly in HTML without switching files.
- Reduced Side Effects: Classes scoped to individual elements prevent styling conflicts.
- Reusability: Single-purpose classes work across the entire application.
- Maintainability: Effects of adding/removing classes are predictable and visible in markup.

#### Disadvantages

- Verbose HTML: Numerous class names can clutter markup.
- Learning Curve: Requires familiarity with utility class names.
- Lack of Semantics: Utility classes don't convey element meaning (mitigated by combining with semantic classes).

## Installation

- Create a [[React]] application with [[Vite]] and [[pnpm]]: `pnpm create vite`
- Install Tailwind CSS and it's Vite Plugin: `pnpm install tailwindcss @tailwindcss/vite`
- Add the plugin in the Vite configuration:

```js
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
});
```

- Add an `@import` to your root CSS i.e. `main.css` for Tailwind CSS:

```css
@import "tailwindcss";
```

- You can now start using the utility classes.

## Core Concepts

### Utility Classes

- In Tailwind, we can style components by combining multiple single-purpose presentational or utility classes directly in our markup.

```html
<div
  class="mx-auto flex max-w-sm items-center gap-x-4 rounded-xl bg-white p-6 shadow-lg outline outline-black/5 dark:bg-slate-800 dark:shadow-none dark:-outline-offset-1 dark:outline-white/10"
>
  <img class="size-12 shrink-0" src="/img/logo.svg" alt="ChitChat Logo" />
  <div>
    <div class="text-xl font-medium text-black dark:text-white">ChitChat</div>
    <p class="text-gray-500 dark:text-gray-400">You have a new message!</p>
  </div>
</div>
```

- In the above example we've used the following:
  - The display and padding utilities (`flex`, `shrink-0`, and `p-6`) to control the overall layout
  - The `max-width` and `margin` utilities (`max-w-sm` and `mx-auto`) to constrain the card width and center it horizontally
  - The `background-color`, `border-radius`, and `box-shadow` utilities (`bg-white`, `rounded-xl`, and `shadow-lg`) to style the card's appearance
  - The `width` and `height` utilities (`size-12`) to set the width and height of the logo image
  - The `gap` utilities (`gap-x-4`) to handle the spacing between the logo and the text
  - The `font-size`, `color`, and `font-weight` utilities (`text-xl`, `text-black`, `font-medium`, etc.) to style the card text

#### The Big Four utility Categories

##### Layout and Display

- Used for building and adjusting layouts.
- The most common ones:
  - `flex`, `inline-flex`, `grid`, `block`, `inline-block`,`hidden`
  - `justify-*` (`justify-start`, `justify-between`, `justify-center`)
  - `items-*` (`items-start`, `items-center`)
  - `gap-*` (gaps between flex/grid children)

```tsx
export function PageShell({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen flex flex-col bg-slate-50">
      <header className="flex items-center justify-between px-6 py-4 border-b border-slate-200">
        <span className="text-lg font-semibold">My App</span>
      </header>

      <main className="flex-1 flex">
        <aside className="w-64 border-r border-slate-200 p-4">Sidebar</aside>
        <section className="flex-1 p-6">{children}</section>
      </main>
    </div>
  );
}
```

##### Spacing

- To add spacing.
- All spacing is via a scale: `p-4`, `px-4`, `py-2`, `mt-6`, `space-y-4` (for vertical gaps between children).
  - `p-*`, `m-*` → padding/margin
  - `px-*`, `py-*`, `pt-*`, `pr-*`, etc.
  - `space-x-*`, `space-y-*` → add gaps between siblings without touching each child’s margin

```tsx
function Stack({ children }: { children: React.ReactNode }) {
  return <div className="space-y-4">{children}</div>;
}
```

##### Typography

- To deal with typography:
  - Font size: `text-xs`, `text-sm`, `text-base`, `text-lg`, `text-xl`, `text-2xl`…
  - Weight: `font-normal`, `font-medium`, `font-semibold`,`font-bold`
  - Line-height: `leading-5`, `leading-relaxed`, `leading-tight
-` Text color: `text-slate-900`, `text-slate-500`,`text-brand-600`

```tsx
export function Heading({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <h2 className={`text-lg font-semibold text-slate-900 ${className ?? ""}`}>
      {children}
    </h2>
  );
}
```

##### Color & Background

- For adding colors:
  - Text:`text-*`
  - Background:`bg-*`
  - Border: `border`,`border-*`
  - Ring (focus): `ring-*`,`ring-offset-*`

```html
<button
  class="
    inline-flex items-center justify-center
    px-3 py-2
    text-sm font-medium
    rounded-md
    bg-brand-600 text-white
    hover:bg-brand-500
    focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2
  "
>
  Save
</button>
```

### Variants

- These are prefixes that you add to add your Tailwind class conditionally e.g. which may target specific states:
  - Pseudo-classes, like `:hover`, `:focus`, `:first-child`, and`:required`
  - Pseudo-elements, like `::before`, `::after`, `::placeholder`, and `::selection`
  - Media and feature queries, like responsive breakpoints, dark mode, and `prefers-reduced-motion`
    - Breakpoints: `sm:`, `md:`, `lg:`, `xl:` map to theme screens
    - Dark mode: `dark:bg-slate-900`, etc.
  - Attribute selectors, like `[dir="rtl"]` and `[open]`
  - Child selectors, like `& > *` and `& *`

```html
<button class="bg-sky-500 hover:bg-sky-700 ...">Save changes</button>
```

- Generated CSS:

```css
.hover\:bg-sky-700 {
  &:hover {
    background-color: var(--color-sky-700);
  }
}
```

- The only job of this class is to provide `:hover` styles and nothing else.
- These variants can even be stacked to target more specific situations, for example changing the background color in dark mode, at the medium breakpoint, on hover:

```html
<button class="dark:md:hover:bg-fuchsia-600 ...">Save changes</button>
```

### Sizes

- Three types:
  - Fixed units: `1 unit = 0.25rem = 4px` (considering default browser settings)
  - Relative units: `[w/h]-1/2`, `[w/h]-1/4`, `[w/h]-full` etc.
  - Viewport units: `w-screen`, `h-screen` etc.

### Colors

- The colors are given in the following format: `<property>-<color>-<shade>` e.g. `bg-gray-100` for `background-color`.

### Responsive Design

- Every utility class in Tailwind can be applied conditionally at different breakpoints, which makes it a piece of cake to build complex responsive interfaces without ever leaving your HTML.
- First, make sure you've added the viewport meta tag to the <head> of your document:

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
```

- Then to add a utility but only have it take effect at a certain breakpoint, all you need to do is prefix the utility with the breakpoint name, followed by the `:` character:

```css
<img class="w-16 md:w-32 lg:w-48" src="..." />
```

- Here are all the available [breakpoints](https://tailwindcss.com/docs/responsive-design) available by default.

### React Class Composition Libraries

##### clsx and classnames

- These are tiny helpers to conditionally compose `className` strings based on props and state.
  - `clsx`: `clsx('base', condition && 'extra', {'bg-red-500': hasError})`
  - `classnames` is similar to `clsx` but it's slightly more verbose
    - `clsx` is just a popular alias because it's lightweight and fast

```tsx
import { clsx, type ClassValue } from "clsx";

type Variant = "primary" | "secondary" | "ghost";

const base =
  "inline-flex items-center justify-center rounded-md text-sm font-medium focus:outline-none focus:ring-2 focus:ring-offset-2";

const variantClasses: Record<Variant, ClassValue> = {
  primary: "bg-brand-600 text-white hover:bg-brand-500 focus:ring-brand-500",
  secondary:
    "bg-slate-100 text-slate-900 hover:bg-slate-200 focus:ring-slate-400",
  ghost:
    "bg-transparent text-slate-900 hover:bg-slate-100 focus:ring-slate-300",
};

export function Button({
  variant = "primary",
  className,
  ...props
}: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant }) {
  return (
    <button
      {...props}
      className={clsx(base, variantClasses[variant], "px-3 py-2", className)}
    />
  );
}
```

##### twMerge / tailwind-merge to resolve conflicts

- `clsx` just concatenates, `className="px-2 px-4"` => both exists, the browser picks last.
  - With conditional logic, we can accidentally duplicate conflicting utilities.
- `tailwind-merge`(`twMerge`) understands Tailwind's conflict rules and keeps only the one with higher [[CSS Specificity|specificity]] per group:

```ts
import { twMerge } from "tailwind-merge";
import { clsx, type ClassValue } from "clsx";

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

```tsx
export function Button({ className, ...props }: Props) {
  return (
    <button
      {...props}
      className={cn(
        "inline-flex items-center justify-center rounded-md px-3 py-2",
        "bg-brand-600 text-white hover:bg-brand-500",
        className,
      )}
    />
  );
}
```
