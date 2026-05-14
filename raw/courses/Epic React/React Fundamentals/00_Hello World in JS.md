---
creation date: 2026-04-21 12:42
modification date: Tuesday 21st April 2026 12:42:49
tags:
  - chapter
status:
  - completed
---
- Creating a child `div` [[HTML]] element with text content as `Hello World` and then appending that to the `root` `div` can be done in [[JavaScript]] as follows:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hello World in JS</title>
</head>
<body>
  <div id="root"></div>
  <script type="module">
     const rootDiv = document.getElementById('root')
     const childDiv = document.createElement('div')
     childDiv.setAttribute('class', 'container')
     childDiv.textContent = "Hello World"
     rootDiv.appendChild(childDiv)
  </script>
</body>
</html>
```

- This is an [[Imperative vs Declarative Programming|imperative]] way to create `Hello World` in [[JavaScript]].
- If we want to generate the root node as well:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hello World in JS</title>
</head>
<body>
  <script type="module">
     const rootDiv = document.createElement('div')
     rootDiv.setAttribute('id', 'root')
     const childDiv = document.createElement('div')
     childDiv.setAttribute('class', 'container')
     childDiv.textContent = "Hello World"
     rootDiv.appendChild(childDiv)
     document.body.appendChild(rootDiv)
  </script>
</body>
</html>
```

- `document.createElement('div')`: Creates a `div` [[Document Object Model (DOM)|DOM]] node.
	- This can be used to create other types of elements like `p`, `span`, `button` etc based on the input argument of `createElement` function.
- `document.getElementById('root')`: Captures the [[Document Object Model (DOM)|DOM]] node with the `id` as `root`.
	- We can also use `querySelector('#root')` here for the same functionality.
- `rootDiv.setAttribute('id', 'root')`: Sets the `id` attribute of the `rootDiv` as `root`.
	- We can also do this for the same effect: `rootDiv.id = 'root'`.
- `childDiv.setAttribute('class', 'container')`: Sets the `class` attribute of the `childDiv` as `container`.
	- We can also do this for the same effect: `childDiv.className = 'container'`.
	- Checkout `classList` also. #todo
- `childDiv.textContent = 'Hello World'`: Creates a text node with the content as `Hello World` and appends it to the `childDiv` as it's child.
- `rootDiv.appendChild(childDiv)`: Appends the `childDiv` node as a children of `rootDiv` node.
	- Similarly, `document.body.appendChild(rootDiv)` appends the `rootDiv` node as children to the `body` of the [[HTML]].
