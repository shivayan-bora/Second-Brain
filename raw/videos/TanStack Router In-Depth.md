---
id: TanStack Router In-Depth
aliases: []
tags:
  - video
creation date: 2026-06-13 12:51
modification date: Saturday 13th June 2026 12:51:18
source: https://www.youtube.com/watch?v=WyqxZniJk5w
status:
  - in-progress
---

## Links

- [Course Repository](http://github.com/codegenixdev/tanstack-router-tutorial)

## Workspace Setup

- Create a [[React]] application with [[Vite]], [[pnpm]] and [[TypeScript]]: `pnpm create vite@latest`
- Install [[Tailwind CSS]] styling libraries: `pnpm install tailwindcss @tailwindcss/vite tailwind-merge clsx`
- Add the Tailwind plugin to Vite as follows:

```ts
// vite.config.ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import path from "path";

// https://vite.dev/config/
export default defineConfig({
  resolve: {
    alias: {
      "@": path.resolve("./src"), // 👈 if you want absolute paths instead of relative in imports
    },
  },
  plugins: [
    // 👇 needed for tailwindcss to work it's magic and inject appropriate styles based on the utility classes used as well as tree-shaking unused classes
    tailwindcss(),
    react(),
  ],
});
```

- Add the tailwind styles to your `index.css`:

```css
/* src/index.css */
@import "tailwindcss";
```

- Create a utility class for `twMerge` and adding a delay to mimic an actual server while sending a response

```ts
// /src/lib/utils.ts
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

// 👇 for merging tailwind classes
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// 👇 to mimic an actual server to delay the response
export function wait() {
  const delay = 1000;
  return new Promise((resolve) => setTimeout(resolve, delay));
}
```

- To change the import path alias from relative to absolute, we need to do a similar configuration for [[TypeScript]].

```json
/* tsconfig.app.json */
{
  "compilerOptions": {
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.app.tsbuildinfo",
    "target": "es2023",
    "lib": ["ES2023", "DOM"],
    "module": "esnext",
    "types": ["vite/client"],
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    /* 👇 using absolute paths for import alias instead of relative paths */
    "paths": {
      "@/*": ["./src/*"]
    },

    /* Linting */
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "erasableSyntaxOnly": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"]
}
```

- Initialize [[ESLint]] configuration in your project: `pnpm create @eslint/config@latest`
- Install [[Prettier]] and the EsLint plugin for prettier to make sure they play nicely with each other:
  - `pnpm add --save-dev --save-exact prettier`
  - `pnpm add -D eslint-config-prettier`
- [Configure](https://github.com/prettier/eslint-config-prettier#installation) ESLint with the prettier plugin.
- Install Tailwind plugin for prettier: `pnpm install -D prettier-plugin-tailwindcss`
- Configure `.prettierrc` as follows:

```json
{
  "arrowParens": "always",
  "bracketSameLine": false,
  "bracketSpacing": true,
  "jsxSingleQuote": true,
  "printWidth": 120,
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "useTabs": false,
  "plugins": ["prettier-plugin-tailwindcss"]
}
```

- Configure `.prettierignore`:

```text
.gitignore
.npmrc
/coverage
/dist
tsconfig*.json
node_modules
```

## TanStack Router Setup

- Install [[TanStack Router]] dependencies: `pnpm install @tanstack/react-router @tanstack/react-router-devtools`
- Install the TanStack Router [[Vite]] plugin as a `devDependency`: `pnpm install -D @tanstack/router-plugin`
- Add the TanStack Router plugin to the Vite configuration:

```ts
// vite.config.ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import { tanstackRouter } from "@tanstack/router-plugin/vite";
import path from "path";

// https://vite.dev/config/
export default defineConfig({
  resolve: {
    alias: {
      "@": path.resolve("./src"), // 👈 if you want absolute paths instead of relative in imports
    },
  },
  plugins: [
    // 👇 needed for tailwindcss to work it's magic and inject appropriate styles based on the utility classes used as well as tree-shaking unused classes
    tailwindcss(),
    // 👇 needed because tanstack router does automatic file and code generation for managing routes
    tanstackRouter({
      target: "react",
      autoCodeSplitting: true,
    }),
    react(),
  ],
});
```

- Install [[Zod]] for runtime type checking: `pnpm install zod`
- Cleanup all existing files and code you don't need.
- Create a folder `routes` and create a file inside it, `__root.tsx`.
- Run the dev server: `pnpm run dev`
- You will see `__root.tsx` gets filled with some boilerplate code and a file gets generated `routeTree.gen.ts`.
  - This file is maintained by the TanStack Router to keep a track of your routes and provide type-safety.

> [!WARNING]
> You absolutely shouldn't touch `routeTree.gen.ts` yourself and let TanStack router manage it automatically.

```tsx
// src/routes/__root.tsx
import * as React from "react";
import { Outlet, createRootRoute } from "@tanstack/react-router";

export const Route = createRootRoute({
  component: RootComponent,
});

function RootComponent() {
  return (
    <React.Fragment>
      <div>Hello "__root"!</div>
      {/* 👇 the route contents based on the URL route gets rendered here */}
      <Outlet />
    </React.Fragment>
  );
}
```

- Create an `index.ts` for the base route `/`.

```tsx
import { createFileRoute } from "@tanstack/react-router";

// 👇 Defines the `/` route
export const Route = createFileRoute("/")({
  component: RouteComponent, // 👈 component to render on `/` route
});

function RouteComponent() {
  return <div>Hello "/"!</div>;
}
```

- We need to provide the router to our application as follows:

```tsx
import { createRouter, RouterProvider } from "@tanstack/react-router";
import { routeTree } from "./routeTree.gen";

// 👇 Creates the router from the generated route tree
const router = createRouter({
  routeTree: routeTree,
});

// 👇 We're enhancing the installed tanstack router library by replacing the router type with our router containing the routes from routeTree.gen.ts
declare module "@tanstack/react-router" {
  interface Register {
    router: typeof router;
  }
}

function App() {
  // 👇 Provide the router to the application
  return <RouterProvider router={router} />;
}

export default App;
```

## Adding some basic routes and changing the styles of the active route

- Create an `about.tsx` file.

```tsx
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/about")({
  component: RouteComponent,
});

function RouteComponent() {
  return <div>Hello "/about"!</div>;
}
```

- Modify the `__root.tsx` as follows:

```tsx
import * as React from "react";
import { Link, Outlet, createRootRoute } from "@tanstack/react-router";

export const Route = createRootRoute({
  component: RootComponent,
});

function RootComponent() {
  return (
    <React.Fragment>
      {/* 👇 whenever the current route is active, modify the class of the link with this */}
      <Link to="/" activeProps={{ className: "text-blue-500 font-bold" }}>
        Home
      </Link>
      <Link to="/about" activeProps={{ className: "text-blue-500 font-bold" }}>
        About Us
      </Link>
      <Outlet />
    </React.Fragment>
  );
}
```

## Creating a custom nav-link

- Create a folder `-components` and create a file `nav-link.tsx`.
  - `-` in the folder name tells the TanStack Router to ignore this folder from the File Route structure.

```tsx
// src/routes/-component/nav-link.tsx
import { cn } from "@/lib/utils";
import { createLink, type LinkComponent } from "@tanstack/react-router";

type BasicLinkProps = React.AnchorHTMLAttributes<HTMLAnchorElement> & {
  // other props
  ref: React.Ref<HTMLAnchorElement>; // 👈 needed by the link component
};

// 👇 enhancing the basic anchor tag from HTML
const BasicLinkComponent = ({ className, ref, ...props }: BasicLinkProps) => {
  return <a ref={ref} {...props} className={cn("nav-link", className)} />;
};

// 👇 creates a TanStack Router LinkComponent by taking the BasicLinkComponent as a base
const CreatedLinkComponent = createLink(BasicLinkComponent);

export const NavLink: LinkComponent<typeof BasicLinkComponent> = (props) => {
  return (
    <CreatedLinkComponent
      activeProps={{ className: "active-nav-link" }} {/* 👈 apply the styles if the current active route is this */}
      {...props}
    />
  );
};
```

```tsx
// src/routes/__root.tsx
import { Outlet, createRootRoute } from "@tanstack/react-router";
import { NavLink } from "./-components/nav-link";

export const Route = createRootRoute({
  component: RootComponent,
});

function RootComponent() {
  return (
    <div className="container mx-auto max-w-xl">
      <div className="space-x-2">
        <NavLink to="/">Home</NavLink> {/* 👈 our custom nav link */}
        <NavLink to="/about">About Us</NavLink>
      </div>
      <Outlet />
    </div>
  );
}
```

## Flat Nested Routes

- If we want to have a route in the format `/contact-us/$country/$city` where `$country` and `$city` are path parameters, we can create them in two ways:
  - Create nested folders `contact-us/` => `$country/` => `$city/` and create a `route.tsx` file to handle the path parameters.
  - Create flat nested routes using three files: `contact-us.tsx`, `contact-us.$country.tsx` and `contact-us.$country.$city.tsx`.

- The parent route: `/contact-us`

```tsx
// src/contact-us.tsx
import { getCountries } from "@/lib/mock";
import { createFileRoute, Link } from "@tanstack/react-router";

export const Route = createFileRoute("/contact-us")({
  component: RouteComponent,
  // 👇 before even the component is rendered, fetch the data
  loader: async () => {
    const countries = await getCountries();
    return { countries };
  },
  // 👇 show loading state till the promise resolves in `loader` function
  pendingComponent: () => <div>Countries are loading...</div>,
});

function RouteComponent() {
  const { countries } = Route.useLoaderData(); // 👈 capture the data from the `loader` function
  return (
    <div className="space-y-3">
      <h2 className="heading">What country you're at?</h2>
      <div className="list">
        {countries.map((country) => (
          <Link
            className="card"
            activeProps={{ className: "active-card" }}
            key={country.name}
            {/* 👇 path to which we want to route to */}
            to="/contact-us/$country"
            {/* 👇 path params to be passed to the route */}
            params={{
              country: country.name,
            }}
          >
            <span className="title">{country.name}</span>
          </Link>
        ))}
      </div>
      <Outlet /> {/* 👈 Where the nested route component renders */}
    </div>
  );
}
```

- The nested child `/contact-us/$country`

```tsx
import { getCities } from '@/lib/mock';
import { createFileRoute, Link, notFound } from '@tanstack/react-router';

export const Route = createFileRoute('/contact-us/$country')({
  component: RouteComponent,
  loader: async ({ params: { country } }) => {
    const cities = await getCities(country);

    if (cities.length === 0) {
      throw notFound();
    }

    return { cities };
  },
  pendingComponent: () => <div>Cities are loading...</div>,
});

function RouteComponent() {
  const { cities } = Route.useLoaderData();
  return (
    <div className='space-y-3'>
      <h2 className='heading'>Cities: </h2>
      <div className='list'>
        {cities.map((city) => (
          <Link
            className='card'
            activeProps={{ className: 'active-card' }}
            {/* 👇 TanStack Router keeps a track of where we came from so the $country parameter doesn't need to be passed again */}
            from='/contact-us/$country'
            to='/contact-us/$country/$city'
            key={city}
            params={{
              city,
            }}
          >
            <span className='title'>{city}</span>
          </Link>
        ))}
      </div>
    </div>
  );
}
```
