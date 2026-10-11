---
id: destructuring-defaults-create-new-references
aliases: []
tags:
  - review-comments
  - react
  - javascript
creation date: 2026-10-06 23:20
modification date: Tuesday 6th October 2026 23:20:52
---

## The idea
A default value in destructuring (`const { data = [] } = result`) is evaluated each time the line runs. In a React component or hook that's every render, so whenever the source is `undefined` you get a brand-new array, with a new [[referential equality|reference]], every render. Anything that compares by reference (`useMemo`/`useEffect`/`useCallback` deps, `React.memo` props) sees a change every time.

## Example
```tsx
// Bad: new [] every render while data is undefined
const { data: rows = [] } = useQuery(...);
const sorted = React.useMemo(() => [...rows].sort(byName), [rows]); // recomputes every render

// Good: one shared empty array
const EMPTY_ROWS: Row[] = [];
const { data: rows = EMPTY_ROWS } = useQuery(...);
const sorted = React.useMemo(() => [...rows].sort(byName), [rows]); // stable until data arrives
```
The same applies to `= {}`, to `?? []` and `|| []` in render, and to a `return []` fallback inside a hook.

## Why it matters
At best the memo does nothing and child components re-render for no reason. At worst the unstable value feeds an effect that sets state, and the component loops (see [[effect-setstate-with-unstable-deps-loops]]). The bug only shows up while the value is missing (loading, disabled query, empty config), so it hides in the happy path.

## Rule of thumb
For empty fallbacks of arrays or objects that flow into deps or props, use a module-level constant (`const EMPTY_X: X[] = []`). Never write a literal `[]`/`{}` default in render code that feeds a dependency array.
