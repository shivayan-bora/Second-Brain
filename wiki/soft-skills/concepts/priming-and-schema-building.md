---
title: "Priming and Schema Building"
pillar: soft-skills
type: concept
tags: [learning, meta-learning, schema, mental-models]
status: stable
sources: ["[[video-learn-dangerously-fast]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Priming and Schema Building

## Definition

**Priming** is the deliberate act of building an initial mental model — a *schema* — of a new topic *before* studying any one piece in depth. You skim headings, look at the table of contents, identify the keywords and relationships, and form a rough top-level picture. Then you go back and fill in the details, layering them onto the schema you built.

## Why it matters

The default advice for overwhelming material is "break it into smaller pieces and study one at a time." The pushback in *Learn Dangerously Fast*: **this destroys the cross-connections that make the material learnable.** A list of facts without their relationships is harder to remember than the same facts embedded in a structure.

For technical learning specifically — where every new concept connects to many others — priming saves time. You catch the relationships *before* getting bogged down in any one detail.

## The mechanics

1. **Look at the whole.** Read the table of contents. Skim chapter headings, section titles, the first paragraph of each. Look at diagrams. Don't try to understand; just look.
2. **Extract the keywords.** Make a rough list of the concepts that appear.
3. **Form initial connections.** What does this look like? What domains does it remind you of? What's the central thing this material is about? (Often the title plus the first chapter answer this.)
4. **Now study a piece.** Read chapter 1 properly. As you go, you're not just learning chapter 1 — you're *placing* it in the schema you sketched.
5. **Refine the schema.** What did the chapter tell you that updates your initial mental model? Adjust. Then move on.
6. **Repeat.** Each chapter adds detail to the schema and updates it.

## The contrast with "break it down"

| "Break it down" (default) | "Prime first" (the better move) |
|---|---|
| Study chapter 1 in isolation | Skim all chapters; understand the arc |
| Build understanding sequentially | Build a sketch first, then fill in |
| Cross-connections discovered (or missed) later | Cross-connections are part of the initial schema |
| One chapter at a time | One pass for shape, then deep dives |

Breaking down isn't *wrong* — eventually you do study one chapter at a time. But you do it *after* priming, not instead of.

## The questions priming answers

Per the source, the questions to ask:

- *Why is this important?*
- *How can I use and apply this information?*
- *What is the main point of this in its simplest form?*
- *What would I need to already know in order for this to become easier?*

That last one is critical — it surfaces prerequisite gaps before they ambush you.

## Examples

- **Learning Go.** Don't start with chapter 1 of a 600-page Go book. Skim the table of contents: variables, packages, goroutines, channels, interfaces, generics. *Now* you know Go's arc. *Now* chapter 1 lands in context, not in a vacuum.
- **Adopting a new framework** (React, TanStack Query, Tailwind). Prime by reading the *Why X?* doc, then the API reference outline, then the philosophy section, before touching any single API.
- **Onboarding to a new codebase.** Read the top-level README, skim the directory structure, look at the largest packages, run the app once. *Then* dive into the file you were assigned.
- **This wiki's [[synthesis|synthesis.md]] page.** It's a priming aid for *yourself* — re-reading it before deep work in any one pillar resets the schema.

## When priming might not pay off

- **Material that genuinely is a sequence** (a calculus textbook where each chapter depends on the last in a strict order) — but even there, priming the *arc* still helps.
- **Material so small it doesn't have a structure** — a one-page tutorial doesn't need priming.
- **You already have the schema.** Re-priming a domain you know well wastes time.

## Related

- [[learning-encoding-and-recall]] — priming builds the encoding substrate.
- [[active-recall]] — what you do once the schema exists.
- [[desirable-difficulty]] — priming reduces the chance of overshooting.

## Sources

- [[video-learn-dangerously-fast]]
