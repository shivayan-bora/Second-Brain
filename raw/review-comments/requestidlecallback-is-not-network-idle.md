---
id: requestidlecallback-is-not-network-idle
aliases: []
tags:
  - review-comments
  - performance
  - browser-apis
creation date: 2026-10-05 22:10
modification date: Monday 5th October 2026 22:10:18
---

## The idea
[[requestIdleCallback]] runs your callback when the *main thread* has a spare slice inside a frame. It knows nothing about the network. While a single-page app boots, the main thread is idle most of the time because it is *waiting* on the network for the route's code chunk and the first API responses. So "at idle" often means "right in the middle of the critical loads".

Two more traps:
- Without the `timeout` option, a busy page can postpone the callback indefinitely. With it, the callback eventually runs regardless.
- Some engines (historically Safari) do not ship `requestIdleCallback`. A common fallback is `setTimeout(cb, 0 or 1)`, which is not idle at all: it fires immediately.

## Example
```ts
// Looks polite, but fires during boot; the fallback fires instantly.
const id = 'requestIdleCallback' in window
  ? requestIdleCallback(prefetch)
  : setTimeout(prefetch, 1);

// Better: wait for the app to settle, then take an idle slot, with a cap.
const DELAY_MS = 3000;
let idleId: number | undefined;
const timer = setTimeout(() => {
  if ('requestIdleCallback' in window) {
    idleId = requestIdleCallback(prefetch, { timeout: DELAY_MS });
  } else {
    prefetch();
  }
}, DELAY_MS);
const cancel = () => {
  clearTimeout(timer);
  if (idleId !== undefined) cancelIdleCallback(idleId);
};
```
Detached `new Image().src = url` requests get Low priority in Chromium by default. That softens contention but does not remove it, other engines prioritise differently, and you can make the intent explicit with `img.fetchPriority = 'low'`.

## Why it matters
[[prefetching]] that competes with the [[critical rendering path]] makes the cold first load slower, which is the exact load it was meant to improve. The cost does not show up on a warm dev machine with a fast network.

## Rule of thumb
Idle is not settled. For speculative work, wait for a real settle signal or a delay first, then use an idle slot with a `timeout`, and give the fallback the same delay rather than 1 ms.
