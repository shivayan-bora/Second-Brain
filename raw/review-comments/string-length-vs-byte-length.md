---
id: string-length-vs-byte-length
aliases: []
tags:
  - review-comments
  - javascript
  - validation
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
In JavaScript, `str.length` counts UTF-16 code units. In Go, `len(s)` counts bytes (UTF-8), and many databases and APIs limit bytes, not characters. Non-ASCII text (accents, CJK, emoji, translations) uses more bytes than characters, so a client check on `.length` passes while the server rejects the value.

## Example
```ts
const byteLength = (s: string) => new TextEncoder().encode(s).length

'abc'.length        // 3, byteLength 3
'café'.length       // 4, byteLength 5
'😀'.length         // 2, byteLength 4

// Build the most descriptive value that fits
const name = candidates.find(c => byteLength(c) <= MAX_NAME_BYTES) ?? fallback
```

## Why it matters
A value the client builds automatically (a generated name, a title) can go over a server limit for real inputs. Tests with short fixtures and mocked mutations never see it.

## Rule of thumb
When the frontend generates a value, look up the server's validation for it, and measure in the same unit the server uses. Test the longest realistic input. See [[Input Validation]].
