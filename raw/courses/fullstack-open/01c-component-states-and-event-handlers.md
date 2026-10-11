---
id: 01c-component-states-and-event-handlers
aliases: []
tags:
  - chapter
creation date: 2026-09-30 10:27
modification date: "Wednesday 30th September 2026 10:27:02"
status:
  - completed
---

## Adding State to a component and an Event Handler

```tsx
import { useState } from "react";

function App() {
  const [counter, setCounter] = useState(0);

  const increment = () => {
    setCounter((prev) => prev + 1);
  };

  const decrement = () => {
    setCounter((prev) => prev - 1);
  };

  const reset = () => {
    setCounter(0);
  };

  return (
    <>
      <div>{counter}</div>
      <button onClick={increment}>Increment</button>
      <button onClick={decrement}>Decrement</button>
      <button onClick={reset}>Reset</button>
    </>
  );
}

export default App;
```

- The `useState` [[React.js Hooks|hook]] adds state to a component.
  - State is any piece of information held by a component. When this state changes, the component re-renders.
  - The argument passed to this function is the initial value of the state, so in this cause, the initial value of `counter` is 0.
  - This happens through a [[Virtual DOM]]. Virtual DOM diffs the component pre and post the state change and updates only those parts which changed.
    - The whole component re-renders, but only the counter's text node is updated in the real DOM.
- The `useState` hook returns an array with two values:
  - `counter`: The state.
  - `setCounter`: Function to update the state.
    - This is necessary since if we directly update `counter`, [[React.js]] will not know that the state has been updated and we need to re-render the component.
- To register a click handler to a `button`, we use the `onClick` prop. We pass the `increment` function reference to `onClick`.

> [!NOTE]
> `prev` above is the previous value of the state.
