---
title: React Element vs Component
pillar: software-engineering
type: concept
tags: [react, frontend, mental-model]
status: in-progress
sources: ["[[epic-react-rf-01-raw-react-apis]]", "[[epic-react-rf-03-custom-components]]", "[[react-dev-00-quick-start]]"]
created: 2026-05-17
updated: 2026-05-17
---

# React Element vs Component

## Definition

A **React element** is a plain JavaScript object that *describes* what should appear on screen — the output of `React.createElement(...)` or a JSX expression. A **React component** is a *function* (or, historically, a class) that *returns* one or more React elements when called with a `props` object.

Put differently: elements are the nouns, components are the factories. `<MyButton />` is JSX that becomes `React.createElement(MyButton, ...)` — a call that React will eventually invoke to obtain another element.

## Why it matters

This distinction is the single most useful piece of React vocabulary. Almost every "why doesn't this work?" question — capitalization rules, why props are an object, why children are special, why hooks must live in component bodies — falls out of clearly separating *element* (data) from *component* (function that produces data).

## Mechanics

### Elements

- Produced by `React.createElement(type, props, ...children)` or by JSX (which transpiles to the same call).
- Plain immutable objects of roughly the shape `{ type, props, key, ref, ... }`.
- Cheap to allocate and discard — React reconciles them against the previous render.

### Components

- Functions that take a `props` object and return renderable output (an element, string, number, `null`, or array of those).
- Convention: **PascalCase name**. JSX uses capitalization to decide whether `<foo />` means "create a host element `'foo'`" or "call the component `Foo`". See [[react-components]] for the full rule table.

```tsx
// component (function)
function Greeting(props) {
  return <h1>Hello, {props.name}</h1>
}

// element (object) — React creates this when JSX is transpiled
const element = <Greeting name="Shivayan" />
//             ≡ React.createElement(Greeting, { name: 'Shivayan' })
```

React calls the component function when it's ready to render the element. You don't invoke it yourself with `Greeting({ name: '...' })` — let React do it so it can manage hooks, memoization, and reconciliation.

## Examples

- `<div className="container">Hi</div>` is an element whose `type` is the string `'div'` (a host element).
- `<Greeting name="Shivayan" />` is an element whose `type` is the function `Greeting` (a component element).
- A component *renders* by returning more elements; React walks the resulting tree until every node has a string-typed (host) `type`.

## Related

- [[react-create-element]] — the API that produces elements.
- [[react-components]] — the function side.
- [[react-jsx]] — sugar over `createElement`.
- [[react-create-root]] — what consumes the top-level element to actually paint pixels.

## Sources

- [[epic-react-rf-01-raw-react-apis]] (`raw/courses/Epic React/React Fundamentals/01_Raw React APIs.md`)
- [[epic-react-rf-03-custom-components]] (`raw/courses/Epic React/React Fundamentals/03_Custom Components.md`)
- [[react-dev-00-quick-start]] (`raw/documentation/react.dev/00_Quick Start.md`)
