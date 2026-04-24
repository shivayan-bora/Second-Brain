---
creation date: 2026-04-21 12:58
modification date: Tuesday 21st April 2026 12:58:01
tags:
  - chapter
status:
  - completed
---

```html
<html>
	<body>
		<div id="root"></div>

		<script type="module">
			// 🐨 add imports for react and react-dom/client here
			import { createElement } from '/react.js'
			import { createRoot } from '/react-dom/client.js'

			const rootElement = document.getElementById('root')

		    const element = createElement('div', {className: 'container'}, 'Hello World')

		    createRoot(rootElement).render(element)
		</script>

		<!-- this is here to add automatic browser reloading as you save your work -->
		<script type="module" src="epic_ws.js"></script>
	</body>
</html>
```

- We have two main parts in the `imports` ([[JavaScript ES6 Modules]]):
	- `react`: This is the [[React]] import that helps you to create [[React Components]].
	- `react-dom`: [[React DOM]] helps you to render these [[React Components]] to the browser [[Document Object Model (DOM)|DOM]].
- `const element = createElement('div', { className: 'container' }, 'Hello World')`: Allows you to create React components/elements.
	- The first argument is the type of react element to create.
	- The second argument is the [[props]] to be passed on to the element.
		- We're using `className` to add a `class` ([[CSS Class]]) to the element because `class` is a reserved [[Prototypal Inheritance|keyword]] in [[JavaScript]] and is a [[Document Object Model (DOM)|DOM]] method for signifying the `class` of a DOM node.
	- The third argument is the element's children.
		- This is an [[Arrays|array]] of elements which can be the children to the element.
		- We can pass the `children` as a `prop` as well to the component: `{ className: 'container', children: 'Hello World' }`

## Nesting Elements

```html
<html>
	<body>
		<div id="root"></div>

		<script type="module">
			import { createElement } from '/react.js'
			import { createRoot } from '/react-dom/client.js'

			const rootElement = document.getElementById('root')
		    const helloSpan = createElement('span', {}, 'Hello')
		    const worldSpan = createElement('span', {}, 'World')
			const element = createElement(
				'div',
				{ className: 'container' },
		        helloSpan,
		        " ",
		        worldSpan
			)

			createRoot(rootElement).render(element)
		</script>

		<!-- this is here to add automatic browser reloading as you save your work -->
		<script type="module" src="epic_ws.js"></script>
	</body>
</html>
```

### Deeply Nesting Elements

```html
<html>
	<body>
		<div id="root"></div>

		<script type="module">
			import { createElement } from '/react.js'
			import { createRoot } from '/react-dom/client.js'

			const rootElement = document.getElementById('root')

			const element = createElement(
				'div',
				{ className: 'container' },
				createElement('p', null, "Here's Sam's favorite food:"),
		        createElement(
		          'ul',
		          { className: 'sams-food' }, 
		          createElement('li', null, 'Green eggs'),
		          createElement('li', null, 'Ham'),
		        ),
			)

			createRoot(rootElement).render(element)
		</script>

		<!-- this is here to add automatic browser reloading as you save your work -->
		<script type="module" src="epic_ws.js"></script>
	</body>
</html>
```
