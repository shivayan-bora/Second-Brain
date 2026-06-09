---
creation date: 2026-05-30 20:37
modification date: Saturday 30th May 2026 20:37:27
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 00_Laying the Foundation
---

## Why TanStack Query?

- [[React]] is a library used for building user interfaces.
  - The mental mode for React is that your view is a function of state or `v = f(s)`.
    - In this case you define how the UI should look like and how it changes based off of this state. [[React]] will do the heavy lifting of updating the UI for you.
    - You only need to worry on how the state in your application changes.
- The primary mode of encapsulation for this concept is the [[React Components|component]] which encapsulates both the visual representation of your UI as well as the state and logic that goes along with it.
- With the same intuition we have for creating and composing functions to get some value, the same can be achieved by creating and composing components to get some UI.
- In real world, we need UI composition as well as non-visual composition to build web applications.
- For non-visual composition, we have [[React Hooks|hooks]].
- When talking about states, we have two different kind of states to deal with:

### Client State vs Server State

- Client State or the synchronous state is the state we own:
  - It is owned by the client and is always up-to-date.
  - Since it's our state, we can change it.
  - Usually ephemeral since it disappears when the browser is closed.
  - It's synchronous and always available.
- Server State or the asynchronous state is the state we receive from an external server:
  - It's owned by server and we receive only a snapshot of it which can get outdated.
  - Multiple users can change the data.
  - It is persisted remotely and is available across browsing sessions.
  - It's asynchronous and takes time for the data to come from the servers to the client.
- `Client State !== Server State`
- For managing client state, we have the following options:
  - `useState`
  - `useReducer`
  - [[Redux]]
  - [[Zustand]]

### Managing Server State

- With dynamic web application talking back and forth with servers, React didn't have an intuitive way of handling asynchronous state or server state.

#### Handling API calls with useEffect and useState

- Initially we used to handle any asynchronous logic inside a `useEffect` hook and then preserved the state using `useState` hook.

```jsx
import * as React from "react";
import PokemonCard from "./PokemonCard";
import ButtonGroup from "./ButtonGroup";

export default function App() {
  const [id, setId] = React.useState(1);
  const [pokemon, setPokemon] = React.useState(null);

  React.useEffect(() => {
    const handleFetchPokemon = async () => {
      setPokemon(null);

      const res = await fetch(`https://pokeapi.co/api/v2/pokemon/${id}`);
      const json = await res.json();
      setPokemon(json);
    };

    handleFetchPokemon();
  }, [id]);

  return (
    <>
      <PokemonCard data={pokemon} />
      <ButtonGroup handleSetId={setId} />
    </>
  );
}
```

- This code, however, doesn't account for loading and error states of the API endpoint resulting in bad [[Cumulative Layout Shift(CLS)]] and the infinite spinner.

#### Handling Loading and Error states of the API response

- The fix for this is including more `useState` hooks to track loading and error states as follows:

```jsx
import * as React from "react";
import PokemonCard from "./PokemonCard";
import ButtonGroup from "./ButtonGroup";

export default function App() {
  const [id, setId] = React.useState(1);
  const [pokemon, setPokemon] = React.useState(null);
  const [isLoading, setIsLoading] = React.useState(false);
  const [error, setError] = React.useState(null);

  React.useEffect(() => {
    const handleFetchPokemon = async () => {
      setPokemon(null);
      setIsLoading(true);
      setError(null);
      try {
        const res = await fetch(`https://pokeapi.co/api/v2/pokemon/${id}`);

        if (res.ok === false) {
          throw new Error(`Error fetching pokemon #${id}`);
        }

        const json = await res.json();
        setPokemon(json);
        setIsLoading(false);
      } catch (e) {
        setError(e.message);
        setIsLoading(false);
      }
    };

    handleFetchPokemon();
  }, [id]);

  return (
    <>
      <PokemonCard isLoading={isLoading} data={pokemon} error={error} />
      <ButtonGroup handleSetId={setId} />
    </>
  );
}
```

#### Invalidating older API calls and only updating state with the latest API call

- We're not quite there yet though. Imagine the user clicks the button to fetch Pokemon with `id = 2`. While that data is getting fetched, the user clicks the button again.
  - Now if the response for `id = 3` comes after the response for `id = 2`, it's all well and good but we will see the 2nd Pokemon flash once before showing the 3rd.
  - If `id = 3` comes before the response for `id = 2`, then the UI will sync to show the 3rd Pokemon but then immediately show the 2nd Pokemon but the `id` state is now 3. This is a sync issue that we're seeing here.
- Both of these are bad UX.
- Ideally we need to tell React to ignore the response coming from requests made in `useEffect` that are now irrelevant.
  - To do this, we need to know if an effect is the latest one. If not, then we should ignore the response and not re-render.
  - We need to use [[JavaScript Closures|closures]] alongwith `useEffect`'s cleanup function as follows:

```jsx
import * as React from "react";
import PokemonCard from "./PokemonCard";
import ButtonGroup from "./ButtonGroup";

