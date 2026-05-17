---
title: "react.dev — Quick Start"
pillar: software-engineering
type: summary
tags: [documentation, react, quickstart]
status: in-progress
source: "raw/documentation/react.dev/00_Quick Start.md"
documentation: "react.dev"
created: 2026-05-17
updated: 2026-05-17
---

# react.dev — Quick Start

Official React quick-start tour. Covers components and nesting, JSX rules, styling via `className`, displaying data, conditional rendering, list rendering with `key`, event handlers, the `useState` hook, and prop-passing between parent and child.

## TL;DR

- A [[react-components|component]] is a function that returns markup. PascalCase distinguishes a component from an HTML element in [[react-jsx|JSX]].
- JSX rules: every tag closed (`<br />`), single root per component (use [[react-fragments|Fragment]] `<>...</>` to avoid an extra DOM node).
- Use `className` (not `class`) for CSS classes.
- `{expr}` interpolates any JS expression: data, ternaries, `&&`-conditionals.
- Lists rendered via `.map` need a `key` prop — usually a stable database id.
- Event handlers are plain functions passed via props: `onClick={handleClick}`.
- State lives in components via [[react-hooks|hooks]] like `useState`. Hooks must be called at the top level of components.
- Parent → child data flow is via [[react-props|props]]; sharing state across siblings means lifting state to a common parent.

## Key takeaways

- **PascalCase = component, lowercase = HTML element.** Same rule Epic React calls out — relied on here without much elaboration. Details in [[react-components]].
- **Three idiomatic conditional renderings:**
  - `let x; if (cond) x = <A/>; else x = <B/>;`
  - `{cond ? <A/> : <B/>}`
  - `{cond && <A/>}`
- **Keys are reconciliation identity, not just a warning to silence.** Without stable keys React can't tell apart "reordered" from "replaced", leading to bugs in stateful list items. Use a database id — index is a smell.
- **`useState` returns `[value, setValue]`** — destructure it. Calling the setter schedules a re-render. See [[react-hooks]].
- **Sharing state = lifting it up.** When two siblings need the same value, the state moves to the nearest common parent and both siblings receive it (plus an updater) via props.

## Notable passages

> "Functions starting with `use` are called hooks. […] Hooks are more restrictive than regular functions, they can only be called at the top level of a component or from other hooks, and not inside loops, conditions or nested functions."
> — react.dev *Quick Start*

> "React uses the keys to know what happened if you later insert, delete or reorder items in the list."
> — react.dev *Quick Start*

## Open questions

- The Quick Start mentions `useState` but not `useEffect`, refs, or context — these are the natural next stops. Flag for ingest of subsequent react.dev pages.
- "Lifting state up" is named here but not fully developed. A dedicated concept page makes sense once a more substantive source (e.g. a later react.dev page) lands.

## Cross-references

- Concepts touched: [[react-components]], [[react-jsx]], [[react-fragments]], [[react-props]], [[react-hooks]], [[react-element-vs-component]]
- Overlaps with Epic React Fundamentals: [[epic-react-rf-03-custom-components]] (components/children), [[epic-react-rf-02-using-jsx]] (JSX rules), [[epic-react-rf-01-raw-react-apis]] (the model underneath).
