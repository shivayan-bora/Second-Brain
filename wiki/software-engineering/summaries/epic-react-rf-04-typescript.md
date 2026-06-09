---
title: "Epic React — RF ch04 — TypeScript"
pillar: software-engineering
type: summary
tags: [course, chapter, react, typescript]
status: stable
source: "raw/courses/Epic React/React Fundamentals/04_TypeScript.md"
course: "Epic React — React Fundamentals"
created: 2026-05-17
updated: 2026-06-09
---

# Epic React — React Fundamentals — ch04 — TypeScript

Add type annotations to components. Covers basic prop typing, `React.ReactNode` for `children`, union/narrow types, derived types (`typeof`, `keyof`), `Record<K, V>`, default props, and `satisfies`.

## TL;DR

- Typing a component is typing its `props` parameter — there are several stylistic forms, all equivalent. See [[react-typescript]].
- Use `React.ReactNode` for the `children` prop; `string` is too narrow (rejects nested elements).
- **Narrow types** (`'+' | '-' | '*' | '/'`) lock a prop to a known set of values — autocomplete works at every call site.
- **Derived types** (`typeof value`, `keyof T`) let the implementation be the source of truth instead of duplicating shape information.
- **`satisfies T`** enforces conformance without widening the literal type — preserves narrow `keyof` derivation.
- Use `@ts-expect-error` (not `@ts-ignore`) to suppress single-line errors temporarily.

## Key takeaways

- **`React.ReactNode` is the right type for `children`** in nearly every case. It's the broadest "renderable thing" union React exposes.
- **Defaults via destructuring** are the React-idiomatic way: `function C({ left = 0 }: Props)`. No `defaultProps` ceremony needed.
- **`Record<K, V>` + function types** clean up lookup tables. Once the table type is annotated, callbacks can drop their inner type annotations — TS infers from the table.
- **`satisfies` is the answer when you want literal precision *and* shape enforcement.** Plain `: Record<string, OperationFn>` widens `keyof typeof operations` to `string`; `satisfies Record<string, OperationFn>` keeps it narrow to `'+' | '-' | '*' | '/'`.
- **Reference:** [typescript-cheatsheets/react](https://github.com/typescript-cheatsheets/react) — flagged in the raw notes as the canonical cheatsheet.

## Notable passages

> "The React types have a `ReactNode`, which is the recommended choice for the children prop."
> — *Epic React: React Fundamentals*, ch. 4

## Open questions

- Full semantics of `satisfies` vs explicit annotation — raw notes flag two pending references (a Perplexity thread and a Total TypeScript video) as `#todo`. Worth a deeper page once those are ingested.
- React event handler typing (`React.MouseEventHandler<HTMLButtonElement>` etc.) — not covered here; expect in a later chapter.

## Cross-references

- Previous: [[epic-react-rf-03-custom-components]]
- Concepts introduced / extended: [[react-typescript]], [[react-components]], [[react-props]]
- Related: [[react-jsx]] (typed props end up here)
