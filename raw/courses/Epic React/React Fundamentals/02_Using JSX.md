---
creation date: 2026-04-21 17:52
modification date: Tuesday 21st April 2026 17:52:06
tags:
  - chapter
status:
  - completed
---
- Creating [[React Components]] through `createElement` can be a lot of hassle.
- We can use [[JSX]] to create elements as follows:

```html
<html>
	<body>
		<div id="root"></div>
		<!-- `type="text/babel"`: tells babel to transpile this script -->
		<!-- `data-type="module"`: indicates that this script should be treated as a module after babel transpilation -->
		<script type="text/babel" data-type="module">
			// import all exports from React as a namespace called `React`
			import * as React from '/react.js'
			import { createRoot } from '/react-dom/client.js'

			const rootElement = document.getElementById('root')

			// React element created using JSX syntax
			const element = <div className="container">Hello World</div>
			createRoot(rootElement).render(element)
		</script>
		<script type="module" src="/babel-standalone.js"></script>

		<!-- this is here to add automatic browser reloading as you save your work -->
		<script type="module" src="epic_ws.js"></script>
	</body>
</html>

```

- Here [[Babel]] is used to transpile [[JSX]] into [[JavaScript]] that browsers understand.
	- We use both the `type` and `data-type` as browsers don't natively understand [[JSX]]. Thus [[Babel]] needs to transpile our code first and then it can be treated as a module.
- We use `import * as React from '/react.js'` because:
	- It provides access to all [[React]] [[Application Programming Interface (API)|APIs]] and not just `createElement`.
	- When using [[JSX]], the transpiler will convert JSX elements to `React.createElement` calls, so we need the `React` namespace in scope.

## Interpolation

- **Interpolation** is defined as the insertion of something of a different nature into something else.
	- We can use the same concept as [[Template Strings in JavaScript]] for React.

```js
const greeting = 'Hello'
const subject = 'World'

const message = `${greeting}, ${subject}!` // Hello, World!
```

- In case of [[React]] we can use a similar syntax as shown below:

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
			// interpolation to insert `className` and `children` to the react element
		    const element = <div className={className}>{children}</div>

			createRoot(rootElement).render(element)
		</script>

		<script type="module" src="/babel-standalone.js"></script>

		<!-- this is here to add automatic browser reloading as you save your work -->
		<script type="module" src="epic_ws.js"></script>
	</body>
</html>
```

- Few other ways to do the same thing:

```jsx
<>
	<!-- #1 -->
	<div className={className}>{children}</div>
	
	<!-- #2 -->
	<div className={className} children={children}></div>
	
	<!-- #3 -->
	<div className={className} children={children} />
```

- If you use interpolation, it has to be a [[JavaScript]] expression that evaluates to something.
- If you have the following, you can also spread the `props`:

```jsx
const children = 'Hello World'
const className = 'container'
const props = { children, className }
const element = <div {...props}></div>
```

- In case you want to override the `props`, remember that the position of the object matters and whatever comes last will override the previous ones in case of conflicts:

```jsx
const children = 'Hello World'
const className = 'container'
const props = { children, className }
const props_new = { className: 'another-class' }
const element1 = <div {...props}></div> // <div class='container'>Hello World</div>
const element2 = <div {...props} {...props_new}></div> // <div class='another-class'>Hello World</div>
const element3 = <div {...props} className='some-class'></div> // <div class='some-class'>Hello World</div>
const element4 = <div {...props} className='some-class'>Goodbye World</div> // <div class='some-class'>Goodbye World</div>
```

## Fragments

- [[React Fragments]] allow grouping multiple elements without adding an extra [[Document Object Model (DOM)|DOM]] node.
	- This is useful for avoiding extra markup that could affect the layout or the styling.

```jsx
<React.Fragment>This is a fragment<React.Fragment>
{/* is the same as */}
<>This is a fragment</>
```
