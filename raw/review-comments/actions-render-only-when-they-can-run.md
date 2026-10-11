---
id: actions-render-only-when-they-can-run
aliases:
  - no inert buttons
  - gate actions on their permission
tags:
  - review-comments
  - ux
  - accessibility
  - react
creation date: 2026-10-07 14:58
modification date: Wednesday 7th October 2026 20:55:00
---

## The idea
A button is a promise that clicking it does something. Show it only when two things are true: there is something wired up behind it, and the current user is allowed to do it. A placeholder button with no handler, or a button for a flow the user's role can't reach, breaks that promise. Leaving the button out until both are true is better than showing it "for now".

## Example
```tsx
interface Insight {
  readonly title: string
  readonly count: number
  readonly action?: { readonly label: string; readonly onClick: () => void }
}

// Trap: always rendered, no handler, no permission check
<Button>{insight.actionLabel}</Button>

// Better: the caller decides the action, including permission, and the card renders it only when present
const canAssign = useCan('assign:owner')
const insight = {
  title,
  count,
  action: canAssign ? { label: 'Assign owners', onClick: openAssignMode } : undefined,
}

{insight.action && insight.count > 0 ? (
  <Button onClick={insight.action.onClick}>{insight.action.label}</Button>
) : null}
```
Let the page pass the action in instead of building it inside the shared card. Different pages often have different destinations, and some have none yet.

Two places this shows up a lot:
- **Onboarding or "how it works" panels.** They add new entry points ("Get started", "Try now") to create flows. Those entry points need the same permission check as the main "Create" button. If one panel gates its CTAs and a sibling panel doesn't, the one that doesn't is almost always the bug.
- **Route guards that only check a feature flag.** If the destination route checks the flag but not the permission, the link is the only gate. A missing check on the link sends the user into a form that fails on save.

## Why it matters
- Users read a dead button as a bug, and screen readers announce it as something the user can do.
- If an action button already shows for everyone, whoever wires it up later probably won't add the permission check, and users get sent into a flow that fails at the server.
- A `disabled` button with no explanation is only slightly better. It still advertises a feature and doesn't say why it's off.

## Rule of thumb
Render an action only when it has a handler and the user has the permission. If the feature isn't built yet, ship without the button and link the follow-up ticket. See [[Progressive Disclosure]] and [[Role-Based Access Control]].
