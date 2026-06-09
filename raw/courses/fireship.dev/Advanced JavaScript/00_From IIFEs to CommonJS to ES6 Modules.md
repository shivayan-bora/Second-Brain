---
id: 00_From IIFEs to CommonJS to ES6 Modules
aliases: []
tags:
  - chapter
creation date: 2026-06-08 12:13
modification date: Monday 8th June 2026 12:13:10
status:
  - in-progress
---

## What is a Modules?

- Individual pieces of an application with a specific purpose and clear boundaries for how it interacts with the other pieces.
- Benefits:
  - Reusability: Individual pieces can be reused as much as we want.
  - Composability: Individual pieces are composed together to for the system as a whole.
  - Leverage: Create the pieces in-house or outsource them.
  - Isolation: Individual pieces can be worked on in isolation.
  - Organization: Organize your code which is a byproduct of reusability and composability.
    - Helps prevent collisions and pollution of the global namespace.
- A module consists of three distinct parts:
  - imports or dependencies needed to run this module
  - code or functionality
  - exports or interfaces for other modules to use this module

## Implementation

### Isolation of logic inside Individual files

```js
// users.js
var users = ["Tyler", "Sarah", "Dan"];

function getUsers() {
  return users;
}
```

```js
// dom.js

function addUserToDOM(name) {
  const node = document.createElement("li");
  const text = document.createTextNode(name);
  node.appendChild(text);

  document.getElementById("users").appendChild(node);
}

document.getElementById("submit").addEventListener("click", function () {
  var input = document.getElementById("input");
  addUserToDOM(input.value);

  input.value = "";
});

var users = window.getUsers();
for (var i = 0; i < users.length; i++) {
  addUserToDOM(users[i]);
}
```

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
  <head>
    <title>Users</title>
  </head>

  <body>
    <h1>Users</h1>
    <ul id="users"></ul>
    <input
      id="input"
      type="text"
      placeholder="New User">
    </input>
    <button id="submit">Submit</button>

    <script src="users.js"></script>
    <script src="dom.js"></script>
  </body>
</html>
```

- All the variables we declared that aren't in a function are just living on the global object.
- We can access, and worse, change `addUsers`, `users`, `getUsers`, `addUserToDOM`.

### IIFE Module Pattern

- Instead of giving access to all our variables, we can create a single object which we will expose.

```js
// App.js
var APP = {};
```

```js
// users.js
function usersWrapper() {
  var users = ["Tyler", "Sarah", "Dan"];

  function getUsers() {
    return users;
  }

  APP.getUsers = getUsers;
}

usersWrapper();
```

```js
// dom.js

function domWrapper() {
  function addUserToDOM(name) {
    const node = document.createElement("li");
    const text = document.createTextNode(name);
    node.appendChild(text);

    document.getElementById("users").appendChild(node);
  }

  document.getElementById("submit").addEventListener("click", function () {
    var input = document.getElementById("input");
    addUserToDOM(input.value);

    input.value = "";
  });

  var users = APP.getUsers();
  for (var i = 0; i < users.length; i++) {
    addUserToDOM(users[i]);
  }
}

domWrapper();
```

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
  <head>
    <title>Users</title>
  </head>

  <body>
    <h1>Users</h1>
    <ul id="users"></ul>
    <input
      id="input"
      type="text"
      placeholder="New User">
    </input>
    <button id="submit">Submit</button>

    <script src="app.js"></script>
    <script src="users.js"></script>
    <script src="dom.js"></script>
  </body>
</html>
```

- The global `window` object now just has `APP` and our wrapper functions, `usersWrapper` and `domWrapper`.
- More important, none of our important code (like `users`) can be modified since they're no longer on the global namespace.
- We can now make `usersWrapper` and `domWrapper` functions into an [[JavaScript Immediately Invoked Functions (IIFE)|IIFE]].

```js
// App.js
var APP = {};
```

```js
// users.js
(function () {
  var users = ["Tyler", "Sarah", "Dan"];

  function getUsers() {
    return users;
  }

  APP.getUsers = getUsers;
})();
```

```js
// dom.js

(function () {
  function addUserToDOM(name) {
    const node = document.createElement("li");
    const text = document.createTextNode(name);
    node.appendChild(text);

    document.getElementById("users").appendChild(node);
  }

  document.getElementById("submit").addEventListener("click", function () {
    var input = document.getElementById("input");
    addUserToDOM(input.value);

    input.value = "";
  });

  var users = APP.getUsers();
  for (var i = 0; i < users.length; i++) {
    addUserToDOM(users[i]);
  }
})();
```

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
  <head>
    <title>Users</title>
  </head>

  <body>
    <h1>Users</h1>
    <ul id="users"></ul>
    <input
      id="input"
      type="text"
      placeholder="New User">
    </input>
    <button id="submit">Submit</button>

    <script src="app.js"></script>
    <script src="users.js"></script>
    <script src="dom.js"></script>
  </body>
