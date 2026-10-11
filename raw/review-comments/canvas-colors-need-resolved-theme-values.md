---
id: canvas-colors-need-resolved-theme-values
aliases: []
tags:
  - review-comments
  - canvas
  - dark-mode
  - design-tokens
creation date: 2026-10-07 13:23
modification date: Wednesday 7th October 2026 13:23:55
---

## The idea
Theme tokens usually live in CSS custom properties (`--color-text`), and the theme switches by redefining them under a `.dark` class. Anything drawn on a `<canvas>` (2D context, WebGL, or a graph/chart library that renders to canvas) does not go through CSS. `ctx.fillStyle = 'var(--color-text)'` is not a valid color, so the library needs **literal** values. Two consequences follow:
1. You must resolve the token to a value yourself, either from a JS token map keyed by theme, or with `getComputedStyle(document.documentElement).getPropertyValue('--color-text')`.
2. Nothing re-runs on a theme switch by itself. The resolved values must be part of the inputs that rebuild what the canvas draws, for example a memo dependency.

## Example
```tsx
const useCanvasColors = () => {
  const theme = useThemeStore((s) => s.theme) // 'light' | 'dark'
  return useMemo(() => ({
    text: tokens.textPrimary[theme],
    surface: tokens.surface[theme],
  }), [theme])
}

const Chart = ({ data }) => {
  const colors = useCanvasColors()
  // The background is decided by the SAME input as the text drawn on it
  const items = useMemo(() => buildItems(data, colors), [data, colors])
  return (
    <div style={{ background: colors.surface }}>
      <CanvasChart items={items} />
    </div>
  )
}
```

Trap: the text color follows the theme inside the shared component, but the surface behind the canvas is a prop that only one caller sets. Every other caller ends up with light text on a white background in dark mode.

## Why it matters
CSS-driven UI gets dark mode "for free" once the tokens are right. Canvas-drawn UI only changes when the code that resolves colors runs again. Pairs that must contrast (text on surface, a label on its pill) break when the two halves come from different decisions. And the break shows up on pages nobody checked, because each piece looks correct on its own.

## Rule of thumb
For canvas content, resolve theme colors in one hook, include the theme in the dependencies of whatever builds the drawn items, and let the same owner pick both the foreground and the surface it sits on. Check every caller of a shared canvas component in dark mode, not just the page you migrated.
