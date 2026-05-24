---
id: radix.ui
aliases: []
tags:
  - documentation
creation date: 2026-05-21 08:42
modification date: Thursday 21st May 2026 08:42:57
source: https://www.radix-ui.com/primitives/docs/overview/introduction
status:
  - in-progress
---

## Other References

- [Vercel Academy: What are Radix Primitives](https://vercel.com/academy/shadcn-ui/what-are-radix-primitives)
- [Youtube: Radix UI - Create Customizable Components](https://www.youtube.com/watch?v=D-NDIy6A1Zw)
- [Peerlist: Understanding asChild and Slot in Radix UI](https://peerlist.io/jagss/articles/understanding-aschild-and-slot-in-react-clean-flexible-compo)
- [dev.to: Why component composition matters](https://dev.to/woovi/how-to-write-material-ui-components-like-radix-ui-and-why-component-composition-matters-4epn)
- [Blog: Building Low Level Components the Radix way][https://alexkondov.com/building-low-level-components-the-radix-way/]

## Radix Primitives

### What are Radix Primitives?

- [[Radix Primitives]] are barebones [[Radix UI]] components which are unstyled but provide the following out of the box:
  - Behaviour
  - Accessibility
  - State Management
  - [[Document Object Model (DOM)|DOM]] structure
  - Keyboard, mouse and touch interactivity
- Radix UI has an open component architecture where it allows you to have granular access to each part of the component, so you can wrap and add your own event listeners, [[React props|props]] and [[React useRef Hook|refs]].
- Radix also powers the [[shadcn/ui]]'s architecture.
- Each primitive is a separate package that exports a set of components which we can put together as we need.
- In contrast to most component libraries that give an accordion component with an API as follows:

```tsx
<Collapse items={items} defaultActiveKey={["1"]} />
```

- Radix gives you a more expressive and composable API as follows:

```tsx
<Accordion.Root
  className="AccordionRoot"
  type="single"
  defaultValue="item-1"
  collapsible
>
  <Accordion.Item className="AccordionItem" value="item-1">
    <Accordion.Trigger>Is it accessible?</Accordion.Trigger>
    <Accordion.Content>
      Yes. It adheres to the WAI-ARIA design pattern.
    </Accordion.Content>
  </Accordion.Item>

  <Accordion.Item className="AccordionItem" value="item-2">
    <Accordion.Trigger>Is it unstyled?</Accordion.Trigger>
    <Accordion.Content>
      Yes. It's unstyled by default, giving you freedom over the look and feel.
    </Accordion.Content>
  </Accordion.Item>

  <Accordion.Item className="AccordionItem" value="item-3">
    <Accordion.Trigger>Can it be animated?</Accordion.Trigger>
    <Accordion.Content className="AccordionContent">
      <div className="AccordionContentText">
        Yes! You can animate the Accordion with CSS or JavaScript.
      </div>
    </Accordion.Content>
  </Accordion.Item>
</Accordion.Root>
```

- You can now attach styles to these components without the fear of clashes and selector specificity. e.g.

```css
.AccordionItem {
  border-bottom: 1px solid gainsboro;
}

/* Rely on data attributes to style specific states e.g. an open accordion with the below style */
.AccordionItem[data-state="open"] {
  border-bottom-width: 2px;
}
```

### Why use Radix Primitives?

- Every time you're starting a new project, you need common components like dropdowns, accordions, tooltips etc. You have two options:
  - Build them yourself: Time consuming and difficult to get right in terms of behaviour and accessibility.
  - Component Libraries:
    - They provide pre-built components but they are often difficult to customize since they can be opinionated and may sometimes lack features. e.g. [[Material UI]].
    - You don't know if the markup under the hood follows the semantic conventions.
- It also allows you to have incremental adoption where you can import only the packages you need and then moving from there.

### Primitives Package

- The basic structure of the Primitive's repository:

```
├── core
|   ├── number
|   |    ├── ...
|   ├── primitive
|   |    ├── ...
|   ├── rect
|   |    ├── ...
├── react
|   ├── accordion
|   |    ├── src
|   |    |    ├── index.ts
|   |    |    ├── Accordion.tsx
|   |    |    ├── Accordion.test.tsx
|   |    |    ├── index.tsx
|   ├── ...
```

- `core`: Internal utilities and primitives
- `react`: Radix components
  - All components are split into packages where each package corresponds to a set of functionalities or components that are logically related making them easier to manage, update and using individually easier.
  - Distributed as separate components.

#### No single component per package

- Unlike other [[React]] components where we have only one component per file, Radix doesn't follow that standard and all individual components of Accordion from the above example are exported from the same file.

### Under the Hood

- If you peek into the source code of a Radix primitive, you will notice a heavily layered implementation that separates public APIs from private logic:
  - **The Collection Provider**: Because Radix uses a composable API, components are nested freely. Radix uses a `Collection.Provider` to keep track of nested elements in the DOM dynamically using `querySelector`, bypassing standard React state limitations.
  - **The "Impl" (Implementation) Pattern**: Radix relies on internal, private implementation layers (like `AccordionImplSingle` or `AccordionImpl`) to handle the heavy lifting. This keeps the top-level user API clean and free of messy conditional codeblocks.
  - **Primitive Wrapper**: Instead of rendering a standard `<div>`, Radix utilizes a `Primitive.div wrapper`. This allows the components to seamlessly pass `refs`, merge event handlers, and inject data attributes under the hood.

## Composition

- We can use the `asChild` prop to compose Radix's functionality onto alternative element types or our own [[React Components]].
- When `asChild` is set to `true`, Radix will not render a default DOM element and instead cloning the part's child and passing it the `props` and behaviour required to make it functional.

### Changing the Element Type

- In the majority of the cases, you shouldn't need to modify the element type as Radix has been designed to provide the most sensible defaults.
- However, there are cases where it is helpful to do so:

```tsx
import { Tooltip } from "radix-ui";

export default () => (
  <Tooltip.Root>
    <Tooltip.Trigger asChild>
      <a href="https://www.radix-ui.com/">Radix UI</a>
    </Tooltip.Trigger>
    <Tooltip.Portal>...</Tooltip.Portal>
  </Tooltip.Root>
);
```

> [!WARNING]
> If you do decide to change the type, it's your responsibility to ensure it remains accessible and functional.

### Composing with Your Own React Component

- This is same as above but there are a few gotchas that you need to be aware of:

#### Your Component Must Spread Props

- When Radix clones your own [[React]] component, it will pass its own `props` and event handlers to make it functional and accessible. If your component doesn't support those `props`, it will break.
- This is done by spreading all of the `props` onto the underlying DOM node:

```tsx
// before
const MyButton = () => <button />;

// after
const MyButton = (props) => <button {...props} />;
```

- It's better to spread all the `props` instead of worrying about which specific `props`, functionality and event listeners to accept.

> [!WARNING]
> Similar to above, it's your responsibility to ensure the elements rendered by your custom component remains accessible and functional.

#### Your Component Must forward Ref

- Radix will sometimes need to attach a `ref` to your component (e.g. to measure it's size). If your component doesn't accept a `ref`, then it will break.
- This can be done by using [[React forwardRef|React.forwardRef]].

```tsx
// before
const MyButton = (props) => <button {...props} />;

// after
const MyButton = React.forwardRef((props, forwardRef) => (
  <button {...props} ref={forwardRef} />
));
```

- It's better to do this by default so that you aren't bothered with implementation details.

> [!WARNING]
> Please note that `forwardRef` has been deprecated and we can directly pass `ref` to child components.

### Composing Multiple Primitives

- We can use `asChild` prop to compose multiple primitive's behaviour together as shown below:

```tsx
import * as React from "react";
import { Dialog, Tooltip } from "radix-ui";

const MyButton = React.forwardRef((props, forwardedRef) => (
  <button {...props} ref={forwardedRef} />
));

export default () => {
  return (
    <Dialog.Root>
      <Tooltip.Root>
        <Tooltip.Trigger asChild>
          <Dialog.Trigger asChild>
            <MyButton>Open dialog</MyButton>
          </Dialog.Trigger>
        </Tooltip.Trigger>
        <Tooltip.Portal>…</Tooltip.Portal>
      </Tooltip.Root>

      <Dialog.Portal>...</Dialog.Portal>
    </Dialog.Root>
  );
};
```
