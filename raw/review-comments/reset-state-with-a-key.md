---
id: reset-state-with-a-key
aliases:
  - key-based state reset
tags:
  - review-comments
  - react
  - state
  - effects
creation date: 2026-10-07 10:55
modification date: Thursday 8th October 2026 20:24:41
---

## The idea
React keeps a component's state as long as the component stays at the same position in the tree with the same `key`. Changing the `key` makes React unmount the old instance and mount a fresh one, so all state inside it (hooks, context stores created in a provider, child state) starts over. When some state should live for exactly one "session" (one selected record, one visit to a mode, one form instance), key the subtree by that session. Don't watch for the change and clear things by hand.

## Example
```tsx
// Trap: state lives for the whole page, and every exit path must remember to reset it
function Table({ mode }) {
  const [selected, setSelected] = useState<string[]>([])
  useEffect(() => {
    if (mode !== 'select') setSelected([])  // runs after paint
  }, [mode])
  const onCancel = () => { setSelected([]); exitMode() }  // and again here
  // ...
}

// Better: the subtree's lifetime is the mode's lifetime
function Page({ mode }) {
  return (
    <SelectionProvider key={mode}>
      <Table mode={mode} />
    </SelectionProvider>
  )
}
```

The flip side: a key resets only what lives **inside** the keyed subtree. If a parent keeps its own copy of the same data (a draft it will save later), remounting the child wipes what the user sees while the parent's copy survives. The screen and the save now disagree.
```tsx
// Trap: the panel remounts empty when `tab` changes, but draftRef still holds the old picks
<Picker key={tab} onChange={(picks) => { draftRef.current = picks }} />
// later: save(draftRef.current)  -> saves picks the user can no longer see

// Better: seed the remounted child from the parent's copy (or lift the state up)
<Picker key={tab} initial={draftRef.current?.tab === tab ? draftRef.current.picks : []} ... />
```

A second trap: fixing this on one path only. A key change is rarely the only way the child disappears. A "Back" key, an Escape, or a parent that simply stops rendering the child all unmount it too, and each one leaves the parent's copy behind. And if later code asks "is anything pending?" by looking at what is open on screen instead of at the draft, a hidden draft gets saved at a surprising moment.
```tsx
// Trap: switching tabs drops the draft, but closing the panel does not
const switchTab = (next) => { draftRef.current = null; setTab(next) }
const closePanel = () => { setTab(null) }          // draft survives, panel is gone
const openPanel = (next) => {
  if (next !== tab) save(draftRef.current)          // tab is null after close, so this saves early
  setTab(next)
}

// Better: every path that hides the child decides what happens to the draft
const closePanel = () => { draftRef.current = null; setTab(null) }
```

## Why it matters
An effect-based reset runs after the render that changed the mode, so there is one frame with stale state. It also only covers the transitions you thought of: a Back button, a URL edit or a new exit button each need their own reset. A key covers all of them at once, because it ties the state's lifetime to the value itself. This is the pattern the React docs recommend in [[You Might Not Need an Effect]] ("Resetting all state when a prop changes").

## Rule of thumb
If you are writing `useEffect(() => { if (x changed) resetState() }, [x])`, ask whether the state should simply belong to a subtree keyed by `x`. Use a key when everything inside should start over. Use an effect or event handler only when part of the state must survive. And when a parent also holds a copy, key the child only if that copy is reset too, or seed the child from it, and handle the copy on every path that unmounts the child, not just the key change.
