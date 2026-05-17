---
title: "Epic React — RF ch01 — Raw React APIs"
pillar: software-engineering
type: summary
tags: [course, chapter, react, api]
status: stable
source: "raw/courses/Epic React/React Fundamentals/01_Raw React APIs.md"
course: "Epic React — React Fundamentals"
created: 2026-05-17
updated: 2026-05-17
---

# Epic React — React Fundamentals — ch01 — Raw React APIs

Rewrite the previous chapter's imperative "Hello World" using only React's low-level APIs — `React.createElement` and `react-dom/client`'s `createRoot` — *before* introducing JSX. The goal is to demystify JSX by showing that it's sugar over plain function calls.

## TL;DR

- React splits into two packages: `react` (creates elements) and `react-dom` (renders them to the browser). See [[react-create-element]] and [[react-create-root]].
- [[react-create-element|`createElement(type, props, ...children)`]] is the underlying API; everything else (JSX) compiles down to this.
- Children passed as positional args are equivalent to a `children` prop: `createElement('div', { children: 'Hi' })` ≡ `createElement('div', null, 'Hi')`.
- `className` is used (not `class`) because `class` is reserved in JS and is also a DOM property name.
- Nesting elements means nesting `createElement` calls — fine for two levels, exhausting at three, which motivates JSX in the next chapter.

## Key takeaways

- **`react` vs `react-dom` split is intentional.** Elements are platform-agnostic; rendering them is platform-specific. Same split underlies React Native. See [[react-create-root]].
- **The signature `createElement(type, props, ...children)` explains a lot.** Why props are an object, why children are special (just the rest arg), why a JSX expression "is" a function call.
- **Children can be strings, elements, or arrays of either** — and you can mix positional + named (`{ children: ... }`) styles.
- **Deep nesting via `createElement` is unergonomic by design** — the chapter ends with a deliberately-painful nested example as the setup for [[epic-react-rf-02-using-jsx|JSX]].

## Notable passages

> "The first argument is the type of react element to create. The second argument is the props to be passed on to the element. The third argument is the element's children."
> — *Epic React: React Fundamentals*, ch. 1

## Open questions

- What does `react-dom/client` give you that the old `react-dom` entrypoint didn't? (Answer involves React 18 concurrent rendering — flagged for a later page.)

## Cross-references

- Previous: [[epic-react-rf-00-hello-world-js]]
- Next: [[epic-react-rf-02-using-jsx]]
- Concepts introduced: [[react-create-element]], [[react-create-root]], [[react-element-vs-component]], [[react-props]]
- Related: [[dom-create-element]] (the imperative baseline this replaces)
