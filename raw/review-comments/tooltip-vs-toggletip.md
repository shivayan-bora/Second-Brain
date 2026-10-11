---
id: tooltip-vs-toggletip
aliases:
  - toggletip
  - info button popover
tags:
  - review-comments
  - accessibility
  - ui-patterns
creation date: 2026-10-01 10:27
modification date: Thursday 1st October 2026 10:27:14
---

## The idea
A [[tooltip]] is a short, supplementary label for a control that does something else (an icon button's name, a keyboard shortcut hint). It opens on hover or focus and gets out of the way on interaction. A **toggletip** is a small button whose *only* job is to reveal extra information; it opens on click/Enter/Space, stays open until dismissed (Escape, click outside, click again) and works on touch. It is usually built on a non-modal [[popover]].

Popular tooltip libraries enforce the tooltip contract in code. Radix `Tooltip.Trigger`, for example:
- closes the tooltip on `pointerdown` and on `click`,
- ignores `pointermove` when `pointerType === 'touch'`, so touch never opens it,
- opens on keyboard focus and closes on blur.

So when an "info" icon button carries the real content in a tooltip, clicking it (the natural action) hides the content, and touch users can never reach it.

## Example
```tsx
// Tooltip: the button has its own action; the tooltip just names it.
<Tooltip>
  <Tooltip.Trigger asChild>
    <IconButton label="Retry" onClick={retry}><RetryIcon aria-hidden /></IconButton>
  </Tooltip.Trigger>
  <Tooltip.Content>Retry</Tooltip.Content>
</Tooltip>

// Toggletip: the button's only job is disclosure.
<Popover>
  <Popover.Trigger asChild>
    <IconButton label="Why Jane is an owner"><InfoIcon aria-hidden /></IconButton>
  </Popover.Trigger>
  <Popover.Content side="top">
    <ul>{reasons.map((reason) => <li key={reason}>{reason}</li>)}</ul>
  </Popover.Content>
</Popover>
```
With the popover the trigger gets `aria-expanded`/`aria-controls`, the content is reachable on touch, and it stays open while the user reads it.

## Why it matters
- Tooltip content must never be the only way to get information ([[WCAG 1.4.13 content on hover or focus]] plus touch support).
- A button that does nothing when clicked, or worse hides what the user just saw, breaks the basic expectation of a button.
- Screen readers announce tooltip text as a description (`aria-describedby`) only while it's open; long or structured content (lists) gets flattened into one string.

## Rule of thumb
Ask "what happens when the user clicks the trigger?" If the honest answer is "the content disappears" or "nothing", you want a toggletip/popover, not a tooltip. Keep tooltips for short labels on controls that already do something.
