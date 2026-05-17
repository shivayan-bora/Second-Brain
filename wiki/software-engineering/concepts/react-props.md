---
title: Props
pillar: software-engineering
type: concept
tags: [react, props, frontend]
status: in-progress
sources: ["[[epic-react-rf-01-raw-react-apis]]", "[[epic-react-rf-02-using-jsx]]", "[[epic-react-rf-03-custom-components]]", "[[react-dev-00-quick-start]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Props

## Definition

**Props** ("properties") are the single object argument React passes to a component when rendering it. They are the only mechanism for a parent to send data, callbacks, or rendered output into a child. Props are read-only from the child's perspective — they belong to the parent.

## Why it matters

Props are how data flows down the tree. Combined with [[react-hooks|state]] flowing up via callbacks, they're the entire data model React gives you out of the box. Everything more elaborate — context, reducers, external state stores — is built on top.

## Mechanics

### Passing props

```tsx
<Greeting name="Shivayan" />
// transpiles to:
React.createElement(Greeting, { name: 'Shivayan' })

function Greeting(props) {
  return <h1>Hello, {props.name}</h1>
}
```

### `children` is just a prop

```tsx
<Message>Hello World</Message>
// ≡
<Message children="Hello World" />
```

The only thing special about `children` is that JSX gives it implicit syntax (the element body). Otherwise it's a normal prop — you could call it `greeting` or `body` and pass it explicitly. See [[react-components]].

### Spread

You can pass an object as a bundle of props:

```jsx
const props = { className: 'container', children: 'Hello World' }
<div {...props}></div>
```

Order matters — later attributes override earlier ones, in the order they appear:

```jsx
const a = { className: 'container', children: 'Hi' }
const b = { className: 'another-class' }

<div {...a}></div>              // class='container', text 'Hi'
<div {...a} {...b}></div>       // class='another-class', text 'Hi'
<div {...a} className='x'></div>           // class='x', text 'Hi'
<div {...a} className='x'>Bye</div>        // class='x', text 'Bye'
```

### Parent → child data flow

To share state across siblings, lift it to a common parent and pass `value` + `onChange`-style callbacks down:

```tsx
function App() {
  const [count, setCount] = useState(0)
  const handleClick = () => setCount(count + 1)

  return (
    <div>
      <MyButton count={count} onClick={handleClick} />
      <MyButton count={count} onClick={handleClick} />
    </div>
  )
}

const MyButton = ({ count, onClick }) => (
  <button onClick={onClick}>
    Clicked {count} {count === 1 ? 'time' : 'times'}
  </button>
)
```

Both buttons share the same `count` because they share a parent that owns the state.

### Default values (in TypeScript)

Defaults are typically set via destructuring:

```tsx
function Calculator({ left = 0, operator = '+', right = 0 }: CalculatorProps) {
  // ...
}
```

## Related

- [[react-components]] — what receives props.
- [[react-jsx]] — the syntax for passing them.
- [[react-typescript]] — typing props with `MessageProps`, `React.ReactNode`, etc.
- [[react-hooks]] — `useState` is the source of values that flow back down as props.

## Sources

- [[epic-react-rf-01-raw-react-apis]] (`raw/courses/Epic React/React Fundamentals/01_Raw React APIs.md`)
- [[epic-react-rf-02-using-jsx]] (`raw/courses/Epic React/React Fundamentals/02_Using JSX.md`)
- [[epic-react-rf-03-custom-components]] (`raw/courses/Epic React/React Fundamentals/03_Custom Components.md`)
- [[react-dev-00-quick-start]] (`raw/documentation/react.dev/00_Quick Start.md`)
