---
id: required-ui-should-not-depend-on-optional-children
aliases: []
tags:
  - review-comments
  - react
  - component-api
  - composition
creation date: 2026-10-01 19:30
modification date: Thursday 1st October 2026 19:30:00
---

## The idea
In a compound component, a value the parent receives (an action, a link, a badge) is sometimes rendered by whichever child slot happens to read it from context. If that child is optional, the value vanishes silently whenever a caller leaves the child out or renders it conditionally. Required UI should be placed by the component that owns it, with a fallback, not by an optional child.

## Example
```tsx
// Fragile: only <Card.Avatar> renders the action
const Avatar = ({ name }) => {
  const action = React.useContext(ActionContext);
  return <div><h2>{name}</h2>{action}</div>;
};

// Caller with no name skips the avatar, and the action silently disappears
{name ? <Card.Avatar name={name} /> : null}

// Workaround that leaks: force the avatar, which renders an empty <h2>
<Card.Avatar name={name ?? ''} />
```

Better: the root tracks whether a slot consumed the action (or simply renders the action row itself), and the avatar omits its heading when the name is empty.

```tsx
const Root = ({ action, children }) => (
  <ActionProvider action={action}>
    {children}
    {/* render action here unless a child registered that it placed it */}
  </ActionProvider>
);
```

## Why it matters
- The failure is silent: no error and no type error, just a missing link for some data shapes (for example, records without a name).
- Callers start patching around it (`name || otherFlag`), spreading layout knowledge across every call site.
- The patches often create new defects, like empty headings that screen readers announce.

## Rule of thumb
If removing an optional child can make a required piece of UI disappear, move ownership of that UI up to the parent and give it a fallback position. Slots should either fail loudly on misuse or degrade safely inside the component. Related: [[context-for-ambient-layout-concerns]], [[convert-every-branch-a-switch-renders]].
