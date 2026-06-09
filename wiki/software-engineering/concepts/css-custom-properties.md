---
title: "CSS Custom Properties (Variables)"
pillar: software-engineering
type: concept
tags: [css, variables, theming, custom-properties]
status: stable
sources: ["[[scrimba-learn-css-variables]]"]
created: 2026-06-09
updated: 2026-06-09
---

# CSS Custom Properties (Variables)

## Definition

CSS Custom Properties are named values declared with the `--name: value` syntax and read with `var(--name)`. They live in the cascade — declared at any selector, scoped to its subtree, and overrideable by more specific selectors. Unlike SASS/LESS variables, they exist at runtime, are readable/writable from JavaScript, and respond to media queries.

## Why it matters

CSS variables are the platform's native answer to design tokens and theming. They're a small primitive with outsized leverage: change the variable in one place, every consuming property re-evaluates. This is the substrate Tailwind v4 sits on top of, and it's the cleanest way to ship a theme switcher (light/dark/high-contrast) without JS-mediated DOM updates per element.

## Mechanics

### Declaration and use

```css
:root {
  --red: #ff6f69;
  --beige: #ffeead;
}

button {
  background: var(--red);
  color: var(--beige);
}
```

- `:root` is the convention for "global" — it matches the `<html>` element, so the variable is visible everywhere.
- `var(--name)` reads the value. Optional fallback: `var(--name, defaultValue)`.

### Cascade-based override

Re-declare inside a more specific selector to override for that subtree:

```css
:root { --red: #ff6f69; }
.warning { --red: #cc0000; }   /* only .warning and descendants */
```

### Media-query swap

Change a variable inside `@media`, and every `var(--name)` in scope retargets:

```css
:root { --columns: 200px 200px; }

@media (max-width: 450px) {
  :root { --columns: 200px; }
}

.grid { grid-template-columns: var(--columns); }
```

One variable, two layouts. No `.grid-mobile` class, no per-property duplication.

### JS interop

```js
// Read
const root  = document.querySelector(':root');
const style = getComputedStyle(root);
const red   = style.getPropertyValue('--red');   // " #ff6f69"

// Write
root.style.setProperty('--red', 'green');
```

The asymmetry (computed read, inline-style write) is a thing to memorize. `getComputedStyle` is needed because the variable lives in the cascade, not on the element's `style` attribute.

## Vs SASS/LESS

| | CSS Custom Properties | SASS/LESS Variables |
|---|---|---|
| Compile time? | No — native CSS | Yes — compiled away |
| Runtime mutation | Yes (JS, media queries) | No |
| Cascade-aware | Yes | No |
| Scope | Any selector | File / function |
| Browser support | Modern (all evergreen) | n/a — emits plain CSS |

## Examples

- **Theme switcher**: declare `--bg`, `--fg`, etc., at `:root`; override the same names under `[data-theme="dark"]`. Switching themes is one attribute toggle.
- **Component theming**: a `<Button>` exposes `--button-bg` for consumers to override without forking the component.
- **JS-driven values**: a slider sets `--brightness`, CSS reads it.

## Related

- [[design-tokens]] — the abstract; CSS variables are one concrete vehicle.
- [[utility-first-css]] — Tailwind v4 compiles to CSS variables internally.
- [[react-styling-options]] — `style={{ "--red": "green" }}` is the React-flavored write API.

## Sources

- [[scrimba-learn-css-variables]]
