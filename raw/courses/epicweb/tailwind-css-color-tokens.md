---
id: tailwind-css-color-tokens
aliases: []
tags:
  - workshop
creation date: 2026-08-31 21:44
modification date: Monday 31st August 2026 21:44:48
repository:
status:
  - in-progress
---

## What This Workshop Covers

In this workshop, we will:

- Convert a [Figma design](figma.com/design/utWvEdksWPfgkx2MsExQu5/Color-Tokens?node-id=0-1&p=f) to a [[Tailwind CSS]] project.
- Define custom colors in the Tailwind theme
- Create a semantic color token layer in the Tailwind theme
- Replace "hardcoded" colors with semantic color tokens in the UI
- Leverage CSS variables to make the color tokens themable
- Support dark mode 🌑 and multiple color themes 🎨
- Port a [[JavaScript]] Tailwind theme configuration (v3) to a [[CSS]]-only configuration (v4)

## Why Use Semantic Color Tokens?

- We use semantic color tokens:
	- To attach a meaning to specific styles with the color that it should represent. UI elements should not be directly connected to a specific color value - but instead us an aliased reference token.
		- e.g. we may have primary buttons for specific CTA and secondary buttons. We can say all primary buttons will have `background/primary` color which can be e.g. a shade of teal and secondary buttons will have `background/secondary` which may be a shade of white.
	- We can provide themes to it
		- e.g. light and dark themes but from the above example if we have a primary color palette of a shade of teal which gives color to the entire website, we can change it to a shade of amber which automatically will change the look and feel.
		- This unlocks the ability to change an entire design system by changing the color tokens, opening doors to advanced theming strategies.
	- Establish a common design language between developers and the designers.
- Semantic color tokens serve as the backbone of a [[Design System]].

## Process Overview

- Raw color accessors are mapped to the color values directly. => These raw color values are aliased to semantic color tokens. => The design consumes these semantic tokens to compose the UI.
- We will take reference from the provided [[Figma]] design.

![[Pasted image 20260903100228.png]]

## Implementation

### Design Implementation
