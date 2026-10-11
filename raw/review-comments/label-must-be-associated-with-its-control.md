---
id: label-must-be-associated-with-its-control
aliases: []
tags:
  - review-comments
  - accessibility
  - html
  - forms
creation date: 2026-09-30 23:46
modification date: Wednesday 30th September 2026 23:46:51
---

## The idea
A `<label>` only does its job when the browser can tie it to a form control: either `for`/`htmlFor` points at the control's `id`, or the label wraps the control. Once tied, the label becomes the control's [[Accessible Name]], and clicking the label focuses or toggles the control. A label that isn't tied to anything is styled text, and adding `aria-label` on the control to cover the gap means the name is kept in two places.

## Example
```tsx
// Trap: label points at nothing, name duplicated via aria-label
<input type="checkbox" aria-label="Send email" />
<label>Send email</label>

// Better: one association, one source for the name
<input type="checkbox" id="send-email" />
<label htmlFor="send-email">Send email</label>

// Also fine: wrapping
<label>
  <input type="checkbox" /> Send email
</label>
```

## Why it matters
- The click target grows to include the text, which matters most for small checkboxes and radios ([[Fitts's Law]]).
- Screen readers announce the visible text as the name, so what sighted users see and what AT users hear can't drift apart the way a separate `aria-label` can.
- An unassociated label looks fine in a disabled or read-only case, then silently breaks once someone copies it onto an interactive control.

## Rule of thumb
Every `<label>` gets an `htmlFor` or a wrapped control. If the control already has a visible label, drop its `aria-label`. See [[WCAG 1.3.1 Info and Relationships]] and [[WCAG 4.1.2 Name Role Value]].
