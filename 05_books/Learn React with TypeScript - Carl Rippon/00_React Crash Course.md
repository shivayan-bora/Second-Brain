---
creation date: 2026-04-13 15:41
modification date: Monday 13th April 2026 15:41:19
tags:
  - chapter
status:
  - in-progress
---
- React is a [[JavaScript]] library to build dynamic [[Single Page Applications (SPA)]].
- [[React]] focuses on doing one thing really well - **provide a powerful mechanism to build UI components**
	- To render these components into a web browser, we use [[React DOM]] and for rendering these components in a mobile application, we use [[React Native]].
- Components are reusable pieces of UI that can be composed together to create a frontend.
- React's components are displayed performantly using a [[Virtual DOM]] which is an in-memory representation of [[Document Object Model (DOM)]].
	- DOM interactions can be costly.
	- React compares the previous virtual DOM with the current virtual DOM, calculates the minimum amount of changes and then updating the actual DOM with those changes.

## Create a New React Application Using Vite

- `npm create vite@latest`: Create a new [[Vite]] app.
	- Enter the name of the project, select `React` and `JavaScript` in the prompts.
- `npm install`: Install the dependencies.
- `npm run dev`: Run the application in development mode.
- `npm run build`: Create a production build of the application.
- Earlier, React applications were created using [[Create React App]] which used [[Webpack]] under the hood for creating production builds.

### File Structure

- `node_modules`: Contains all dependent [[npm]] packages and was created when they were installed using the `npm install` command.
- `public`: Contains static assets e.g. images to be served at the root path `\`.
- `src`: Contains source code:
	- `main.jsx`: Contains the logic to load the top level component of the React application under the root element of the web page (`index.html`).
	- `index.css`: Global styles.
	- `App.jsx`: Top level [[React Components|component]] of the application.
		- Note the component and the file name starts with a capital letter which allows React to distinguish between React components and [[HTML]] elements.
	- `App.css`: Styles for the `<App/>` component.
- `.gitignore`: Specifies the file and folders to be ignored by [[git]].
- `eslint.config.js`: Configuration file for [[ESLint]] for [[Lint|linting]] which is the process of checking the code to find potential problems and deviations from the coding standards.
- `index.html`: Root web page of the application.
- `package.json`: Contains the project name, version, a list of all the dependencies of the project alongwith it's versions, scripts and other project metadata.
- `package-lock.json`: Contains the exact version of the dependencies installed to ensure consistency when the project is run on different environments.
- `vite.config.js`: Contains the [[Vite]] configuration. For this project, a [[Vite React Plugin]] has to be specified.

### Configure Linting Using ESLint

- In the old system of ESLint (`.eslintrc`), ESLint searched every directory from the linted file up to the root.
	- You could have `.eslintrc.json`, `.eslintrc.yml`, `.eslintrc.js`, or even a `"eslintConfig"` key inside `package.json`.
	- Rules merged as it walked up the tree — deeply nested files could unknowingly override root-level rules.
	- Plugins and parsers were referenced as **strings** (e.g., `"extends": ["airbnb"]`) and ESLint resolved them via implicit `require()` behind the scenes.
- The new flat configuration replaced all of that with a **single `eslint.config.js`** at the project root that exports a plain JavaScript array. No more directory walking, no more string magic — everything is **explicit JS imports**.
- The name comes from the fact that all config resolution happens in **one flat array** instead of across a tree of files in a directory hierarchy. ESLint walks down the array (not up a file tree) and merges every config object whose `files` glob matches the current file. The last matching object wins on any conflicting rule.
- In this project, since we would be using [[TypeScript]] to create strongly typed React components, we can disable the ESLint configuration for checking the `prop` types in it's `rules`: `‘react/prop-types’: ‘off’,`.

### Configure Code Formatting Using Prettier

- Automatic code formatting is done using [[Prettier]].
- Install Prettier as a development-only dependency: `npm install --save-dev prettier`
- Prettier has overlapping style rules with ESLint. So install the following library to allow Prettier to take responsibility of the styling rules from ESLint: `npm install --save-dev eslint-config-prettier`
- Make the following changes to your `eslint.config.js`:

```js
import js from "@eslint/js";
import globals from "globals";
import reactHooks from "eslint-plugin-react-hooks";
import reactRefresh from "eslint-plugin-react-refresh";
import { defineConfig, globalIgnores } from "eslint/config";
import eslintConfigPrettier from "eslint-config-prettier/flat";

