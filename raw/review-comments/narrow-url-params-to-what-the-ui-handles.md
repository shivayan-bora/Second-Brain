---
id: narrow-url-params-to-what-the-ui-handles
aliases:
  - validate url enums against the supported subset
tags:
  - review-comments
  - routing
  - security
creation date: 2026-10-02 12:08
modification date: Friday 2nd October 2026 12:08:08
---

## The idea
A search param is user input: anyone can edit the URL or follow an old link. When a param selects one of a few views, validate it against the values that screen actually supports, not against the full enum the backend happens to have. A wider schema lets the URL reach states the UI never designed for, and the UI usually mislabels them with an `else` branch.

## Example
```ts
// Backend enum: active | inactive | draft | archived | deleted
// Trap: any backend state passes, and the label's else-branch calls them all "Inactive"
const Search = z.object({ state: StatusEnum.optional().catch(undefined) })
const label = state === 'active' ? 'Active' : 'Inactive'

// Better: only the states this view offers, everything else falls back to the default view
const ViewState = z.enum(['active', 'inactive'])
const Search = z.object({ state: ViewState.optional().catch(undefined) })
const LABELS = { active: 'Active', inactive: 'Inactive' } as const satisfies Record<z.infer<typeof ViewState>, string>
```
Using an explicit map instead of a ternary means a new value fails type-checking instead of rendering under the wrong name.

## Why it matters
The page can end up querying data it shouldn't show (drafts, deleted rows) under a heading that says otherwise, and none of the visible controls reflects the current filter. This is the [[Parse Dont Validate]] idea applied at the [[URL State]] boundary.

## Rule of thumb
Schema at the URL edge = exactly the options the UI renders, with `.catch()` back to the default.
