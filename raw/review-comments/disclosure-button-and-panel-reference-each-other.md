---
id: disclosure-button-and-panel-reference-each-other
aliases:
  - aria-controls for show/hide buttons
  - headless primitive without its trigger
tags:
  - review-comments
  - accessibility
  - react
creation date: 2026-10-07 20:55
modification date: Wednesday 7th October 2026 20:55:00
---

## The idea
A [[Disclosure Pattern]] is a button that shows or hides a region. The button needs `aria-expanded`, and the button and region should point at each other: `aria-controls` on the button names the region's id, and the region is labelled by the button (`aria-labelledby`) or has its own `aria-label`. Headless accordion and collapsible primitives (Radix, Headless UI, React Aria) do this wiring for you, but only when you use their own trigger component. If you drive the content from a button somewhere else on the page, you have taken over that wiring, and it is easy to end up with a region labelled by a trigger id that doesn't exist.

## Example
```tsx
// Trap: accordion content driven by an outside button.
// The library still sets aria-labelledby to its own (unrendered) trigger id.
<button aria-expanded={open} onClick={toggle}>How it works</button>
...
<Accordion value={open ? ['x'] : []}>
  <Accordion.Item value='x'>
    <Accordion.Content>...</Accordion.Content>   {/* role=region, aria-labelledby -> nothing */}
  </Accordion.Item>
</Accordion>

// Better: one hook owns both ids and hands out matching props
const useDisclosure = () => {
  const [open, setOpen] = useState(false)
  const buttonId = useId()
  const panelId = useId()
  return {
    open,
    buttonProps: { id: buttonId, 'aria-controls': panelId, 'aria-expanded': open, onClick: () => setOpen(o => !o) },
    panelProps: { id: panelId, 'aria-labelledby': buttonId },
  }
}

<button {...d.buttonProps}>How it works</button>
<Accordion.Content {...d.panelProps}>...</Accordion.Content>
```
`aria-controls` should resolve, so ideally the panel stays mounted and hidden (`hidden`, `inert`) instead of unmounting. Some primitives unmount the content when closed so the close animation can play, which is a trade-off worth knowing about.

## Why it matters
Screen-reader users hear "collapsed" or "expanded", but with no link they can't tell what changed or jump to it, and a region with no name isn't exposed as a navigable landmark. Returning the wiring as one props object also stops each call site from re-implementing half of it.

## Rule of thumb
If you use a primitive's content without its trigger, you own the ARIA wiring. Generate both ids in one place with `useId()` and spread matching props onto the button and the panel.
