---
title: "Compound Component Pattern"
pillar: software-engineering
type: pattern
tags: [react, library-design, composition, patterns]
status: stable
sources: ["[[article-building-components-radix-ui]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Compound Component Pattern

## Context

You're designing a stateful UI component — a Dialog, Tabs, Menu, Combobox, Accordion — that has multiple distinct visual parts (trigger, panel, header, items, close button). The component needs to coordinate shared state (open/closed, selected index, focus) across these parts, and you want consumers to compose it flexibly.

## Problem

A flat-props API breaks down quickly:

```tsx
<Dialog
  trigger={<button>Open</button>}
  title="Hello"
  description="..."
  showCloseButton
  showOverlay
  overlayClassName="..."
  contentClassName="..."
  closeButtonClassName="..."
  onClose={() => {}}
>
  <p>content</p>
</Dialog>
```

Problems:

- **Customization explodes.** Every styling or rendering nuance becomes another prop.
- **Reordering is impossible.** Want the close button at the top? You can't.
- **Conditional rendering is awkward.** Want to skip the Portal in tests? Add `disablePortal`? Add `usePortal=false`?
- **TypeScript surface gets unmanageable.** Two dozen props, half optional, with conditional types.
- **The API breaks down when one prop affects another.** `<Dialog showCloseButton={true} closeButtonPosition="top-right" />` is a code smell.

A simpler imperative API (`dialog.open()`, `dialog.close()`) trades the flat-prop problem for a lifecycle-management problem and loses React's declarative rendering benefits.

## Solution

Expose the component as a **namespace of sub-components** that share state via React Context:

```tsx
<Dialog.Root>
  <Dialog.Trigger>Open</Dialog.Trigger>
  <Dialog.Portal>
    <Dialog.Overlay />
    <Dialog.Content>
      <Dialog.Title>Hello</Dialog.Title>
      <Dialog.Description>...</Dialog.Description>
      <Dialog.Close>Close</Dialog.Close>
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>
```

The consumer:
- **Includes only what they need.** Skip `Portal` and rendering happens inline.
- **Orders the pieces however.** Close button at the top? Move `<Dialog.Close>` up.
- **Styles each part independently.** Each sub-component takes its own props.
- **Uses [[aschild-and-slot|`asChild`]] for custom elements.** `<Dialog.Trigger asChild><MyButton/></Dialog.Trigger>`.

The state machinery lives in `Dialog.Root`, which provides a Context that the other sub-components read.

## Trade-offs

### Pros

- **Composition over configuration.** The API surface stays small; flexibility comes from composition.
- **Discoverable.** Auto-complete shows all the slots when you type `Dialog.`.
- **Each part is independently customizable** — className, style, refs, event handlers, all isolated.
- **Forwards perfectly to design systems.** Wrap the compound (`<MyDialog>` that internally uses `<Dialog.Root>...<Dialog.Content>...</Dialog.Content></Dialog.Root>`) and consumers see a friendly API.
- **Accessibility wiring is invisible** — Radix's `Title` and `Description` auto-set `aria-labelledby`/`aria-describedby`.

### Cons

- **Verbose at the call site** — `<Dialog.Root><Dialog.Trigger>...</Dialog.Trigger>...<Dialog.Close/></Dialog.Root>` is longer than `<Dialog onClose={...}>`.
- **Required ordering is implicit.** Some sub-components must be inside specific parents (e.g., `Title` must be inside `Content`). Errors are runtime warnings, not compile-time.
- **Tree-shaking subtlety.** Sub-components attached to a namespace object require bundlers that handle property-access tree-shaking (modern bundlers do).
- **Typing is more involved.** `forwardRef`, generics, and ref-forwarding through compound shapes need care.

### When NOT to use

- **Simple, single-slot components.** A `<Tooltip text="..." />` doesn't need a compound API.
- **One-off internal components.** The pattern shines for *reusable libraries*; it's overkill for a one-shot widget.
- **Components without internal coordinated state.** If there's no context to share, you don't need a Root.

## Examples in the wild

- **Radix UI** — every Primitive uses this pattern (`Dialog`, `DropdownMenu`, `Select`, `Tooltip`, `Accordion`, `Tabs`, `Switch`...).
- **Headless UI** — uses it for `Menu`, `Listbox`, `Dialog`, `Transition`.
- **shadcn/ui** — copy-paste components that mostly wrap Radix in this same shape.
- **cmdk** — command palette built on the same model.
- **React Aria Components** (when their compound shape works for your case).

## Related

- [[compound-components]] (concept) — the building block.
- [[aschild-and-slot]] — the customization escape hatch most compound libraries pair with this pattern.
- [[react-composition]] — the underlying React mechanism.
- [[headless-ui-library]] — most headless libraries use compound components as their API.

## Sources

- [[article-building-components-radix-ui]] — Dialog's eight-element anatomy is the canonical example.
