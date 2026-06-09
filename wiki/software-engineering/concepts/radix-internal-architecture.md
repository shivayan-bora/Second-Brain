---
title: "Radix Internal Architecture (Collection.Provider, Impl Pattern, Primitive.div)"
pillar: software-engineering
type: concept
tags: [radix, react, library-design, internals]
status: stable
sources: ["[[radix-ui-overview]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Radix Internal Architecture (Collection.Provider, Impl Pattern, Primitive.div)

## Definition

A look beneath the public-facing [[compound-component-pattern|compound component]] API of [[radix-primitives|Radix Primitives]]. Three internal patterns Radix uses repeatedly: **`Collection.Provider`** for dynamic DOM-based child indexing, **the "Impl" pattern** for separating public APIs from private implementation, and **`Primitive.div` (and friends)** as the lowest-level rendering wrapper.

## Why it matters

You don't *need* to know these to use Radix. But if you're debugging composition issues, contributing patches, or building your own headless library, knowing the architectural choices saves hours. They're also a useful pattern catalog for any team building React libraries at scale — these solve real problems React itself doesn't address.

## 1. `Collection.Provider` — dynamic DOM indexing

### The problem

Radix's compound components let you nest children freely:

```tsx
<Tabs.Root>
  <Tabs.List>
    {someCondition && <Tabs.Trigger value="a">A</Tabs.Trigger>}
    <SomeWrapper>
      <Tabs.Trigger value="b">B</Tabs.Trigger>
    </SomeWrapper>
    <Tabs.Trigger value="c">C</Tabs.Trigger>
  </Tabs.List>
</Tabs.Root>
```

The `Root` needs to know the **order** of triggers (for keyboard navigation: Tab/arrow keys move through them in order), but React's children API can't reliably give this — children can be conditional, wrapped, fragmented, or rendered via portals.

### The solution

`Collection.Provider` is an internal context that maintains a Map of collection items. Each `Tabs.Trigger` registers itself on mount, then uses `querySelector` against a DOM marker (a `data-radix-collection-item` attribute on the wrapping `Primitive.div`) to compute its **runtime position** in the DOM, regardless of how it got there in JSX.

This sidesteps React's "children must be statically structured" limitation. The trade-off: it depends on the DOM being queryable, which means it doesn't work cleanly inside iframes or Shadow DOM boundaries.

### Where you'll see it

Whenever you use `<Tabs>`, `<RadioGroup>`, `<Menu>`, `<Toolbar>`, `<Accordion>` — anything with sibling items that need order-aware behavior.

## 2. The "Impl" pattern — public API vs private logic

### The shape

```ts
// AccordionImpl.tsx (internal)
function AccordionImpl(props: AccordionImplProps) { /* heavy logic */ }
function AccordionImplSingle(props) { /* single-open variant */ }
function AccordionImplMultiple(props) { /* multi-open variant */ }

// Accordion.tsx (public)
function Accordion(props: AccordionProps) {
  return props.type === 'single'
    ? <AccordionImplSingle {...props} />
    : <AccordionImplMultiple {...props} />;
}
```

The top-level `Accordion` is a thin dispatcher; the `*Impl` files hold the actual behavior. The public type stays narrow (e.g., `AccordionSingleProps | AccordionMultipleProps`); the internal types are richer.

### Why split it

- **Type narrowing**: `single` vs `multiple` accordions accept different props. The top-level type is a union; the impl files type-narrow.
- **Source-reading clarity**: when you `Cmd+Click` into `Accordion` in node_modules, you see the dispatcher first, then can drill into the relevant impl.
- **Code reuse without leaking the API**: `*ImplSingle` can call into a shared `*ImplBase` without exposing it.

### Where you'll see it

Any Primitive with mode variants: `Accordion` (single/multiple), `Tooltip` (root with delay/no-delay), `Toggle vs ToggleGroup` (single vs multiple).

## 3. `Primitive.div` (and friends) — the lowest-level wrapper

### What it is

Instead of:

```tsx
<div ref={ref} className={className} {...props}>{children}</div>
```

Radix internally uses:

```tsx
<Primitive.div ref={ref} className={className} {...props}>{children}</Primitive.div>
```

`Primitive.div` is a thin wrapper that:

- **Forwards refs** correctly (composing with [[aschild-and-slot|Slot]] for `asChild`).
- **Merges event handlers** (multiple `onClick` from different layers compose, not overwrite).
- **Injects `data-*` attributes** (`data-state`, `data-side`, etc.) automatically.
- **Standardizes prop merging** so behavior is consistent across all Primitives.

There's one `Primitive.{element}` per HTML element Radix needs to render (`Primitive.div`, `Primitive.button`, `Primitive.span`, `Primitive.li`, etc.).

### Why it matters for consumers

When you use `asChild`, your custom component effectively replaces a `Primitive.{element}`. The contracts Radix expects (ref forwarding, prop spreading, event-handler composition) are the contracts `Primitive.*` upholds. If you mimic them, your `asChild` integration works flawlessly.

## What this implies for users

- **Spread all props in custom child components** — Radix's `Primitive.div` does; your component should too.
- **Forward refs** (or use React 19+'s implicit ref-as-prop) — Radix may need refs for measurement, focus management, scroll positioning.
- **Compose event handlers, don't replace them** — `onClick={composeEventHandlers(props.onClick, myHandler)}`.
- **Don't query the DOM around Radix Primitives without coordination** — `Collection.Provider` may be using `querySelector` on those same nodes.

## Trade-offs

### Pros (for Radix's design)

- **Compound APIs survive arbitrary nesting** thanks to `Collection.Provider`.
- **Public types stay narrow** thanks to the Impl pattern.
- **Behavioral correctness is consistent** thanks to `Primitive.*` wrappers.

### Cons

- **Source code is harder to navigate** — finding "where does this hook actually run" means walking dispatcher → impl → base.
- **`querySelector`-based indexing** has subtle failure modes in Shadow DOM, iframes, and SSR streaming scenarios.
- **The wrapper layers add small runtime overhead** — not measurable for normal use, but a consideration in extreme list-rendering scenarios.

## Related

- [[radix-primitives]] — the public API these patterns implement.
- [[radix-themes]] — themes built on top.
- [[aschild-and-slot]] — Slot uses `Primitive.*` conventions.
- [[compound-components]] — the API shape `Collection.Provider` powers.
- [[compound-component-pattern]] — the formalized pattern.

## Sources

- [[radix-ui-overview]] — explicit treatment of Collection.Provider, the "Impl" pattern, and Primitive.div.
