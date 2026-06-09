---
title: "Learning — Encoding and Recall"
pillar: soft-skills
type: concept
tags: [learning, meta-learning, cognitive-science]
status: stable
sources: ["[[video-learn-dangerously-fast]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Learning — Encoding and Recall

## Definition

For a learning technique to be effective, it must do two things: **encoding** (connect a new piece of information to your existing schema of knowledge) and **recall** (test yourself on what you've learned in a free, uncued way). A technique that does only one is incomplete.

## Why it matters

Most people's default study habits (re-reading, summarizing, highlighting) optimize for the *feeling* of learning. They put the material in front of you, which feels like progress, but they neither force connection-making nor test retrieval. Real learning happens when the brain has to *produce* the information from memory and *integrate* it with what's already known.

For a staff engineer who needs to learn new domains continuously — new languages, new architectures, new systems — knowing this distinction is the difference between time well spent and time spent looking productive.

## The two components

### Encoding

- The act of forming meaningful connections, groupings, and relationships between new information and your existing knowledge schema.
- Connects "what" you're learning to "what you already know."
- Failure mode: studying in isolation, never connecting new concept to anything familiar.
- Activities that promote encoding: asking *"how is this like / unlike something I know?"*, drawing diagrams, explaining out loud, writing in your own words (not copying).

### Recall

- The act of producing information **from memory**, **uncued**.
- Tests whether the information has actually moved from passive recognition to active reproduction.
- Failure mode: thinking "I get it" while looking at the material; not testing the same understanding the next day with no notes.
- Activities that promote recall: closed-book quizzes, explaining without notes, writing a fresh summary from memory, applying to a new problem you haven't seen.

## Why both matter

| Have | Lack | Result |
|---|---|---|
| Encoding + Recall | — | Real understanding; transferable. |
| Encoding only | No Recall | Feels insightful but evaporates. |
| Recall only | No Encoding | Isolated facts that don't generalize. |
| Neither | — | Re-reading. |

The killer detail: **recall itself strengthens encoding.** The act of producing a memory restructures it, making future retrieval easier. So testing isn't separate from learning — it *is* learning.

## Examples

- **Reading a Go tutorial** → encoding-only if you nod along. Closing the tab and writing the example from memory adds recall.
- **TDD's red-green-refactor cycle** ([[tdd-red-green-refactor]]) is a working programmer's version of this: the "red" step forces uncued recall (write the test from the API you want), the "green" step provides immediate feedback, the "refactor" step strengthens encoding by re-organizing.
- **Wiki ingestion** (this very project) is encoding-shaped: forcing you to connect a new source to existing pages.

## Related

- [[desirable-difficulty]] — the right *amount* of recall difficulty.
- [[active-recall]] — the practical technique for recall.
- [[priming-and-schema-building]] — how to seed the schema that encoding plugs into.

## Sources

- [[video-learn-dangerously-fast]]
