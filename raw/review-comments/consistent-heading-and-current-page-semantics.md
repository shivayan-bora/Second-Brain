---
id: consistent-heading-and-current-page-semantics
aliases: []
tags:
  - review-comments
  - a11y
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:23:15
---

## The idea
A page should have one `<h1>` with a single owner, and the current item in a breadcrumb should carry `aria-current="page"`. If a component renders different landmarks in different branches (an `h1` in one, a plain crumb in another), the heading count and the "current page" announcement change with an unrelated toggle, and no visual check notices.

## Example
```tsx
// Trap: branch A renders <h1>{title}</h1>, branch B renders <Crumb>{title}</Crumb>,
// and the page header also renders its own <h1>

// Better: the page header owns the h1, the breadcrumb always renders the same way
<nav aria-label="Breadcrumb">
  <ol>
    <li><a href="/parent">Parent</a></li>
    <li><span aria-current="page">{title}</span></li>
  </ol>
</nav>
```

## Why it matters
Screen-reader users navigate by headings and landmarks. Two `h1`s, or none, makes the page structure confusing, and the problem is invisible to sighted testing.

## Nuance: layouts that own the title, and disclosure headers
- If an app shell or top bar renders the page title as the `<h1>`, the page body should not render its own `<h1>` too, especially under a different name. Put extra header content (a "last updated" status, actions) in a row with no heading.
- Radix `Accordion.Header` (and many disclosure components) renders an `<h3>` by default. Headings inside the panel's content should be one level deeper (`<h4>`), or not headings at all. An `<h2>` inside an `<h3>` section inverts the outline. Change the header level with `asChild` when the section sits higher in the page.

```tsx
<Accordion.Header asChild>
  <h2>{sectionTitle}</h2>
</Accordion.Header>
<Accordion.Content>
  <h3>{greeting}</h3>
</Accordion.Content>
```

## Rule of thumb
Every branch of a component should produce the same landmarks. Decide who owns the `h1` once. See [[Accessibility]].
