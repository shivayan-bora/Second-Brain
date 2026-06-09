---
title: "animations.dev ch00 — Animation Theory"
pillar: software-engineering
type: summary
tags: [course, chapter, animation, ux, frontend]
status: stable
source: "raw/courses/animations.dev/00_Animation Theory.md"
course: "animations.dev"
created: 2026-06-09
updated: 2026-06-09
---

# animations.dev ch00 — Animation Theory

Short opening chapter. Frames animation as a *deliberate UX resource*, not decoration. The "right" animation feels natural (matches real-world physics), serves a purpose, and is taste-paced through the experience.

## TL;DR

- Three predicates for "right" animation: **natural**, **purposeful**, **tasteful**.
- Natural means mirroring everyday physics — the user shouldn't be surprised by how it moves. Quoting Paul Graham: *"It's not so much that resembling nature is intrinsically good as that nature has had a long time to work on the problem."*
- **Animation is a finite UX resource.** The more you spend, the less each is worth. The user's goal-orientation overrides delight after the first encounter.
- The **frequency-of-encounter test**: a hover effect that looks great in a demo can feel sluggish at 50 hovers a day. Even a 200ms animation becomes friction at high frequency.

## Key takeaways

- Animation choices reduce to four parameters: **easing**, **duration**, **properties animated**, and **frequency** (how often the user sees it). The chapter foreshadows easing/duration without teaching them — likely covered later.
- The "200ms feels sluggish at 50x/day" framing is the operational version of "animation is a finite resource." Treat any high-frequency interaction as needing near-zero or zero animation.
- Concrete questions to ask before adding animation: *what does the user want to achieve here? how often will they see this?* If "achieve a goal quickly" + "see often," cut the animation.

## Notable passages

> "An animation feels right when it mirrors the physics we experience every day. It feels right when you are not surprised by the way it animates, because it feels familiar."
> — animations.dev, *Animation Theory*

> "Usually whenever a user is using your product, they don't want to be delighted, they want to achieve their goal."

## Open questions

- Easing curves (`ease-in`, `ease-out`, spring physics) and duration heuristics are foreshadowed but not taught. Future chapters.
- What's the empirical relationship between perceived sluggishness and frequency? The "50 hovers/day at 200ms" example is intuitive but undocumented.
- Are there established design-system patterns for *opting out* of motion (`prefers-reduced-motion`) layered with frequency-aware tuning?

## Cross-references

- Concepts: [[animation-purpose-and-pacing]].
- Soft-skills tangent: the "users want goals, not delight" framing applies beyond animation — see [[learning-encoding-and-recall|encoding and recall]] for the analogous "don't optimize for what feels good in the moment."

## Source

- `raw/courses/animations.dev/00_Animation Theory.md`
