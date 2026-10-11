---
id: double-submit-guard
aliases: []
tags:
  - review-comments
  - react
  - forms
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 10:15:23
---

## The idea
A loading flag that comes from a mutation (`isPending`) only turns on when the network call starts. Any `await` before that (validation, a prefetch) leaves a window where a second click runs the handler again. A [[Double Submit]] of a non-idempotent action creates duplicates.

## Example
```tsx
const [isSubmitting, setIsSubmitting] = useState(false)

async function onConfirm() {
  if (isSubmitting) return
  setIsSubmitting(true)
  try {
    await validate()
    await mutation.mutateAsync(payload)
  } finally {
    setIsSubmitting(false)
  }
}

<Button onClick={onConfirm} isLoading={isSubmitting || mutation.isPending} />
```

## Why it matters
Double-clicks are common, and fast users or slow validation make the window real. The result is duplicate records that the backend accepts because each request looks valid on its own.

## Rule of thumb
Guard non-idempotent submits from the moment of the click, not from the moment of the network call.
