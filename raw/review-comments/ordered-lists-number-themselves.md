---
id: ordered-lists-number-themselves
aliases:
  - numbers in copy
tags:
  - review-comments
  - i18n
  - html
creation date: 2026-10-09 12:52
modification date: Friday 9th October 2026 12:52:23
---

## The idea
When steps render in an `<ol>`, the list already knows the order. Writing the number into each translatable title ("1. Create account", "2. Invite team") puts display logic into the copy. The numbers then live in N strings times every locale, and reordering or inserting a step means editing every later title and re-sending them for [[Localization]].

## Example
```tsx
// Trap: order lives in the strings
const steps = [t`1. Create account`, t`2. Invite team`, t`3. Publish`]
<ol className="list-none">{steps.map(s => <li key={s}>{s}</li>)}</ol>

// Better: the list numbers itself
const steps = [t`Create account`, t`Invite team`, t`Publish`]
<ol className="list-decimal list-inside">{steps.map(s => <li key={s}>{s}</li>)}</ol>

// Or, when the number needs custom styling
{steps.map((s, index) => <li key={s}><span aria-hidden="true">{index + 1}.</span> {s}</li>)}
```
Note that CSS resets (Tailwind's preflight, many others) set `list-style: none`, which is often why people add the numbers by hand. Turn the list style back on rather than baking the numbers in. If you render the number yourself, hide it from screen readers only when the list semantics already announce position.

## Why it matters
Copy changes cost a translation round trip. Keeping order in code means a reorder is a one-line array change, and the `<ol>` still tells assistive tech "item 2 of 5".

## Rule of thumb
Strings carry words, the list carries order. If a title starts with a number, ask whether the list should be numbering it.
