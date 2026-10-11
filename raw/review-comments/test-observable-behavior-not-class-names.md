---
id: test-observable-behavior-not-class-names
aliases: []
tags:
  - review-comments
  - testing
  - react
creation date: 2026-09-30 10:15
modification date: Wednesday 7th October 2026 13:23:55
---

## The idea
Tests that assert CSS class strings (`toHaveClass('gap-px -m-px')`) or inline style values fail on harmless refactors and still pass on real visual breakage (a `twMerge` conflict, a missing token). [[React Testing Library]] is built around what a user can observe: roles, accessible names, text, and state.

## Example
```tsx
// Trap
expect(screen.getByTestId('card')).toHaveClass('h-[153.5px]', 'overflow-hidden')

// Better
expect(screen.getByRole('heading', { name: 'Summary' })).toBeInTheDocument()
expect(screen.getByRole('switch', { name: 'Show inactive' })).toBeChecked()
```

When you do have to assert a class (for example, checking that a feature flag switches styling), don't find the element using the class you are about to check:

```tsx
// Trap: the lookup already requires h-8, so toHaveClass('h-8') can't fail on its own
const box = screen.getByText('Okta').closest('.h-8, .h-10')
expect(box).toHaveClass('h-8')

// Better: locate by text or structure, then assert
const box = screen.getByText('Okta').closest('div')
expect(box).toHaveClass('h-8')
```
`closest()` returns `null` on a miss, so a lookup that depends on the class under test either proves nothing or fails with an unhelpful "not an HTMLElement" error. Use `it.each` rather than a loop inside one test, so each case passes or fails separately.

A class assertion can also lock in a bug. A test that checks a featured card "has `col-span-2`" passes happily while that very class makes the grid overflow at narrow widths, and a fix (`sm:col-span-2`) then looks like a test failure.

Walking the DOM (`element.parentElement`, `.firstChild`) to reach a wrapper is the same trap in another form: the test now depends on exactly how many elements sit between two nodes. It gets worse when many consumer tests assert a shared child component's internals. One wrapper added inside that component then breaks every consumer's test, though no consumer changed. Keep structural assertions in the component's own test, and have consumers assert what they own.

## Why it matters
Class-string tests cost maintenance and give false confidence at the same time. `toHaveClass` only proves the attribute is set. It can't tell whether a CSS rule for that class was ever generated, so a class the build tool dropped (see [[tailwind-scans-raw-source-text]]) still passes. Pixel and layout correctness belong in visual or interaction tests (Storybook, Chromatic, Playwright screenshots).

## Rule of thumb
If a user can't see or do it, don't assert it. Assert roles and names, not class names. See [[Testing Library]].
