---
id: cross-field-validation-revalidate-both-fields
aliases: []
tags:
  - review-comments
  - forms
  - validation
creation date: 2026-10-07 20:42
modification date: Wednesday 7th October 2026 20:42:22
---

## The idea
Most form libraries validate a field when that field changes. A rule that compares two fields ("escalation must be fewer days than warning") breaks that model: the error lives on one field, but either field can fix it. If only the edited field re-validates, the error on the other field goes stale. It stays on screen after the form is already valid, or never appears when the other field breaks the rule.

Two more traps sit next to it:
- **When validation runs at all.** In React Hook Form the default `mode` is `onSubmit`, so nothing validates until the first submit, and only then does `reValidateMode` (default `onChange`) kick in. A rule plus re-validation wiring still gives no feedback "while typing" on a fresh form.
- **Showing the error on both fields.** Adding the same issue to both paths turns both inputs red and gets announced twice by screen readers. It also creates a second error that itself needs re-validation wiring to clear.

## Example
```tsx
// schema: two rules read warningDays
.superRefine((v, ctx) => {
  if (v.reminderDays <= v.warningDays) ctx.addIssue({ path: ['reminderDays'], ... });
  if (v.escalateDays >= v.warningDays) ctx.addIssue({ path: ['escalateDays'], ... });
});

// React Hook Form: when warningDays changes, re-check every field whose error depends on it
<Controller name='warningDays' rules={{ deps: ['reminderDays', 'escalateDays'] }} ... />

// and validate before the first submit if the UX promises early feedback
useForm({ mode: 'onTouched', resolver: zodResolver(schema) });
```
Listing only `escalateDays` leaves a stale "reminder must be more than warning" error after the user lowers the warning.

## Why it matters
A stale error says the form is wrong when it isn't, or hides a real problem until save. Users then fight the form or lose trust in its messages. Tests usually check that the error appears, not that it clears, so the gap ships.

## Rule of thumb
For every cross-field rule, list the fields it reads and the field that shows its error, and make a change to any of them re-validate that field. Show the error once, on the field the user should change. Test both "appears" and "clears", and pick a validation mode that matches when the UI promises feedback.
