---
title: "Controlled vs Uncontrolled Components"
pillar: software-engineering
type: concept
tags: [react, state, forms, patterns, library-design]
status: stable
sources: ["[[build-ui-radix-00-animated-switch]]", "[[article-building-components-radix-ui]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Controlled vs Uncontrolled Components

## Definition

In React, a component's stateful value can be owned in one of two places:

- **Controlled** — React state outside the component owns the value, passed in via prop, updated via callback.
- **Uncontrolled** — the component (or DOM) owns the value internally; the outside world reads it via `ref`, form submission, or doesn't read it at all.

A well-designed component supports **both modes** with the same API. Radix Primitives are the canonical example.

## Why it matters

The choice shapes how your component composes with React state, with forms, with libraries like React Hook Form, with React 19's `<form action={...}>` flow. Picking wrong forces awkward workarounds (`useEffect` shims, controlled-input gotchas). For a library author, supporting both modes is table stakes.

## The two shapes

### Controlled

The parent owns the state:

```tsx
const [airplaneMode, setAirplaneMode] = useState(false);

<Switch.Root
  checked={airplaneMode}
  onCheckedChange={setAirplaneMode}
/>
```

- React state is the source of truth.
- The component is a "pure function of props."
- Easy to derive other state from the value (e.g., conditionally show another component).
- Easy to test (set state, render, assert).

### Uncontrolled

The component owns its own state:

```tsx
<form action={(formData) => console.log(Object.fromEntries(formData))}>
  <Switch.Root name="airplane-mode" />
  <button type="submit">Save</button>
</form>
```

- React state is *not* involved.
- Value read at submission time via `name` (form) or via `ref` (imperative).
- Simpler for one-off forms that don't need cross-field reactivity.
- React 19's `<form action={...}>` and form-data submission paradigm love this shape.

### The "defaultValue" hybrid

Most uncontrolled components also accept an initial value:

```tsx
<Switch.Root defaultChecked={true} name="airplane-mode" />
```

`defaultChecked` is read once on mount; subsequent changes are internal.

## Supporting both modes — the API rule

A library component is **controlled iff** the consumer passes the value prop (`checked`, `value`, `open`, etc.). The pattern (used by Radix, React Aria, MUI, almost everyone):

```tsx
// Pseudo-API
type SwitchRootProps = {
  checked?: boolean;            // controlled if provided
  onCheckedChange?: (v: boolean) => void;
  defaultChecked?: boolean;     // uncontrolled initial value
  name?: string;                // for form submission
};
```

- `checked` defined → controlled mode.
- `checked` undefined → uncontrolled mode, internal state initialized to `defaultChecked`.

## React's classic warning

> *"A component is changing an uncontrolled input to be controlled..."*

This appears when a `value` (or `checked`) prop is `undefined` on first render but defined on a later render. React sees the switch from uncontrolled to controlled and panics. Fix: provide `value=""` (empty string) from the start, never `undefined`.

## When to choose which

- **Controlled** — when you need to derive other state from this value, validate live, sync to a server, share between siblings.
- **Uncontrolled** — when the value is purely local, when you're submitting a form, when adding state would be ceremony for no payoff.
- **Both** — library authors should support both. Apps usually pick one per use case.

## Examples

```tsx
// Controlled — derived UI based on toggle
const [advanced, setAdvanced] = useState(false);
return (
  <>
    <Switch.Root checked={advanced} onCheckedChange={setAdvanced} />
    {advanced && <AdvancedSettings />}
  </>
);

// Uncontrolled — just a form
<form action={save}>
  <Switch.Root name="notifications" defaultChecked />
  <button>Save</button>
</form>
```

## Related

- [[radix-primitives]] — every stateful Primitive supports both modes.
- [[react-hooks]] — `useState` is the controlled-mode primitive.
- [[react-props]] — the controlled value is just a prop.

## Sources

- [[build-ui-radix-00-animated-switch]] — applied controlled/uncontrolled Switch examples.
- [[article-building-components-radix-ui]] — feature list mentions both as Radix capabilities.
