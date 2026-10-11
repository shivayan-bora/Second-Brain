---
id: warm-lazy-chunks-with-a-shared-import
aliases: []
tags:
  - review-comments
  - react
  - code-splitting
creation date: 2026-10-05 22:10
modification date: Monday 5th October 2026 22:10:18
---

## The idea
`import('./x')` is cached by the JavaScript module map per resolved specifier. Calling it twice returns the same module instance, and the network fetch happens only once. That makes it safe to "warm" a [[React.lazy]] component ahead of time: share one loader function between `React.lazy` and the warm-up call. When the component later renders, its import resolves from cache and Suspense barely blinks.

The harder question is *when* to warm. A warm-up only pays off if it runs in the state the user is in *before* they trigger the lazy component. If the component opens from state A and you only warm it in state B, the user who needs it gets no benefit, and everyone in state B pays for a chunk they rarely use.

## Example
```tsx
export const loadSettingsDialog = () => import('./settings-dialog');

const SettingsDialog = React.lazy(async () => {
  const { SettingsDialog } = await loadSettingsDialog();
  return { default: SettingsDialog };
});

// Warm on intent, in the state the trigger lives in.
<button
  onPointerEnter={() => void loadSettingsDialog()}
  onFocus={() => void loadSettingsDialog()}
  onClick={open}
>
  Settings
</button>
```
Images the lazy component shows are a separate request. The chunk only contains their URL, so warm those too, for example with `new Image().src = url`.

## Why it matters
[[code splitting]] trades a smaller first load for a delay on first use. Warming at the right moment wins back that delay. Warming at the wrong moment just moves the cost onto users who never open the component.

## Rule of thumb
Use one shared `() => import()` function for both `React.lazy` and the warm-up. Before choosing when to call it, list every call site that opens the component, and warm it in *their* state or on hover or focus of the trigger.
