---
id: 00_Fundamentals Recap
aliases: []
tags:
  - chapter
creation date: 2026-06-30 19:26
modification date: Tuesday 30th June 2026 19:26:24
status:
  - in-progress
---

## Anatomy of a CSS Rule

```css
p {
  margin: 32px;
}
```

- **Properties** in [[CSS]] are the attributes you can specify values for, like `color`, `font-size` and in this case, `margin`.
- Some values have units, like `px`, `%`, or `em`. In this case, our `margin` has a value of `32px`, which is measured in the `px` unit.

```css
.apple {
  background-color: red;
  border-radius: 50%;
}
```

- A **selector** (`.apple`) is a descriptor that lets you target specific elements on the page. In this case, we're selecting all nodes with the `apple` class.
- A **declaration** is a combination of a property and a value. In this case, the first declaration has a property of `background-color`, and a value of `red`.
- A **rule**, also known as a style, is a collection of declarations, targeting one or more selectors. A style sheet is made up of multiple rules e.g. in this case, the entire `.apple` block is a rule.

## Media Queries

- An `iframe` is an embedded [[HTML]] document within the main HTML document. It's a page within a page.
- Media Queries allow you to put different styles for different screen sizes.
- Think of them as the [[CSS]] equivalent of an `if` statement in [[JavaScript]].

```js
// JavaScript
if (condition) {
  // Some JS that will run if the condition is met.
}
```

```css
/* CSS */
@media (condition) {
  /* Some CSS that'll run if the condition is met. */
}
```

- e.g. the below CSS rule gets applied when the screen size is between `0px` to `300px`.

```css
@media (max-width: 300px) {
  .thing {
    font-weight: bold;
    text-align: center;
    background: peachpuff;
  }
}
```

- Two ways of applying media-queries:

```css
/* Default (desktop) styles */
.wrapper {
  /* ... */
}

/* Tablet styles */
@media (max-width: 768px) {
  .wrapper {
    /* ... */
  }
}

/* Mobile styles */
@media (max-width: 440px) {
  .wrapper {
    /* ... */
  }
}
```

```css
.wrapper {
  /* Default (desktop) styles here */

  @media (max-width: 768px) {
    /* Tablet styles */
  }

  @media (max-width: 440px) {
    /* Mobile styles */
  }
}
```

## Pseudo-classes

- Pseudo-classes let us apply a chunk of CSS based on an element's current state e.g. the following CSS turns the button text to blue on hover:

```css
button:hover {
  color: blue;
}
```
