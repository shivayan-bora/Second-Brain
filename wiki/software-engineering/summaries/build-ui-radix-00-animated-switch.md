---
title: "Build UI: Advanced Radix UI ch00 — Animated Switch"
pillar: software-engineering
type: summary
tags: [course, chapter, radix, react, tailwind, switch, animation]
status: stable
source: "raw/courses/Build UI/Advanced Radix UI/00_Animated Switch.md"
course: "Build UI — Advanced Radix UI"
created: 2026-06-09
updated: 2026-06-09
---

# Build UI: Advanced Radix UI ch00 — Animated Switch

Applied chapter: build a fully-styled animated Switch using Radix Primitives + Tailwind. Demonstrates [[radix-primitives|Primitives]] in isolation, the `data-state` styling hook, [[controlled-vs-uncontrolled|controlled vs uncontrolled]] forms, and Next.js's `"use client"` requirement.

## TL;DR

- Radix Primitives give you **behavior + accessibility for free** (keyboard, ARIA, focus management); you style them.
- **Install only what you need**: `pnpm install @radix-ui/react-switch` — and Radix is [[tree-shaking|tree-shakeable]] even if you install the meta-package.
- The **`data-state` attribute** is the styling bridge. Tailwind reads it via attribute selectors: `data-[state=checked]:bg-sky-500`, `data-[state=checked]:translate-x-4.5`.
- Pseudo-class variants: `hover:`, `active:`, `focus:`, and **`focus-visible:`** (focus achieved via keyboard, not mouse) — important for accessibility.
- Two integration modes: **controlled** (`checked={state}` + `onCheckedChange={setState}`) and **uncontrolled** (just `name="..."` for form submission). See [[controlled-vs-uncontrolled]].
- **Next.js gotcha**: Radix Primitives use hooks/refs, so they can't render as Server Components. Add `"use client"`.

## Key takeaways

- The `data-[state=checked]:translate-x-4.5` is doing the *animation* — Tailwind moves the thumb when the state attribute flips, with `transition duration-500` handling the easing. No JavaScript animation library needed for a simple slide.
- **Tree-shakeability** matters at the library level: even if you `pnpm install @radix-ui/react` (meta-package), only imported Primitives end up in your bundle. See [[tree-shaking]].
- **`focus-visible` vs `focus`**: a button that's `:focus` from a mouse click shows the focus ring; `focus-visible` only triggers when keyboard-focused. Use `focus-visible:` for ring styles to avoid the "ring on every click" anti-pattern.

## The two-form pattern

**Controlled** — React state owns the value:

```tsx
const [airplaneMode, setAirplaneMode] = useState(false);
<Switch.Root checked={airplaneMode} onCheckedChange={setAirplaneMode} />
```

**Uncontrolled** — Radix owns the state internally, form picks it up via `name`:

```tsx
<form action={(formData) => console.log(Object.fromEntries(formData))}>
  <Switch.Root name="airplane-mode" />
</form>
```

The uncontrolled form is more common than people realize; it pairs perfectly with React 19's `action` form-data submission.

## Notable passages

> "Radix UI provides the behaviour and accessibility for the Switch component, but it is up to us to add the styling and animation. It is unopinionated in terms of style."

> "For using these primitives inside of Next.js, use the `use client` i.e. these can't be used inside of a Server Component."

## Open questions

- The example uses Tailwind `transition` + `translate-x-*` — fine for a simple slide. For more elaborate animation (springs, exit transitions), when do you reach for Framer Motion / Motion's `<motion.div asChild>`?
- The note on `focus-visible` is the user's first encounter with the keyboard-vs-mouse focus distinction; does subsequent material in the course go deeper on accessibility?
- `Switch.Thumb` uses `translate-x-4.5` — is `4.5` a standard step in Tailwind 4's spacing scale, or arbitrary? (Tailwind 4 uses a different scale system than 3.)

## Cross-references

- Companion: [[article-building-components-radix-ui]] — the broader Radix surface area.
- Concepts: [[radix-primitives]], [[controlled-vs-uncontrolled]], [[tree-shaking]], [[utility-first-css]], [[tailwind-variants]].

## Source

- `raw/courses/Build UI/Advanced Radix UI/00_Animated Switch.md`
