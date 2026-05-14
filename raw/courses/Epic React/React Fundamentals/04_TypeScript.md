---
creation date: 2026-05-11 19:00
modification date: Monday 11th May 2026 19:00:30
tags:
  - chapter
status:
  - in-progress
---
- To add type annotations to functions:

```ts
// here's a regular JS function that accepts a user
// which might have a name property
function getName(user) {
	return user.name ?? 'Unknown'
}

// here's how you'd type that user object to say it has an optional name property:
type User = { name?: string }

// and here's how you'd tell TypeScript that the user parameter is a User object
function getName(user: User) {
	return user.name ?? 'Unknown'
}

// and if you'd like to, you can specify the return type explicitly as well
// (though it is inferred):
function getName(user: User): string {
	return user.name ?? 'Unknown'
}
```

- To add type annotations to [[React Components]]:

```tsx
function Message(props) {
	return <div className="message">{props.children}</div>
}

// We could say:
type MessageProps = { children: string }
function Message(props: MessageProps) {
	return <div className="message">{props.children}</div>
}
// that would allow: <Message>Hello World</Message>
// but not: <Message><span>Hello</span> <span>World</span></Message>

// The React types have a ReactNode, which is the recommended choice for the children prop:
type MessageProps = { children: React.ReactNode }
function Message(props: MessageProps) {
	return <div className="message">{props.children}</div>
}

// keep in mind that you don't *have* to give your props a name.
// You can inline them as well. This works just the same as above:
function Message(props: { children: React.ReactNode }) {
	return <div className="message">{props.children}</div>
}

// and you can destructure as well:
function Message({ children }: { children: React.ReactNode }) {
	return <div className="message">{children}</div>
}

// mix-and-match:
type MessageProps = { children: React.ReactNode }
function Message({ children }: MessageProps) {
	return <div className="message">{children}</div>
}
```

- Cheatsheet for React types: https://github.com/typescript-cheatsheets/react
- To make sure [[TypeScript]] compiler quiets down:

```ts
// @ts-expect-error TypeScript is complaining about this next line.
// Something about magic not existing.
// I don't know how to fix this right now and AI Assistants were unhelpful...
// Come back later.
make.magic()
```

## Narrow Types

- To specify specific types to a variable e.g. operations on a calculator which can only have specific operations, we can narrow the types as follows:

```ts
// `|` is also known as `union`
type CalculatorProps = {
	left: number
	operator: '+' | '-' | '*' | '/'
	right: number
}
```

## Derived Types

- `typeof` is a [[JavaScript]] keyword but [[TypeScript]] uses it to derive types from a particular variable.

```ts
const user = { name: 'kody', isCute: true }
type User = typeof user
// type User = { name: string; isCute: boolean; }
```

- `keyof` is used to get the union (`|`) of all keys in a given type as strings.

```ts
type UserKeys = keyof User
// type UserKeys = "name" | "isCute"
```

## Default Props

- Below is the code to make some `props` optional and adding a default value to them.

```tsx
const operations = {
	'+': (left: number, right: number): number => left + right,
	'-': (left: number, right: number): number => left - right,
	'*': (left: number, right: number): number => left * right,
	'/': (left: number, right: number): number => left / right,
}

type CalculatorProps = {
	left?: number
	operator?: keyof typeof operations
	right?: number
}

function Calculator({ left = 0, operator = '+', right = 0 }: CalculatorProps) {
	const result = operations[operator](left, right)
	return (
		<div>
			<code>
				{left} {operator} {right} = <output>{result}</output>
			</code>
		</div>
	)
}
```

### Reducing Duplications

- `Record<K, V>`: Shape of an object where `K` is the type of key and `V` is the value.
- `(left: number, right: number) => number`: Function type with it's arguments and return type.

```tsx
type OperationFn = (left: number, right: number) => number
type Operator = '+' | '-' | '*' | '/'

const operations: Record<Operator, OperationFn> = {
	// 🦺 remove all the ": number" from these functions
	'+': (left, right) => left + right,
	'-': (left, right) => left - right,
	'*': (left, right) => left * right,
	'/': (left, right) => left / right,
}

type CalculatorProps = {
	left?: number
	operator?: Operator
	right?: number
}

function Calculator({ left = 0, operator = '+', right = 0 }: CalculatorProps) {
	const result = operations[operator](left, right)
	return (
		<div>
			<code>
				{left} {operator} {right} = <output>{result}</output>
			</code>
		</div>
	)
}
```

## Satisfies

- https://www.perplexity.ai/search/cb545822-5f7f-4156-994a-b3e29e427c43 #todo
- https://www.youtube.com/watch?v=r1L35zxZQPE #todo

```tsx
import { createRoot } from 'react-dom/client'

type OperationFn = (left: number, right: number) => number

// `satisfies` makes sure the value satisfies the shape of `Record<string, OperationFn>`
// we can
const operations = {
	'+': (left, right) => left + right,
	'-': (left, right) => left - right,
	'*': (left, right) => left * right,
	'/': (left, right) => left / right,
} satisfies Record<string, OperationFn>

type CalculatorProps = {
	left?: number
	operator?: keyof typeof operations
	right?: number
}
function Calculator({ left = 0, operator = '+', right = 0 }: CalculatorProps) {
	const result = operations[operator](left, right)
	return (
		<div>
			<code>
				{left} {operator} {right} = <output>{result}</output>
			</code>
		</div>
	)
}

function App() {
	return (
		<div>
			<h1>Calculator</h1>
			<Calculator left={1} right={2} />
			{ /* We get autocomplete with the available operators from the operations object i.e. '+' | '-' | '*' | '/' */ }
			<Calculator operator="-" /> 
			<Calculator left={1} operator="*" />
			<Calculator operator="/" right={2} />
		</div>
	)
}

const rootEl = document.createElement('div')
document.body.append(rootEl)
createRoot(rootEl).render(<App />)
```
