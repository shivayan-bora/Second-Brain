---
id: tailwind-scans-raw-source-text
aliases: []
tags:
  - review-comments
  - tailwind
  - css
creation date: 2026-10-07 13:23
modification date: Wednesday 7th October 2026 13:23:55
---

## The idea
[[Tailwind CSS]] (v3 JIT and v4) builds its stylesheet by scanning your source files **as plain text** for things that look like class names. It never runs your JavaScript. The class has to appear in the file exactly as it will appear in the DOM. If the source spells it differently from the runtime string (escaped quotes, string concatenation, a template built from variables), no CSS is generated. The element still gets the class name at runtime, so nothing errors and nothing renders.

## Example
```tsx
// Works: the raw text matches the runtime class
<div className="bg-[radial-gradient(theme('colors.gray.200')_4%,white_3%)]" />

// Broken: the file text contains theme(\'colors.gray.200\') with backslashes.
// At runtime the string is correct, but Tailwind never saw that spelling.
// v3 even warns: "contains an invalid theme value and was not generated"
const styles = 'bg-[radial-gradient(theme(\'colors.gray.200\')_4%,white_3%)]'

// Fix: pick the quote style that needs no escaping
const styles = "bg-[radial-gradient(theme('colors.gray.200')_4%,white_3%)]"

// Same trap with string building
const color = isError ? 'red' : 'green'
<p className={`text-${color}-600`} />          // never generated
<p className={isError ? 'text-red-600' : 'text-green-600'} /> // generated
```

## Why it matters
The failure is silent. Unit tests in jsdom assert `toHaveClass(...)`, which checks the attribute and never checks that a matching CSS rule exists, so the suite stays green while the UI loses its styling. It usually shows up during a refactor that moves a class string between a JSX attribute and a JS string, where a linter's preferred quote style quietly adds escapes.

## Rule of thumb
Write every class as a complete, literal string in the source, with no escapes and no interpolation. After moving an arbitrary-value class (`bg-[...]`, `grid-cols-[...]`), run the Tailwind CLI against that file or look at the page. A class-name test only proves the class is on the element, not that it renders.
