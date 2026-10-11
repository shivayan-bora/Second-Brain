---
id: shared-components-dont-switch-on-caller
aliases: []
tags:
  - review-comments
  - react
  - component-api
  - composition
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
When a shared component checks who is rendering it (`page === 'A' ? labelA : labelB`), it has to know every caller, and a new caller silently gets the `else` value. This is [[Coupling]] pointing the wrong way. The caller should pass in whatever is specific to it.

## Example
```tsx
// Trap
const name = context === 'hygiene' ? hygieneName : inventoryName

// Better: the caller owns the caller-specific value
<DisableModal getWorkflowName={strings.hygieneWorkflowName} />

// Or, if a map is unavoidable, make it exhaustive so a new caller fails to compile
const NAMES = { hygiene: ..., inventory: ... } satisfies Record<Context, ...>
```

## Why it matters
A new caller gets a wrong label instead of a compile error. The shared component also grows a hidden dependency on every page that uses it.

## Rule of thumb
Shared components take caller-specific values as props. They never switch on who called them. See [[Composition Over Duplication]].