export default function App() {
  const [id, setId] = React.useState(1);
  const [pokemon, setPokemon] = React.useState(null);
  const [isLoading, setIsLoading] = React.useState(false);
  const [error, setError] = React.useState(null);

  React.useEffect(() => {
    let ignore = false;

    const handleFetchPokemon = async () => {
      setPokemon(null);
      setIsLoading(true);
      setError(null);

      try {
        const res = await fetch(`https://pokeapi.co/api/v2/pokemon/${id}`);

        // If this isn't the latest useEffect, ignore will be true and we will just return
        if (res.ok === false) {
          throw new Error(`Error fetching pokemon #${id}`);
        }

        const json = await res.json();
        setPokemon(json);
        setIsLoading(false);
      } catch (e) {
        setError(e.message);
        setIsLoading(false);
      }
    };

    handleFetchPokemon();

    // Cleanup will only happen when another request has been made
    return () => {
      ignore = true;
    };
  }, [id]);

  return (
    <>
      <PokemonCard isLoading={isLoading} data={pokemon} error={error} />
      <ButtonGroup handleSetId={setId} />
    </>
  );
}
```

#### Extracting the API logic into a custom hook

- Now most probably, you might want the logic for handling the fetch request into a custom hook.

```jsx
import * as React from "react";
import PokemonCard from "./PokemonCard";
import ButtonGroup from "./ButtonGroup";

export default function useQuery(url) {
  const [pokemon, setPokemon] = React.useState(null);
  const [isLoading, setIsLoading] = React.useState(false);
  const [error, setError] = React.useState(null);

  React.useEffect(() => {
    let ignore = false;

    const handleFetch = async () => {
      setPokemon(null);
      setIsLoading(true);
      setError(null);

      try {
        const res = await fetch(url);

        // If this isn't the latest useEffect, ignore will be true and we will just return
        if (res.ok === false) {
          throw new Error("A network error occurred");
        }

        const json = await res.json();
        setPokemon(json);
        setIsLoading(false);
      } catch (e) {
        setError(e.message);
        setIsLoading(false);
      }
    };

    handleFetchPokemon();

    // Cleanup will only happen when another request has been made
    return () => {
      ignore = true;
    };
  }, [url]);

  return { data, isLoading, error };
}
```

- However, this doesn't handle another caveat i.e. data duplication.

#### Handling Data Duplication

- Imagine having multiple different components making the same API call.
  - Each component will maintain it's own response, loading and error states.
  - While making multiple requests to the server, one request could fail while the other succeeds or one data is different than a subsequent request.
- The most instant instinct will be to pass the data from the nearest parent down with [[Prop Drilling]] or by using the [[React Context|context]] API to the components that need it.

```jsx
import * as React from "react";

const queryContext = React.createContext([{}, () => {}]);

export function QueryProvider({ children }) {
  const tuple = React.useState({});

  return (
    <queryContext.Provider value={tuple}>{children}</queryContext.Provider>
  );
}

export default function useQuery(url) {
  const [state, setState] = React.useContext(queryContext);

  React.useEffect(() => {
    let ignore = false;

    const handleFetch = async () => {
      const update = (newState) =>
        setState((prev) => ({
          ...prevState,
          [url]: { ...prevState[url], ...newState },
        }));

      try {
        const res = await fetch(url);

        // If this isn't the latest useEffect, ignore will be true and we will just return
        if (res.ok === false) {
          throw new Error("A network error occurred");
        }

        const json = await res.json();
        update({ data, isLoading: false, error: null });
      } catch (e) {
        update({ data: data, isLoading: false, error: e.message });
      }
    };

    handleFetch();

    // Cleanup will only happen when another request has been made
    return () => {
      ignore = true;
    };
  }, [url]);

  return state[url] || { data: null, isLoading: true, error: null };
}
```

- Now when we fetch data from the URL, it will check the state first if the data exists and if not, it will fetch from the URL:

```js
useQuery("/api/v2/pokemon"); // fetches from API
useQuery("/api/v2/pokemon"); // fetches from cache
```

- With this however, there's a fundamental problem where components down the tree are unable to subscribe to pieces of state. In that case, if any query gets called, it will re-render all the components subscribed to the context even if they don't depend upon that query.
- Apart from that if two components call the same query at the same time, we need to figure a way out to de-duplicate the request and only care about the latest response of those queries.
- Apart from that, cache invalidation is one of the hardest problem statements in Computer Science.

#### Conclusion

- What started out as a simple data fetching operation resulted in a complex mesh of `useEffect`, `useState` and `useContext`.

### Solution: TanStack Query

- [[TanStack Query]], initially also called React Query, was known as the missing piece for data fetching in React.
- However, more importantly, [[TanStack Query]] is the asynchronous state management solution for managing server side state.

> [!NOTE]
> TanStack query doesn't actually fetch the data but manages it.

```jsx
import * as React from "react";
import PokemonCard from "./PokemonCard";
import ButtonGroup from "./ButtonGroup";
import {
  QueryClient,
  QueryClientProvider,
  useQuery,
} from "@tanstack/react-query";

const queryClient = new QueryClint();

function App() {
  const [id, setId] = React.useState(1);
  const {
    data: pokemon,
    isLoading,
    error,
  } = useQuery({
    queryKey: ["pokemon", id],
    queryFn: () =>
      fetch(`https://pokeapi.co/api/v2/pokemon/${id}`).then((res) =>
        res.json(),
      ),
  });

  return (
    <>
      <PokemonCard data={pokemon} isLoading={isLoading} error={error} />
      <ButtonGroup handleSetId={setId} />
    </>
  );
}

export default function Root() {
  return (
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  );
}
```
