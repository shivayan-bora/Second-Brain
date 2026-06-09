---
title: JSX
pillar: software-engineering
type: concept
tags: [react, jsx, syntax, babel]
status: stable
sources: ["[[epic-react-rf-02-using-jsx]]", "[[epic-react-rf-03-custom-components]]", "[[react-dev-00-quick-start]]"]
created: 2026-05-17
updated: 2026-06-09
---

# JSX

## Definition

**JSX** is an HTML-like syntax extension to JavaScript that compiles down to [[react-create-element|`React.createElement`]] calls. It's not part of the language — browsers don't run it natively. Tools like [[babel|Babel]] transpile JSX to plain JS at build time (or via `<script type="text/babel">` in the demo setups Epic React uses).

## Why it matters

JSX is the *authoring surface* for almost all React code. Understanding the desugaring (JSX → `createElement`) makes every JSX rule make sense — capitalization, single root element, attribute quirks, interpolation. Without that mental model, JSX feels like magic; with it, it's just function calls.

## Mechanics

### Desugaring

```jsx
const element = <div className="container">Hello World</div>
// becomes:
const element = React.createElement(
  'div',
  { className: 'container' },
  'Hello World',
)
```

Because JSX compiles to `React.createElement`, the `React` namespace must be in scope wherever JSX is used — hence the convention of `import * as React from 'react'` (or, with the modern JSX transform, an automatic import you don't write).

### Why `className` and not `class`

`class` is a reserved word in JavaScript and a method name on DOM nodes. JSX uses `className` to set the HTML class attribute. Same reasoning underlies `htmlFor` (vs `for`).

### Interpolation: `{expression}`

Anything inside `{ ... }` in JSX is a JavaScript expression:

```jsx
const greeting = 'Hello'
const subject  = 'World'
const message  = `${greeting}, ${subject}!`

const element  = <div className={className}>{children}</div>
```

The interpolated value has to evaluate to *something*. Statements (if, for) are not allowed; expressions are (ternary, `&&`, function calls, JSX).

### Spread props

You can spread an object into JSX attributes. Order matters — later wins:

```jsx
const props = { children: 'Hello World', className: 'container' }

<div {...props}></div>                                  // class='container', text 'Hello World'
<div {...props} {...{ className: 'another-class' }} />  // class='another-class'
<div {...props} className='some-class'></div>           // class='some-class'
<div {...props} className='some-class'>Goodbye</div>    // class='some-class', children 'Goodbye'
```

### Rules for writing JSX (from react.dev)

1. **Close every tag.** `<br>` and `<img>` must be self-closed: `<br />`, `<img />`. Void elements like `<br></br>` are valid but cannot have children (`br is a void element tag…`).
2. **Return exactly one root element.** Wrap multiple siblings in a `<div>` or in a [[react-fragments|Fragment]] (`<>...</>`). The error if you don't: *"Adjacent JSX elements must be wrapped in an enclosing tag."*
3. **Capitalization decides element vs component.** `<div />` becomes `createElement('div', ...)` (a string type — host element); `<Greeting />` becomes `createElement(Greeting, ...)` (a function type — component). See [[react-components]] for the full rule table.

### Equivalent forms for passing children

```jsx
<div className={className}>{children}</div>
<div className={className} children={children}></div>
<div className={className} children={children} />
```

The `children` prop is "special" only in that JSX gives it implicit syntax via the element's body. Otherwise it's just a prop.

## Related

- [[react-create-element]] — what JSX compiles to.
- [[react-element-vs-component]] — why capitalization matters in JSX.
- [[react-components]] — host elements vs component elements.
- [[react-props]] — interpolation and spread are how you pass props.
- [[react-fragments]] — the "no extra wrapper" answer to the single-root rule.

## Sources

- [[epic-react-rf-02-using-jsx]] (`raw/courses/Epic React/React Fundamentals/02_Using JSX.md`)
- [[epic-react-rf-03-custom-components]] (`raw/courses/Epic React/React Fundamentals/03_Custom Components.md`)
- [[react-dev-00-quick-start]] (`raw/documentation/react.dev/00_Quick Start.md`)
