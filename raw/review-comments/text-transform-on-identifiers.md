---
id: text-transform-on-identifiers
aliases:
  - uppercase styling hides case
tags:
  - review-comments
  - css
  - a11y
creation date: 2026-10-08 19:45
modification date: Thursday 8th October 2026 19:45:10
---

## The idea
[[CSS text-transform]] (`uppercase`, `capitalize`, `lowercase`) changes how text is painted, not the string in the DOM. That's great for labels ("ACTIVE", "NEW"), but on data whose case carries meaning (usernames, API keys, file paths, IDs) it misrepresents the value: `Hq7Rk2` and `HQ7RK2` look identical. Browsers also disagree on copy: some copy the transformed text, some the original, so what the user pastes may not match what they saw. Badge, chip and lozenge components often bake `uppercase` into their styles, so the transform arrives without anyone writing it.

## Example
```tsx
// Trap: a status-style badge reused for identifiers
const Badge = ({ children }: { children: string }) => (
  <span className="uppercase font-semibold text-xs">{children}</span>
)
<Badge>{account.name}</Badge> // "svc-Reporter_01" renders as "SVC-REPORTER_01"

// Better: a chip that keeps case for data, the badge stays for labels
const Chip = ({ children }: { children: string }) => (
  <span className="truncate text-xs" title={children}>{children}</span>
)
<Chip>{account.name}</Chip>
```

## Why it matters
Users compare and copy identifiers. If two IDs differ only in case, an uppercase display makes them look like one, and a copied value may fail a case-sensitive lookup. Tests won't notice: DOM queries like `getByText` match the untransformed string, so the bug only shows up by eye. Screen readers may also read short all-caps strings letter by letter.

## Rule of thumb
Uppercase styling is for words you wrote (labels, statuses), never for values the user owns. Before reusing a badge-like component for data, check whether it transforms case in any of its variants or themes.
