---
title: "Epic React: Advanced Patterns ch00 — Composition"
pillar: software-engineering
type: summary
tags: [course, chapter, react, composition, patterns]
status: stable
source: "raw/courses/Epic React/Advanced React Patterns/00_Composition.md"
course: "Epic React — Advanced React Patterns"
created: 2026-06-09
updated: 2026-06-09
---

# Epic React: Advanced Patterns ch00 — Composition

Opening chapter of Epic React's *Advanced Patterns* track. Frames composition (passing React elements as props/children) as the canonical answer to [[prop-drilling]], distinguishing it from the easy-but-overreaching reach for `useContext`.

## TL;DR

- **[[prop-drilling]] isn't always bad** — it makes data flow explicit, which is the same property that makes ESM imports better than globals. The pain comes from refactors: renaming, over-forwarding, under-forwarding, abusing `defaultProps`.
- Before reaching for `useContext`, try **composition**: pass React elements as props instead of treating components as uncrossable walls. See [[react-composition]].
- A **[[react-layout-components|layout component]]** is the canonical product of this discipline: a component that knows where things go, not what they are. Three implementation shapes — `children`, named-slot props, `<Outlet />`.
- The mental model shift: **components don't have to plumb props they don't use**. Pass the pre-constructed element down; intermediate components become element-agnostic layout containers.

## Key takeaways

- **Composition collapses the middle.** When the grandchild needs `count` but the child doesn't, ordinary refactoring forces every intermediate component to thread the prop. Composition lets the App pass a pre-built `<button>` element to a `grandChild` prop, so intermediate components carry React elements instead of domain data.
- **The four [[prop-drilling]] pains are renames, over-/under-forwarding, and `defaultProps` masking.** Each is a *refactor* problem, not a runtime problem. Composition shrinks the surface that needs to change on refactor.
- **Layout components vs domain components.** A layout component is *deliberately* agnostic about what it renders — that's what makes it reusable across pages and routes.
- **`useContext` is the right answer when the value is truly cross-cutting** (auth user, theme, locale) and not when you just want to avoid threading one prop two levels.

## Notable passages

> "Here we're passing React elements rather than treating components as uncrossable boundaries. You can keep the components that don't care about state free of the plumbing needed to make it work."
> — Epic React, *Advanced React Patterns ch. 0*

> "A layout component in React is a special-purpose component whose primary job isn't to render its own unique data, but to define the structural skeleton — the visual scaffolding — within which other components live and breathe."
> — Epic React, *Advanced React Patterns ch. 0*

## Open questions

- Where does composition stop being enough and `useContext` (or a state library) become genuinely necessary? Probably when the same value would have to be passed to many sibling subtrees.
- Compound components (`<Tabs.Root>`, `<Tabs.Trigger>`) are the same idea pushed further with context — covered later in the track?
- How does this interact with React Server Components, where children can cross the server/client boundary?

## Cross-references

- Companion fundamentals: [[epic-react-rf-03-custom-components]] (basic `children`) and [[react-dev-00-quick-start]] (basics of props/state lift).
- Concepts: [[react-composition]], [[prop-drilling]], [[react-layout-components]].

## Source

- `raw/courses/Epic React/Advanced React Patterns/00_Composition.md`
