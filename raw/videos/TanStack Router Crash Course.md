---
id: TanStack Router Crash Course
aliases: []
tags:
  - video
creation date: 2026-06-13 01:08
modification date: Saturday 13th June 2026 01:08:22
source: https://www.youtube.com/watch?v=Ab01W6h4Giw
status:
  - completed
---

## Introduction

- Routing solution for [[React]]:
  - End to end type-safety through [[TypeScript]].
  - Nested routes and layout routes
  - Designed for client-side data caches ([[TanStack Query]], [[Stale-While-Revalidate (SWR)]], etc.)
  - Automatic route prefetching
  - File-based Route Generation
  - Path and Search Parameter Schema Validation
- You can check it's feature in the [official docs](https://tanstack.com/router/latest/docs/quick-start).

## Installation

- Quick start: `pnpx @tanstack/cli create --router-only`.
- Installs the following dependencies:
  - `@tanstack/react-devtools`
  - `@tanstack/react-router`
  - `@tanstack/react-router-devtools`
  - `@tanstack/router-plugin`

- Entry point of the application `main.tsx` to render the root element and attach the router as a children to the root.

```tsx
// src/main.tsx
import ReactDOM from "react-dom/client";
import { RouterProvider, createRouter } from "@tanstack/react-router";
import { routeTree } from "./routeTree.gen";

// 👇 Creates a router
const router = createRouter({
  routeTree,
  defaultPreload: "intent",
  scrollRestoration: true,
});

// 👇 this enables end-to-end type-safety
declare module "@tanstack/react-router" {
  interface Register {
    router: typeof router;
  }
}

const rootElement = document.getElementById("app")!;

if (!rootElement.innerHTML) {
  // 👈 Only runs when the root element is empty to prevent double RouterProvider invocation
  const root = ReactDOM.createRoot(rootElement);
  root.render(<RouterProvider router={router} />); // 👈 Provides the router to the application
}
```

- Creates a `routes` folder and a `routeTree.gen.`

## File Based Routing

- TanStack Router provides file based routing out of the box.
- [[Single Page Applications (SPA)|SPAs]] display a component based on the URL route and that's usually handled by a router. There are two types of routers:
  - Code Based: We specify in code which component to display based on a path.
  - File Based: The file and folder structure depicts the path and which component to display.
- In TanStack Router we can do both but the File Based router has some advantages.
  - We can easily locate the component to be rendered by following the file tree based on the path that we have.
  - The LSP and [[TypeScript]] does the same providing us intellisense and type-safety.
- All routes are inside the `routes` folder.

### Root Route

- TanStack creates the `routeTree.gen.ts` which is automatically generated based on the file path which provides information to the library about the routes available.

> [!IMPORTANT]
> Don't try to modify the `routeTree.gen.ts` by yourself. It's always automatically generated.

- TanStack Router creates a route tree-like structure where every node is a route except the root node.

![[Pasted image 20260613015500.png]]

- The `__root.tsx` is the root node with some special properties:
  - It is not associated with a route
  - Whatever markup / components we have here will always get rendered regardless of the route.

```tsx
// src/routes/__root.tsx
import { Outlet, createRootRoute } from "@tanstack/react-router";
import { TanStackRouterDevtoolsPanel } from "@tanstack/react-router-devtools";
import { TanStackDevtools } from "@tanstack/react-devtools";

import "../styles.css";

export const Route = createRootRoute({
  component: RootComponent,
});

function RootComponent() {
  return (
    <>
      {/* 👇 contains the component to be rendered based on the route */}
      <Outlet />
      <TanStackDevtools
        config={{
          position: "bottom-right",
        }}
        plugins={[
          {
            name: "TanStack Router",
            render: <TanStackRouterDevtoolsPanel />,
          },
        ]}
      />
    </>
  );
}
```

## Basic Routes

- If we want to have a route `/home`, we will create `home.tsx` inside the routes folder. It will automatically get populated with some boilerplate code and the `routeTree.gen.ts` automatically gets updated with this information.

```tsx
import { createFileRoute } from "@tanstack/react-router";

// 👇 registers this route for the router
export const Route = createFileRoute("/home")({
  component: RouteComponent, // 👈 the component to be rendered for this route
});

function RouteComponent() {
  return <div>Hello "/home"!</div>;
}
```

## Navigating to Routes

