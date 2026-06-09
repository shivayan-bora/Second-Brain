---
title: "Radix UI — Documentation Overview"
pillar: software-engineering
type: summary
tags: [documentation, radix, react, primitives, composition]
status: stable
source: "raw/documentation/radix.ui/radix.ui.md"
created: 2026-06-09
updated: 2026-06-09
---

# Radix UI — Documentation Overview

User's notes on the Radix UI Primitives docs. Goes a layer deeper than [[article-building-components-radix-ui]] — covers the **internal architecture** (Collection.Provider, the "Impl" pattern, Primitive.div wrapper) and the **composition gotchas** when wrapping `asChild` around your own React components (spread props, forward refs, multi-primitive nesting).

## TL;DR

- **[[radix-primitives|Radix Primitives]]** are barebones, unstyled React components providing behavior + accessibility + state + DOM structure + keyboard/mouse/touch interactivity out of the box. Each primitive is a separate npm package.
- The architecture is **open**: granular access to each part, with composable APIs like `<Accordion.Root>/<Accordion.Item>/<Accordion.Trigger>/<Accordion.Content>` — *not* a single monolithic `<Collapse items={...} />`.
- **Radix powers [[radix-themes|Radix Themes]] and shadcn/ui** — the de-facto react design-system stack rests on these primitives.
- **`data-state` is the styling hook**: `.AccordionItem[data-state="open"] { ... }` lets CSS read the state machine without React state. See [[radix-primitives]].
- **Internal architecture (new this ingest)**:
  - **`Collection.Provider`** — tracks nested elements in the DOM dynamically via `querySelector` to bypass React state limitations on freely-nested compound children.
  - **The "Impl" pattern** — Radix's components delegate heavy lifting to private `*Impl` / `*ImplSingle` layers, keeping the public API clean.
  - **`Primitive.div` wrapper** — instead of rendering plain `<div>`s, Radix wraps in `Primitive.div` to seamlessly pass refs, merge event handlers, and inject `data-*` attributes.
- **[[aschild-and-slot|`asChild`]] gotchas when composing with your own components**:
  - **Spread props**: `<MyButton {...props} />` is the safe default; cherry-picking what to accept will break Radix's prop merging.
  - **Forward ref**: Radix may need to attach a ref (e.g., to measure size). The component must accept and forward refs.
  - **Multi-primitive composition**: chain `asChild` triggers to put both Tooltip + Dialog behavior on one button.

## Key takeaways

- **The radix.ui notes go where [[article-building-components-radix-ui]] doesn't** — into the internals. Useful when debugging composition issues or contributing patches.
- **`Collection.Provider` solves a real React limitation.** React's children API can't tell you "where am I in the tree at runtime" cleanly; Radix sidesteps this with DOM-based dynamic indexing. This is what makes `<Tabs>` know the active index without explicit numbering.
- **The "Impl" naming convention is intentional** — `AccordionImpl`, `AccordionImplSingle`. When debugging Radix source, the `Impl`-suffixed file holds the actual logic.
- **Spread-everything in custom child components** isn't optional. Radix's `asChild` works by `React.cloneElement(child, mergedProps)`. If your component drops a prop it doesn't recognize, you've silently broken the integration.
- **`React.forwardRef` is deprecated in React 19+** but still required for libraries supporting earlier React versions. The source explicitly notes this — direct `ref` passing works in React 19+.
- **Three primitive packages can stack via `asChild`**: `<Dialog.Trigger asChild><Tooltip.Trigger asChild><MyButton/></Tooltip.Trigger></Dialog.Trigger>` — each layer of `asChild` merges its props onto the child below it.

## Notable passages

> "Radix UI has an open component architecture where it allows you to have granular access to each part of the component, so you can wrap and add your own event listeners, props and refs."

> "If you peek into the source code of a Radix primitive, you will notice a heavily layered implementation that separates public APIs from private logic: The Collection Provider... The 'Impl' (Implementation) Pattern... Primitive Wrapper."

> "It's better to spread all the props instead of worrying about which specific props, functionality and event listeners to accept."

> "Please note that `forwardRef` has been deprecated and we can directly pass `ref` to child components."

## Notable transcription quirk

The source has one broken markdown link on line 19: `[Blog: ...][https://...]` — backticks where square brackets should be. Raw is read-only; flagging for a future fix.

## Open questions

- The "Impl" pattern is in many Radix source files but not formally documented by Radix — is this evolving or stable across Primitive versions?
- `Collection.Provider`'s `querySelector` approach has performance implications at scale (large lists, virtualized containers) — does Radix document the perf characteristics?
- React 19's `ref` as prop simplifies things; how does Radix's `Primitive.div` wrapper adapt? Worth re-ingesting once Radix publishes React 19-specific guidance.

## Cross-references

- Companion: [[article-building-components-radix-ui]] (Refine.dev tour — broader, less internals), [[build-ui-radix-00-animated-switch]] (applied example with Tailwind), [[radix-ui-hub]].
- Concepts: [[radix-primitives]], [[radix-themes]], [[aschild-and-slot]], [[compound-components]], [[radix-internal-architecture]].
- Patterns: [[compound-component-pattern]], [[headless-ui-library]].

## Source

- `raw/documentation/radix.ui/radix.ui.md`
