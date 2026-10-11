---
id: percentages-name-their-base
aliases:
  - name the denominator
tags:
  - review-comments
  - ux-writing
  - data-display
creation date: 2026-10-07 14:58
modification date: Wednesday 7th October 2026 14:58:41
---

## The idea
Readers take a percentage as a share of the nearest noun. "432 orphaned accounts (26%)" will be read as 26% of orphaned accounts, even if the code divided by all accounts. When the denominator isn't the noun right next to the number, either change the math to match the sentence or say the base out loud.

## Example
```ts
// Trap: math uses the grand total, copy implies the subset
const pct = format(dormantOrphaned / total)
`${dormantOrphaned} orphaned accounts (${pct}) are dormant`

// Better, option A: divide by the subset the sentence talks about
const pct = format(orphaned > 0 ? dormantOrphaned / orphaned : 0)
`${dormantOrphaned} orphaned accounts (${pct} of orphaned) are dormant`

// Better, option B: keep the total, name it
`${dormantOrphaned} orphaned accounts (${pct} of all accounts) are dormant`
```
Guard the zero denominator either way, and pluralize the whole sentence with ICU `plural`, not just the noun.

## Why it matters
Dashboards drive decisions. A 26% that's really 37% of the group the reader cares about changes what they prioritize. When sibling cards name their base ("of the total") and one card doesn't, readers assume all of them use the same base, and that one gets misread.

## Rule of thumb
Every percentage in UI copy should either sit right after the noun it divides by or spell out "of <base>". Check the denominator in code against the sentence, not just against the design mock. See [[Data Visualization]].