```tsx
// src/routes/home.tsx
import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";

export const Route = createFileRoute("/home")({
  component: RouteComponent,
});

function RouteComponent() {
  const navigate = useNavigate();

  const handleClick = () => {
    /* 👇 navigate to about page */
    navigate({
      to: "/about",
    });
  };

  return (
    <div className="flex justify-between items-center w-100 h-screen">
      {/* 👇 button to navigate to about page */}
      <button
        onClick={handleClick}
        className="bg-blue-500 rounded-lg p-4 cursor-pointer"
      >
        About
      </button>
      {/* 👇 link to contact page */}
      <Link to="/contact" className="bg-blue-500 rounded-lg p-4 cursor-pointer">
        Contact
      </Link>
      {/* 👇 link to more page */}
      <Link to="/more" className="bg-blue-500 rounded-lg p-4 cursor-pointer">
        More
      </Link>
    </div>
  );
}
```

- If you want to know where you came from, you can use `Route.useNavigate()` instead of `useNavigate()`.

## Nested Routes

- If you want to create a nested route e.g. `/youtube/profile/shivayan`, you would create the file structure as: `youtube/ => profile/ => shivayan.tsx`
- However, with this, we can't access the routes `/youtube/profile/` or `/youtube/`. The way we can do that is by creating an **index route** inside the folder i.e. an `index.tsx` file.

## Layout Routes

- These are necessary when you want to render some content which might be common to `/youtube/profile/shivayan` and `/youtube/profile/debanjali` but not `/youtube`
- You can create a `route.tsx` inside a nested route.
- If you have both `index.tsx` and `route.tsx` inside a nested route, the components of `route.tsx` will render first and below that the `index.tsx`

```tsx
// src/youtube/profile/route.tsx
import { createFileRoute, Outlet } from "@tanstack/react-router";

export const Route = createFileRoute("/youtube/profile")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div>
      {/* 👇 The children will be rendered here */}
      <Outlet />
    </div>
  );
}
```

## Dynamic Routes

- Imagine you have posts with a unique `postId` and based on that we want to go to that specific post i.e. `/posts/$postId` where `$postId` can be a number like `1`, `10`, `100` etc.
- To do this, we would create a folder `/posts` and create the file `$postId` inside the folder.
- To go to this particular link dynamically, we can have the following markup:

```tsx
<Link to={`/posts/postId`} params={{ postId: String(id) }}>
  ...
</Link>
```

- To capture the path params:

```tsx
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/posts/$postId")({
  component: RouteComponent,
});

function RouteComponent() {
  // 👇 capture the path parameter
  const { postId } = Route.useParams();

  return <div>Hello {`/posts/${postId}`}!</div>;
}
```

### Querying Data using Data Loaders

- One unique feature TanStack Router provides is the ability to query for data in the route itself instead of waiting for the component to mount itself.
  - Basically we start fetching data even before the component mounts at all i.e. we don't allow navigation until the data is actually loaded.
- To do this, we use the `loader` function which takes precedence even before the component mounts.
- Till the `loader` function gets resolved, the navigation will wait after which it will render the component.

```tsx
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/slowPosts")({
  // 👇 will take precedence before rendering the component
  loader: () => fetchSlowPosts(),
  component: RouteComponent,
});

function RouteComponent() {
  // 👇 will capture the data from the `loader` function
  const data = Route.useLoaderData();

  return <div>{JSON.stringify(data)}</div>;
}

const fetchSlowPosts = async () => {
  return new Promise((resolve) => {
    setTimeout(async () => {
      const res = await fetch("https://jsonplaceholder.typicode.com/posts");
      const data = await res.json();
      resolve(data);
    }, 2000);
  });
};
```

- You can even capture path params as follows:

```tsx
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/posts/$postId")({
  component: RouteComponent,
  loader: ({ params }) => fetchPosts(params.pathId),
});

function RouteComponent() {
  const data = Route.useLoaderData();

  return <div>{JSON.stringify(data)}</div>;
}

const fetchPosts = async (postId) => {
  const res = await fetch(
    `https://jsonplaceholder.typicode.com/posts/${postId}`,
  );
  const data = await res.json();
  return data;
};
```

## Search Parameters or Query Parameters

- You can validate your search parameters or query parameters via the `validateSearch` parameter in your `createFileRoute()` function as shown below.

```tsx
const productSearchSchema = z.object({
  category: z.enum(["all", "running", "casual"]).default("all"),
  brand: z
    .enum(["all", "Nike", "Adidas", "Converse", "Reebok", "Vans"])
    .default("all"),
  sortBy: z.enum(["name", "price-asc", "price-desc"]).default("name"),
  page: z.number().int().positive().default(1),
});

export const Route = createFileRoute("/shop")({
  component: RouteComponent,
  validateSearch: productSearchSchema, // 👈 zod schema
});
```

- You can then capture them using the `Route.useSearch()` hook.
- To set the search parameter in the URL, use the `Route.useNavigate()` hook:

```tsx
const navigate = useNavigate();

navigate({ search: (prev) => ({ ...prev, page: newPage }) });
```
