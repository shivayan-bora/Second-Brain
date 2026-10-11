---
id: main-landmark-contains-page-heading
aliases: []
tags:
  - review-comments
  - accessibility
  - react
creation date: 2026-09-30 12:05
modification date: Thursday 1st October 2026 14:30:11
---

## The idea
`<main>` is the [[ARIA Landmarks|landmark]] that screen readers and "skip to content" links jump to. It should contain the page's `h1` and any controls that switch the main content (tabs, filters). A common way to break this is a route layout that renders the heading and tabs, then an `<Outlet />` whose child page renders its own `<main>`. The landmark then starts below the heading and the tabs.

## Example
```tsx
// Trap: heading and tabs sit outside the landmark
const Layout = () => (
  <div>
    <h1>Hygiene</h1>
    <Tabs>{/* tab links */}</Tabs>
    <Outlet /> {/* child renders <main>...</main> */}
  </div>
)

// Better: the layout owns the landmark, children render plain content
const Layout = () => (
  <main>
    <h1>Hygiene</h1>
    <Tabs>{/* tab links */}</Tabs>
    <Outlet /> {/* child renders a <div> or <section> */}
  </main>
)
```
If the child page is also used standalone, give it a way to skip its own `<main>` when an ancestor already provides one, for example a small context set by the layout.

The opposite failure happens behind a feature flag or redesign switch: the old branch wraps the page in `<main>`, the new branch renders a new root `<div>`, and the landmark quietly disappears only in the new UI.
```tsx
// Trap: only the old branch has a landmark
flag ? <NewPage /> /* root is <div> */ : <main><OldPage /></main>

// Better: the landmark sits above the switch, or both roots render <main>
<main>{flag ? <NewPage /> : <OldPage />}</main>
```

## Why it matters
A keyboard or screen-reader user who jumps to the main region lands past the title and the tabs, so they don't know which view they're in and can't reach the control that changes it without backtracking. A page should have exactly one visible `<main>`, and nesting them confuses assistive tech.

## Rule of thumb
Whoever renders the `h1` should also render `<main>`. When you add a [[React Router]] layout above existing pages, move the landmark up with it.
