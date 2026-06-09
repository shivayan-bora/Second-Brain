---
title: "Radix Themes"
pillar: software-engineering
type: concept
tags: [radix, react, design-systems, theming, pre-styled]
status: stable
sources: ["[[article-building-components-radix-ui]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Radix Themes

## Definition

**Radix Themes** is the pre-styled component library that sits on top of [[radix-primitives|Radix Primitives]]. Where Primitives ship pure behavior, Themes ships components with default styles — accessible, themable via CSS variables, and customizable through a Theme provider.

## Why it matters

Radix's two layers represent a trade-off most design-system decisions reduce to: **do you want full styling control (Primitives) or fast onboarding (Themes)?** Themes is right when you don't have a design system yet but want one that's accessible and reasonable. Primitives is right when you have visual identity to preserve.

## Mechanics

### Setup

```tsx
import "@radix-ui/themes/styles.css";
import { Theme } from "@radix-ui/themes";

createRoot(document.getElementById("root")).render(
  <Theme>
    <App />
  </Theme>
);
```

### Use components directly

```tsx
import { Button, Flex, Text } from "@radix-ui/themes";

<Flex direction="column" gap="2">
  <Text>Hello</Text>
  <Button>Click me</Button>
</Flex>
```

### Theme provider knobs

```tsx
<Theme accentColor="cyan" radius="full">
  <App />
</Theme>
```

- **`accentColor`** — the brand color used for buttons, links, focus rings.
- **`radius`** — global border-radius preset (`none`, `small`, `medium`, `large`, `full`).
- **Light/dark mode** — automatic, opt-in via `appearance="dark"` or system-detected.
- **Scale** — global size multiplier.

### Nested themes

```tsx
<Theme accentColor="cyan">
  <Card>...</Card>
  <Theme accentColor="orange">
    <Card>...</Card>  {/* different accent for this subtree */}
  </Theme>
</Theme>
```

Nested `<Theme>` providers override their parent's tokens for everything inside. Useful for "this side panel is brand B" without rebuilding components.

### Customizing via CSS variables

Themes is styled with standard CSS — no styling system inside. You override the token CSS variables to retheme:

```css
:root {
  --accent-1: #...;
  --accent-9: #...;
  --gray-1: #...;
}
```

Full token list: https://github.com/radix-ui/themes/tree/main/packages/radix-ui-themes/src/styles/tokens

### Notable components

- **Theme** — the wrapper.
- **ThemePanel** — visual playground for adjusting accent/radius/scale during development.
- **Reset** — collapses opinionated browser styles for a child element (sets `box-sizing: border-box`, removes user-agent margins, etc.).
- **Slot** — Radix's element-forwarding mechanism (the implementation behind [[aschild-and-slot|`asChild`]]).
- **Layout primitives** — `Box`, `Flex`, `Grid`, `Container` with margin/padding/gap props that map to the spacing scale.

## When to use Themes vs Primitives

| Choose **Themes** | Choose **Primitives** |
|---|---|
| You want components today, accessible by default. | You have (or are building) your own design system. |
| Custom branding via CSS variables is enough. | You need full visual control. |
| Standard component shapes work. | You need bespoke composition. |
| Mostly internal tools or rapid prototyping. | Customer-facing product with strong visual identity. |

You can mix: install both packages and reach for Primitives when Themes doesn't have what you need.

## Related

- [[radix-primitives]] — the unstyled layer underneath.
- [[design-tokens]] — Themes is a token-customizable system.
- [[css-custom-properties]] — Themes's customization vehicle.
- [[aschild-and-slot]] — Themes ships `Slot` as a top-level export.

## Sources

- [[article-building-components-radix-ui]]
