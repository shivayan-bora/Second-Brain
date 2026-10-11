---
id: aschild-composition-merges-onto-one-child
aliases: []
tags:
  - review-comments
  - react
  - radix
  - accessibility
creation date: 2026-10-09 19:19
modification date: Friday 9th October 2026 19:25:00
---

## The idea
In Radix-style component libraries, `asChild` tells a component "don't render your own element, merge your props onto my single child". Under the hood a `Slot` clones the child and merges props: `className` strings are concatenated, `style` objects merged, event handlers composed (both run), refs composed, and for other props the child's value wins. Slots can nest: if layer A slots onto layer B, and B slots onto the real element, every layer's props end up on that one element.

The chain only stays flat if **every** layer forwards `asChild`. If one wrapper in the middle renders its own `span` or `div`, the outer layers merge onto that wrapper instead, and the caller's element ends up nested inside it.

`Slot` also needs exactly one React element as its child. Plain text renders nothing, and several children throw.

## Example
```tsx
// A Label that adds typography through an inner Text component
const Label = ({ asChild, children, ...props }) => (
  <LabelPrimitive.Root {...props} asChild={asChild}>
    {/* Bug: Text renders a <span> even when the caller asked for asChild */}
    <Text variant="body2">{children}</Text>
  </LabelPrimitive.Root>
);

<fieldset>
  <Label asChild><legend>Roles</legend></Label>
</fieldset>
// DOM: <fieldset><span class="label typography"><legend>Roles</legend></span></fieldset>

// Fix: forward asChild to every layer
<Text variant="body2" asChild={asChild}>{children}</Text>
// DOM: <fieldset><legend class="label typography">Roles</legend></fieldset>
```

## Why it matters
Wrappers break structural HTML pairs that depend on parent/child position. A `<legend>` only names its fieldset when it is the fieldset's **first direct child**, so the wrapped version leaves the group with no accessible name for screen readers. The same goes for `li` inside `ul`, `tr` inside `tbody`, `option` inside `select`, and `dt`/`dd` inside `dl`. Pseudo-elements like a required asterisk (`::after`) also land on the wrapper, so they can drop onto their own line after a block child.

These bugs often appear only in one rendering mode (a theme or feature flag that adds an extra typography layer), so tests that cover the other mode stay green.

## Rule of thumb
When a component composes other components and accepts `asChild`, pass `asChild` to every layer between the outer one and the caller's child. Pin the fix with a behavior test, such as `getByRole('group', { name: 'Roles' })` for a fieldset/legend, in each mode that adds a layer.
