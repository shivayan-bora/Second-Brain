---
id: tanstack-query basic project
aliases: []
tags:
  - project
creation date: 2026-05-19 18:55
modification date: Tuesday 19th May 2026 18:55:22
repository:
status:
  - in-progress
---

## References

- [Vite Getting Started](https://vite.dev/guide/)
- [ESLint Getting Started](https://eslint.org/docs/latest/user-guide/getting-started)
- [Prettier](https://prettier.io/docs/install)
- [eslint-config-prettier](https://github.com/prettier/eslint-config-prettier#installation)
- Tanstack Query:
  - [Installation](https://tanstack.com/query/latest/docs/framework/react/installation)

## Step by Step Implementation

### Step 0: Scaffold the project

#### Create a React and TypeScript application with Vite

- Create a new [[React]] (without [[React Compiler]]) and [[TypeScript]] application using [[Vite]] with [[pnpm]]:

```bash
pnpm create vite
```

- Install dependencies with `pnpm install` and start the dev server with `pnpm run dev` to verify if your project is running.

#### Setup Linting

- Install and configure [[ESLint]] using the command: `pnpm create @eslint/config@latest`.

> [!NOTE]
> While configuration, remember that you're creating a frontend project with:
>
> - React
> - TypeScript

- The above configuration automatically creates two files:
  - `eslint.config.ts`: Developer-facing, typed version of eslint config.
  - `eslint.config.js`: Engine-facing, executable version that ESLint actually uses.
- Modern `flat config` in eslint is the new way of writing configuration introduced in eslint v9, where you define **all your configs in a single array of plain [[JavaScript]] objects**, instead of scattering rules across multiple `.eslintrc._`-style files and `extends` fields.
  - In the old way, eslint walks your directory tree, merges `.eslintrc.js`, `.eslintrc.json`, or `package.json` files, and figures out which rule to apply based on folder hierarchy and `extends`.
  - In the new way, we export a single array of config objects from `eslint.config.js` (or `.mjs`/`.cjs`), and it filters and merges them based on the `files` and `ignores` fields in each object.

#### Setup Formatting

- Install [[Prettier]] for formatting: `pnpm add --save-dev --save-exact prettier`.
- Create a file `.prettierrc` which contains configuration for your prettier.
- The below is the most common configuration for prettier.

```json
{
  "$schema": "https://json.schemastore.org/prettierrc",
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "jsxSingleQuote": false,
  "quoteProps": "as-needed",
  "trailingComma": "all",
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "always",
  "endOfLine": "lf",
  "embeddedLanguageFormatting": "auto",
  "htmlWhitespaceSensitivity": "css",
  "proseWrap": "preserve",
  "singleAttributePerLine": false
}
```

- Now there are some rules in both prettier and eslint which clash against each other. In order to make sure eslint only performs linting and prettier takes care of the formatting, install `eslint-config-prettier`: `pnpm add -D eslint-config-prettier`.
- Add the config at the last of the configuration array in both eslint `.ts` and `.js` configuration file.

```js
import someConfig from "some-other-config-you-use";
// Note the `/flat` suffix here, the difference from default entry is that
// `/flat` added `name` property to the exported object to improve
// [config-inspector](https://eslint.org/blog/2024/04/eslint-config-inspector/) experience.
import eslintConfigPrettier from "eslint-config-prettier/flat";

export default [someConfig, eslintConfigPrettier];
```

- To confirm none of the styles conflict with each other: `npx eslint-config-prettier ./src/main.tsx`.

#### Install axios and tanstack-query

- Install [[axios]] and [[Tanstack Query]]: `pnpm install @tanstack/react-query` and `pnpm install axios`

#### Install Tailwind CSS

- Install [[Tailwind CSS]] and the Tailwind CSS Vite plugin: `pnpm install tailwindcss @tailwindcss/vite`.
- Add the Tailwind Vite plugin to your Vite config:

```ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
});
```

- Add an `@import` to your global [[CSS]] to import Tailwind CSS styles:

```css
@import "tailwindcss";
```

### Step 1: Add QueryClient to the root

- Create a `QueryClient` and add it to the `root` of the application using `QueryClientProvider`.
  - `QueryClient`: Holds the cache and scheduling logic
  - `QueryClientProvider`: Provides the `queryClient` to the `root` of the application.
    - This provides us the `useQuery` hook.
    - Allows us to use the cache for the server state.

```tsx
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.tsx";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

// Create a client
const queryClient = new QueryClient();

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  </StrictMode>,
);
```

### Step 2: Fetch Products Query

- The below code is used to fetch a paginated list of products.

```ts
import axios from "axios";

const API_BASE_URL = "https://dummyjson.com";

export interface Product {
  id: number;
  title: string;
  price: number;
  description: string;
  category: string;
  thumbnail: string;
}

export interface ProductsResponse {
  products: Product[];
  total: number;
  skip: number;
  limit: number;
}

export async function fetchProducts(): Promise<ProductsResponse> {
  const response = await axios.get<ProductsResponse>(
    `${API_BASE_URL}/products`,
  );
  return response.data;
}
```

### Step 3: useQuery to fetch the paginated list of products

- Create the `ProductsList` component as follows.
  - `useQuery` is a hook that allows up to hook into the server state cache.
    - `queryKey`: Unique identifier of the state we're trying to fetch.
    - `queryFn`: Function to fetch the products.
  - `useQuery` returns:
    - `data`: The data from the API
    - `isLoading`: If the [[JavaScript Promise|promise]] is pending.
    - `isError`: If the API call fails.
    - `error`: The error message.

```tsx
import { useQuery } from "@tanstack/react-query";
import { fetchProducts } from "../../api/products";

export function ProductsList() {
  const { data, isLoading, isError, error } = useQuery({
    queryKey: ["products"],
    queryFn: fetchProducts,
  });

  if (isLoading) return <p>Loading Products...</p>;

  if (isError) return <p>Error: {(error as Error).message}</p>;

  return (
    <div>
      <h1 className="text-xl font-semibold mb-4">Products</h1>
      <ul className="space-y-2">
        {data?.products.map((product) => (
          <li key={product.id} className="border rounded p-2">
            <div className="font-medium">{product.title}</div>
            <img src={product.thumbnail} alt={`Image of ${product.title}`} />
            <div className="text-sm text-gray-600">
              {product.category} - {product.price}
            </div>
            <div className="text-sm">{product.description}</div>
          </li>
        ))}
      </ul>
    </div>
  );
}
```
