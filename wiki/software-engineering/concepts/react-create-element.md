---
title: React.createElement
pillar: software-engineering
type: concept
tags: [react, api, frontend]
status: in-progress
sources: ["[[epic-react-rf-01-raw-react-apis]]", "[[epic-react-rf-02-using-jsx]]", "[[epic-react-rf-03-custom-components]]"]
created: 2026-05-17
updated: 2026-05-17
---

# `React.createElement`

## Definition

`React.createElement(type, props, ...children)` is the low-level API that constructs a [[react-element-vs-component|React element]]. JSX is sugar that compiles down to exactly this call.

## Why it matters

- It's what JSX *is* — knowing `createElement` removes the magic from JSX and clarifies error messages and unusual patterns (e.g. `property.access` components, dynamic `type`).
- The signature explains why props are an object and why `children` is special: it's just the rest parameter, optionally addressable as a named prop.

## Mechanics

Signature:

```ts
React.createElement(
  type,                // string for host elements ('div'), function for components (Greeting)
  props,               // object | null
  ...children          // rest-arg, flattened into props.children
)
```

The two forms are equivalent:

```js
createElement('div', { className: 'container' }, 'Hello World')
createElement('div', { className: 'container', children: 'Hello World' })
```

Children can be a string, number, element, or array of any of those:

```js
const helloSpan = createElement('span', {}, 'Hello')
const worldSpan = createElement('span', {}, 'World')
const element = createElement(
  'div',
  { className: 'container' },
  helloSpan,
  ' ',
  worldSpan,
)
```

Deeply nested trees are just deeply nested calls — which is exactly why [[react-jsx|JSX]] exists.

## Calling a component element

You don't have to use JSX to call a component — `createElement(Message, props, ...children)` works identically:

```tsx
function Message({ children }) {
  return <div className="message">{children}</div>
}

const element = (
  <div className="container">
    { React.createElement(Message, { children: 'Hello World' }) }
    { React.createElement(Message, null, 'Goodbye World') }
  </div>
)
```

## Related

- [[react-jsx]] — the surface syntax that compiles to `createElement`.
- [[react-element-vs-component]] — the object this returns.
- [[react-create-root]] — what mounts the resulting tree.
- [[dom-create-element]] — the imperative analogue in the browser.

## Sources

- [[epic-react-rf-01-raw-react-apis]] (`raw/courses/Epic React/React Fundamentals/01_Raw React APIs.md`)
- [[epic-react-rf-02-using-jsx]] (`raw/courses/Epic React/React Fundamentals/02_Using JSX.md`)
- [[epic-react-rf-03-custom-components]] (`raw/courses/Epic React/React Fundamentals/03_Custom Components.md`)
