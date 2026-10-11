---
id: 00-environment-setup
aliases: []
tags:
  - chapter
creation date: 2026-10-04 20:28
modification date: "Sunday 4th October 2026 20:28:48"
status:
  - in-progress
---

## Basic Terminal Commands

### Navigation Commands

- `pwd`: Present working directory.
  - Shows the path you're currently at in a terminal.
- `cd`: Change directory.
  - Navigate to a directory by providing either the absolute or the relative path.
- `ls`: Lists the contents of the current directory.
  - `ls -la`: Show hidden files and folders with extra details.
- `clear`: Clean-up terminal.

### File and Folder Commands

- `mkdir <folder-name>`: Create a directory.
  - `mkdir -p <parent-folder>/<child-folder>`: Will create the parent folder and then create the child folder inside it.
- `touch <file-name>`: Create an empty file.
- `cp <source> <destination>`: Copy files or folders.
  - `cp -r <source> <destination>`: Copy recursively. Used for folders.
- `mv <source> <destination>`: Move or Rename.
- `rm <target>`: Remove file.
  - `rm -r <target>`: Remove recursively. Used for folders.
  - `rm -rf <target>`: Same as above but won't ask for confirmation.
- `rmdir <target>`: Remove empty folder.

### Reading Files

- `cat <file-name>`: Display contents of a file.
- `less <file-name>`: Opens a file for browsing. Useful for long files.
- `head <number-of-lines> <file-name>`: Read the first `<number-of-lines>` of `<file-name>`
- `tail <number-of-lines> <file-name>`: Read the last `<number-of-lines>` of `<file-name>`

### Searching

- `find <location> -name <file-name>`: Locate File.
- `grep <regex> <file-name>`: Search for text within files.
  - `grep -r <regex> <location>`: Search for text recursively in all files including sub folders.
- `history | grep "npm"`: Search command history.

### Help

- `man`: Manual pages

> [!NOTE]
> `-l`, `-r`, `-la` are known as flags. They modify how a command behaves, similar to toggling a setting.

> [!NOTE]
> Words like `file.txt` or `Documents` after a command are also known as arguments i.e. the thing we want our commands to act on.

### Practical Patterns

- `&&`: Run multiple commands e.g. `mkdir my-project && cd my-project`.
- `|` or also called **pipe**: Send the output of one command as an input to another command e.g. `ls -la | grep ".css`.
- `>` or also called **redirect**: Save the output to a file e.g. `ls -la > file-list.txt`.
- `>>` or also called **append**: Append to a file e.g. `echo "New Line" >> notes.txt`.

## Initialize your first project

- Create a new folder `my-project`.
- Run `npm init -y` to initialize [[npm]] and create a `package.json` which holds metadata about your [[node.js]] project, contains scripts and lists dependencies.
- Create `src/index.html` and `src/styles.css`:

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

```css
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family:
    system-ui,
    -apple-system,
    sans-serif;
  min-height: 100vh;
  display: grid;
  place-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

main {
  text-align: center;
}

h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
}

p {
  font-size: 1.25rem;
  opacity: 0.9;
}
```

- Install [[Vite]] as a developer dependency: `npm install --save-dev vite`.
- Add `build` and `dev` scripts.
- Run the server: `npm run dev`

```json
{
  "name": "my-first-project",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "dev": "vite src",
    "build": "vite build src"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "type": "commonjs",
  "devDependencies": {
    "vite": "^8.3.2"
  },
  "dependencies": {
    "lodash": "^4.18.1"
  }
}
```

- `dependencies`: Dependencies needed for the project to run in production.
- `devDependencies`: Dependencies only needed during development.
- When you run `npm install`, it creates a `node_modules` folder which contains the code for the dependencies and their various sub-dependencies.
  - This file should never be checked in. So, `echo "node_modules" > .gitignore`
