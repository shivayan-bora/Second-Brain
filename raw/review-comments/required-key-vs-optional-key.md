---
id: required-key-vs-optional-key
aliases: []
tags:
  - review-comments
  - typescript
  - api-design
creation date: 2026-10-06 23:20
modification date: Tuesday 6th October 2026 23:20:52
---

## The idea
In [[TypeScript]], `key?: T` and `key: T | undefined` both allow the value `undefined`, but they mean different things to callers. `key?: T` lets callers leave the key out entirely, so it reads as "safe to ignore". `key: T | undefined` forces every caller to write the key, so they have to decide, even if they decide `undefined`.

## Example
```ts
interface Options {
  // Callers can forget this without a type error
  context?: Context;
}

interface Options {
  // Callers must write context: ctx or context: undefined
  context: Context | undefined;
}

resolve({ source });                     // compiles with the first, errors with the second
resolve({ source, context: undefined }); // explicit, visible in review
```

## Why it matters
Make a parameter optional only when leaving it out does something sensible. If leaving it out quietly degrades behavior (an empty list, a skipped feature, a generic fallback), the optional key is a trap: the bug compiles, and reviewers can't see the omission because there's nothing on the line to look at. This often happens when a parameter starts as "opt-in" for backward compatibility and then every caller opts in.

## Rule of thumb
Use `key?: T` when there's a correct default. Use `key: T | undefined` when every caller must decide. Once an "opt-in" option is passed by every caller, make it required.
