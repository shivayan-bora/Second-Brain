---
creation date: 2026-05-12 12:51
modification date: Tuesday 12th May 2026 12:51:54
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 05_Styling
---

- There are two primary ways to style [[React Components]]:
  - Inline styles with the `style` prop.
  - Regular [[CSS]] with the `className` prop.

## Element properties and HTML attributes

- In [[HTML]], you have elements and attributes. e.g. `div` element has a `class` attribute:

```html
<div class="my-class"></div>
```

- In [[Document Object Model(DOM)|DOM]], the `div` element has a `className` property:

```html
<div id="my-div" class="my-class"></div>
<script>
  const myDiv = document.getElementById("my-div");
  console.log(myDiv.class); // undefined
  console.log(myDiv.className); // "my-class"
</script>
```

- In [[JSX]], we use the property name rather than the attribute name:

```jsx
<div className="my-class"></div>
```

- This applies to a number of other attributes as well. For example, `for` in HTML is `htmlFor` in DOM (and JSX). Others include `tabindex` and `readonly` (which are, respectively, `tabIndex` and `readOnly` in JSX).

## Inline Styles

```jsx
<div style={{ marginTop: 20, backgroundColor: "blue" }} />
```

> [!NOTE]
> Note also that the property names are camelCased rather than kebab-cased. This matches the style property of DOM nodes (which is a [CSSStyleDeclaration](https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration) object).

## Class Names

- In JSX, we can use the `className` prop as follows:

```jsx
<div className="my-class"></div>
```

- Then we can load a [[CSS]] file into the page:

```html
<link rel="stylesheet" href="styles.css" />
```

- We can add the styles in the stylesheet:

```css
.my-class {
  margin-top: 20px;
  background-color: blue;
}
```

> [!TIP]
> When you want to wrap an element to basically simulate that element + a little functionality, you'll want to borrow the type definition for that element from React.
>
> ```jsx
> const Box = (props: React.ComponentProps<'div'>) => {
>  const {children, className, style, ...rest} = props
>
>  return <div className={`box ${className}`} style={{ fontStyle: 'italic', ...style }} {...rest}>
>    {children}
>  </div>
> }
> ```
>
> Now we'll get type-safety and autocomplete for all the [[HTML]] attributes accepted by a `div` element.
