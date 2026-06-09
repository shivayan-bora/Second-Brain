---
title: "`asChild` and Slot (Radix)"
pillar: software-engineering
type: concept
tags: [radix, react, patterns, composition, slot]
status: stable
sources: ["[[article-building-components-radix-ui]]"]
created: 2026-06-09
updated: 2026-06-09
---

# `asChild` and Slot (Radix)

## Definition

**`asChild`** is the Radix prop that tells a component to *forward its behavior and props onto its child* instead of rendering its own wrapper element. **Slot** is the underlying primitive that implements this — it accepts one React element as its child and merges its own props (including event handlers) onto that element via [[react-composition]].

## Why it matters

Without `asChild`, every `<Dialog.Trigger>` renders an extra `<button>`. If you already have a custom `<MyButton>` component that you want to be the trigger, you'd nest them (`<Dialog.Trigger><MyButton>...</MyButton></Dialog.Trigger>`) — producing two buttons in the DOM, breaking accessibility, breaking focus management, and breaking the visual design.

`asChild` flattens this: your `<MyButton>` *becomes* the trigger. One element in the DOM, your styling, Radix's behavior.

## Mechanics

### Without `asChild`

```tsx
<Dialog.Trigger className="my-trigger">
  Open dialog
</Dialog.Trigger>
// Renders:
// <button class="my-trigger" aria-haspopup="dialog" onClick={...}>
//   Open dialog
// </button>
```

### With `asChild`

```tsx
<Dialog.Trigger asChild>
  <MyButton variant="primary">Open dialog</MyButton>
</Dialog.Trigger>
// Renders:
// <button class="my-button-primary" aria-haspopup="dialog" onClick={...}>
//   Open dialog
// </button>
```

Radix's props (the click handler, the ARIA attributes, the data-state) are merged onto `<MyButton>`. No extra wrapper.

## How Slot works internally

Slot is essentially a function that:

1. Accepts one React child element.
2. Captures its own props (`className`, `onClick`, `ref`, ARIA, etc.).
3. Clones the child with those props merged onto the child's existing props.
4. Returns the merged clone.

```tsx
function Slot({ children, ...props }: SlotProps) {
  if (!React.isValidElement(children)) return null;
  return React.cloneElement(children, mergeProps(props, children.props));
}
```

The merge logic handles event handlers (compose, don't replace), `className` (concatenate), `style` (object-spread), and `ref` (forward both).

## When to use

- **Custom-styled triggers.** `<Dialog.Trigger asChild><CustomButton>...</CustomButton></Dialog.Trigger>`.
- **Wrapping in `<Link>` from Next.js / React Router.** `<Tooltip.Trigger asChild><Link href="/about">...</Link></Tooltip.Trigger>`.
- **Composing with motion libraries.** `<Dialog.Overlay asChild><motion.div animate={...} /></Dialog.Overlay>`.
- **Anywhere you'd otherwise nest two elements with the same semantic role.**

## When NOT to use

- The default wrapper is what you want — using `asChild` complicates the call site for no benefit.
- The child doesn't accept the relevant DOM props (e.g., a third-party component that doesn't forward `onClick`). The merge would silently fail.

## Same pattern, other libraries

- **shadcn/ui** — uses Radix Slot directly; every shadcn primitive has `asChild`.
- **React Aria's `<Slot>`** — similar concept, different API surface.
- **Headless UI's render-props** — different approach to the same problem (`<Menu.Button>{({ open }) => ...}`).

## Trade-offs

- **Pro:** clean DOM (no `<div>`/`<button>` nesting hell).
- **Pro:** preserves your design system's element semantics.
- **Pro:** composable with any well-behaved component that forwards props.
- **Con:** silent failure when the child doesn't forward props correctly — your `onClick` might not fire and there's no error.
- **Con:** debugging gets harder — you can't always tell where a prop came from.

## Related

- [[radix-primitives]] — `asChild` is on every Primitive.
- [[radix-themes]] — exports `Slot` as a top-level utility.
- [[react-composition]] — `asChild` is composition with prop-merging.
- [[compound-components]] — `asChild` is part of the compound-component contract.

## Sources

- [[article-building-components-radix-ui]]
