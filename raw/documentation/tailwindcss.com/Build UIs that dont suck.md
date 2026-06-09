---
id: Build UIs that dont suck
aliases: []
tags:
  - chapter
creation date: 2026-06-06 15:46
modification date: Saturday 6th June 2026 15:46:37
status:
  - in-progress
---

## Add hover styles to card instead of making the entire card as a link

```html
<article class="md:grid md:grid-cols-4 md:items-baseline">
  <!-- 👇 make position in div as relative -->
  <div
    class="relative isolate flex flex-col items-start rounded-2xl px-4 py-6 hover:bg-zinc-200/70 md:col-span-3"
  >
    <h2 class="text-base font-semibold tracking-tight text-zinc-800">
      <!-- 👇 Wrap only the header with the anchor tag -->
      <a href="#">
        <!-- 👇 add a span inside the anchor tag with position absolute, inset 0 and z-index as 10 -->
        <span class="absolute inset-0 z-10"></span>
        Crafting a design system for a multiplanetary future
      </a>
    </h2>
    <time
      class="relative order-first mb-3 flex items-center pl-3.5 text-sm text-zinc-400 md:hidden"
      datetime="2022-09-05"
    >
      <span
        class="absolute inset-y-0 left-0 flex items-center"
        aria-hidden="true"
        ><span class="h-4 w-0.5 rounded-full bg-zinc-200"></span
      ></span>
      September 5, 2022
    </time>
    <p class="mt-2 text-sm text-zinc-600">
      Most companies try to stay ahead of the curve when it comes to visual
      design, but for Planetaria we needed to create a brand that would still
      inspire us 100 years from now when humanity has spread across our entire
      solar system.
    </p>
    <div
      aria-hidden="true"
      class="mt-4 flex items-center text-sm font-medium text-teal-500"
    >
      Read article &rarr;
    </div>
  </div>
  <time
    class="order-first hidden text-sm text-zinc-400 md:block"
    datetime="2022-09-05"
    >September 5, 2022</time
  >
</article>
```

- `inset` servers as a shorthand to simultaneously set the `top`, `right`, `bottom` and `left` positioning properties of an element in [[CSS]]
- This is useful for accessibility as the link now only wraps the header, so screen readers will only read out the header on focus.
