---
id: 01-html-fundamentals
aliases: []
tags:
  - chapter
creation date: 2026-10-05 21:14
modification date: "Monday 5th October 2026 21:14:26"
status:
  - in-progress
---

- [[HTML]] or HyperText Markup Language is the skeleton of every web page.
  - It provides structural foundation that gives content a meaning and makes the web accessible.
  - `HyperText` means text linking to some other text.
  - `Markup` refers to the tags used to describe the content.
  - `Language` implies that there is a standardized way of writing these tags for browser to interpret.

![[Pasted image 20261005211807.png]]

## How HTML works?

- HTML uses tags to mark up content: `<p>Hello World</p>`
  - `<p>`: Opening Tag
  - `Hello World`: Content
  - `</p>`: Closing Tag
  - Together this forms an HTML Element
- We can also pass attributes to an HTML element e.g. `<a href="www.google.com">Go to Google</a>`
  - `a` is an anchor tag used to link to other pages for the users to navigate.
  - `href` is an attribute that tells when we click on the anchor tag, where should the user navigate to.

### Basic HTML Document:

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My First Project</title>
    <link rel="stylesheet" href="./styles.css" />
  </head>
  <body>
    <main>
      <h1>Hello, Design Engineer!</h1>
      <p>You built this from the terminal</p>
    </main>
  </body>
</html>
```

- `<!doctype html>`: Implies the document is an HTML5 document.
- `<html lang="en">`: Root element
  - `lang="en"`: Primary language of the document.
    - Helps with a11y and SEO.
- `<head>`: Contains the metadata e.g. page title, linked files, fonts etc.
- `<body>`: Visible content of a web page.

#### `head` Element

- `<meta charset="UTF-8" />`: Defines the character encoding. In this case, it's `utf-8`.
- `<meta name="viewport" content="width=device-width, initial-scale=1.0" />`: The viewport meta tag is essential for responsive design as it allows you to set the viewport width to match the device's width and prevents the browser from zooming in by default.
  - Ensures that our application displays accurately across all screen sizes rather than forcing mobile users to navigate a tiny, zoomed-out version of a desktop layout.
- `<meta name="description" content="A brief description of the page content." />`: Displayed in search results. Keep to ~155 characters. Should be unique per page and accurately describe the content.

##### Linking Resources

###### Stylesheets

```html
<link rel="stylesheet" href="styles.css" />
```

###### Favicon

```html
<link rel="icon" href="favicon.ico" />
<link rel="apple-touch-icon" href="apple-touch-icon.png" />
```

###### Fonts

```html
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link
  href="https://fonts.googleapis.com/css2?family=Inter&display=swap"
  rel="stylesheet"
/>
```

##### Scripts (in head):

```html
<script src="analytics.js" defer></script>
```

- `defer`: Downloads during HTML parsing, executes after parsing complete.

```html
<script src="analytics.js" async></script>
```

- `async`: Downloads and executes as soon as possible, order not guaranteed.

##### Open Graph Tags

- For social media sharing:

```html
<meta property="og:title" content="Page Title" />
<meta property="og:description" content="Page description" />
<meta property="og:image" content="https://example.com/image.jpg" />
<meta property="og:url" content="https://example.com/page" />
<meta property="og:type" content="website" />
```

- Twitter has its own format:

```html
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="Page Title" />
<meta name="twitter:description" content="Page description" />
<meta name="twitter:image" content="https://example.com/image.jpg" />
```

### Semantic HTML

- [[Semantic HTML]] uses tags that describe the meaning of content and not just structure. This is useful for, readability, maintainability, [[Search Engine Optimization (SEO)|SEO]] and [[Web Accessibility|a11y]].
- Semantic elements also come with built-in behaviours that would otherwise require significant [[JavaScript]] to recreate e.g. `button` is inherently keyboard accessible, an `a` tag provides native navigation and `form` element handles data submission automatically.

- Non-semantic:

```html
<div class="header">Site Title</div>
<div class="nav">...</div>
<div class="main">...</div>
```

- Semantic:

```html
<header>Site Title</header>
<nav>...</nav>
<main>...</main>
```

## Common HTML Elements

- Here's a quick overview of essential elements (we'll cover each in depth):

### Structure

- <header>: Page or section header
- <nav>: Navigation links
- <main>: Main content
- <section>: Thematic grouping
- <article>: Self-contained content
- <aside>: Tangentially related content
- <footer>: Page or section footer

### Text

- <h1> to <h6>: Headings (hierarchy)
- <p>: Paragraph
- <span>: Inline text container
- <strong>: Important text
- <em>: Emphasized text

### Links and Media

- <a>: Links
- <img>: Images
- <video>: Video content
- <audio>: Audio content

### Lists

- <ul>: Unordered list
- <ol>: Ordered list
- <li>: List item

### Forms

- <form>: Form container
- <input>: Input field
- <button>: Clickable button
- <label>: Input label

### Scripts

```html
<body>
  <!-- content -->
  <script src="app.js"></script>
</body>
```

- Traditional approach: scripts don't block rendering.
