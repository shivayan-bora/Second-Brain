---
id: test-the-click-guard-not-just-the-href
aliases:
  - links with preventDefault guards
tags:
  - review-comments
  - testing
  - react
creation date: 2026-10-09 12:52
modification date: Friday 9th October 2026 12:52:23
---

## The idea
A link can carry two behaviors: where it goes (`href`) and an `onClick` that sometimes stops it (`event.preventDefault()` plus a modal, a confirm, a "please wait" message). A test that only checks `toHaveAttribute('href', ...)` proves the first and says nothing about the second. Delete the `onClick` and the test still passes. When the guard is the business rule, the test has to click.

## Example
```tsx
const onCreateClick = (event: React.MouseEvent) => {
  if (isCoolingDown) {
    event.preventDefault()   // stay here
    openWaitModal()
  }
}
<a href="/campaigns/new" onClick={onCreateClick}>Get started</a>

// Weak: passes even if onClick is removed
expect(screen.getByRole('link', { name: 'Get started' })).toHaveAttribute('href', '/campaigns/new')

// Better: drive the guard both ways
await user.click(screen.getByRole('link', { name: 'Get started' }))
expect(screen.getByRole('dialog', { name: /please wait/i })).toBeInTheDocument()
expect(navigate).not.toHaveBeenCalled()
```
If the link lives in a child component that just forwards a handler prop, a cheap unit test is "clicking calls the handler". The full guard (condition true, modal shows, no navigation) belongs in one test at the level that owns the condition.

## Why it matters
Guards like cooldowns, unsaved-changes prompts and permission checks are easy to lose in a refactor, because the link still "works" and nobody notices until the bad action happens. They are also exactly the behavior a PR description tends to promise.

## Rule of thumb
If a link has an `onClick` that can stop navigation, at least one test must click it with the guard active and assert you stayed put. See [[test-observable-behavior-not-class-names]].
