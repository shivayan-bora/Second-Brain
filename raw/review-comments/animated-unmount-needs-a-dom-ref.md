---
id: animated-unmount-needs-a-dom-ref
aliases: []
tags:
  - review-comments
  - react
  - radix
  - animation
creation date: 2026-09-30 19:45
modification date: Wednesday 30th September 2026 19:45:00
---

## The idea
Libraries that animate an element out before removing it, such as Radix `Presence` (used by Dialog, Popover and Tooltip portals), Framer Motion `AnimatePresence` or React Transition Group, need a ref to the real DOM node. They read `getComputedStyle(node).animationName` or listen for `animationend`, and only then unmount. If the child they wrap can't take a ref, for example a context provider, a fragment or a plain function component without `forwardRef`, they never see a node. They assume "no animation" and unmount immediately. Nothing errors. The exit animation just stops happening. React 18 prints "Function components cannot be given refs" in dev, and that warning is the only clue.

Radix makes this easy to hit. `Dialog.Portal` maps over its children and wraps each one in `Presence` + `Portal asChild`, so every direct child of the portal has to be a ref-forwarding element.

## Example
```tsx
// Broken: Presence gets a ref to ThemeProvider, not to a DOM node
<Dialog.Portal>
  <ThemeProvider value='dark'>
    <Dialog.Overlay className='data-[state=closed]:animate-fade-out' />
    <Dialog.Content className='data-[state=closed]:animate-zoom-out'>...</Dialog.Content>
  </ThemeProvider>
</Dialog.Portal>

// Works: the portal's children are the ref-forwarding primitives;
// the provider lives inside the content element
<Dialog.Portal>
  <Dialog.Overlay className='data-[state=closed]:animate-fade-out' />
  <Dialog.Content className='data-[state=closed]:animate-zoom-out'>
    <ThemeProvider value='dark'>{children}</ThemeProvider>
  </Dialog.Content>
</Dialog.Portal>
```

## Why it matters
Exit animations are rarely tested. jsdom has no CSS animations, and snapshot or role-based tests pass either way. So one wrapper added for an unrelated reason (resetting a context at a portal boundary) can remove the close animation from every dialog in an app, and nobody notices until a designer does.

## Rule of thumb
Never put a provider, fragment or non-forwardRef component as the direct child of an `asChild` slot, a Radix `Portal` or any presence/transition wrapper. Put it one level down, inside the element that owns the DOM node, and check close animations in a real browser.
