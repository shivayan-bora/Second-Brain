---
title: React Components
pillar: software-engineering
type: concept
tags: [react, components, frontend]
status: in-progress
sources: ["[[epic-react-rf-03-custom-components]]", "[[react-dev-00-quick-start]]", "[[epic-react-rf-04-typescript]]"]
created: 2026-05-17
updated: 2026-05-17
---

# React Components

## Definition

A **React component** is a JavaScript function that accepts a single `props` object argument and returns renderable output — a React element, string, number, `null`, or an array of those. Components are reusable units of UI, the React analogue of "extract a function for code you'd otherwise repeat".

## Why it matters

Components are the only abstraction unit React provides — there are no layouts, controllers, or services in the framework itself. Everything compositional in a React codebase is "more components". Knowing the rules around capitalization, `children`, and how JSX maps to host vs component elements is the price of admission.

## Mechanics

### Authoring

```tsx
function Greeting(props) {
  return <h1>Hello, {props.name}</h1>
}

// usage:
<Greeting name='Shivayan' />
```

You can destructure props, type them (see [[react-typescript]]), and compose components however you like:

```tsx
function MyApp() {
  return (
    <div>
      <h1>Hello World!</h1>
      <MyButton />
    </div>
  )
}
```

### Capitalization decides host vs component

In JSX, capitalization is *the* signal that distinguishes a [[react-element-vs-component|component element]] from a host (DOM) element:

```tsx
element = <Capitalized />          // createElement(Capitalized)
element = <property.access />      // createElement(property.access)
element = <Property.Access />      // createElement(Property.Access)
element = <Property['Access'] />   // SyntaxError
element = <lowercase />            // createElement('lowercase')          ← treated as host
element = <kebab-case />           // createElement('kebab-case')          ← treated as host
element = <Upper-Kebab-Case />     // createElement('Upper-Kebab-Case')   ← treated as host (string)
element = <Upper_Snake_Case />     // createElement(Upper_Snake_Case)
element = <lower_snake_case />     // createElement('lower_snake_case')   ← treated as host
```

Rule of thumb: **PascalCase names = component, all-lowercase or kebab-case = host string**. Member-access (`a.b`) is always treated as a reference, regardless of case.

### The `children` prop

`children` is implicit in JSX — whatever sits between the opening and closing tags becomes `props.children`. These are equivalent:

```tsx
<Alert>Something went wrong!</Alert>
<Alert children="Something went wrong!" />
```

It accepts strings, numbers, elements, or arrays:

```tsx
<Message>
  <span>Hello</span> <span>World</span>
</Message>
// ≡
<Message children={[<span>Hello</span>, ' ', <span>World</span>]} />
```

You're not forced to use a prop *called* `children` — `<Message greeting={...} />` is fine. `children` is just the one with implicit JSX syntax.

### React calls components for you

When React encounters a component element during rendering, it calls the function with its props. Don't invoke a component as a plain function (`Greeting({ name: 'x' })`) — go through React (JSX or `createElement`) so hooks, reconciliation, and DevTools work.

## Examples

A component that wraps children:

```tsx
function Message({ children }) {
  return <div className="message">{children}</div>
}

const element = (
  <div className="container">
    <Message>Hello World</Message>
    <Message>Goodbye World</Message>
  </div>
)
```

A component accessed via a namespace object (legal because `property.access` defeats the lowercase-is-a-host rule):

```tsx
const component = { message }

<div className="container">
  <component.message>Hello World</component.message>
  <component.message>Goodbye World</component.message>
</div>
```

## Related

- [[react-element-vs-component]] — the conceptual contrast.
- [[react-jsx]] — how `<Foo />` becomes `createElement(Foo, ...)`.
- [[react-props]] — the argument shape.
- [[react-typescript]] — typing components and props.
- [[react-hooks]] — components are the only place hooks can live.

## Sources

- [[epic-react-rf-03-custom-components]] (`raw/courses/Epic React/React Fundamentals/03_Custom Components.md`)
- [[react-dev-00-quick-start]] (`raw/documentation/react.dev/00_Quick Start.md`)
- [[epic-react-rf-04-typescript]] (`raw/courses/Epic React/React Fundamentals/04_TypeScript.md`)
