---
creation date: 2026-05-11 08:28
modification date: Monday 11th May 2026 08:28:34
tags:
  - chapter
status:
  - completed
---
- Just like in [[JavaScript]], we create functions to have reusable code that we can use, in [[React]], we have components.
- [[React Components]] are functions which accept an object known as `props` and return something that is renderable e.g. other React elements, strings, `null`, numbers etc.

```tsx
function Greeting(props) {
	return <h1>Hello, {props.name}</h1>
}
```

- They can then be used as:

```tsx
<Greeting name='Shivayan'/>
```

- RAW API to use custom component:

```tsx
import * as React from '/react.js'
import { createRoot } from '/react-dom/client.js'

const rootElement = document.getElementById('root')

function message({ children }) {
	return <div className="message">{children}</div>
}

// React takes care of calling the function when necessary to load the element i.e. when we call the `createRoot` function
const element = (
	<div className="container">
		{ React.createElement(message, { children: 'Hello World'}) }
	    { React.createElement(message, null, 'Goodbye World') }
	</div>
)

createRoot(rootElement).render(element)
```

- Since we use [[JSX]] to create components, using `<message>Hello World</message>` won't work as shown below:

```tsx
element = <message>Hello World</message>

// the desired output
element = createElement(message, { children: 'Hello World' })

// the actual output
element = createElement('message', { children: 'Hello World' })
```

- Component creation rules:

```tsx
element = <Capitalized /> // createElement(Capitalized)
element = <property.access /> // createElement(property.access)
element = <Property.Access /> // createElement(Property.Access)
element = <Property['Access'] /> // SyntaxError
element = <lowercase /> // createElement('lowercase')
element = <kebab-case /> // createElement('kebab-case')
element = <Upper-Kebab-Case /> // createElement('Upper-Kebab-Case')
element = <Upper_Snake_Case /> // createElement(Upper_Snake_Case)
element = <lower_snake_case /> // createElement('lower_snake_case')
```

- Example with `property.access`:

```tsx
import * as React from '/react.js'
import { createRoot } from '/react-dom/client.js'

const rootElement = document.getElementById('root')

function message({ children }) {
	return <div className="message">{children}</div>
}

const component = { message }

const element = (
	<div className="container">
		<component.message>Hello World</component.message>
		<component.message>Goodbye World</component.message>
	</div>
)

createRoot(rootElement).render(element)
```

- The children prop is special because it can appear either as a prop or in between the opening and closing tags of a component. So these two are equivalent:

```tsx
<Alert>Something went wrong!</Alert>
<Alert children="Something went wrong!" />
```

- Our `Message` component uses the "special" and implicit `children` prop. It's special because it means we can do this:

```tsx
element = <Message>Hello World</Message>
// is functionally equivalent to:
element = <Message children="Hello World" />
```

- And you can put JSX in the children prop with either syntax as well:

```tsx
element = (
	<Message>
		<span>Hello</span> <span>World</span>
	</Message>
)
// is functionally equivalent to:
element = <Message children={[<span>Hello</span>, ' ', <span>World</span>]} />
```

- But we don't have to use the `children` prop, we can call it whatever we want. So you could also do:

```tsx
element = <Message greeting={[<span>Hello</span>, ' ', <span>World</span>]} />
```

- The only thing that's special about the `children` prop is that it's implicit in JSX.

```
Please quiz me on exercise 4 using the epicshop MCP server. Call the get_quiz_instructions tool with exerciseNumber "4" to get the quiz instructions, then quiz me one question at a time.
```

```
Please quiz me on this workshop using the epicshop MCP server. Call the get_quiz_instructions tool to get the quiz instructions, then quiz me one question at a time.
```
