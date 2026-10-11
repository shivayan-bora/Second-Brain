---
id: scroll-position-is-not-user-intent
aliases:
  - stick-to-bottom
  - follow the stream
tags:
  - review-comments
  - scroll-behavior
  - react
creation date: 2026-10-02 23:34
modification date: Friday 2nd October 2026 23:34:59
---

## The idea
Chat logs, streaming AI output and live logs usually "stick to the bottom": they follow new content while the reader is at the end, and stop when the reader scrolls up. The common hand-rolled version decides "is the reader following?" from **position** on every `scroll` event (`scrollHeight - scrollTop - clientHeight <= threshold`). Position can't tell you what the user *meant*. A `scroll` event fires for the user's gesture, for your own programmatic `scrollTop =` writes, and for browser scroll anchoring. And small, slow gestures stay inside the threshold.

## Example
```ts
// Trap: intent derived from position
const onScroll = () => {
  following = el.scrollHeight - el.scrollTop - el.clientHeight <= 24;
};
// On every streamed chunk (say every 60ms):
if (following) el.scrollTop = el.scrollHeight;
```
A trackpad sends many 2 to 10px deltas. The first one leaves the reader 5px from the bottom, which still counts as "following", so the next chunk snaps them back. The reader can only escape with a fast flick.

```ts
// Better: unpin on a signal of intent, re-pin on position
let lastTop = 0;
const onScroll = () => {
  const movedUp = el.scrollTop < lastTop;   // our own writes only ever move down
  lastTop = el.scrollTop;
  if (movedUp) following = false;
  else if (isAtBottom(el)) following = true;
};
el.addEventListener('wheel', (e) => { if (e.deltaY < 0) following = false; }, { passive: true });
```
Libraries such as `use-stick-to-bottom` do this properly. They also follow content growth with a `ResizeObserver` (not render deps) and cope with scroll anchoring.

## Why it matters
If the follow can't be escaped, the user can't read back during the exact window when the content is most interesting (while it streams). Tests usually miss it, because they jump `scrollTop` hundreds of pixels in one synthetic event.

## Rule of thumb
Treat position as *state* and input as *intent*. Unpin on upward user input (scroll direction, `wheel`, touch, PageUp/Home keys), and re-pin only when the reader reaches the bottom themselves or clicks "Jump to latest". Test with small, repeated scroll steps, not one big jump. See [[Scroll Anchoring]] and [[ResizeObserver]].
