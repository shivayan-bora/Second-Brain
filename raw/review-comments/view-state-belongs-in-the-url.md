---
id: view-state-belongs-in-the-url
aliases: []
tags:
  - review-comments
  - routing
  - state
creation date: 2026-10-01 14:30
modification date: Thursday 1st October 2026 14:30:11
---

## The idea
State that describes *what the user is looking at* (filters, sort, tab, grid vs list view, page number) belongs in the URL search params. Web storage (`localStorage`, `sessionStorage`) is a poor home for it: it doesn't travel with links, it differs between tabs, and it can throw or be empty in private or locked-down browsers. A common smell is reaching for `sessionStorage` because a component remounts and loses its `useState`. The URL already survives remounts.

## Example
```tsx
// Trap: survives a remount, but not a shared link or a new tab
const [view, setView] = useState(() => sessionStorage.getItem('view') ?? 'grid')

// Better: the router owns it (TanStack Router style)
const searchSchema = z.object({ view: z.enum(['grid', 'list']).optional() })
const { view = 'grid' } = route.useSearch()
const setView = (next) => navigate({ search: (prev) => ({ ...prev, view: next }) })
```

## Why it matters
Users expect Back, reload, bookmarks and "copy link" to bring them to the same view. Keeping half the page state in the URL and half in storage means some of it silently resets. One source of truth also makes tests simpler: render with a URL and assert.

## Rule of thumb
If you would want it restored from a pasted link, put it in the URL. Use web storage only for per-device preferences that shouldn't be shared (theme, dismissed hints), and wrap every access in try/catch. See [[URL as State]] and [[url-state-round-trip]].
