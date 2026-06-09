---
id: TanStack Query Crash Course
aliases: []
tags:
  - video
creation date: 2026-05-25 19:01
modification date: Monday 25th May 2026 19:01:20
status:
  - in-progress
---

## Sources

- [TanStack Query Part 1: How to become a React Query God](https://www.youtube.com/watch?v=mPaCnwpFvZY)
- [TanStack Query Part 2: How to Master God-Tier React Query](https://www.youtube.com/watch?v=KkxPtimqaew)
- [Advanced React Query Patterns for Modern Applications](https://www.youtube.com/watch?v=9Vuz4BbPkXc)

## What is TanStack Query?

- [[TanStack Query]] is a querying and server state management library that makes querying super easy and efficient.
- It provides [[React Hooks|hooks]] that have reactive state, loading state, error state, refetching capabilities all built into one hook.
  - Under the hood it uses a query client that keeps track of all the queries in your application and it will automatically cache queries and use that cache to make queries as fast and efficient as possible.
- Includes:
  - caching queries
  - handling stale data
  - performance optimizations
  - page focus refetching
  - and a lot more...
- Also known as the missing data-fetching library for web applications.
  - It makes fetching, caching, synchronizing and updating server state in your applications a breeze.

### Properties of Server State

- For starters, server state:
  - Is persisted remotely in a location you may not control or own
  - Requires asynchronous APIs for fetching and updating
  - Implies shared ownership and can be changed by other people without your knowledge
  - Can potentially become "out of date" in your applications if you're not careful
- Once you grasp the nature of server state in your application, **even more challenges will arise** as you go, e.g.:
  - Caching... (possibly the hardest thing to do in programming)
  - Deduping multiple requests for the same data into a single request
  - Updating "out of date" data in the background
  - Knowing when data is "out of date"
  - Reflecting updates to data as quickly as possible
  - Performance optimizations like pagination and lazy loading data
  - Managing memory and garbage collection of server state
  - Memoizing query results with structural sharing

## Installation and Setup

- Install the TanStack Query library in your project for [[React]]: `pnpm add @tanstack/react-query`
- Instantiate the `QueryClient` at the entry point of your application and make sure it's outside of any [[React Components|React Component]].
  - This is the backbone of the TanStack Query library.
  - Without this, the hooks won't know how to query the data.
  - Think of it as the Object Store which stores all the query data with a query key and has the responsibility to cache, invalidate, refetch etc.
- You need to provide this `QueryClient` to the `root` component using `QueryClientProvider` so that any TanStack functions invoked in any child component knows which `QueryClient` to refer to.

```tsx
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.tsx";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

// Backbone of your TanStack Query
// Without this, the hooks won't know how to query the data
// Should exist outside of a React Component
const queryClient = new QueryClient();

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    {/* Provides the Query Client to all the components under the root component so that any TanStack functions invoked knows which query client to refer to */}
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  </StrictMode>,
);
```

## useQuery Hook

- At the heart of TanStack Query, we have the `useQuery` hook which allows us to query data from the server. We can use it as follows:

```tsx
import { useQuery } from "@tanstack/react-query";

function App() {
  const { data, isPending, refetch, error } = useQuery({
    queryKey: ["todos"],
    queryFn: getTodos,
  });

  if (error) {
    alert("Something went wrong!");
  }

  return (
    <>
      <div>
        {isPending ? <div>Loading...</div> : JSON.stringify(data.slice(0, 10))}
      </div>
      <button onClick={() => refetch()}>Refetch</button>
    </>
  );
}

const getTodos = async () => {
  await new Promise((resolve) => setTimeout(resolve, 1000));
  const response = await fetch("https://jsonplaceholder.typicode.com/todos");
  return await response.json();
};

export default App;
```

- The `useQuery` hook takes in an object with two mandatory parameters:
  - `queryKey`: unique identifier of the query and also used to cache the query result which can later be fetched from a component and hence improves the performance.
  - `queryFunction`: function used to query the data and usually this is the function which calls the API endpoint to fetch the data.
    - This needs a function reference and it handles the execution and [[JavaScript Promise|promise]] resolution by itself. Don't pass `getTodos()` here as we're effectively executing the function and passing it's result to `queryFn` which isn't correct.
- The biggest advantage of [`useQuery`](https://tanstack.com/query/latest/docs/framework/react/reference/useQuery) is that it provides you with various states like loading, error etc. but also provides you with a way to refetch the data as well.

> [!NOTE]
> Also read the [differences between isFetching, isPending and isLoading](https://www.perplexity.ai/search/7d16ca68-be62-4723-8e62-dec62af67868).

### Passing Query Parameters

```tsx
import { useQuery } from "@tanstack/react-query";
import { useState } from "react";

function App() {
  const [id, setId] = useState(1);

  const { data, isPending, refetch, error } = useQuery({
    queryKey: ["comments", id],
    queryFn: () => getComments(id),
  });

  if (error) {
    alert("Something went wrong!");
  }

  return (
    <>
      <div>
        {isPending ? <div>Loading...</div> : JSON.stringify(data.slice(0, 10))}
      </div>
      <br />
      <button onClick={() => refetch()}>Refetch</button>
      <br />
      <button onClick={() => setId((prev) => prev + 1)}>Increment</button>
    </>
  );
}

const getComments = async (id: number) => {
  await new Promise((resolve) => setTimeout(resolve, 1000));
  const response = await fetch(
    `https://jsonplaceholder.typicode.com/comments?postId=${id}`,
  );
  return await response.json();
};

export default App;
```

- Some key things to note here:
  - `queryKey: ["comments", id]`: We need to pass the ID as well since this will be used to uniquely identify the piece of data returned by this query. e.g. if we're fetching an employee, we should be able to differentiate between employee A and employee B.
  - `queryFn: () => getComments(id)`: Since we can't directly call the function, we can pass it an arrow function. This should be self explanatory as we use the same thing in `onClick` event handlers.

### Conditionally call Queries

```tsx
import { useQuery } from "@tanstack/react-query";
import { useState } from "react";

function App() {
  const [id, setId] = useState(1);
  const [on, setOn] = useState(false);

  const { data, isPending, refetch, error } = useQuery({
    queryKey: ["todos", id],
    queryFn: () => getTodos(id),
    enabled: on,
  });

  if (error) {
    alert("Something went wrong!");
  }

  return (
    <>
      <div>
        {isPending ? <div>Loading...</div> : JSON.stringify(data.slice(0, 10))}
      </div>
      <br />
      <button onClick={() => refetch()}>Refetch</button>
      <br />
      <button onClick={() => setId((prev) => prev + 1)}>Increment</button>
      <br />
      <button onClick={() => setOn((prev) => !prev)}>
        Turn {on ? "off" : "on"}
      </button>
    </>
  );
}

const getTodos = async (id: number) => {
  await new Promise((resolve) => setTimeout(resolve, 1000));
  const response = await fetch(
    `https://jsonplaceholder.typicode.com/comments?postId=${id}`,
  );
  return await response.json();
};

export default App;
```

- You can pass the `enabled` flag to make the query not run on every component re-render.
- We can still run the query using the `refetch` function.

### Reusable Queries

```ts
import { queryOptions } from "@tanstack/react-query";

export function fetchCommentsQueryOptions(id: number) {
  return queryOptions({
    queryKey: ["comments", id],
    queryFn: () => getComments(id),
  });
}

const getComments = async (id: number) => {
  await new Promise((resolve) => setTimeout(resolve, 1000));
  const response = await fetch(
    `https://jsonplaceholder.typicode.com/comments?postId=${id}`,
  );
  return await response.json();
};
```

- TanStack provides you with the `queryOptions` object which is the same as the object we pass to `useQuery`. This allows us to seggregate the query implementations from the main component and the same query can be used in different components.
- This can now be used as follows:

```tsx
import { useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { fetchCommentsQueryOptions } from "./queryOptions/fetchCommentsQueryOptions";

function App() {
  const [id, setId] = useState(1);
  const [on, setOn] = useState(false);
  const queryOptions = fetchCommentsQueryOptions(id);

  const { data, isPending, refetch, error } = useQuery({
    ...queryOptions,
    enabled: on,
  });

  if (error) {
    alert("Something went wrong!");
  }

  return (
    <>
      <div>
        {isPending ? <div>Loading...</div> : JSON.stringify(data.slice(0, 10))}
      </div>
      <br />
      <button onClick={() => refetch()}>Refetch</button>
      <br />
      <button onClick={() => setId((prev) => prev + 1)}>Increment</button>
      <br />
      <button onClick={() => setOn((prev) => !prev)}>
        Turn {on ? "off" : "on"}
      </button>
    </>
  );
}

export default App;
```

### Type Safety

```ts
import { queryOptions } from "@tanstack/react-query";

type Comments = {
  postId: number;
  id: number;
  name: string;
  email: string;
  body: string;
};

const getComments = async (id: number): Promise<Comments[]> => {
  await new Promise((resolve) => setTimeout(resolve, 1000));
  const response = await fetch(
    `https://jsonplaceholder.typicode.com/comments?postId=${id}`,
  );
  return await response.json();
};

export function fetchCommentsQueryOptions(id: number) {
  return queryOptions({
    queryKey: ["comments", id],
    queryFn: () => getComments(id),
  });
}
```

```tsx
import { useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { fetchCommentsQueryOptions } from "./queryOptions/fetchCommentsQueryOptions";

function App() {
  const [id, setId] = useState(1);
  const [on, setOn] = useState(false);
  const queryOptions = fetchCommentsQueryOptions(id);

  const { data, isPending, refetch, error } = useQuery({
    ...queryOptions,
    enabled: on,
  });

  if (error) {
    alert("Something went wrong!");
  }

  return (
    <>
      <div>
        {isPending ? <div>Loading...</div> : JSON.stringify(data.slice(0, 10))}
      </div>
      <br />
      <button onClick={() => refetch()}>Refetch</button>
      <br />
      <button onClick={() => setId((prev) => prev + 1)}>Increment</button>
      <br />
      <button onClick={() => setOn((prev) => !prev)}>
        Turn {on ? "off" : "on"}
      </button>
    </>
  );
}

export default App;
```

- Now you might be seeing an issue like this: `'data' is possibly 'undefined'`
- This is the default behaviour of the `useQuery` hook with [[TypeScript]] and while this can be annoying to deal with but it's perfectly valid since `data` can be `undefined`.
- If you want to use a query where the data is guaranteed to resolve before it's return to you and it can't be `undefined`, there's another hook that you can use called `useSuspenseQuery`.

## useSuspenseQuery Hook

- This behaves similar to `useQuery` but guarantees that the `data` will never be `undefined`.

```tsx
import { useSuspenseQuery } from "@tanstack/react-query";
import { Suspense, useState } from "react";
import { fetchCommentsQueryOptions } from "./queryOptions/fetchCommentsQueryOptions";

function App() {
  return (
    <>
      <Suspense fallback={<div>Loading...</div>}>
        <Card />
      </Suspense>
    </>
  );
}

const Card = () => {
  const [id, setId] = useState(1);
  const queryOptions = fetchCommentsQueryOptions(id);
  const { data, refetch, error } = useSuspenseQuery({
    ...queryOptions,
  });

  if (error) {
    alert("Something went wrong!");
  }

  return (
    <div className="flex flex-col justify-center items-center p-4 border-blue-500 border-2">
      <h1 className="text-blue-500 text-5xl mb-2">CARD</h1>
      <div>{JSON.stringify(data.slice(0, 10))}</div>
      <br />
      <button className="border border-gray-600 p-2" onClick={() => refetch()}>
        Refetch
      </button>
      <br />
      <button
        className="border border-gray-600 p-2"
        onClick={() => setId((prev) => prev + 1)}
      >
        Increment
      </button>
    </div>
  );
};

export default App;
```

- The great part about `useSuspenseQuery` hook is that you don't need to define the loading state. You can just wrap your component in a [[React Suspense|suspense]] and till the data is loaded, it will automatically call your fallback component.
- The downside of `useSuspenseQuery` is that you can't use conditional querying using the `enabled` flag. Since `useSuspenseQuery` guarantees the data will be resolved, calling it conditionally kind of defeats the purpose and you're better off using the `useQuery` hook.\

## Multiple Queries

### Multiple Queries that are exclusive to each other

- You can use the `useQueries` or `useSuspenseQueries` hook and pass it multiple `queryOption` in an array as shown below.
  - It accepts an object as an input

```tsx
const [todos, posts] = useQueries({
  queries: [fetchTodosQueryOptions(), fetchPostsQueryOptions()],
});
```

- Complete code example:

```tsx
import { useQueries } from "@tanstack/react-query";
import { fetchTodosQueryOptions } from "./queryOptions/fetchTodosQueryOptions";
import { fetchPostsQueryOptions } from "./queryOptions/fetchPostQueryOptions";

function App() {
  return (
    <>
      <MultipleQueriesComponent />
    </>
  );
}

const MultipleQueriesComponent = () => {
  const [todos, posts] = useQueries({
    queries: [fetchTodosQueryOptions(), fetchPostsQueryOptions()],
  });

  if (todos.error || posts.error) {
    alert("Something went wrong");
  }

  return (
    <>
      <h2>Todos</h2>
      <ul>
        {todos.isPending ? (
          <div>Loading...</div>
        ) : (
          todos?.data?.map((todo) => (
            <li key={todo.id}>
              {`${todo.title} : ${todo.completed ? "✅" : "❌"}`}
            </li>
          ))
        )}
      </ul>
      <h2>Posts</h2>
      <ul>
        {posts.isPending ? (
          <div>Loading...</div>
        ) : (
          posts?.data?.map((post) => (
            <li key={post.id}>
              <h3>{post.title}</h3>
              <p>{post.body}</p>
            </li>
          ))
        )}
      </ul>
    </>
  );
};

export default App;
```

```ts
import { queryOptions } from "@tanstack/react-query";

type Posts = {
  userId: number;
  id: number;
  title: string;
  body: string;
};

const getPosts = async (): Promise<Posts[]> => {
  await new Promise((resolve) => setTimeout(resolve, 1000));
  const response = await fetch(`https://jsonplaceholder.typicode.com/posts`);
  return await response.json();
};

export function fetchPostsQueryOptions() {
  return queryOptions({
    queryKey: ["posts"],
    queryFn: () => getPosts(),
  });
}
```

```ts
import { queryOptions } from "@tanstack/react-query";

type Todos = {
  userId: number;
  id: number;
  title: string;
  completed: boolean;
};

const getTodos = async (): Promise<Todos[]> => {
  await new Promise((resolve) => setTimeout(resolve, 1000));
  const response = await fetch(`https://jsonplaceholder.typicode.com/todos`);
  return await response.json();
};

export function fetchTodosQueryOptions() {
  return queryOptions({
    queryKey: ["todos"],
    queryFn: () => getTodos(),
  });
}
```

### Multiple Queries that need to run in a specific order

- Here you'll use the `enabled` option to make sure the dependent query only runs when the parent query resolves.

```tsx
import { useQuery } from "@tanstack/react-query";
import { fetchCommentsQueryOptions } from "./queryOptions/fetchCommentsQueryOptions";
import { fetchPostsQueryOptions } from "./queryOptions/fetchPostQueryOptions";

function App() {
  const { data, isPending, isError, error, refetch } = useQuery({
    ...fetchPostsQueryOptions(),
  });

  if (isError) {
    alert(`Error while fetching posts: ${error}`);
  }

  return (
    <>
      {isPending ? (
        <div>Loading...</div>
      ) : (
        <Card id={(data && data[5]?.id) || 1} />
      )}
      <button className="border border-gray-600 p-2" onClick={() => refetch()}>
        Refetch
      </button>
    </>
  );
}

const Card = ({ id }: { id: number }) => {
  const queryOptions = fetchCommentsQueryOptions(id);
  const { data, isError, error } = useQuery({
    ...queryOptions,
    enabled: !!id,
  });

  if (isError) {
    alert(`Error while fetching comments: ${error}`);
  }

  return (
    <div className="flex flex-col justify-center items-center p-4 border-blue-500 border-2">
      <h1 className="text-blue-500 text-5xl mb-2">CARD</h1>
      <div>{JSON.stringify(data?.slice(0, 10))}</div>
      <br />
      <br />
    </div>
  );
};

export default App;
```

- Since suspense queries always resolve, we can also make the parent query a suspense query and not use the `enabled` query option as follows:

```tsx
import { useQuery, useSuspenseQuery } from "@tanstack/react-query";
import { fetchCommentsQueryOptions } from "./queryOptions/fetchCommentsQueryOptions";
import { fetchPostsQueryOptions } from "./queryOptions/fetchPostQueryOptions";
import { Suspense } from "react";

function App() {
  const { data, isError, error, refetch } = useQuery({
    ...fetchPostsQueryOptions(),
  });

  if (isError) {
    alert(`Error while fetching posts: ${error}`);
  }

  return (
    <>
      <Suspense fallback={<div>Loading...</div>}>
        <Card id={(data && data[5]?.id) || 1} />
      </Suspense>
      <button className="border border-gray-600 p-2" onClick={() => refetch()}>
        Refetch
      </button>
    </>
  );
}

const Card = ({ id }: { id: number }) => {
  const queryOptions = fetchCommentsQueryOptions(id);
  const { data, isError, error } = useQuery({
    ...queryOptions,
  });

  if (isError) {
    alert(`Error while fetching comments: ${error}`);
  }

  return (
    <div className="flex flex-col justify-center items-center p-4 border-blue-500 border-2">
      <h1 className="text-blue-500 text-5xl mb-2">CARD</h1>
      <div>{JSON.stringify(data?.slice(0, 10))}</div>
      <br />
      <br />
    </div>
  );
};

export default App;
```

## Query Key and Caching

- TanStack Query caches query data and uses `queryKey` to uniquely identify a query data.

![[Pasted image 20260601090917.png]]

- Everytime we hit a query with a `queryKey`, TanStack Query will lookup in the cache if a query with the same key exists or not.
  - If it does, it fetches the data from that cache back to the consumer.
  - If not, TanStack Query calls the `queryFn` to fetch the data and then stores it in the cache with the same `queryKey`.
- The `QueryClient` is responsible for this caching and hence, we need to pass it via a `QueryClientProvider` to the root of our application.

### Fresh and Stale Data

- The data stored in the cache can be of two types of state.
  - Fresh: The data was recently added to the cache and can be sent back to the consumer.
  - Stale: The data has passed it's validity and needs to be refetched.

![[Pasted image 20260601091521.png]]

![[Pasted image 20260601091554.png]]

- So how do we determine if data is **fresh** or **stale**?
- Take a look at the below code:

```tsx
const App = () => {
  const {data, isLoading, isError, error} = useQuery({
    queryKey: ['users'],
    queryFn: () => getUsers()
  })

  if(isError) {
    return <div>An Error Occurred: {error}</div>
  }

  return (
    isLoading ?
      <div>Loading...</Loading>
    : <div>{JSON.stringify(data)}</div>
  )
}
```

- If apart from `queryKey` and `queryFn`, nothing else is passed, the query data will be stale by default.
- So how can I make my data fresh?

```tsx
const App = () => {
  const {data, isLoading, isError, error} = useQuery({
    queryKey: ['users'],
    queryFn: () => getUsers(),
    staleTime: 60000, // 👈 How much time in milliseconds will the data stay fresh for i.e. 1m in this case
  })

  if(isError) {
    return <div>An Error Occurred: {error}</div>
  }

  return (
    isLoading ?
      <div>Loading...</Loading>
    : <div>{JSON.stringify(data)}</div>
  )
}
```

- In above example, after 1 min, the data will be marked as stale after one minute.

![[Pasted image 20260601092506.png]]

- If we were to query within 30s, TanStack Query will fetch the data from the cache:

![[Pasted image 20260601093010.png]]

- After 60s more i.e. at 90s, the data is stale, so TanStack Query will invoke the `queryFn` again to fetch the data:

![[Pasted image 20260601092947.png]]

- This is also known as Cache Invalidation.
- When should you add `staleTime` vs when should you allow the default behaviour?
  - Real-time or frequently updating data: default behaviour
  - Data that doesn't need real-time active data updates: add stale time
- You can also mark data with `staleTime: Infinity`, this will make sure that the `queryFn` is invoked only once and never get invoked again, i.e. the data is always fresh and fetched from the cache even if you were to invoke `refetch`.
- You can however, trigger query invalidation manually as shown below.

### Query Invalidation

- Query invalidation is used to manually mark data as `stale` to trigger a `refetch`.

```jsx
const App = () => {
  const { data: users } = useQuery(createUsersQueryOptions())
  const queryClient = useQueryClient() // 👈 You need to get the query client from the context provider

  const handleCreate =  async () => {
    const user = {
      ...
    }

    await createUser(user)
    queryClient.invalidateQueries({queryKey: ['users']}) // 👈 Is an array to invalidate all necessary queries
    // Can also be written as:
    // queryClient.invalidateQuerys({queryKey: createUsersQueryOptions().queryKey })
  }
}
```

- `invalidateQueries` does two things:
  - Marks the query in question as stale.
  - Asks the question, is this query actively being used in our application?
    - If yes, then it will trigger a `refetch` of that query.
    - If no, then on the next call of that query, `queryClient` won't provide the data from the cache but call the `queryFn` to fetch fresh data.
- If you have any query that makes a change in the database like create, delete or update, then you should mark it's dependent query as stale so that fresh data can be fetched from the server.
- If you don't specify the `queryKey` to tell which query to invalidate, it will invalidate the entire cache: `queryClient.invalidateQueries()`

## Mutations

- For create, update and delete operations, TanStack Query provides a `useMutation` hook.

```ts
const { mutate, isLoading, isError } = useMutation({
  mutationFn: (user: Omit<User, "_id">) => createUser(user),
});

mutate(user);
```

- Mutation side effects:

```ts
useMutation({
  mutationFn: addTodo,
  onMutate: (variables, context) => {
    // A mutation is about to happen!

    // Optionally return a result containing data to use when for example rolling back
    return { id: 1 };
  },
  onError: (error, variables, onMutateResult, context) => {
    // An error happened!
    console.log(`rolling back optimistic update with id ${onMutateResult.id}`);
  },
  onSuccess: (data, variables, onMutateResult, context) => {
    // Boom baby!
  },
  onSettled: (data, error, variables, onMutateResult, context) => {
    // Error or success... doesn't matter!
  },
});
```
