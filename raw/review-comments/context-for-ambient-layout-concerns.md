---
id: context-for-ambient-layout-concerns
aliases: []
tags:
  - review-comments
  - react
  - component-api
creation date: 2026-09-30 10:15
modification date: Thursday 1st October 2026 17:40:00
---

## The idea
Some information is about **where** a component is rendered (inside a modal, inside a dense table) rather than **what** it does. Threading that through a generic props contract ([[Prop Drilling]]) forces every implementer to accept a prop most of them ignore. A small context set once by the container and read only by the component that cares is a better fit.

## Example
```tsx
const InModalContext = createContext(false)
export const useIsInModal = () => useContext(InModalContext)

function Modal({ children }) {
  return <InModalContext.Provider value={true}>{children}</InModalContext.Provider>
}

// Deep inside, only where needed (for example to raise a popover's z-index)
const inModal = useIsInModal()
```

## Nuance: context flows through portals
[[React Portals]] move DOM nodes, not the React tree. A dialog portaled to `document.body` still reads every context above the component that rendered it. So an ambient layout context ("this page is edge to edge, supply your own gutter") also reaches a modal or drawer opened from that page, where it's wrong. Any primitive that renders into a portal should reset the ambient value at its boundary.

```tsx
const FullBleedContext = createContext(false)

function Dialog({ children }) {
  return createPortal(
    // the dialog surface has its own padding, so reset the page's value
    <FullBleedContext.Provider value={false}>{children}</FullBleedContext.Provider>,
    document.body,
  )
}
```
Popovers, dropdown menus and tooltips are portals too. When you add an ambient layout context, list every portal-rendering primitive and decide for each one whether it should inherit the value.

## Nuance: the leaf still guards its own preconditions
If an ambient value is only meaningful under some other condition (a feature flag, a theme, a mode), don't count on today's single provider to enforce it. A second provider (a test harness, a story, a new layout) will eventually set the value without that condition. Have the consumer check both, or bake the check into the hook:

```tsx
export const useIsFullBleed = () => {
  const isFullBleed = useContext(FullBleedContext)
  const isNewDesign = useIsNewDesign()
  return isNewDesign && isFullBleed
}
```

Also write the portal-reset rule into the provider's doc comment. It's an invariant every future overlay primitive has to follow, and a PR description is not where the next person will look. Where to place the reset relative to a presence/animation wrapper is covered in [[animated-unmount-needs-a-dom-ref]].

## Nuance: every primitive that renders a row must read it
An ambient layout mode only works if every affected primitive reads it. Say an "edge to edge" mode tells descendants to supply their own side gutter. The toolbar and the table read the context, but the pagination bar doesn't, and each page wraps it in a padded div instead. One page that forgets the wrapper gets a row sitting flush against the screen edge under an inset toolbar, and different pages end up using different wrappers for the same row.

```tsx
// fragile: every call site has to remember
<PaddedIfEdgeToEdge><Pagination /></PaddedIfEdgeToEdge>

// robust: the primitive applies the mode itself
function Pagination(props) {
  const isEdgeToEdge = useIsEdgeToEdge()
  return <nav className={cx('flex justify-end', isEdgeToEdge && GUTTER)} {...props} />
}
```
When you add an ambient layout mode, list every primitive that renders a top-level row inside it (toolbar, filter chips, table, pagination, empty state) and make each one read the context. jsdom reports no layout, so unit tests won't catch the one you missed. Check it in a real browser.

## Why it matters
Inert props clutter every interface and invite drift. Layout concerns mixed into behavior contracts are hard to remove later. With portals, forgetting the reset makes components render with the page's layout rules inside an overlay that has different ones.

## Rule of thumb
Behavior goes in props, ambient environment goes in context. Reset ambient layout context at every portal boundary, and make every row primitive inside the mode read it rather than relying on call-site wrappers.
