---
id: read-only-values-need-a-read-only-look
aliases: []
tags:
  - review-comments
  - ux
  - forms
  - accessibility
creation date: 2026-09-30 23:47
modification date: Wednesday 30th September 2026 23:47:30
---

## The idea
A value the user can't change should not look like a field they can type into. An input's resting style (border, white surface) is a signal. It tells people "click here and edit." If you use that styling on a static `div`, you send a false [[Affordance]]. Most design systems have a separate read-only or disabled state for this, often a tinted background, and static values should use it.

## Example
```tsx
// Looks editable, but it's a div. Clicking does nothing.
<div className="h-8 px-2 rounded-md border bg-white">Production tenant</div>

// Option A: use the design system's read-only state.
<div className="h-8 px-2 rounded-md border bg-gray-100 text-gray-700">Production tenant</div>

// Option B: if it really is form data, use a real read-only input.
<input readOnly value="Production tenant" aria-label="Tenant" />
```
With option B, the browser and screen readers report it as read-only (`aria-readonly` is implied), and it still goes into the form. A styled `div` is only a visual.

## Why it matters
- Users click the fake field, nothing happens, and the UI feels broken.
- Next to real inputs, the eye can't tell which fields are the user's to fill in.
- Screen reader users get no hint that it's a form value, and sighted users get the wrong hint.

## Rule of thumb
When you show a value in a field-shaped box, copy the design system's read-only state, not its editable resting state. If the value belongs to the form, use a real `readonly` input. See also [[Form Accessibility]].
