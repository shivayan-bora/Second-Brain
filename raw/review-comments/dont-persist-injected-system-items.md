---
id: dont-persist-injected-system-items
aliases: []
tags:
  - review-comments
  - state
  - routing
creation date: 2026-10-06 23:11
modification date: Tuesday 6th October 2026 23:11:09
---

## The idea
Apps often inject a system-owned item into a list the user can edit, such as a checkbox column in a table's visible-columns list, a pinned "All" tab, or a default filter. If the edited list is saved (in the URL, a preferences API or storage), the injected item gets saved with it. On the next load the app injects it again, and now it appears twice. Each save and inject cycle adds another copy. Hiding the item with a separate "allowed" or "visible" map doesn't help, because hidden is not the same as absent from the list.

## Example
```ts
// Trap: inject on read, then save whatever the editor hands back
const visible = saved === 'default' ? 'default' : ['select', ...saved]
const onChange = (ids: string[]) => save(ids) // ids still contains 'select'

// Better: the persisted list only ever holds user-owned ids
const userIds = saved === 'default' ? 'default' : saved.filter((id) => id !== 'select')
const visible = userIds === 'default' ? 'default' : ['select', ...userIds]
const onChange = (ids: string[]) => save(ids.filter((id) => id !== 'select'))

// Best: don't put the system item in the editable list at all,
// add it at render time when it applies
const columns = isSelecting ? [selectColumn, ...userColumns] : userColumns
```

## Why it matters
The bug is easy to miss. Nothing looks wrong on screen, because the item is hidden or deduped during rendering, while saved state keeps growing and shared links carry an internal id. It also breaks "feature off means no change", since the leak happens on paths that never check the feature. Separately, if you build the injected array inline and pass it to a memoized hook, the new array identity defeats the memo on every render.

## Rule of thumb
Split lists into user-owned and system-owned. Persist only the user-owned part, compose the two at render time, and test what gets saved, not just what renders. See [[url-state-round-trip]] and [[view-state-belongs-in-the-url]].
