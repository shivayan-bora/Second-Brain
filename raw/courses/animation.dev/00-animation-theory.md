---
id: 00-animation-theory
aliases: []
tags:
  - chapter
creation date: 2026-10-01 12:45
modification date: "Thursday 1st October 2026 12:45:47"
status:
  - completed
---

## Taste, Explained

- `ease-out` on enter: feels snappier
- `180ms` and not `400ms`: feels faster, more responsive
- springs for gestures: they carry your momentum
- scale 0.97 on press: it makes UI feel alive
- no animation at all: you open it hundreds of times

## What makes a Good Animation?

- An animation feels right when it mirrors the physics we experience every day.

> “It’s not so much that resembling nature is intrinsically good as that nature has had a long time to work on the problem.”
>
> - Paul Graham, Taste for Makers

- A subtle blur filling the visual gap in between two different states feels more natural. Blur tricks the eye into seeing a smooth transition by blending the two states together.
- We can make our animations feel more natural through careful choices:
  - the right easing,
  - duration,
  - and the properties we want to animate.

### Purpose

- Just because we can animate UI elements to improve the user experience doesn't mean that we have to animate everything on the screen.
  - We have to pace the animations through the experience.
  - The more animations we add, the less valuable they become.
- When a user needs to interact with the same element quite often during the day, adding even a `200ms` animation can feel sluggish and can cause friction.
- Whenever a user comes to your website, they come to achieve a goal and not be delighted.
- If there's an animation, users shouldn't be surprised of it's existence.
- An animation feels right when it's obvious why it exists.

### Taste

- Great animation, like great design, follows a set of rules.
- To get really good at animations, we need to develop good taste and despite what people think, taste is not just a personal preference, you can actually learn it.

### Summary

- Animations feel right when:
  - They feel natural.
  - They have a purpose.
  - They are made with taste.

## The Easing Blueprint

- Easing is the rate at which something changes over a period of time.
- Easing also plays a part in how fast our interfaces feel.
  - Sometimes the perception of speed is more important than the actual performance of the application e.g. a faster loading spinner gives the feeling that an application is loading faster even if there's no difference in the loading time.
