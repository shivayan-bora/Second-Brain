---
id: 00-hello-world-in-js
aliases: []
tags:
  - project
creation date: 2026-09-04 20:11
modification date: Friday 4th September 2026 20:11:46
repository:
status:
  - completed
---

- Before going into [[React.js]], let's see how we can use vanilla [[JavaScript]] to create and append elements to the [[Document Object Model (DOM)|DOM]].

## Hello World in JavaScript

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <body>
    <!-- 🐨 Create a <script type="module"> for your JavaScript -->
    <script type="module">
      // create the root element like you do the hello world element
      const rootElement = document.createElement("div");
      // 🐨 you can even add the id to the root element if you like
      rootElement.id = "root";
      // 🐨 Create a div with the JavaScript DOM API:
      const element = document.createElement("div");
      // 🐨 Set the div's className property to 'container'
      element.className = "container";
      // 🐨 Set the div's textContent to 'Hello World'
      element.textContent = "Hello World";
      // 🐨 Append the div to the root div using `append`
      root.append(element);

      // 🐨 add the rootElement to the start of the document.body
      document.body.prepend(rootElement);
    </script>
  </body>
</html>
```
