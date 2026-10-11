---
id: feature-flag-rollout-hygiene
aliases: []
tags:
  - review-comments
  - feature-flags
  - release
creation date: 2026-09-30 10:17
modification date: Thursday 1st October 2026 14:38:00
---

## The idea
A [[Feature Flags|feature flag]] is a kill switch: you can turn a change off without a deploy. That only works if the flag gates the whole change and nothing else. A few habits keep flags trustworthy:
- **One flag, one decision.** Reusing an unrelated flag couples two rollbacks together.
- **Flag-off means unchanged.** With the flag off, behavior should match production exactly. Any deliberate flag-off change needs to be written down and tested, or the next person will "fix" it back.
- **Risky changes ship behind a flag first:** destructive bulk actions, removing an approval or confirmation step, and changing a default on a shared component (which changes every page that renders it).
- **Replacing a path carries over its guards.** When the flag hides an old entry point and shows a new one, the new one has to check everything the old one did (permissions, environment kill switches, limits), and keep emitting the same analytics events so rollout dashboards stay comparable.
- **Delete dead flags.** A flag registration that nothing reads makes a removed feature look gated.
- **Hide the link and guard the route, with the same condition.** Hiding a menu item is not access control, so the route needs its own flag check. In nested routers the effective gate for a child page is every ancestor's guard AND its own. The link has to use that same combined condition, or users see a link that redirects them away.

## Example
```tsx
// Gate the affordance, and let shared components opt in rather than change for everyone
const canBulkDisable = useFlag('bulk-disable') && useCanDisable() // same guards as the old button
return canBulkDisable ? <BulkDisableAction /> : <LegacyDisableButton />

// Test both arms
describe.each([true, false])('bulk-disable flag = %s', (flag) => { /* ... */ })

// Child page under a gated parent: the link uses the combined gate the router enforces
const showReports = parentFlag && reportsFlag // parent route guard AND child route guard
// and a test for reportsFlag on + parentFlag off asserts the link is absent
```

## Why it matters
A flag you can't flip safely isn't a kill switch. The usual failures are quiet ones: turning the flag on removes a safety check, turning it off doesn't fully restore the old behavior, or a shared component changes on pages the flag was never meant to touch.

## Rule of thumb
For every flagged change, check four cases by hand: flag on and off, each with a fresh click and a legacy deep link. The flag gates one decision, and flag-off equals production. See [[Progressive Rollout]].
