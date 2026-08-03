---
id: 00_Styling
aliases: []
tags:
  - chapter
creation date: 2026-07-31 10:33
modification date: Friday 31st July 2026 10:33:48
status:
  - in-progress
---

## Link Tag

- Establishes the relationship between the [[HTML]] document and an external resource.
- Link an external [[CSS]]:

```html
<link rel="stylesheet" href="styles.css" />
```

- Link a favicon:

```html
<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
```

- Prefetch some data, preload a stylesheet, or preload a [[JavaScript Modules]]

```html
<link rel="prefetch" href="/some-resource" as="fetch" />
<link rel="preload" href="/some-file.css" as="style" />
<link rel="modulepreload" href="/some-file.js" />
```

### Linking in Remix

- [[Remix.js]] allows routes to define `link` elements that should be on the page when the route is active.
  - Each file in the `app`/`routes` directory of a Remix app is a route which can define a set of `link` elements.
  - `app/root.tsx` file is the root route of the entire application and will be rendered on every page.
- Some other built-in features:
  - Specifying a default import (like `import stylesheetUrl from './styles.css'`) will copy the CSS file to the `public` directory allowing you to link to the copied file.
  - When properly configured `import './styles.css'` will load the CSS file and add it to a special stylesheet you can link.
  - When properly configured import `'./styles.module.css'` will load the CSS file as a [[CSS Module]] and give you an object of class names you can apply when you've loaded the special CSS file.
  - If a `postcss.config.js` file is present in your application, Remix will automatically run your CSS through [[PostCSS]]. If none is present, but a `tailwind.config.js` is found, Remix will run your CSS through [[Tailwind]].
  - When properly configured, you can even use vanilla-extract to define your styles in a `.css.ts` file.
