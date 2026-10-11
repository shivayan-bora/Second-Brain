---
id: convert-every-branch-a-switch-renders
aliases: []
tags:
  - review-comments
  - react
  - code-review
  - visual-qa
creation date: 2026-10-01 14:32
modification date: Thursday 1st October 2026 14:32:51
---

## The idea
When a parent picks which child to render from a value (a dropdown, a tab, a status), each child it can render is part of the same visual surface. A styling or behavior change that is meant to apply "to the picker" has to reach every component in that switch. Otherwise the change only exists in whichever state the author happened to look at. This is easy to miss because the branches often live in sibling files with similar names, and the default value shows only one of them.

## Example
```tsx
// Parent swaps the picker based on a select value
{kind === 'user' ? <UserPicker /> : null}
{kind === 'group' ? <GroupPicker /> : null}
{kind === 'role' ? <RolePicker /> : null}

// The change landed in UserPicker only:
<Combobox.Trigger className={refreshedTriggerStyles()} />  // UserPicker
<Combobox.Trigger />                                        // GroupPicker, RolePicker unchanged
```
Choosing "group" or "role" now gives a control with a different height from the rest of the row.

A quick way to find every branch is to open the parent and list each component it can render, then search for files with the same name in nearby folders. Two features often each have their own `group-picker.tsx`.

## Why it matters
- Screenshots and manual checks usually cover the default state, so the other branches ship unseen.
- The result is visibly inconsistent: the same row looks different depending on a choice the user just made.
- Reviewers looking at the diff only see the files that changed. The unchanged siblings are invisible unless someone goes looking.

## Rule of thumb
Before calling a visual change done, enumerate every child the parent can switch to, apply the change to all of them (or extract the shared part so there's one place to change), and check each state. Add a test that drives the switch to a non-default value. See [[test-observable-behavior-not-class-names]] and [[pr-description-matches-the-diff]].
