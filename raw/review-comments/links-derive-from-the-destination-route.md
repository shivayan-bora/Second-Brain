---
id: links-derive-from-the-destination-route
aliases: []
tags:
  - review-comments
  - routing
  - react
  - feature-flags
creation date: 2026-09-30 10:17
modification date: Wednesday 7th October 2026 20:46:04
---

## The idea
A link is only as available as the route it points to. If the destination route has a guard (a feature flag, a permission, a path that moves depending on a flag), a hardcoded path literal ignores all of that. Users then get a call to action that redirects to not-found, or a flag-off user lands on a path that only exists with the flag on. Once a project has a path registry or a resolver hook, one stray literal defeats it.

## Example
```tsx
// Trap: always rendered, always the same path
<Link to="/inventory/agents">View agents</Link>

// Better: the same predicate and resolver the destination route uses
const canViewAgents = useCanViewAgents()   // what the route's guard checks
const agentsPath = useAgentsPath()         // resolves the flag-dependent path
{canViewAgents && <Link to={agentsPath}>View agents</Link>}
```
For static column definitions that can't call hooks, pass the resolved path through table `meta` or props.

When the guard and the link get their inputs in different shapes (the router reads a context object, components read hooks), don't write the condition twice. Share a pure boolean core and wrap it per layer:
```ts
export const shouldUseNewPaths = (flagOn: boolean, isNewUi: boolean) => flagOn && !isNewUi

// route guard
const guardSaysNew = (ctx: RouterContext) => shouldUseNewPaths(readFlag(ctx.flags), ctx.isNewUi)
// link hook
const useLinkSaysNew = () => shouldUseNewPaths(useFlag('new-paths'), useIsNewUi())
```
Two hand-written copies agree on day one and drift later; the symptom is an extra redirect on every click and a tab or nav item that stops showing as active.

## Why it matters
Broken links in onboarding panels, empty states and table cells are some of the most visible bugs, and they only show up for tenants or users in the "other" flag state, so they rarely surface during development.

## Rule of thumb
Derive every link from its destination's guard, never from a copied path. After adding a path registry, grep for the old and new literals. Test each gated link with its flag off. See [[Route Guards]].
