---
title: createRoot (react-dom/client)
pillar: software-engineering
type: concept
tags: [react, react-dom, rendering]
status: stable
sources: ["[[epic-react-rf-01-raw-react-apis]]", "[[react-dev-00-quick-start]]"]
created: 2026-05-17
updated: 2026-06-09
---

# `createRoot` (from `react-dom/client`)

## Definition

`createRoot(domNode)` is the entry point in `react-dom/client` that connects a React element tree to a real DOM node. It returns a root object with `.render(element)` and `.unmount()` methods. This is the call that actually paints pixels.

## Why it matters

React splits cleanly into two packages: `react` produces elements; `react-dom` (web) or `react-native` (mobile) renders them. `createRoot` is the seam — it's where the platform-agnostic tree of [[react-element-vs-component|React elements]] meets the browser's DOM. The split also explains why `React.createElement` lives in one import and `createRoot` in another.

## Mechanics

```js
import { createRoot } from 'react-dom/client'

const rootElement = document.getElementById('root')
createRoot(rootElement).render(<App />)
```

- The `domNode` argument is an *existing* element in the DOM. React owns its children from that point on; don't mutate them by hand.
- `.render(element)` can be called again on the same root to update; React reconciles the new tree against the previous one.
- Replaces the legacy `ReactDOM.render(element, container)` API used before React 18. The new API is what unlocks concurrent rendering.

## Examples

Mounting against an `<div id="root">` baked into HTML:

```html
<div id="root"></div>
<script type="module">
  import { createElement } from '/react.js'
  import { createRoot } from '/react-dom/client.js'

  const element = createElement('div', { className: 'container' }, 'Hello World')
  createRoot(document.getElementById('root')).render(element)
</script>
```

Mounting against a node created on the fly:

```tsx
const rootEl = document.createElement('div')
document.body.append(rootEl)
createRoot(rootEl).render(<App />)
```

## Related

- [[react-create-element]] — produces the element you pass to `.render`.
- [[react-jsx]] — typical authoring surface.
- [[dom-create-element]] — the imperative DOM equivalent of "create a container and put stuff in it".

## Sources

- [[epic-react-rf-01-raw-react-apis]] (`raw/courses/Epic React/React Fundamentals/01_Raw React APIs.md`)
- [[react-dev-00-quick-start]] (`raw/documentation/react.dev/00_Quick Start.md`)
