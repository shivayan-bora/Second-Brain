---
title: "Epic React — RF ch00 — Hello World in JS"
pillar: software-engineering
type: summary
tags: [course, chapter, react, javascript, dom]
status: stable
source: "raw/courses/Epic React/React Fundamentals/00_Hello World in JS.md"
course: "Epic React — React Fundamentals"
created: 2026-05-17
updated: 2026-05-17
---

# Epic React — React Fundamentals — ch00 — Hello World in JS

The course's opening chapter: build "Hello World" using only browser DOM APIs, no React. The point isn't the result — it's establishing the imperative baseline against which everything React adds will land as *abstraction*.

## TL;DR

- Building a DOM node by hand requires `document.createElement`, `setAttribute` / property writes, `textContent`, and `appendChild` — every step is an explicit mutation. See [[dom-create-element]].
- This style is **imperative**: you tell the browser exactly *how* to mutate the DOM, step by step.
- React's value proposition lands once you've felt the imperative version. The next chapter ([[epic-react-rf-01-raw-react-apis]]) reframes the same example with [[react-create-element|`React.createElement`]] and [[react-create-root|`createRoot`]].
- Several attribute-setting shorthands exist (`el.id`, `el.className`, `classList`) — worth knowing but not the focus.

## Key takeaways

- **The minimum DOM API set for "render something":** `createElement`, `setAttribute` (or property assignment), `textContent`, `appendChild`. Everything in [[dom-create-element]].
- **Imperative vs declarative is the framing for the whole course.** Every step here is a command. React lets you describe the *desired* tree and offloads the mutations.
- **`getElementById` ≡ `querySelector('#...')`** — Epic React mentions both, useful to remember when reading varied codebases.
- **Class-attribute foot-gun preview:** `class` is reserved in JS, hence both `setAttribute('class', ...)` and `el.className = ...` exist. This is also why React uses `className` in JSX, covered in [[react-jsx]].

## Notable passages

> "This is an imperative way to create `Hello World` in JavaScript."
> — *Epic React: React Fundamentals*, ch. 0

## Open questions

- How does `classList` compare to `className`? Flagged `#todo` in raw notes.
- At what tree size does the imperative pattern actually break down ergonomically? (Empirical / qualitative — worth revisiting after a few more chapters to articulate the slope.)

## Cross-references

- Next chapter: [[epic-react-rf-01-raw-react-apis]]
- Concepts introduced: [[dom-create-element]]
- Related: [[react-create-element]], [[react-create-root]] (the next chapter's React rewrite of this example).
