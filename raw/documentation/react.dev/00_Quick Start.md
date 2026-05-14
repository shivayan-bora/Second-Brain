---
creation date: 2026-05-12 10:13
modification date: Tuesday 12th May 2026 10:13:21
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 00_Quick Start
---

## Creating and Nesting Components

- [[React]] applications are made out of [[React Components|components]].
  - A component is a piece of UI (user interface) that has its own logic and appearance.
    - It can be as small as a button or as large as an entire page.
  - [[React Components]] are JavaScript functions that return markup.

```tsx
function MyButton() {
  return <button>Click Me!</button>;
}
```

- We can now use it by nesting it in a parent component as follows:

```tsx
export default function MyApp() {
  return (
    <div>
      <h1>Hello World!</h1>
      <MyButton />
    </div>
  );
}
```

- [[React Components]] always starts with a capital letter as shown above i.e. `MyButton` whereas [[HTML]] elements starts with lowercase letters i.e. `div`, `h1` etc.
  - This is how [[React]] distinguishes between [[React Components]] and [[HTML]] elements.

## Writing Markup with JSX

- The above syntax which allows us to write [[HTML]] inside a [[JavaScript]] file is known as [[JSX]].
- **Rules for writing JSX**:
  - You have to close tags, even with [[Self-Closing HTML Tags]] e.g. `<br/>` or `<br></br>`.
    - Here `<br>` or `<img>` will cause errors: `Expected corresponding JSX closing tag for <br>.`
    - If we use `<br></br>`, we can't put any children to them, else it will throw an error saying: `br is a void element tag and must neither have children nor use dangerouslySetInnerHTML.`
  - Your component can't return multiple [[JSX]] elements.
    - You must wrap them into a shared parent e.g.
      - `<div></div>`
      - `<></>` which are [[React Fragments]] and they don't add elements to the [[Document Object Model (DOM)|DOM]] and is useful for styling and layout purposes.
    - The error in case we violate this: `Adjacent JSX elements must be wrapped in an enclosing tag.`

```tsx
function AboutPage() {
  return (
    <>
      <h1>About</h1>
      <p>
        Hello there. <br />
        How do you do?
      </p>
    </>
  );
}
```

- If you have a lot of HTML to port to JSX, you can use an [online converter.](https://transform.tools/html-to-jsx)

## Adding Styles

- Using `className`:

```jsx
<img className="avatar" src="/avatar.png" alt="Avatar" />
```

- Then we can add a class with the same name [[CSS]] file:

```css
.avatar {
  width: 150px;
  height: 150px;
  border-radius: 50%;
}
```

- [[React]] doesn't have any opinions on how you add styles to your application, so you can use any styling solution you like.
- At it's simplest, you can just import your CSS using `<link>` in the `<head>` of your HTML file.

## Displaying Data

```tsx
return (
  <>
    <h1>{user.name}</h1>
    <img className="avatar" src={user.avatarUrl} alt={user.name} />
  </>
);
```

- Anything inside `{}` is a [[JavaScript]] expression, so you can put any [[JavaScript]] code in there.

### Conditional Rendering

```tsx
let content;

if (isLoggedIn) {
  content = <AdminPanel />;
} else {
  content = <LoginForm />;
}

return <div>{content}</div>;
```

- This can be written as:

```tsx
<div>{isLoggedIn ? <AdminPanel /> : <LoginForm />}</div>
```

- or:

```tsx
<>
  <div>{isLoggedIn && <AdminPanel />}</div>
  <div>{!isLoggedIn && <LoginForm />}</div>
</>
```

## Rendering Lists

```tsx
const products = [
  { id: 1, name: "Cucumber", price: "$1" },
  { id: 2, name: "Tomato", price: "$2" },
  { id: 3, name: "Eggplant", price: "$3" },
];

const listItems = products.map((product) => (
  <li key={product.id}>
    {product.name}: {product.price}
  </li>
));

return <ul>{listItems}</ul>;
```

- The `key` attribute is used to uniquely identify each element in the list i.e. the `li` items. React uses the keys to know what happened if you later insert, delete or reorder items in the list.
  - This should be a unique string or a number.
  - Usually, a key should be coming from your database over at the backend e.g. a database ID.

## Event Handling

```tsx
function MyButton() {
  const handleClick = () => {
    alert("Clicked!");
  };

  return <button onClick={handleClick}>Click Me!</button>;
}
```

## Hooks

### Updating the screen

- Often times, you'll want your component to `remember` some information and display it. e.g. maybe you want to count the number of times a button was clicked.
- To do this, add **state** to your component using the `useState` hook:

```tsx
import { useState } from "react";

function MyButton() {
  const [count, setCount] = useState(0);
}
```
