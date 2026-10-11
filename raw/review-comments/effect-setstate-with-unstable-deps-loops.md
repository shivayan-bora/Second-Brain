---
id: effect-setstate-with-unstable-deps-loops
aliases: []
tags:
  - review-comments
  - react
  - react-hooks
creation date: 2026-10-06 23:20
modification date: Tuesday 6th October 2026 23:20:52
---

## The idea
An effect (`useEffect` or `useLayoutEffect`) that sets state, directly or through a context setter, runs again whenever a dependency changes. If one of its deps gets a new reference every render, the loop is: render, effect, setState, render, new reference, effect, and so on. With `useLayoutEffect` the updates are synchronous, and React throws "Maximum update depth exceeded". With `useEffect` it can loop silently and peg the CPU.

## Example
```tsx
function Picker({ source }: { source: () => Option[] }) {
  const { setLabels } = useLabelsContext();           // setState in a parent provider
  const options = source();                           // new array every render
  React.useLayoutEffect(() => {
    setLabels(Object.fromEntries(options.map(o => [o.id, o.label])));
  }, [options, setLabels]);                           // loops: setLabels re-renders Picker
  ...
}

// Fix: give the dep a stable identity
const options = React.useMemo(() => source(), [source]);
```
Two things make it worse. The setter always creates a new object (`prev => ({ ...prev, [k]: v })`), so React can't bail out. And the provider re-renders every consumer.

## Why it matters
The loop often only appears in one branch, for example when a fallback is a fresh `[]` (see [[destructuring-defaults-create-new-references]]) or when a function prop is defined inline. Tests with mocked context don't catch it, so it shows up in production as a crash or a frozen tab.

## Rule of thumb
Every dependency of an effect that sets state must be referentially stable across renders that don't change its meaning: primitives, memoized values or module constants. Pin it with a test that renders the real provider, not a mocked setter. Better still, derive the value during render instead of syncing it through an effect.
