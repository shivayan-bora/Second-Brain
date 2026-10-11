---
id: aria-busy-and-live-regions
aliases: []
tags:
  - review-comments
  - a11y
creation date: 2026-09-30 10:15
modification date: Wednesday 7th October 2026 18:29:00
---

## The idea
`aria-busy="true"` tells assistive tech that a **region** is updating and it should wait before announcing it. On a button, most screen readers ignore it. To tell a screen-reader user that something started or finished, use a [[Live Regions|live region]] (`role="status"` / `aria-live="polite"`) whose text changes.

## Example
```tsx
<section aria-busy={isRefreshing}>
  <Table ... />
</section>
<span role="status" className="sr-only">
  {isRefreshing ? 'Refreshing results' : ''}
</span>
<IconButton aria-label="Refresh" onClick={refresh} /> {/* keep it enabled so focus stays */}
```

The opposite mistake is putting `aria-busy="true"` on the live region itself. Busy tells assistive tech to hold that region's updates until it is no longer busy, so a status message that is busy for its whole life (and then unmounts) may never be read:
```tsx
// Trap: the status that should be announced is marked "don't announce yet"
<div role="status" aria-busy="true">{isWorking ? 'Working...' : 'Finishing...'}</div>

// Better: the status stays announceable; the thing being rebuilt is busy
<ul aria-busy={isGenerating}>{messages}</ul>
<div role="status">{statusText}</div>
```

A third trap: mounting the live region together with its message. Many screen readers only announce *changes inside* a live region that was already in the accessibility tree, so a `role="status"` element inserted along with its text is often silent. Live regions also shouldn't wrap interactive content like headings plus buttons; that is a labelled region, not a status.
```tsx
// Trap: region and text appear at the same time, and it wraps a button
{noResults ? <div role="status"><h2>No matches</h2><button>Reset</button></div> : null}

// Better: persistent live region, separate labelled block for the UI
<span role="status" className="sr-only">{noResults ? 'No matches' : ''}</span>
{noResults ? <section aria-labelledby={id}><h2 id={id}>No matches</h2><button>Reset</button></section> : null}
```

A fourth trap: setting the same message twice. A live region speaks when its content **changes**. If the second event writes the identical string ("Filter added", twice in a row), most UI libraries skip the update entirely, the DOM never changes, and the second event is silent. The old text also lingers, so someone browsing the page later finds a stale message.
```tsx
// Trap: second identical add is never announced
const [message, setMessage] = useState('')
const onAdd = (name: string) => setMessage(`${name} added`)
<div role="status">{message}</div>

// Better: a new node per event, cleared when the flow restarts
const [message, setMessage] = useState({ id: 0, text: '' })
const onAdd = (name: string) => setMessage((m) => ({ id: m.id + 1, text: `${name} added` }))
const onOpen = () => setMessage((m) => ({ ...m, text: '' }))
<div role="status"><span key={message.id}>{message.text}</span></div>
```

## Why it matters
Without an announcement, a screen-reader user clicks Refresh and gets no feedback. Disabling the button while loading also drops focus to the body.

## Rule of thumb
Put `aria-busy` on the region that's changing, never on the live region that describes the change, and announce status changes through that live region. Announce events, not states: a repeated message needs a new node or a clear in between. See [[Accessibility]].
