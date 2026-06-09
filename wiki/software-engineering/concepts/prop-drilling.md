---
title: "Prop Drilling"
pillar: software-engineering
type: concept
tags: [react, props, anti-pattern, design]
status: stable
sources: ["[[epic-react-arp-00-composition]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Prop Drilling

## Definition

**Prop drilling** (a.k.a. threading) is the act of passing a prop down through several intermediate components that don't themselves consume it, purely so it reaches a deeper descendant that does. It's the most-common "smell" in React codebases — and not always a problem worth fixing.

## Why it matters

Prop drilling is often called an anti-pattern, but it's actually a *trade-off*: explicit data flow vs. ergonomic depth. Knowing the actual failure modes (not the vibes) lets you decide whether to refactor with [[react-composition|composition]], reach for `useContext`, or just leave it alone.

## The trade-offs

### Why it's good

- **Explicit.** You can grep for `count` and see every place it travels. Compare to context, where the same trace is invisible.
- Same property that makes [[js-es-modules|ESM]] better than globals: explicit dependency declarations are easier to refactor against than hidden state.

### Why it goes wrong

- **Renames** become tedious — `<Toggle on={on} />` → `<Switch toggleIsOn={on} />` mid-chain breaks the mental thread.
- **Over-forwarding.** Passing props that are no longer needed because a downstream component was removed but its callers still send them.
- **Under-forwarding + `defaultProps`.** Missing a forward but masking it with a default, so the bug shows up far from the cause.
- **Data-shape refactors.** `{user: {name: 'Joe West'}}` → `{user: {firstName: 'Joe', lastName: 'West'}}` requires touching every link in the chain.

## Mitigation strategies

1. **Don't break up components prematurely.** A 200-line component you'd otherwise extract three pieces from might be fine as-is. Extract when there's a real reuse or testing motivation.
2. **Avoid `defaultProps` for required values.** Make the type system or runtime tell you when a prop is missing.
3. **Keep state close to where it's used.** Lifting state higher than necessary is the root cause of most drilling.
4. **Use [[react-composition|composition]]** — pass React elements as props so intermediate components don't need to know the data.
5. **Reach for `useContext`** only when the value is genuinely cross-cutting (theme, auth, locale) or composition would force the producer to know too many slots.

## Examples

A two-level drill that's probably fine to leave:

```tsx
function App() {
  const [user, setUser] = useState(null);
  return <Layout user={user} onLogin={setUser} />;
}

function Layout({ user, onLogin }) {
  return <Header user={user} onLogin={onLogin} />;
}
```

A four-level drill of the same value is a stronger signal to refactor (typically with composition or context).

## Related

- [[react-composition]] — the primary refactor.
- [[react-components]] — what the data flows through.
- [[react-props]] — the mechanism.

## Sources

- [[epic-react-arp-00-composition]]
