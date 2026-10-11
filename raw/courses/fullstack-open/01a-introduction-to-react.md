---
id: 01a-introduction-to-react
aliases: []
tags:
  - chapter
creation date: 2026-09-17 10:27
modification date: "Thursday 17th September 2026 10:27:12"
repository:
status:
  - completed
---

- To create a new [[React.js]] application: `pnpm create vite@latest`
- To run the application: `pnpm run dev`
- We're using [[Vite]] and [[pnpm]]
- Vite, by default, starts the web application server on port `5173`.

## Overview of the React Application

- The entry point of the application is `index.html`. It only has a single root `div` (with `id="root"`) under which the entire [[React.js]] application is rendered.

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>part1</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
```

- It has a `script` tag with the source as `main.jsx` which has the task of creating the root element and rendering the React application under the root element:

```tsx
// main.tsx
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App.jsx";

// Creates application root and renders the root component inside it
createRoot(document.getElementById("root")).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
```

- `<App/>` is the root component of the React application.
- A component is the smallest unit of UI with it's own markup and state which has the responsibility to render the markup as well as tell how that UI changes based off of the state.

```tsx
const App = () => {
  return <div>Hello World</div>;
};

export default App;
```

## JSX

- [[JSX]] is a special syntax that utilizes [[HTML]] elements and HTML-like syntax to define markup inside a component.
- In JSX, we can put in curly braces `{}` to interpolate [[JavaScript]] expressions inside it. Anything inside `{}` is treated as a JavaScript expression and renders the evaluated result of the expression.

```tsx
const App = () => {
  const now = new Date();
  const a = 10;
  const b = 20;
  console.log(now, a + b);

  return (
    <div>
      <p>Hello world, it is {now.toString()}</p>
      <p>
        {a} plus {b} is {a + b}
      </p>
    </div>
  );
};
```

- The browser can only understand [[HTML]], [[CSS]] and [[JavaScript]], and not [[JSX]]. So we need a way to convert or transpile this [[JSX]] code into browser-understandable [[JavaScript]] which is done through a build tool like [[Babel]].
- Transpilation is automatically configured in [[Vite]] based React application. [[Vite]] uses [[esbuild]] as the transpilation tool.
- The above code after transpilation looks like the following:

```tsx
const App = () => {
  const now = new Date();
  const a = 10;
  const b = 20;
  return React.createElement(
    "div",
    null,
    React.createElement("p", null, "Hello world, it is ", now.toString()),
    React.createElement("p", null, a, " plus ", b, " is ", a + b),
  );
};
```

- `React.createElement()` is a function to create [[React]] elements. It takes in the following arguments:
  - The first parameter represents the type of [[HTML]] element that we want to create. In the above case, we're creating a `p` element.
  - The second parameter is the `props` which represents the attributes as well as state passed down from the parent to this component.
  - The third parameter is the `children` which is an array of HTML or React elements which gets rendered as the child node to the current element.

## Composing Multiple Components

- By creating multiple components and composing them together, we can create really complicated user experiences which is easier to build as well as to maintain.

```tsx
const App = () => {
  return (
    <>
      <h1>Greetings!</h1>
      <Greetings />
      <Greetings />
      <Greetings />
      <Greetings />
      <Greetings />
      <Greetings />
    </>
  );
};

const Greetings = () => {
  return (
    <div>
      <p>Hello world</p>
    </div>
  );
};

export default App;
```

> [!NOTE]
> A React component always starts with an uppercase letter, e.g. `<App/>`, `<Greetings/>` etc. This is done intentionally by the React team to be able to differentiate between HTML elements and React components.

> [!NOTE]
> The content of a React component (usually) needs to contain one root element. To avoid using extra `div` wrapper element, we can leverage React Fragments and we can use them as `<></>` or `<React.Fragment></React.Fragment>`

## props: Passing Data to the components

```tsx
const App = () => {
  const age = 40;
  return (
    <>
      <h1>Greetings!</h1>
      <Greetings /> {/* 👈 Will take default values */}
      {/* 👇 Passing a JavaScript expression */}
      <Greetings name="Random Person" age={10 + 25} />
      {/* 👇 Passing a variable */}
      <Greetings name="Another Random Person" age={age} />
      <Greetings name="Debanjali" age="33" />
    </>
  );
};

// We can also pass `props`. So in this case we would use `props.name` and `props.age`
const Greetings = ({ name = "Shivayan", age = 36 }) => {
  return (
    <div>
      <p>
        Hello {name}, you are {age} years old
      </p>
    </div>
  );
};

export default App;
```
