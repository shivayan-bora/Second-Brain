---
id: 01-raw-react-apis
aliases: []
tags:
  - project
creation date: 2026-09-04 20:47
modification date: Friday 4th September 2026 20:47:49
repository:
status:
  - completed
---

- We would be using raw [[React.js]] and [[React DOM]] APIs to create and append elements to the [[Document Object Model (DOM)|DOM]].

## Hello World in Raw React APIs

```html
<html>
  <body>
    <div id="root"></div>

    <script type="module">
      // 🐨 add imports for react and react-dom/client here
      import { createElement } from "/react.js";
      import { createRoot } from "/react-dom/client.js";

      // 🦉 In a typical application, your import will be something like: import { createRoot } from 'react-dom/client'
      // A build tool or `importmap` will handle resolving that to the correct path

      const rootElement = document.getElementById("root");

      const elementType = "div"; // 👈 type of the element
      const elementProps = { className: "container" }; // 👈 properties passed onto an element to customize it
      const elementChildren = "Hello World"; // 👈 content inide an element
      // 📜 https://react.dev/reference/react/createElement
      const element = createElement(elementType, elementProps, elementChildren);
      const root = createRoot(rootElement); // 👈 create the root element
      root.render(element); // 👈 append the newly created element to the root element
    </script>

    <!-- this is here to add automatic browser reloading as you save your work -->
    <script type="module" src="epic_ws.js"></script>
  </body>
</html>
```

- There are three ways to specify children:

```js
const elementProps = { id: "element-id" };
const elementType = "h1";

// Method 1: As a prop

const reactElement1 = createElement(elementType, {
  ...elementProps,
  children: "Hello World",
});

// Method 2: Multiple arguments
const reactElement2 = createElement(
  elementType,
  elementProps,
  "Hello",
  " ",
  "world!",
);

// Method 3: Array of children
const children = ["Hello", " ", "world!"];
const reactElement3 = createElement(elementType, elementProps, children);

createRoot(rootElement).render(reactElement1); // or reactElement2 or reactElement3
```

### Nesting Elements

```html
<html>
  <body>
    <div id="root"></div>

    <script type="module">
      import { createElement } from "/react.js";
      import { createRoot } from "/react-dom/client.js";

      const rootElement = document.getElementById("root");
      // 🐨 creates this DOM output with React elements:
      // <div class="container">
      // 	<span>Hello</span> <span>World</span>
      // </div>
      const helloElement = createElement("span", {}, "Hello");
      const worldElement = createElement("span", {}, "World");
      const element = createElement(
        "div",
        { className: "container" },
        helloElement,
        " ",
        worldElement,
      );

      createRoot(rootElement).render(element);
    </script>

    <!-- this is here to add automatic browser reloading as you save your work -->
    <script type="module" src="epic_ws.js"></script>
  </body>
</html>
```

### Deep Nesting Elements

```html
<html>
  <body>
    <div id="root"></div>

    <script type="module">
      import { createElement } from "/react.js";
      import { createRoot } from "/react-dom/client.js";

      const rootElement = document.getElementById("root");

      // 🐨 re-create this with createElement and assign that to the element variable
      // <div class="container">
      // 	<p>Here's Sam's favorite food:</p>
      // 	<ul class="sams-food">
      // 		<li>Green eggs</li>
      // 		<li>Ham</li>
      // 	</ul>
      // </div>

      const element = createElement(
        "div",
        { className: "container" },
        createElement("p", null, "Here's Sam's favorite food:"),
        createElement(
          "ul",
          {
            className: "sams-food",
          },
          createElement("li", null, "Green eggs"),
          createElement("li", null, "Ham"),
        ),
      );

      createRoot(rootElement).render(element);
    </script>

    <!-- this is here to add automatic browser reloading as you save your work -->
    <script type="module" src="epic_ws.js"></script>
  </body>
</html>
```
