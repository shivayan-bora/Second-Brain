---
id: Tailwind CSS v4 Plus
aliases: []
tags:
  - course
creation date: 2026-06-10 18:43
modification date: Wednesday 10th June 2026 18:43:59
source: https://frontendmasters.com/courses/tailwind-css-v2/
status:
  - in-progress
---

- [[Tailwind CSS]] is a utility-first [[CSS]] framework.
  - Provides classes to target one property and modifies that instead of providing pre-made components.
  - It goes through your files to figure out which classes you're not using and then purges them from the resulting CSS file.
  - One downside is that utility classes don't convey the element's semantic meaning (can be mitigated by combining with semantic classes).
  - One presumed prerequisite is that we're using a component system that allows applying consistent styles across multiple instances, such as [[React]], [[Web Components]], or any framework that can reuse component definitions.
- Tailwind CSS is just plain CSS which is configured via [[CSS Variables]] and is framework agnostic.
- Links:
  - [Course Website](https://stevekinney.com/courses/tailwind)
  - [Course Repository](https://github.com/stevekinney/anthology)

## Why it works?

- Predictable Cascade: Utilities declared last in the cascade overrides the component and base styles without `!important`.
- Design Token Synergy: Tokens in `@theme(--color-primary-500)` are available in every utility.
- Rapid Iteration: [[Oxide]], built with [[Rust]], rebuilds styles in milliseconds.

## How it works?

- Treats files as plain text, which means no code parsing.
  - If you have a whole class name defined in a [[JavaScript]] or a [[TypeScript]] file, Tailwind will pick it up.
  - `text-${color}-600` won't work and we need to use the complete static class names (e.g. `text-blue-500`).
- Looks for tokens resembling class names.
- Generates CSS for recognized utilities.
- Tailwind scans all files except these:
  - `.gitignore` entries.
  - Binary files (images, videos, zips)
  - CSS files
  - Package manager lock files (e.g. `package-lock.json`)

> [!NOTE]
> You can use `safelist` or `allowlist` configuration to explicitly tell Tailwind to keep certain classes, even if they're not directly found in the codebase.

## Forcing Classes

```css
@import "tailwindcss";
@source inline("inline-block"); /* 👈 Don't strip out any `inline-block` CSS */
```

## Best Practices and Anti-Patterns

### Using CSS Layers

- When you use `@import "tailwindcss"`, it uses [[CSS]] layers, which is a modern CSS feature.
  - Layers are basically where you apply styles in layers and the one on the top has a higher priority than the bottom one. This helps in avoiding specificity issues and developers using `!important` all over the place in their code etc.
  - CSS layers are a modern CSS feature that organize cascading styles. The theme layer in Tailwind is special because CSS variables defined here become utility classes, allowing customization of default colors, font-sizes, and other design system properties.
- `@import "tailwindcss"` inject 4 layers in this order:
  - `@layer theme`: Design token variables
  - `@layer base`: Element resets and typography
    - The raw [[HTML]] elements like body, lists, input fields and other fundamental document structures.
    - However the Tailwind team recommends minimizing base layer styles and instead applying utility classes directly in markup.
  - `@layer components`: Reusable overrridable patterns
  - `@utility`: One-off helpers that behave like core utilities
- Tailwind has already defined the sequence of layers so it doesn't matter in which order you apply them.

### Configuration and Variants

- [[CSS Variables]] are the primary mechanism for styling in Tailwind CSS. By changing CSS variables in the theme layer, you can update styles globally across the entire application.
- You can add custom colors like brand colors in the theme layer, and change CSS variables to apply colors globally across the app. This allows you to define custom color shades and use classes like `'bg-brand'` instead of standard color classes.
  - Define tokens (e.g. `--color-primary`, `--spacing-4`, `--font-brand`) inside `@theme` using native CSS custom properties.
  - Reuse across all layers for single-source-of-truth styling.
  - Keep documentation near consuming code; no [[JavaScript]] configuration needed.

```css
@theme {
  --color-brand: #00adef;
}
```

- Responsive breakpoint prefixes automatically handle media queries for utility classes. By prefixing a class with `'md:'` or `'lg:'`, you can specify different styles for different viewport sizes without manually writing complex [[CSS Media Queries]].
  - Mobile-first: default rule, then `md:`, `lg:` prefixes
  - Combine state and media: `md:hover:bg-primary-600`

### Anti-Patterns

#### Creating one-off classes

```css
/* ❌ Anti-pattern in Tailwind v4 */
@layer components {
  .my-button {
    background: blue;
  }
}
/* hover:my-button won't work */

/* ✅ Correct approach */
@utility my-button {
  background: blue;
}
```

#### Sleeping on theming

```html
<!-- ❌ Anti-pattern: Magic Values -->
<!-- Good luck refactoring this! -->
<div class="bg-[#ff6b35] p-[123px] text-[14.5px]"></div>
```

```css
/* ✅ Define consistent tokens */
@theme {
  --color-brand: #fff6b35;
  --spacing-selection: 123px;
}
```

#### TL;DR

- Embrace the utility-first approach in your [[HTML]].
- Use component abstraction for reusability.
- Leverage `@theme` for consistent design tokens.
- Use `@utility` for custom utilities needing variant support. These are hooks to support variants and pseudo-classes.

## Element Styling, Borders, & Spacing

- Preflight in Tailwind is a feature that normalizes and strips out base styles that browsers automatically apply across different browsers, providing a consistent starting point for styling.
- `spacing-y` and `spacing-x`, given to a parent element like `flex`, puts in spacing between child elements in vertical and horizontal direction respectively using margins without adding a margin to the last element.
- `divide-x` and `divide-y` puts a divider between two child elements except the last child.
- Sometimes `flexbox` doesn't cut it because the children become flex items which can lead to unexpected results.

## Form Element Styling

- Variants for form element states:
  - `required:`
  - `invalid:` / `valid:`: Input validation state.
  - `user-invalid:` and `user-valid:`: Checks validity after the user has interacted with the input.
  - `in-range:` and `out-of-range:`: For use with number inputs
  - `disabled:` and `enabled:`
  - `read-only:`: Inputs that are read only.
  - `checked:`: Checkboxes/radios
  - `indeterminate:`: Partial selection with checkboxes.
  - `optional:`: Non-required fields.
  - `placeholder-shown:`: Styles for when the placeholder is visible.
  - `autofill:`: Inputs that the browser has automatically filled.
- Focus states:
  - `focus:` - Always shows (mouse & keyboard)
  - `focus-visible:` - Smart detection (keyboard only)
  - `focus-within:` - Parent styling when children focused
