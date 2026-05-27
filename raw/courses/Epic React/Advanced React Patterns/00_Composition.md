---
creation date: 2026-05-24 17:01
modification date: Sunday 24th May 2026 17:01:34
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 00_Composition
---

- The Composition and the Layout Components Pattern helps to avoid the [[prop Drilling]] problem and enhances the reusability of our components.

## What is prop drilling?

- `prop` drilling (also known as threading) refers to the process of passing the data to different parts of the [[React Component]] tree by passing the `prop` down the chain from a parent component to the child component where it's needed.
  - The subsequent components in the chain may or may not use the `props` themselves but have the obligation to pass it down to the next component in the chain till it reaches it's intended destination.

- To understand it with an example, let's consider the following toggle switch component:

```tsx
function Toggle() {
  const [on, setOn] = useState(false);

  const toggle = () => setOn((prev) => !prev);

  return (
    <div>
      <div>The button is {on ? "on" : "off"}</div>
      <button onClick={toggle}>Toggle</button>
    </div>
  );
}
```

- Let's refactor this into two components:

```tsx
function Toggle() {
  const [on, setOn] = useState(false);

  const toggle = () => setOn((prev) => !prev);

  return <Switch on={on} toggle={toggle} />;
}

function Switch({ on, toggle }) {
  return (
    <div>
      <div>The button is {on ? "on" : "off"}</div>
      <button onClick={toggle}>Toggle</button>
    </div>
  );
}
```

- Now let's imagine we want to keep the message in one component and the button in another.

```tsx
function Toggle() {
  const [on, setOn] = useState(false);

  const toggle = () => setOn((prev) => !prev);

  return <Switch on={on} toggle={toggle} />;
}

function Switch({ on, toggle }) {
  return (
    <div>
      <SwitchMessage on={on} />
      <SwitchButton toggle={toggle} />
    </div>
  );
}

function SwitchMessage({ on }) {
  return <div>The button is {on ? "on" : "off"}</div>;
}

function SwitchButton({ toggle }) {
  return <button onClick={toggle}>Toggle</button>;
}
```

- Here, the `Switch` component acts as a pass-through and doesn't actually use the `props` `on` and `toggle` by itself but passes it to the `SwitchMessage` and the `SwitchButton` components respectively. This is known as `prop` drilling.

### Pros and Cons

#### Pros

- Helps us to find where data is initialized, where it's updated and where it's used unlike using global variables.
- This is one of the reasons why we prefer [[JavaScript ES6 Modules|ESModules]] over global variables because it allowed us to be more explicit about our values and where it's used, allowing us to track these states easily which helps us identify what impact our changes will have.
- `prop` drilling does the same thing.

#### Cons

- When our codebase grows, we encounter some problems with `prop` drilling as follows:
  - Refactor the shape of some data (ie: `{user: {name: 'Joe West'}}` -> `{user: {firstName: 'Joe', lastName: 'West'}}`)
  - Over-forwarding props (passing more props than is necessary) due to (re)moving a component that required some props but they're no longer needed.
  - Under-forwarding `props` + abusing `defaultProps` so you're not made aware of missing props (also due to (re)moving a component).
  - Renaming props halfway through (ie `<Toggle on={on} />` renders `<Switch toggleIsOn={on} />`) making keeping track of that in your brain difficult.

### How to avoid prop drilling?

- Break components up if and only when it's necessary and avoid major refactoring as much as possible.
- Avoid `defaultProps` for required `props`.
- Keep state close to where it's relevant as possible.
- Use [[useContext]] for state that's truly necessary deep into the component tree.

## Layout Components

- A layout component in React is a special-purpose component whose primary job isn't to render its own unique data, but to define the structural skeleton — the visual scaffolding — within which other components live and breathe.
- Think of it as the picture frame: it doesn't care what painting goes inside, only that whatever does goes in sits properly aligned, padded, and surrounded by the right consistent decor.
- At its simplest, a layout component is a wrapper/parent component that accepts `children` (or named slot `props` like `header`/`footer`) and renders them within a fixed structural arrangement.
- It's a higher-level abstraction that defines where things go on the page rather than what those things are. Crucially, it doesn't know its children in advance — it's deliberately agnostic, which is what makes it reusable across many pages.
- Three implementation patterns:

| Pattern              | How It Works                                                                                     | When To Use                                               |
| :------------------- | :----------------------------------------------------------------------------------------------- | :-------------------------------------------------------- |
| **Children prop**    | `<Layout>{pageContent}</Layout>` — the layout renders `props.children` inside its skeleton       | Simple wrapping; one content slot                         |
| **Named slot props** | `<Layout header={<Header/>} footer={<Footer/>} />` — multiple named UI regions passed explicitly | Multiple distinct regions needing custom content per page |
| **Router Outlet**    | `<Layout>` renders `<Outlet/>` from React Router; matched child routes render in that slot       | Route-driven apps where the layout wraps many pages       |

## Composition

- This is an example of `prop` drilling:

```tsx
function App() {
  const [count, setCount] = useState(0);
  const increment = () => setCount((c) => c + 1);
  return <Child count={count} increment={increment} />;
}

function Child({ count, increment }: { count: number; increment: () => void }) {
  return (
    <div>
      <strong>
        I am a child and I don't actually use count or increment. My child does
        though so I have to accept those as props and forward them along.
      </strong>
      <GrandChild count={count} onIncrementClick={increment} />
    </div>
  );
}

function GrandChild({
  count,
  onIncrementClick,
}: {
  count: number;
  onIncrementClick: () => void;
}) {
  return (
    <div>
      <small>I am a grand child and I just pass things off to a button</small>
      <button onClick={onIncrementClick}>{count}</button>
    </div>
  );
}
```

- If we restructure things a bit:

```tsx
function App() {
  const [count, setCount] = useState(0);
  const increment = () => setCount((c) => c + 1);
  return (
    <Child
      grandChild={
        <GrandChild
          button={<button onClick={onIncrementClick}>{count}</button>}
        />
      }
    />
  );
}

function Child({ grandChild }: { grandChild: React.ReactNode }) {
  return (
    <div>
      <strong>
        I am a child and I don't actually use count or increment. My child does
        though so I have to accept those as props and forward them along.
      </strong>
      {grandChild}
    </div>
  );
}

function GrandChild({ button }: { button: React.ReactNode }) {
  return (
    <div>
      <small>I am a grand child and I just pass things off to a button</small>
      {button}
    </div>
  );
}
```

- Here's we're passing [[React]] elements rather than treating components as uncrossable boundaries.
- You can keep the components that don't care about state free of the plumbing needed to make it work.
  - If we decided we needed to manage some more state in the App and that was needed in the button then we could update only the app for that.
- When we structure our components to only really deal with props it actually cares about, then it becomes more of a "layout" component. A component responsible for laying out the react elements it accepts as props.
