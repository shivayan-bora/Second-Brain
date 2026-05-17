---
title: TypeScript with React
pillar: software-engineering
type: concept
tags: [react, typescript, types]
status: in-progress
sources: ["[[epic-react-rf-04-typescript]]"]
created: 2026-05-17
updated: 2026-05-17
---

# TypeScript with React

## Definition

Using TypeScript to type [[react-components|React components]] means giving the `props` parameter a static type so the compiler can verify usage at every call site. The mechanics borrow standard TS features — object types, unions, generics — plus a handful of React-specific aliases like `React.ReactNode`.

## Why it matters

Props are an implicit contract between parent and child. Without types, every `<Component foo={...} />` is "hope the parent passed the right shape". With types, that contract is checked by the compiler, autocomplete works, and refactors propagate. For staff-level work the question is rarely "do we use TS?" but "how strictly?" — and patterns like `satisfies` and derived types raise the strictness ceiling without raising boilerplate proportionally.

## Mechanics

### Typing a component

Several equivalent forms:

```tsx
// named props type
type MessageProps = { children: React.ReactNode }
function Message(props: MessageProps) {
  return <div className="message">{props.children}</div>
}

// inline
function Message(props: { children: React.ReactNode }) { /* ... */ }

// destructured
function Message({ children }: { children: React.ReactNode }) { /* ... */ }

// destructured + named type (recommended)
type MessageProps = { children: React.ReactNode }
function Message({ children }: MessageProps) { /* ... */ }
```

### `React.ReactNode` for `children`

`React.ReactNode` accepts strings, numbers, elements, arrays of those, `null`, `undefined`, booleans. Use it for `children`-shaped props.

`{ children: string }` only allows `<Message>Hello</Message>` and rejects `<Message><span>Hello</span></Message>`. Reach for `ReactNode` unless you specifically want to restrict.

### Narrow types

Union types narrow valid values to a fixed set:

```ts
type CalculatorProps = {
  left: number
  operator: '+' | '-' | '*' | '/'
  right: number
}
```

### Derived types: `typeof` and `keyof`

`typeof` in a type position derives a type from a value (this is *not* the runtime `typeof` operator):

```ts
const user = { name: 'kody', isCute: true }
type User = typeof user
// { name: string; isCute: boolean }
```

`keyof T` is the union of string keys of `T`:

```ts
type UserKeys = keyof User    // 'name' | 'isCute'
```

Combined, they're powerful for "let the implementation be the source of truth":

```ts
const operations = {
  '+': (l: number, r: number) => l + r,
  '-': (l: number, r: number) => l - r,
  '*': (l: number, r: number) => l * r,
  '/': (l: number, r: number) => l / r,
}

type Operator = keyof typeof operations  // '+' | '-' | '*' | '/'
```

### `Record<K, V>` and function types

`Record<K, V>` is the shape `{ [key: K]: V }`. Pair it with a function type to constrain a lookup table:

```ts
type OperationFn = (left: number, right: number) => number
type Operator = '+' | '-' | '*' | '/'

const operations: Record<Operator, OperationFn> = {
  '+': (l, r) => l + r,     // params no longer need annotation — inferred
  '-': (l, r) => l - r,
  '*': (l, r) => l * r,
  '/': (l, r) => l / r,
}
```

### Default props via destructuring

```tsx
type CalculatorProps = {
  left?: number
  operator?: Operator
  right?: number
}

function Calculator({ left = 0, operator = '+', right = 0 }: CalculatorProps) {
  const result = operations[operator](left, right)
  return <output>{result}</output>
}
```

### `satisfies`

`satisfies T` checks that a value conforms to `T` *without widening it to `T`*. Use it when you want both:

- compiler enforcement that the literal matches a shape, **and**
- the precise literal type preserved for downstream `keyof`-style derivation.

```tsx
type OperationFn = (left: number, right: number) => number

const operations = {
  '+': (l, r) => l + r,
  '-': (l, r) => l - r,
  '*': (l, r) => l * r,
  '/': (l, r) => l / r,
} satisfies Record<string, OperationFn>

type CalculatorProps = {
  operator?: keyof typeof operations   // '+' | '-' | '*' | '/' — narrow, not 'string'
}
```

If you'd written `: Record<string, OperationFn>` instead of `satisfies`, `keyof typeof operations` would widen to `string` and you'd lose autocomplete.

### Escape hatch: `@ts-expect-error`

When you genuinely can't fix a type error right now, suppress *one specific line* and leave a comment:

```ts
// @ts-expect-error magic doesn't exist on `make` yet — revisit when ready
make.magic()
```

`@ts-expect-error` is preferable to `@ts-ignore` because it errors if the line eventually starts type-checking, prompting cleanup.

## Reference

- React TypeScript cheatsheet: https://github.com/typescript-cheatsheets/react

## Open questions

- Full mechanics and edge cases of `satisfies` — flagged in the raw notes for follow-up.

## Related

- [[react-components]] — what gets typed.
- [[react-props]] — the contract being enforced.

## Sources

- [[epic-react-rf-04-typescript]] (`raw/courses/Epic React/React Fundamentals/04_TypeScript.md`)
