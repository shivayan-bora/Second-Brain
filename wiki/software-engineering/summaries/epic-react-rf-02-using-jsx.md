---
title: "Epic React — RF ch02 — Using JSX"
pillar: software-engineering
type: summary
tags: [course, chapter, react, jsx, babel]
status: stable
source: "raw/courses/Epic React/React Fundamentals/02_Using JSX.md"
course: "Epic React — React Fundamentals"
created: 2026-05-17
updated: 2026-05-17
---

# Epic React — React Fundamentals — ch02 — Using JSX

Introduce [[react-jsx|JSX]] as syntactic sugar for [[react-create-element|`React.createElement`]]. Covers the Babel transpilation setup, interpolation with `{...}`, prop spreading, and [[react-fragments|Fragments]].

## TL;DR

- JSX is not standard JS. Browsers can't run it — [[babel|Babel]] (or the modern JSX transform) compiles it to `React.createElement` calls.
- Because JSX desugars to `React.createElement`, the `React` namespace must be in scope. Epic React uses `import * as React from '/react.js'`.
- Interpolation `{expr}` accepts any JS *expression* that evaluates to a value.
- Spread `{...props}` works in JSX; later-listed attributes win on conflict.
- [[react-fragments|Fragments]] (`<>...</>`) group siblings without an extra DOM node.

## Key takeaways

- **JSX is just `createElement` in disguise.** `<div className="container">Hi</div>` ⇒ `createElement('div', { className: 'container' }, 'Hi')`. Knowing this defuses every JSX rule. See [[react-jsx]].
- **`className`, not `class`.** Because `class` is reserved in JS and is a DOM property name. Same reasoning applies to `htmlFor`.
- **Three equivalent ways to pass `children`:** body, `children={...}` attribute, or a self-closing tag with the attribute. The body is just JSX sugar. See [[react-props]].
- **Spread + override semantics are positional.** `<div {...a} {...b} />` lets `b` win; `<div {...a} className='x' />` lets the explicit one win.
- **Fragments solve the "JSX must return one element" rule** without polluting the DOM.

## Notable passages

> "Interpolation is defined as the insertion of something of a different nature into something else."
> — *Epic React: React Fundamentals*, ch. 2

## Open questions

- The chapter shows `<script type="text/babel" data-type="module">` for an in-browser Babel setup — what's the actual production workflow look like (Vite / Next / build-time transform)? Likely covered in later chapters or a separate source.

## Cross-references

- Previous: [[epic-react-rf-01-raw-react-apis]]
- Next: [[epic-react-rf-03-custom-components]]
- Concepts introduced / extended: [[react-jsx]], [[react-fragments]], [[react-props]]
- Related: [[react-create-element]] (what JSX compiles to)
