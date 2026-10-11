---
id: 03-custom-components
aliases: []
tags:
  - project
creation date: 2026-09-07 10:12
modification date: "Monday 7th September 2026 10:12:07"
repository:
status:
  - in-progress
---

- Components in [[React.js]] are functions that take in an object called `props` and return something that's renderable (more React elements, strings, null, numbers, etc.). e.g.

```tsx
function Greeting(props) {
  return <h1>Hello, {props.name}</h1>;
}
```

- And to use it:

```tsx
<Greeting name="World" />
```

## Components as a simple function

```tsx
import * as React from "/react.js";
import { createRoot } from "/react-dom/client.js";

const rootElement = document.getElementById("root");

// 🐨 Make a function called `message` which returns the JSX we want to share
const message = ({ children }) => {
  return <div className="message">{children}</div>;
};

// 🐨 use that function in place of the divs below with:
const element = (
  <div className="container">
    {message({ children: "Hello World" })}
    {message({ children: "Goodbye World" })}
  </div>
);

createRoot(rootElement).render(element);
```