export default defineConfig([
  globalIgnores(["dist"]),
  {
    files: ["**/*.{js,jsx}"],
    extends: [
      js.configs.recommended,
      reactHooks.configs.flat.recommended,
      reactRefresh.configs.vite,
    ],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
      parserOptions: {
        ecmaVersion: "latest",
        ecmaFeatures: { jsx: true },
        sourceType: "module",
      },
    },
    rules: {
      "no-unused-vars": ["error", { varsIgnorePattern: "^[A-Z_]" }],
      "react/prop-types": "off",
    },
  },
  eslintConfigPrettier,
]);
```

> [!IMPORTANT]
> Why was this change necessary?
>
> Many ESLint configs (like `eslint:recommended`, or third-party ones like `airbnb`) ship with **formatting rules enabled**. When Prettier runs and reformats your code, it may produce output that violates those ESLint formatting rules — causing ESLint to throw errors on code that Prettier itself just wrote. This creates a **circular conflict** where no state of your code satisfies both tools simultaneously.
>
> `eslint-config-prettier` is simply a config object that sets a large list of conflicting formatting rules to `"off"`. It doesn't add any new rules — it only _disables_ the ones that overlap with Prettier's domain.
>
> This is kept last in the array because of the fact that all config resolution happens in **one flat array** instead of across a tree of files in a directory hierarchy. ESLint walks down the array (not up a file tree) and merges every config object whose `files` glob matches the current file. The last matching object wins on any conflicting rule.

- Add the following rules in `.prettierrc.json`:

```json
{
  "printWidth": 100,
  "singleQuote": true,
  "semi": true,
  "tabWidth": 2,
  "trailingComma": "all",
  "endOfLine": "auto"
}
```

- These are the rules:
	- Lines wrap at 100 characters
	- String qualifiers are single quotes
	- Semicolons are placed at the end of statements
	- The indentation level is two spaces
	- A trailing comma is added to multi-line arrays and objects
	- Existing line endings are maintained

### Development Server

- To start the application: `npm run dev`
- [[Vite]] not only serves the application on its development server but it also transpiles React components into JavaScript code that can run in the browser.
- [[Vite]] has [[Hot Module Replacement]] which automatically does any required transpilation and reloads the app in the browser in an efficient manner.

### Production Builds

- Production builds = [[Transpilation]] of React code to JavaScript code + Some other processes:
	- [[Minification]]: Remove all unnecessary characters from source code without impacting functionality e.g. whitespaces, comments, shortening variable names etc.
	- [[Module Bundlers|Bundling]]: Merging files so that code is downloaded and executed in a performant manner in production. The output file is often called a **bundle**.
		- Bundles are separated into smaller chunks to decrease the app's load times.
		- Bundlers also [[Tree Shaking|tree-shake]] redundant code out to keep the bundle size to a minimum.
- To create a production build: `npm run build` => creates a `dist` folder containing the `index.html`, production bundles and assets to be deployed.

## Structure of a React App

- The entry point of the React application is the `main.jsx`:

```jsx
createRoot(document.getElementById('root')).render(
	<StrictMode>
		<App />
	</StrictMode>
)
```

- `createRoot` creates a root in the `index.html` for the [[React Components]] where it takes in a [[Document Object Model (DOM)|DOM]] element for where to place these react components.
	- In this case, we're capturing the element with an `id` of `root` as the root element.
- `createRoot` returns an object containing a `render` function. The `render` function takes in the React component to display in the root DOM element. This displaying process is called rendering.
	- `App` is the top level component to be rendered which is inside of the `StrictMode` component.
	- `StrictMode` helps identify potential problems via additional checks and only runs in development mode.
- The syntax being used here is known as [[JSX|JavaScript XML (JSX)]].
- In React, components are arranged like a tree structure containing nested components.
- In case of React, any component starting with a capital letter is a custom React component whereas any component starting with a lowercase letter is an [[HTML]] element.
- A React component is a regular JavaScript function that returns JSX representing the dynamic UI.

### Props
