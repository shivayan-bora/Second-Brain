---
title: "Compound Components"
pillar: software-engineering
type: concept
tags: [react, patterns, composition, library-design]
status: stable
sources: ["[[article-building-components-radix-ui]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Compound Components

## Definition

A **compound component** is a component exposed as a namespace of sub-components that work together: `<Dialog.Root>`, `<Dialog.Trigger>`, `<Dialog.Content>`, etc. The parent (`.Root`) coordinates shared state and behavior via React context; the children are slots that opt into one part of the API surface.

## Why it matters

Compound components are the API shape every modern headless library converges on (Radix, Headless UI, cmdk, shadcn/ui). They let consumers compose flexibly — omit pieces, reorder, swap in custom elements via [[aschild-and-slot|`asChild`]] — while keeping the cross-cutting state (open/closed, selected item, focus) encapsulated.

For staff-level review, recognizing the compound shape is fast feedback on whether a component library is "well-designed" — most well-designed libraries since 2020 use it; most that don't, struggle with composition flexibility.

## Anatomy — Radix Dialog as canonical example

```tsx
<Dialog.Root>                      {/* state + context root */}
  <Dialog.Trigger>Open</Dialog.Trigger>   {/* opens the dialog */}
  <Dialog.Portal>                  {/* renders into document.body */}
    <Dialog.Overlay />             {/* backdrop */}
    <Dialog.Content>               {/* the dialog surface */}
      <Dialog.Title>Title</Dialog.Title>
      <Dialog.Description>...</Dialog.Description>
      {/* your content */}
      <Dialog.Close>Close</Dialog.Close>
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>
```

Each piece:

- **`Root`** — provides context, owns state.
- **`Trigger`** — the button that opens it.
- **`Portal`** — escapes the parent DOM tree (renders into `body`).
- **`Overlay`** — the dimmed backdrop.
- **`Content`** — the actual surface.
- **`Title` / `Description`** — wired to ARIA labels (`aria-labelledby`, `aria-describedby`).
- **`Close`** — the close button.

The consumer composes in the order *they* want.

## Why namespaces (not flat props)

A flat-prop alternative might look like:

```tsx
<Dialog
  trigger={<button>Open</button>}
  title="Title"
  description="..."
  overlay={true}
  portal={true}
>
  My content
</Dialog>
```

This works for simple cases but breaks down for any of:

- Customizing the trigger's styles deeply.
- Reordering elements (e.g., close button at the top).
- Conditional rendering (skip the Portal in tests).
- Adding decorators to specific parts (motion wrapping just the Overlay).

The namespace-of-subcomponents shape handles all of these naturally.

## How the state machinery works

```tsx
function DialogRoot({ children, ...props }: DialogRootProps) {
  const state = useDialogState(props);
  return (
    <DialogContext.Provider value={state}>
      {children}
    </DialogContext.Provider>
  );
}

function DialogTrigger({ children, asChild }: DialogTriggerProps) {
  const { open, setOpen } = useDialogContext();
  // ... attach onClick, ARIA, etc.
}
```

The parent's React context is what wires the sub-components without prop drilling. Each sub-component reads from `DialogContext` and contributes its slice.

## Constraints / pitfalls

- **Order can matter.** Some compound components require specific nesting (`Portal` must be inside `Root`, `Title` must be inside `Content`). Errors surface as missing ARIA labels rather than crashes.
- **Tree-shaking subtleties.** Sub-components are usually attached to a namespace object — bundlers must support property-mangling tree-shaking. Modern bundlers do; older ones might not.
- **TypeScript hierarchy.** Typing the sub-components and ensuring `<Dialog.Trigger asChild>` flows through requires care.

## Related

- [[radix-primitives]] — uses compound components universally.
- [[aschild-and-slot]] — pairs with compound to let children be customized.
- [[compound-component-pattern]] (pattern) — formalized as a library-design pattern.
- [[react-composition]] — the underlying mechanism.

## Sources

- [[article-building-components-radix-ui]] — explicit Dialog anatomy: Root, Trigger, Portal, Overlay, Content, Title, Description, Close.
