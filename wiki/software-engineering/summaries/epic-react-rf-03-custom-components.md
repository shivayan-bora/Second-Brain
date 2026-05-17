---
title: "Epic React — RF ch03 — Custom Components"
pillar: software-engineering
type: summary
tags: [course, chapter, react, components]
status: stable
source: "raw/courses/Epic React/React Fundamentals/03_Custom Components.md"
course: "Epic React — React Fundamentals"
created: 2026-05-17
updated: 2026-05-17
---

# Epic React — React Fundamentals — ch03 — Custom Components

Introduce **components** — functions that accept `props` and return renderable output. Covers the capitalization-vs-lowercase rule for JSX (host element vs component), the `children` prop, and `property.access` component references.

## TL;DR

- A [[react-components|component]] is a function `(props) => element`. The element it returns becomes part of the rendered tree.
- JSX capitalization is what tells the compiler whether `<foo />` means a string-typed host element or a function-typed [[react-element-vs-component|component]]:
  - `<Capitalized />` ⇒ `createElement(Capitalized, ...)`.
  - `<lowercase />` ⇒ `createElement('lowercase', ...)`.
  - `<property.access />` ⇒ `createElement(property.access, ...)` (member access always treated as reference).
- The `children` prop is special only because JSX has implicit syntax (the element body) for it. Otherwise it's a normal prop.
- React calls component functions for you — don't call them directly.

## Key takeaways

- **Components are the only abstraction unit React provides.** Anything reusable is "another component". See [[react-components]].
- **Capitalization rule is mechanical, not stylistic.** All-lowercase or kebab-case names are passed to `createElement` as *strings* (host elements); PascalCase names are passed as *references* (components). Member access (`a.b`) is always a reference regardless of case.
- **`children` can be anything renderable** — string, number, element, or array. And you don't have to call your slot `children`; that's just the one with implicit JSX syntax.
- **Raw API still works for components:** `React.createElement(Message, { children: 'Hello World' })` is equivalent to `<Message>Hello World</Message>`. Useful when component type is dynamic.

## Notable passages

> "The only thing that's special about the `children` prop is that it's implicit in JSX."
> — *Epic React: React Fundamentals*, ch. 3

## Open questions

- When is `<component.message>` (property-access JSX) actually the right call vs. importing the component directly? Probably in compound-component or dynamic-mapping patterns — flagged for later when ingesting those patterns.

## Cross-references

- Previous: [[epic-react-rf-02-using-jsx]]
- Next: [[epic-react-rf-04-typescript]]
- Concepts introduced / extended: [[react-components]], [[react-element-vs-component]], [[react-props]]
- Related: [[react-jsx]], [[react-create-element]]
