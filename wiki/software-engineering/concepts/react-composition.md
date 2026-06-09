---
title: "Composition (React)"
pillar: software-engineering
type: concept
tags: [react, composition, patterns, advanced]
status: stable
sources: ["[[epic-react-arp-00-composition]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Composition (React)

## Definition

In React, **composition** is the practice of passing **React elements** (not just data) as props — so an intermediate component doesn't have to know about, or thread through, the data its descendants need. The parent constructs the element with the data it owns; the intermediate just renders the slot.

## Why it matters

Composition is the **primary alternative to `useContext`** for relieving [[prop-drilling]]. It keeps data flow explicit (no hidden context dependency) and keeps intermediate components ignorant of state they don't use. For a staff-level reviewer, "reach for composition before context" is a heuristic worth installing.

## Mechanics

### Before — prop drilling

```tsx
function App() {
  const [count, setCount] = useState(0);
  return <Child count={count} increment={() => setCount(c => c + 1)} />;
}

function Child({ count, increment }) {
  return (
    <div>
      <strong>I don't use these props. My grandchild does.</strong>
      <GrandChild count={count} onIncrementClick={increment} />
    </div>
  );
}

function GrandChild({ count, onIncrementClick }) {
  return <button onClick={onIncrementClick}>{count}</button>;
}
```

`Child` carries `count` and `increment` purely to forward them.

### After — composition

```tsx
function App() {
  const [count, setCount] = useState(0);
  const increment = () => setCount(c => c + 1);
  return (
    <Child
      grandChild={
        <GrandChild button={<button onClick={increment}>{count}</button>} />
      }
    />
  );
}

function Child({ grandChild }) {
  return (
    <div>
      <strong>I don't use these props. My grandchild does.</strong>
      {grandChild}
    </div>
  );
}

function GrandChild({ button }) {
  return <div>{button}</div>;
}
```

Now `Child` and `GrandChild` know nothing about `count`. The state lives where it's owned (`App`); the pre-constructed `<button>` element is passed through inert containers.

## When to use composition vs context vs lifting

- **Lift state up** when 2-3 siblings need it.
- **Compose** when the data needs to travel through layers that don't consume it.
- **`useContext`** when the value is genuinely cross-cutting (theme, auth, locale) or when composition would force the producer to know about too many slots.

## Trade-offs

- **Pro:** explicit, type-safe, no hidden coupling, intermediate components become reusable layout shells.
- **Pro:** refactor-friendly — moving a state's owner doesn't ripple through intermediates.
- **Con:** the parent that owns state must also own the construction of *every* element that consumes it. Past a certain depth this gets verbose.
- **Con:** less ergonomic when many sibling subtrees need the same value — context wins there.

## Related

- [[prop-drilling]] — the problem composition solves.
- [[react-layout-components]] — the canonical product of composition discipline.
- [[react-components]] — the unit being composed.
- [[react-props]] — composition is "props that happen to be React elements".

## Sources

- [[epic-react-arp-00-composition]]
