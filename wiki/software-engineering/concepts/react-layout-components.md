---
title: "Layout Components (React)"
pillar: software-engineering
type: concept
tags: [react, layout, patterns, composition]
status: stable
sources: ["[[epic-react-arp-00-composition]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Layout Components (React)

## Definition

A **layout component** is a React component whose job is to define *where* things go on the page, not *what* those things are. It accepts content via `children`, named slot props, or a route outlet, and renders that content inside a fixed structural skeleton (header/sidebar/main, two-column, modal frame, etc.).

## Why it matters

Layout components are the canonical product of [[react-composition|composition]] discipline. They're deliberately agnostic about their content, which is what makes them reusable across pages and routes. Recognizing when a "page" should actually be a layout + content is a basic refactoring move.

## Three implementation patterns

| Pattern | Shape | When to use |
|---|---|---|
| **Children prop** | `<Layout>{pageContent}</Layout>` | One content slot; simplest case. |
| **Named slot props** | `<Layout header={<Header/>} footer={<Footer/>} />` | Multiple distinct regions, each customizable per page. |
| **Router outlet** | `<Layout>` renders `<Outlet />`; matched routes fill the slot | Route-driven apps where one layout wraps many pages. |

## Mechanics

### Children prop

```tsx
function PageLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="page">
      <Header />
      <main>{children}</main>
      <Footer />
    </div>
  );
}
```

### Named slots

```tsx
function PageLayout({
  header,
  sidebar,
  main,
}: {
  header: React.ReactNode;
  sidebar: React.ReactNode;
  main: React.ReactNode;
}) {
  return (
    <div className="page">
      <header>{header}</header>
      <aside>{sidebar}</aside>
      <main>{main}</main>
    </div>
  );
}
```

### Router outlet (React Router)

```tsx
import { Outlet } from "react-router-dom";

function AppLayout() {
  return (
    <div className="page">
      <Header />
      <main><Outlet /></main>
      <Footer />
    </div>
  );
}
```

## Trade-offs

- **Children prop** — cleanest API; one slot only. Use when the layout has obvious "main content" + a stable shell.
- **Named slots** — flexible but more verbose for consumers. Use when multiple regions vary per page.
- **Router outlet** — best when routes naturally drive content. Couples the layout to a router; mixed with the children form for shared shells.

## Examples

A common pattern combines named slots for top-level structure with `children` deeper inside:

```tsx
<AppShell
  header={<Header user={user} />}
  sidebar={<Sidebar />}
>
  {/* page-specific main content */}
  <DashboardPage />
</AppShell>
```

## Related

- [[react-composition]] — the discipline that produces layout components.
- [[react-components]] — the unit being composed.
- [[react-props]] — `children` and named slots are just props.

## Sources

- [[epic-react-arp-00-composition]] — three-pattern table comes from here.
