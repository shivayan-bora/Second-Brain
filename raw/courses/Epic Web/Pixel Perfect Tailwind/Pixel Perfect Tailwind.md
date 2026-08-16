---
id: Pixel Perfect Tailwind
aliases: []
tags:
  - course
creation date: 2026-08-02 19:28
modification date: Sunday 2nd August 2026 19:28:43
source:
status:
  - in-progress
---

## Project Setup

> [!NOTE]
> For a square aspect-ratio, you can use the `size-*` [[Tailwind CSS]] class e.g. `size-20` === `w-20` + `h-20`.

### Tailwind Config

> [!NOTE]
> In Tailwind CSS v4, you can configure your themes directly in [[CSS]] files. In v3, however, you need to configure it in `tailwind.config.ts` file. This file is also supported by v4.

- Sample tailwind config:

```ts
import { type Config } from "tailwindcss";

export default {
  content: [
    /*
     * All files where you'd use tailwind utility classes need to be defined here
     */
    "./src/**/*.{ts,tsx,js,jsx}",
    "./index.html",
  ],
  theme: {
    /*
     * If you want to extend the existing tailwind utility classes. In case you want to override, then put it outside the `extend` object
     */
    extend: {
      /*
       * This overrides the existing `sm` and `lg` utility classes for screen breakpoints for media-queries
       */
      screens: {
        sm: "520px",
        lg: "976px",
      },
      /*
       * Adds a new color `highlight` that we can use
       */
      colors: {
        highlight: "#6202FF",
      },
      /*
       * Adds a poppins font-family with fonts 'Poppins' and 'sans-serif'
       */
      fontFamily: {
        poppins: ["Poppins", "sans-serif"],
      },
      /*
       * Adds 4.5xl and 5.5xl font sizes. The first arg of the array is the font-size and the next one is line-height
       */
      fontSize: {
        "4.5xl": ["2.625rem", "1.15"],
        "5.5xl": ["3.375rem", "1"],
      },
    },
  },
  plugins: [],
} satisfies Config;
```

- [Tailwind CSS Configuration](https://tailwindcss.com/docs/theme)

## Mobile first design and implementation

> [!NOTE]
> Tailwind CSS uses a mobile-first breakpoint system by default and prefixed utilities like md:text-5xl only take effect at the specified breakpoint and above.
