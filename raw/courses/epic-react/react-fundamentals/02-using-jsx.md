---
id: 02-using-jsx
aliases: []
tags:
  - project
creation date: 2026-09-07 09:28
modification date: Monday 7th September 2026 09:28:52
repository:
status:
  - in-progress
---

## JSX Syntax

- [[JSX]] is syntactic sugar on top of [[JavaScript]] which allows us to write [[HTML]]-like syntax in our JavaScript files.

```jsx
const element = <h1 id="greeting">Hey there</h1>;

// ↓ ↓ ↓ ↓ compiles to ↓ ↓ ↓ ↓

const element = createElement("h1", {
  id: "greeting",
  children: "Hey there",
});
```

- Because [[JSX]] is not actually [[JavaScript]], you have to convert it using something called a code compiler. [[Babel]] is one such tool.
- To see how JSX gets compiled to JavaScript, [check out the online babel REPL here.](https://babeljs.io/repl#?builtIns=App&code_lz=MYewdgzgLgBArgSxgXhgHgCYIG4D40QAOAhmLgBICmANtSGgPRGm7rNkDqIATtRo-3wMseAFBA&presets=react&prettier=true)

## Compiling JSX

```html
<html>
  <body>
    <div id="root"></div>

    <script type="text/babel" data-type="module">
      // 🐨 on the script tag above, change `type="module"`
      // to `type="text/babel"` and add data-type="module" so babel will compile
      // this code as a module script for the browser to run.

      // 🐨 babel compiles JSX to "React.createElement" instead of simply "createElement"
      // so change this import to: import * as React from '/react.js'
      import * as React from "/react.js";
      import { createRoot } from "/react-dom/client.js";

      const rootElement = document.getElementById("root");

      // 🐨 With babel compiling this code, you can now re-implement this using JSX!
      const element = <div className={`${className}`}>{children}</div>;

      // 💰 there are a few subtle differences between JSX and HTML. One such
      // difference is how you apply a class to an element in JSX is by using
      // `className` rather than `class`!
      // 📜 You can learn the differences between JSX and HTML syntax from the React docs here:
      // https://react.dev/reference/react-dom/components/common

      createRoot(rootElement).render(element);
    </script>

    <!-- 🐨 add Babel to the page.-->
    <script type="module" src="/babel-standalone.js"></script>

    <!-- this is here to add automatic browser reloading as you save your work -->
    <script type="module" src="epic_ws.js"></script>
  </body>
</html>
```

- Let's break down the key changes in our `script` tag:
  - `type="text/babel"` and `data-type="module"`:
    - `type="text/babel"` tells Babel to transpile this script, allowing us to use JSX and modern JavaScript features.
    - `data-type="module"` indicates that this script should be treated as a module after Babel transpilation. This enables us to use `import` statements.
    - We use both instead of just `type="module"` because browsers don't natively understand JSX. Babel needs to transform our code first, then it can be treated as a module.
  - Importing React: We've changed from: `import { createElement } from '/react.js'` to `import * as React from '/react.js'`:
    - This imports all exports from React as a namespace called `React`. It's beneficial because:
      - It provides access to all React APIs, not just `createElement`.
      - When using JSX, the transpiler will convert JSX elements to `React.createElement` calls, so we need the `React` namespace in scope.

## Interpolation

```html
<html>
  <body>
    <div id="root"></div>

    <script type="text/babel" data-type="module">
      import * as React from '/react.js'
      import { createRoot } from '/react-dom/client.js'

      const rootElement = document.getElementById('root')

      const children = 'Hello World'
      const className = 'container'
      // 🐨 get the children and className interpolated into this element:
       const element = <div className=`${className}`>{children}</div>

      createRoot(rootElement).render(element)
    </script>

    <script type="module" src="/babel-standalone.js"></script>

    <!-- this is here to add automatic browser reloading as you save your work -->
    <script type="module" src="epic_ws.js"></script>
  </body>
</html>
```

- Anything inside the `{}` above is a JavaScript expression.

## Spread props

```html
<html>
  <body>
    <div id="root"></div>

    <script type="text/babel" data-type="module">
      import * as React from "/react.js";
      import { createRoot } from "/react-dom/client.js";

      const rootElement = document.getElementById("root");

      const children = "Hello World";
      const className = "container";
      const props = { children, className };
      // 🐨 get this props object spread onto the div element
      const element = <div {...props}></div>;

      createRoot(rootElement).render(element);
    </script>

    <script type="module" src="/babel-standalone.js"></script>

    <!-- this is here to add automatic browser reloading as you save your work -->
    <script type="module" src="epic_ws.js"></script>
  </body>
</html>
```

- This behaves exactly like object-destructuring in JavaScript i.e. whatever will come later will override the previous.

## Nesting JSX

```html
<html>
  <body>
    <div id="root"></div>

    <script type="text/babel" data-type="module">
      import * as React from "/react.js";
      import { createRoot } from "/react-dom/client.js";

      const rootElement = document.getElementById("root");

      const element = (
        <div className="container">
          {/* 💡 TIP: this is how you do comments inside JSX elements! */}
          <p>Here's Sam's favorite food:</p>
          <ul className="sams-food">
            <li>Green eggs</li>
            <li>Ham</li>
          </ul>
        </div>
      );

      createRoot(rootElement).render(element);
    </script>

    <script type="module" src="/babel-standalone.js"></script>

    <!-- this is here to add automatic browser reloading as you save your work -->
    <script type="module" src="epic_ws.js"></script>
  </body>
</html>
```

## Fragments

- React Fragments allow you to group multiple elements without adding an extra DOM node.
  - This lets you return multiple elements side-by-side from a component without needing a wrapper div.
  - It's useful for avoiding unnecessary markup that could affect styling or layout.
- There are two ways to do it:

```jsx
element = <React.Fragment>this is in a fragment</React.Fragment>;
// is the same as:
element = <>this is in a fragment</>;
```

```html
<html>
  <body>
    <div id="root"></div>

    <script type="text/babel" data-type="module">
      import * as React from "/react.js";
      import { createRoot } from "/react-dom/client.js";

      const rootElement = document.getElementById("root");

      // 🐨 replace the <div> with a React Fragment.
      const element = (
        <>
          <p>Here's Sam's favorite food:</p>
          <ul className="sams-food">
            <li>Green eggs</li>
            <li>Ham</li>
          </ul>
        </>
      );

      createRoot(rootElement).render(element);
    </script>

    <script type="module" src="/babel-standalone.js"></script>

    <!-- this is here to add automatic browser reloading as you save your work -->
    <script type="module" src="epic_ws.js"></script>
  </body>
</html>
```

![[Pasted image 20260907105633.png]]
