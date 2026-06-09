---
title: React Hooks
pillar: software-engineering
type: concept
tags: [react, hooks, state]
status: stable
sources: ["[[react-dev-00-quick-start]]"]
created: 2026-05-17
updated: 2026-06-09
---

# React Hooks

## Definition

**Hooks** are functions, conventionally prefixed `use`, that let function [[react-components|components]] tap into React features — state, refs, lifecycle, context, etc. `useState`, `useEffect`, `useRef`, `useContext`, `useMemo`, `useReducer` are the built-ins; you can also write your own (`useFoo`).

## Why it matters

Hooks are the modern way to give function components persistent behavior between renders. Before hooks (React 16.8), state and lifecycle required class components. Hooks make function components fully featured — and they compose, so you can extract reusable stateful logic into a custom hook the same way you'd extract a function.

## Mechanics

### Rules of hooks

1. **Only call hooks at the top level** of a component or of another hook — never inside loops, conditions, or nested functions.
2. **Only call hooks from React function components or from other custom hooks** — not from plain JS functions or class components.

These rules let React rely on call-order to associate each hook with the right slot of internal state.

### `useState` (the canonical first hook)

`useState(initial)` returns a tuple: the current value and a setter.

```tsx
import { useState } from 'react'

function MyButton() {
  const [count, setCount] = useState(0)

  const handleClick = () => setCount(count + 1)

  return (
    <button onClick={handleClick}>
      Clicked {count} {count === 1 ? 'time' : 'times'}
    </button>
  )
}
```

- Calling the setter schedules a re-render.
- Each call to `useState` is independent — you can have many in one component.
- The initial value is used only on the first render; subsequent renders receive the current stored value.

### Event handlers go in component bodies

```tsx
function MyButton() {
  const handleClick = () => alert('Clicked!')
  return <button onClick={handleClick}>Click Me!</button>
}
```

The handler is just a JS function; React invokes it on the corresponding DOM event.

## Open questions

- Full semantics of `useEffect`, `useMemo`, `useCallback`, `useRef`, `useContext`, `useReducer` — to be added as later sources cover them.
- How `useState` updater functions (`setCount(c => c + 1)`) differ from value form — relevant once batching/concurrent rendering is covered.

## Related

- [[react-components]] — the only place hooks can live.
- [[react-props]] — state in a parent often flows back down as props.

## Sources

- [[react-dev-00-quick-start]] (`raw/documentation/react.dev/00_Quick Start.md`)
