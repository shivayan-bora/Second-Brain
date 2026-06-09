---
title: "Tailwind — Build UIs That Don't Suck"
pillar: software-engineering
type: summary
tags: [documentation, tailwind, css, accessibility, patterns]
status: stable
source: "raw/documentation/tailwindcss.com/Build UIs that dont suck.md"
course: "Tailwind CSS documentation"
created: 2026-06-09
updated: 2026-06-09
---

# Tailwind — Build UIs That Don't Suck

Single-pattern page from Tailwind's docs. Demonstrates the **stretched-`<span>` link** technique for making an entire card hoverable/clickable while keeping the underlying anchor accessible (screen readers announce only the meaningful header, not the entire card text).

## TL;DR

- **Anti-pattern**: wrap the entire card in `<a>`. Screen readers read out everything inside the link, including paragraph body text. Hostile to assistive tech.
- **Pattern**: wrap *only the heading* in `<a>`, then place a `<span class="absolute inset-0 z-10">` inside the anchor. The span stretches across the entire `relative` parent, making the whole card a click target — but the link's accessible name is still just the heading.
- `inset-0` is the **`top: 0; right: 0; bottom: 0; left: 0`** shorthand. Combined with `position: absolute`, it stretches to fill the nearest positioned ancestor.
- The card container needs `relative isolate` — `relative` to be the positioning context, `isolate` to create a stacking context that contains the absolutely-positioned span's `z-index`.

## Key takeaways

- This is one of those patterns where Tailwind makes the technique *trivial* to express (`absolute inset-0 z-10`) compared to writing the equivalent CSS. The friction of writing positioning by hand is what usually pushes developers to do the wrong, accessibility-hostile thing.
- `isolate` (CSS `isolation: isolate`) is an underused utility — it prevents `z-index` leakage between independent components.
- Pattern composes well with the [[tailwind-variants]] system: `hover:bg-zinc-200/70` on the parent applies to the whole card on hover, including the click area created by the span.

## Notable passages

> "`inset` serves as a shorthand to simultaneously set the `top`, `right`, `bottom` and `left` positioning properties of an element in CSS."

> "This is useful for accessibility as the link now only wraps the header, so screen readers will only read out the header on focus."

## Open questions

- What's the keyboard/focus behavior of this pattern? Tabbing should focus the anchor (heading), but does the focus ring look right when the visible focus is on a header inside a card?
- For mobile/touch, the entire card is a tap target via the stretched span — but the focus outline still draws around the heading. Worth verifying.

## Cross-references

- Concepts: [[utility-first-css]], [[tailwind-variants]].
- Companion: [[tailwind-core-concepts]] — covers the underlying utilities.

## Source

- `raw/documentation/tailwindcss.com/Build UIs that dont suck.md`
