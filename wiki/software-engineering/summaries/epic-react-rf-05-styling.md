---
title: "Epic React: Fundamentals ch05 — Styling"
pillar: software-engineering
type: summary
tags: [course, chapter, react, styling, css, typescript]
status: stable
source: "raw/courses/Epic React/React Fundamentals/05_Styling.md"
course: "Epic React — React Fundamentals"
created: 2026-06-09
updated: 2026-06-09
---

# Epic React: Fundamentals ch05 — Styling

Short chapter establishing the two canonical React styling primitives — `style` (inline) and `className` (external CSS) — and the JSX-vs-HTML attribute naming quirks. Closes with a TypeScript pattern for wrapping host elements while preserving full prop typing.

## TL;DR

- React surfaces **two primitive styling props**: `style` (object form, camelCased keys; mirrors `CSSStyleDeclaration`) and `className` (the string passed to the `class` attribute). See [[react-styling-options]].
- **JSX uses DOM property names, not HTML attribute names.** `class` → `className`, `for` → `htmlFor`, `tabindex` → `tabIndex`, `readonly` → `readOnly`. The rule: JSX matches the DOM's IDL, not the HTML source.
- **To wrap a host element preserving its prop surface**, borrow the type from React: `(props: React.ComponentProps<'div'>)`. You get autocomplete and type-safety for every HTML attribute the host accepts.
- Spread the rest of props through (`...rest`) so consumers can override `className`/`style` and pass arbitrary attributes (e.g., `data-*`, `aria-*`) without you enumerating them.

## Key takeaways

- The HTML-vs-DOM-vs-JSX naming gap trips up most beginners. JSX is closer to the DOM API than to the HTML you wrote in the markup file. See [[react-styling-options#Naming mismatch]].
- **Composition of `className`** is a manual responsibility: `\`box \${className}\`` is the canonical "extend, don't overwrite" pattern.
- **Composition of `style`** uses object spread: `{ fontStyle: 'italic', ...style }`. Same "extend, don't overwrite" intent.
- `React.ComponentProps<'div'>` is the right starting point for wrapping a host element. There's also `ComponentPropsWithRef<'div'>` and `ComponentPropsWithoutRef<'div'>` for ref-handling nuance (not covered here).

## Notable passages

> "When you want to wrap an element to basically simulate that element + a little functionality, you'll want to borrow the type definition for that element from React."
> — Epic React, *React Fundamentals ch. 5*

```tsx
const Box = (props: React.ComponentProps<'div'>) => {
  const { children, className, style, ...rest } = props;
  return (
    <div
      className={`box ${className}`}
      style={{ fontStyle: 'italic', ...style }}
      {...rest}
    >
      {children}
    </div>
  );
};
```

## Open questions

- CSS-in-JS, CSS modules, and Tailwind are all not covered in this chapter — Epic React's pedagogical choice. When does the course (or the user's stack) get to them?
- The `box ${className}` pattern doesn't dedupe utility classes; for Tailwind, the article notes pair with `clsx` + `tailwind-merge` — see [[tailwind-class-composition]].
- How does `ref` flow through `React.ComponentProps` vs `ComponentPropsWithoutRef` for `forwardRef`?

## Cross-references

- Fundamentals carried in: [[epic-react-rf-04-typescript]] (props typing baseline).
- Concepts: [[react-styling-options]], [[react-typescript]] (cross-link).

## Source

- `raw/courses/Epic React/React Fundamentals/05_Styling.md`
