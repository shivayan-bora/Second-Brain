---
title: "React Styling Options"
pillar: software-engineering
type: concept
tags: [react, styling, css, typescript]
status: stable
sources: ["[[epic-react-rf-05-styling]]"]
created: 2026-06-09
updated: 2026-06-09
---

# React Styling Options

## Definition

React itself ships **two primitive styling props**: `style` (an object whose keys are camelCased CSS properties) and `className` (a string passed through to the `class` HTML attribute). Everything else — CSS modules, Tailwind, CSS-in-JS, vanilla-extract — is built on top of these two primitives.

## Why it matters

The two primitives sound trivial, but a few details (HTML-vs-DOM-vs-JSX naming, composing `className` and `style` when wrapping host elements, typing the wrapper) come up in every component library. They're the floor you build the rest of your styling story on.

## Mechanics

### Inline styles — `style`

```tsx
<div style={{ marginTop: 20, backgroundColor: "blue" }} />
```

- Object form, not string.
- Keys are **camelCase** (`backgroundColor`), mirroring the DOM `CSSStyleDeclaration` API.
- Numeric values default to `px` for length properties.

### Class names — `className`

```tsx
<div className="my-class" />
```

- Maps to the HTML `class` attribute.
- React uses the DOM property name (`className`) not the HTML attribute name (`class`).

### Naming mismatch

JSX uses DOM property names, not HTML attribute names:

| HTML | DOM / JSX |
|---|---|
| `class` | `className` |
| `for` | `htmlFor` |
| `tabindex` | `tabIndex` |
| `readonly` | `readOnly` |

Rule: JSX follows the DOM's IDL casing, not the HTML source casing.

### Wrapping a host element with full type-safety

`React.ComponentProps<'div'>` borrows the type of all HTML attributes a `<div>` accepts, so a custom wrapper can re-expose them transparently:

```tsx
const Box = (props: React.ComponentProps<'div'>) => {
  const { children, className, style, ...rest } = props;
  return (
    <div
      className={`box ${className ?? ''}`}
      style={{ fontStyle: 'italic', ...style }}
      {...rest}
    >
      {children}
    </div>
  );
};
```

- `className`: extend via template literal (`box ${className}`) — caller's class wins last unless you flip the order.
- `style`: extend via object spread (`{ default, ...override }`) — caller wins last.
- `...rest`: forward `data-*`, `aria-*`, event handlers, `id`, etc., without enumerating them.

## Beyond the primitives

- **CSS modules** — `import styles from './Box.module.css'; <div className={styles.box} />`. Hashed class names for scoping.
- **CSS-in-JS** (styled-components, Emotion) — runtime-generated `className`s with the styles co-located.
- **Tailwind** — utility classes composed in `className`; see [[utility-first-css]] and [[tailwind-class-composition]] for the `clsx` + `tailwind-merge` pattern.
- **CSS variables** — see [[css-custom-properties]].

## Trade-offs

- **Inline `style`** — fast for one-off positioning or values driven by JS state. Loses CSS features (media queries, pseudo-selectors, cascading). No theming.
- **`className` + external CSS** — full CSS feature set, but cascade is global by default; needs CSS modules or naming discipline for scoping.

## Related

- [[react-components]] — the host element being styled.
- [[react-typescript]] — `React.ComponentProps<'div'>` is the type bridge.
- [[react-props]] — `style` and `className` are just props.

## Sources

- [[epic-react-rf-05-styling]]
