---
title: React Fragments
pillar: software-engineering
type: concept
tags: [react, jsx, fragments]
status: stable
sources: ["[[epic-react-rf-02-using-jsx]]", "[[react-dev-00-quick-start]]"]
created: 2026-05-17
updated: 2026-05-17
---

# React Fragments

## Definition

A **Fragment** is a React element that groups multiple children *without* adding an extra node to the DOM. The full form is `<React.Fragment>...</React.Fragment>`; the shorthand is `<>...</>`.

## Why it matters

JSX requires every component to return a single root element. A naive fix is to wrap siblings in a `<div>`, but that pollutes the DOM with markup that exists only to satisfy the parser — and it can break CSS selectors, flexbox layouts, and grid placement. Fragments give you the single-root that JSX requires without that cost.

## Mechanics

```jsx
function AboutPage() {
  return (
    <>
      <h1>About</h1>
      <p>Hello there. <br /> How do you do?</p>
    </>
  )
}
```

Equivalent verbose form:

```jsx
<React.Fragment>
  <h1>About</h1>
  <p>Hello there.</p>
</React.Fragment>
```

Use the verbose form when you need to pass a `key` prop (e.g. inside a `.map`): the shorthand `<>` does not accept attributes.

## When to reach for one

- Returning a list of `<tr>` from a component without breaking the table structure.
- Returning multiple top-level elements without wrapping in `<div>`.
- Anywhere a wrapper element would interfere with CSS or semantics.

## Related

- [[react-jsx]] — the single-root rule that motivates Fragments.

## Sources

- [[epic-react-rf-02-using-jsx]] (`raw/courses/Epic React/React Fundamentals/02_Using JSX.md`)
- [[react-dev-00-quick-start]] (`raw/documentation/react.dev/00_Quick Start.md`)
