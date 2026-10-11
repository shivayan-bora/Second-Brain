---
id: colocate-route-metadata-with-the-route
aliases:
  - Colocate route metadata with the route
tags:
  - review-comments
  - routing
  - react
creation date: 2026-10-05 14:53
modification date: Monday 5th October 2026 14:53:37
---

## The idea
Apps often keep per-page metadata (page title, breadcrumb label, sidebar entry, analytics name) in separate lookup tables keyed by path, apart from the route definitions. Each table is a parallel registry that has to be updated by hand for every new page. When a lookup misses, it usually falls back to an empty value rather than failing, so a forgotten entry ships unnoticed: the page works, but its title or breadcrumb is missing.

## Example
```ts
// Parallel registry: easy to forget, fails silently
const PAGE_TITLES = [
  { prefix: '/reports/overview', getTitle: () => 'Overview' },
  // '/reports/exports' forgotten -> title is ''
]
const title = PAGE_TITLES.find((e) => path.startsWith(e.prefix))?.getTitle() ?? ''

// Colocated: the route carries its own metadata
const exportsRoute = createRoute({
  path: 'exports',
  staticData: { getTitle: () => 'Exports' },
  component: Exports,
})
// consumer reads the deepest match
const title = matches.at(-1)?.staticData.getTitle?.()
```
Most routers support this, for example route `staticData`/`context` in TanStack Router and `handle` in React Router. Typing the metadata field as required makes a missing title a compile error.

## Why it matters
Each new page adds one more chance for the registries to drift apart, and the failures are visual (blank breadcrumb, missing tab title), so tests that only check the page body pass. Prefix-matched tables also depend on order: a broad prefix listed too early can claim a more specific route.

## Rule of thumb
Keep metadata that is "one per route" on the route itself. While a parallel table still exists, grep a sibling page's path when you add a page and update every hit, and make the lookup's tests enumerate the real nav items so a missing entry shows up as a failing test. See [[Single Source of Truth]] and [[Route Guards]].
