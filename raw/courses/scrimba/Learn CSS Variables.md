---
id: Learn CSS Variables
aliases: []
tags:
  - course
creation date: 2026-06-05 13:46
modification date: Friday 5th June 2026 13:46:57
source: http://scrimba.com/learn-css-variables-c026
status:
  - in-progress
---

## Why use CSS Variables?

- Same advantages as a normal Variable.
  - Can be reused
  - If we make a change at one place, it would get translated to all places where it's used
  - If we give meaningful names, it's easy to understand what the [[CSS Variables|CSS variable]] is for.
- Some advantages over [[SASS]] and [[LESS]]:
  - Easier to get started since it's native to the browser (no transpiling)
  - Has access to the [[Document Object Model (DOM)|DOM]]:
    - You can create local scopes i.e. [[CSS]] for styling specific areas of the web application.
    - You can change the variables with [[JavaScript]] to add interactivity.
    - Ideal for responsiveness since you can just modify a variable with a media query.
  - Perfect for themes

## Creating our first CSS Variable

```css
:root {
  --red: #ff6f69;
  --beige: #ffeead;
  --yellow: #ffcc5c;
}

html,
body {
  background: var(--beige);
  color: var(--red);
}

h1,
p {
  color: var(--red);
}

#navbar a {
  color: var(--red);
}

.item {
  background: var(--yellow);
}

button {
  background: var(--red);
  color: var(--yellow);
}
```

- `:root`: scope of the CSS variable.
  - In this case, this is the root tag or the `<html></html>` element.
  - All the children of the `html` element has access to this variable.
- `--red: #ff6f69`: variable declaration and instantiation.
- `color: var(--red)`: using the variable.

## Overriding Variables

- If you want to override the `--red` variable inside the scope of `.item` [[CSS Classes|class]], do the following:

```css
:root {
  --red: #ff6f69;
  --beige: #ffeead;
  --yellow: #ffcc5c;
}

.item {
  --red: #ff8e69; /* Redefine the variable inside this scope */
  background: var(--yellow);
}
```

## Changing CSS Variables with JavaScript

```css
:root {
  --red: #ff6f69;
  --beige: #ffeead;
  --yellow: #ffcc5c;
}
```

```js
var root = document.querySelector(":root");
var rootStyles = getComputedStyle(root);
var red = rootStyles.getPropertyValue("--red");
console.log("red: ", red); // red: #ff6f69

root.style.setProperty("--red", "green");
```

## Responsiveness and Variables

```css
/* Variable declarations */
:root {
  --red: #ff6f69;
  --beige: #ffeead;
  --yellow: #ffcc5c;
}

.grid {
  --columns: 200px 200px;
}

/* Styles */
html,
body {
  background: var(--beige);
  color: var(--red);
}

.grid {
  display: grid;
  grid-template-columns: var(--columns);
  grid-auto-rows: 140px;
  grid-gap: 20px;
  justify-content: center;
}

@media all and (max-width: 450px) {
  .grid {
    --columns: 200px;
  }

  :root {
    --beige: #fffead;
  }
}
```
