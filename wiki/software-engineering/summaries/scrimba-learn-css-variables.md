---
title: "Scrimba — Learn CSS Variables"
pillar: software-engineering
type: summary
tags: [course, css, variables, custom-properties, theming]
status: stable
source: "raw/courses/scrimba/Learn CSS Variables.md"
course: "Scrimba — Learn CSS Variables"
created: 2026-06-09
updated: 2026-06-09
---

# Scrimba — Learn CSS Variables

Short Scrimba course on CSS custom properties (a.k.a. CSS variables). Covers declaration, the `:root` scope convention, cascade-based overrides, the JS read/write API, and the responsive trick of swapping variables inside a media query.

## TL;DR

- CSS variables are declared with `--name: value` and consumed with `var(--name)`. Declare at `:root` for global, anywhere else for scoped overrides. See [[css-custom-properties]].
- They're real **language-level** CSS — no transpiler needed. Unlike SASS/LESS variables, they live in the runtime DOM, can be read/written by JS, and respond to media queries.
- **Override by re-declaring** in a more specific selector — the cascade does the rest:
  ```css
  :root { --red: #ff6f69; }
  .item { --red: #ff8e69; }   /* only affects .item subtree */
  ```
- **JS interop** is asymmetric:
  - Read: `getComputedStyle(el).getPropertyValue('--red')`.
  - Write: `el.style.setProperty('--red', 'green')`.
- The **media-query swap** trick is the killer feature: change a variable inside `@media`, and every `var(--name)` in that scope retargets. No JS, no per-property repetition.

## Key takeaways

- The mental model is **named values that live in the cascade**. Override semantics work identically to any other CSS property — most-specific wins, scope is selector-based.
- Pairs naturally with [[design-tokens]]: the variable name *is* the token name; theming becomes "swap a few `:root` variables and everything responds."
- The course's bridge example (`.grid { --columns: 200px 200px; }` swapping to `200px` at `max-width: 450px`) shows how one variable can drive a layout, not just a color.

## Notable passages

> "Easier to get started since it's native to the browser (no transpiling). Has access to the DOM — you can create local scopes, change variables with JavaScript, modify variables with media queries. Perfect for themes."
> — Scrimba, *Learn CSS Variables*

## Open questions

- The course doesn't cover `@property` (typed custom properties, animation interpolation). When does the user encounter that?
- What's the runtime cost of mutating `:root` variables in a complex component tree?
- Where's the line between using a single CSS variable for theming vs. shipping a full token system with `@layer` and design-tokens tooling?

## Cross-references

- Concepts: [[css-custom-properties]], [[design-tokens]].
- Related: [[utility-first-css]] — Tailwind v4 actually generates CSS variables, so these two pages bridge.

## Source

- `raw/courses/scrimba/Learn CSS Variables.md`
