---
title: document.createElement (imperative DOM)
pillar: software-engineering
type: concept
tags: [javascript, dom, web]
status: stable
sources: ["[[epic-react-rf-00-hello-world-js]]"]
created: 2026-05-17
updated: 2026-06-09
---

# `document.createElement` — Imperative DOM

## Definition

`document.createElement(tagName)` is the browser's built-in API for creating a new DOM node from JavaScript. The node is detached until you insert it into the tree with `appendChild` / `append` / `insertBefore`. This is the **imperative** baseline that React abstracts over.

## Why it matters

Every React mental model starts here: React's job is to let you describe UI *declaratively* and have the runtime issue the same `createElement` / `appendChild` / `setAttribute` calls a human would otherwise hand-write. Knowing the imperative version makes the React version make sense.

## Mechanics

Minimal "Hello World" without any framework:

```html
<div id="root"></div>
<script type="module">
  const rootDiv = document.getElementById('root')
  const childDiv = document.createElement('div')
  childDiv.setAttribute('class', 'container')
  childDiv.textContent = 'Hello World'
  rootDiv.appendChild(childDiv)
</script>
```

Equivalent shorthands worth knowing:

- `document.getElementById('root')` ≡ `document.querySelector('#root')`.
- `el.setAttribute('id', 'root')` ≡ `el.id = 'root'`.
- `el.setAttribute('class', 'container')` ≡ `el.className = 'container'`. See also `el.classList`.
- `el.textContent = 'x'` creates a text node and appends it as the only child.

## The contrast with React

| Step | Vanilla DOM | React |
|---|---|---|
| Create a node | `document.createElement('div')` | `React.createElement('div', props, ...children)` |
| Set a class | `el.className = 'container'` | `{ className: 'container' }` prop |
| Set text | `el.textContent = 'Hi'` | `children: 'Hi'` |
| Mount | `parent.appendChild(el)` | `createRoot(parent).render(el)` |

The vanilla approach mutates DOM nodes step by step. The React approach builds a description of the desired tree and delegates the mutation to the renderer. See [[react-create-element]] and [[react-create-root]].

## Related

- [[react-create-element]] — React's analogue.
- [[react-create-root]] — replaces `appendChild` as the mount call.

## Sources

- [[epic-react-rf-00-hello-world-js]] (`raw/courses/Epic React/React Fundamentals/00_Hello World in JS.md`)