</html>
```

- Now in the `window` object, we're only exposing `APP` object.
- It has a couple of downsides:
  - We still have one item on the global namespace, `APP`. If by chance another library uses that same namespace, we're in trouble.
  - Second, the order of the `<script>` tags in our `index.html` file matter.

### CJS Module Pattern

```js
var users = ["Tyler", "Sarah", "Dan"];

function getUsers() {
  return users;
}

module.exports.getUsers = getUsers;
```

- Or:

```js
var users = ["Tyler", "Sarah", "Dan"];

function getUsers() {
  return users;
}

module.exports = {
  getUsers: getUsers,
};
```

- We can add more function to our exports as shown below:

```js
// users.js

var users = ["Tyler", "Sarah", "Dan"];

module.exports = {
  getUsers: function () {
    return users;
  },
  sortUsers: function () {
    return users.sort();
  },
  firstUser: function () {
    return users[0];
  },
};
```

```js
var users = require("./users");

users.getUsers(); // ["Tyler", "Sarah", "Dan"]
users.sortUsers(); // ["Dan", "Sarah", "Tyler"]
users.firstUser(); // ["Tyler"]
```

- The [[CommonJS]] group defined a module format to solve [[JavaScript]] scope issues by making sure each module is executed in its own namespace.
- CommonJS is supported by [[node.js]] out of the box but not in browsers.
- Apart from that, CommonJS isn't a great solution for browsers since it loads modules synchronously.
- To fix this, we have module bundlers like [[WebPack]] where it examines your codebase, looks at all imports and exports, then intelligently bundles all of your modules together into a single file that the browser can understand.
- Then instead of including all the scripts in your index.html file and worrying about what order they go in, you include the single bundle.js file the bundler creates for you.

```
app.js ---> |         |
users.js -> | Bundler | -> bundle.js
dom.js ---> |         |
```

### ES Modules

- Defining named exports:

```js
// utils.js

// Not exported
function once(fn, context) {
  var result;
  return function () {
    if (fn) {
      result = fn.apply(context || this, arguments);
      fn = null;
    }
    return result;
  };
}

// Exported
export function first(arr) {
  return arr[0];
}

// Exported
export function last(arr) {
  return arr[arr.length - 1];
}
```

- If we want to import everything from `utils.js`:

```js
import * as utils from "./utils";

utils.first([1, 2, 3]); // 1
utils.last([1, 2, 3]); // 3
```

- If we want to import only `first` from `utils.js`:

```js
import { first } from "./utils";

first([1, 2, 3]); // 1
```

- Default exports:

```js
// leftpad.js

export default function leftpad (str, len, ch) {
  var pad = '';
  while (true) {
    if (len & 1) pad += ch;
    len >>= 1;
    else break;
  }
  return pad + str;
}
```

- Importing a default export:

```js
import leftpad from "./leftpad";
```

- Combining named and default exports:

```js
// utils.js

function once(fn, context) {
  var result
  return function() {
    if(fn) {
      result = fn.apply(context || this, arguments)
      fn = null
    }
    return result
  }
}

// regular export
export function first (arr) {
  return arr[0]
}

// regular export
export function last (arr) {
  return arr[arr.length - 1]
}

// default export
export default function leftpad (str, len, ch) {
  var pad = '';
  while (true) {
    if (len & 1) pad += ch;
    len >>= 1;
    else break;
  }
  return pad + str;
}
```

- Importing:

```js
import leftpad, { first, last } from "./utils";
```

- Moving on to our previous example:

```js
// users.js

var users = ["Tyler", "Sarah", "Dan"];

export default function getUsers() {
  return users;
}
```

```js
// dom.js

import getUsers from "./users.js";

function addUserToDOM(name) {
  const node = document.createElement("li");
  const text = document.createTextNode(name);
  node.appendChild(text);

  document.getElementById("users").appendChild(node);
}

document.getElementById("submit").addEventListener("click", function () {
  var input = document.getElementById("input");
  addUserToDOM(input.value);

  input.value = "";
});

var users = getUsers();
for (var i = 0; i < users.length; i++) {
  addUserToDOM(users[i]);
}
```

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Users</title>
  </head>

  <body>
    <h1>Users</h1>
    <ul id="users">
    </ul>
    <input id="input" type="text" placeholder="New User"></input>
    <button id="submit">Submit</button>

    <script type=module src='dom.js'></script> <!-- 👈 Bundled using a Module Bundler -->
  </body>
</html>
```

## Tree-Shaking

- CommonJS modules can be imported conditionally:

```js
if (pastTheFold === true) {
  require("./parallax");
}
```

- Because ES Modules are static, the same isn't true for them.
  - The reason this design decision was made was because by forcing modules to be static, the loader can statically analyze the module tree, figure out which code is actually being used, and drop the unused code from your bundle.
