---
creation date: 2026-04-21 17:52
modification date: Tuesday 21st April 2026 17:52:06
tags:
  - chapter
status:
  - in-progress
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
