---
creation date: 2026-05-21 10:16
modification date: Thursday 21st May 2026 10:16:16
tags:
  - chapter
status:
  - completed
aliases: []
id: 00_Animated Switch
---

- [[Radix UI]] provides the behaviour and accessibility for the Switch component, but it is up to us to add the styling and animation.
	- It is unopinionated in terms of style.
- Apart from that, we can only download the package we need, e.g., we can run just `pnpm install @radix-ui/react-switch` to just install the `Switch` primitive.
	- That being said, even if we install all the components, Radix UI is [[Tree-Shaking|tree-shakeable]].
- On toggling this, we have a [[Data Attributes|data attribute]], `data-state`, that gets toggled and we can add custom styles based on that toggle using [[Tailwind CSS]]: `data-[state=checked]:bg-sky-500`.
- We can use pseudo classes like `hover`, `focus` and `active` states by using `active:bg-sky-500` and `focus:bg-sky-500` etc.
	- `focus-visible`: used when the focus state is achieved using a keyboard.

```tsx
import * as Switch from "@radix-ui/react-switch";

function App() {
  return
    <div className="flex min-h-screen flex-col items-center justify-center bg-black text-gray-200 antialiased">
      <Switch.Root className="w-11 p-px rounded-full shadow-inner shadow-black/50 transition duration-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-sky-400 bg-gray-800 active:bg-gray-700 data-[state=checked]:bg-sky-500 active:data-[state=checked]:bg-sky-400">
        <Switch.Thumb className="w-6 h-6 bg-gray-200 data-[state=checked]:bg-white block rounded-full transition duration-500 shadow-sm data-[state=checked]:translate-x-4.5" />
      </Switch.Root>
    </div>
  );
}

export default App;
```

> [!NOTE]
> For using these primitives inside of [[Next.js]], use the `use client` i.e. these can't be used inside of a [[React Server Components|Server Component]]

## Switch as a Controlled Component

```tsx
import * as Switch from "@radix-ui/react-switch";
import { useState } from "react";

function App() {
  const [airplaneMode, setAirplaneMode] = useState(false);

  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-black text-gray-200 antialiased">
      <p>Airplane mode is {airplaneMode ? 'on' : 'off'}
      <label className="flex space-x-4">
        <span className="font-medium">Airplane Mode</span>
        <Switch.Root
          checked={airplaneMode}
          onCheckedChange={setAirplaneMode}
          className="w-11 p-px rounded-full shadow-inner shadow-black/50 transition duration-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-sky-400 bg-gray-700 active:bg-gray-600 data-[state=checked]:bg-sky-500 active:data-[state=checked]:bg-sky-400"
        >
          <Switch.Thumb className="w-6 h-6 bg-gray-200 data-[state=checked]:bg-white block rounded-full transition duration-500 shadow-sm data-[state=checked]:translate-x-4.5" />
        </Switch.Root>
      </label>
    </div>
  );
}

export default App;
```

## Radix Primitive as an Uncontrolled Component

```tsx
import * as Switch from "@radix-ui/react-switch";

function App() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-black text-gray-200 antialiased">
      <form
        action={(formData) => {
          const json = Object.fromEntries(formData);
          console.log(json);
        }}
      >
        <label className="flex space-x-4">
          <span className="font-medium">Airplane Mode</span>
          <Switch.Root
            name="airplane-mode"
            className="w-11 p-px rounded-full shadow-inner shadow-black/50 transition duration-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-sky-400 bg-gray-700 active:bg-gray-600 data-[state=checked]:bg-sky-500 active:data-[state=checked]:bg-sky-400"
          >
            <Switch.Thumb className="w-6 h-6 bg-gray-200 data-[state=checked]:bg-white block rounded-full transition duration-500 shadow-sm data-[state=checked]:translate-x-4.5" />
          </Switch.Root>
        </label>
        <div className="mt-4">
          <button
            type="submit"
            className="rounded bg-white px-3 py-1 text-gray-900"
          >
            Save
          </button>
        </div>
      </form>
    </div>
  );
}

export default App;
```
