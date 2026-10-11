---
id: aria-describedby-for-help-text
aliases: []
tags:
  - review-comments
  - a11y
  - forms
creation date: 2026-09-30 15:19
modification date: Wednesday 30th September 2026 15:19:16
---

## The idea
Text placed visually under a form control is not connected to it for assistive tech. A screen reader announces a control's **name** (from `<label>` or `aria-label`), its role and value, and then its **description**, which comes only from the elements referenced by `aria-describedby`. Help text or a warning that isn't referenced is only heard if the user happens to read past the field in browse mode. `aria-describedby` accepts a space-separated list of ids, so a hint and an error message can both be attached.

## Example
```tsx
function EmailField({ error }: { error?: string }) {
  const inputId = React.useId();
  const hintId = React.useId();
  const errorId = React.useId();
  const describedBy = [hintId, error ? errorId : null].filter(Boolean).join(' ');

  return (
    <div>
      <label htmlFor={inputId}>Backup contact</label>
      <input id={inputId} aria-describedby={describedBy} aria-invalid={!!error} />
      <p id={hintId}>If left empty, alerts go nowhere.</p>
      {error ? <p id={errorId}>{error}</p> : null}
    </div>
  );
}
```
With a custom combobox, put `aria-describedby` on the element that receives focus (the input or trigger), not on a wrapper.

## Why it matters
Hints often carry the most important information on a form ("leaving this empty means X will not happen"). Without the link, keyboard and screen-reader users fill the form without that context. A common trap is only setting `aria-describedby` when an error exists, which drops the permanent hint.

## Rule of thumb
Any text that explains or warns about a specific field gets an id (`useId()`) and is listed in that field's `aria-describedby`, merged with the error id when one is shown.
