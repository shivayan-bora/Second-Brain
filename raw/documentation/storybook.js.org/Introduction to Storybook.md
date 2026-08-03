---
id: Introduction to Storybook
aliases: []
tags:
  - course
creation date: 2026-05-28 12:58
modification date: Thursday 28th May 2026 12:58:34
source: https://storybook.js.org/tutorials/intro-to-storybook/
status:
  - in-progress
---

## What is a story?

- A story is a named, isolated state of a component (e.g. `Primary`, `Disabled`, `WithIcon`) written using Component Story Format (CSF).
- e.g. `Buttton` story will look like this:

```tsx
// Button.tsx
import React from "react";

export type ButtonVariant = "primary" | "secondary" | "ghost";

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
}

export const Button: React.FC<ButtonProps> = ({
  variant = "primary",
  children,
  ...rest
}) => {
  return (
    <button data-variant={variant} {...rest}>
      {children}
    </button>
  );
};
```

```tsx
// Button.stories.tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./Button";

const meta: Meta<typeof Button> = {
  title: "Components/Button",
  component: Button,
};
export default meta;

type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: {
    variant: "primary",
    children: "Primary Button",
  },
};

export const Secondary: Story = {
  args: {
    variant: "secondary",
    children: "Secondary Button",
  },
};
```

- `default export (meta)`: Tells storybook which component this file is about and where it lives in the sidebar.
- Named exports(`Primary`, `Secondary`, etc.): Each is a story object that describes one visual state.

## Controls

- You expose your component's props as `args` and [[Storybook]] auto-generates a form UI to tweak them at runtime.

```ts
export const Primary: Story = {
  args: {
    variant: "primary",
    children: "Primary Button",
  },
};
```

- `args`: Runtime values passed into your component in that story.
  - Think `pre-filled props for this specific state`.
- Controls Panel: UI that lets designers/developers change `args` and see the component re-render.
- To customize how controls render, we can use the `argTypes` in the `meta`:

```ts
const meta: Meta<typeof Button> = {
  title: "Components/Button",
  component: Button,
  argTypes: {
    variant: {
      control: { type: "radio" },
      options: ["primary", "secondary", "ghost"],
    },
    onClick: {
      action: "clicked", // logs to Actions panel instead of requiring a real handler
    },
  },
};
```

## Decorators and Global Configuration

- Decorators wrap every story (or a subset) with extra markup or context, like `<ThemeProvider>`, `<BrowserRouter>` etc.
- Global decorators live in `.storybook/preview.ts`:

```tsx
// .storybook/preview.ts
import type { Preview } from "@storybook/react";
import { ThemeProvider } from "../src/theme/ThemeProvider";

const preview: Preview = {
  decorators: [
    (Story) => (
      <ThemeProvider>
        <Story />
      </ThemeProvider>
    ),
  ],
};

export default preview;
```

- Component-level decorators:

```tsx
// Button.stories.tsx
const meta: Meta<typeof Button> = {
  title: "Components/Button",
  component: Button,
  decorators: [
    (Story) => (
      <div style={{ padding: "1rem", background: "#f5f5f5" }}>
        <Story />
      </div>
    ),
  ],
};
```

- Hierarchy and where they apply:
  - Global decorators → apply to all stories.
  - Component-level decorators → apply only to stories in that file.
  - Story-level decorators → apply to just one story.
- In a design system, global decorators typically set up:
  - Design-system theme provider
  - Global CSS/reset
  - Maybe feature flags, i18n, etc.

## Documentation (MDX)

- Storybook has Docs mode that auto-generates a documentation page per component from your stories and args. For a DS, this becomes your public API docs.
- Out of the box, you get:
  - Props/Args table (from types + argTypes)
  - List of stories (interactive examples)
  - Source code snippets
- For more control, use [[MDX]] docs:

```mdx
{/* Button.docs.mdx */}
import { Meta, Story, ArgsTable } from "@storybook/blocks";
import \* as ButtonStories from "./Button.stories";

<Meta of={ButtonStories} />

# Button

Use `Button` for primary actions in forms and dialogs.

## Variants

<Story of={ButtonStories.Primary} />
<Story of={ButtonStories.Secondary} />

## Props

<ArgsTable of={ButtonStories.Primary} />
```

- Key ideas:
  - `Meta` associates this MDX doc with your CSF stories.
  - `Story` blocks embed live stories in docs.
  - `ArgsTable` uses the story’s `args`/`argTypes`/TS types to render a prop table.
- For a design system, you typically:
  - Pair each component’s `.stories.tsx` with a `.docs.mdx` for usage guidelines, “do/don’t”, accessibility notes.
  - Have some standalone MDX “pages” for tokens, typography, spacing, etc.

## Theming and Design System Aware Addons

- Two theming layers matter:
  - Storybook UI theme: how Storybook itself looks (sidebar, panels). You can skin it to match your brand.
  - Component themes: light/dark or brand themes for your design system, switched via addon-themes.
- Storybook UI theme (optional but nice for polish):

```ts
// .storybook/manager.ts
import { addons } from "@storybook/manager-api";
import { create } from "@storybook/theming/create";

addons.setConfig({
  theme: create({
    base: "light",
    brandTitle: "Acme Design System",
    brandUrl: "https://acme.io",
  }),
});
```

- Preview theming for your components with `@storybook/addon-themes`:

```ts
// .storybook/preview.ts
import type { Preview } from "@storybook/react";
import { withThemeFromJSXProvider } from "@storybook/addon-themes";
import { ThemeProvider, lightTheme, darkTheme } from "../src/theme";

const preview: Preview = {
  decorators: [
    withThemeFromJSXProvider({
      themes: {
        light: lightTheme,
        dark: darkTheme,
      },
      defaultTheme: "light",
      Provider: ThemeProvider,
    }),
  ],
};

export default preview;
```

- This gives you a theme switcher in the toolbar; every story re-renders under the selected theme.

## Getting started

- Install the template and its dependenies:

```bash
# Clone the template
npx degit chromaui/intro-storybook-react-template taskbox

cd taskbox

# Install dependencies
yarn
```

- Run the application

```bash
# Start the storybook component explorer on port 6006
yarn storybook

# Run the frontend app on port 5173
yarn dev
```

## Build a simple component in isolation

- We will build our UI following the [Component-Driven Development(CDD)](https://www.componentdriven.org/) methodology.
  - It's a process that builds UIs from the `bottom-up` starting with components and ending with screens.

### Component:

```ts
// src/types.ts
type TaskData = {
  id: string;
  title: string;
  state: "TASK_ARCHIVED" | "TASK_INBOX" | "TASK_PINNED";
};
```

```tsx
// src/components/Task.tsx
import type { TaskData } from "../types";

type TaskProps = {
  /** Composition of the task */
  task: TaskData;
  /** Event to change the task to archived */
  onArchiveTask: (id: string) => void;
  /** Event to change the task to pinned */
  onPinTask: (id: string) => void;
};

const Task = ({
  task: { id, title, state },
  onArchiveTask,
  onPinTask,
}: TaskProps) => {
  return (
    <div className={`list-item ${state}`}>
      <label
        htmlFor={`archiveTask-${id}`}
        aria-label={`archiveTask-${id}`}
        className="checkbox"
      >
        <input
          type="checkbox"
          disabled={true}
          name="checked"
          id={`archiveTask-${id}`}
          checked={state === "TASK_ARCHIVED"}
        />
        <span className="checkbox-custom" onClick={() => onArchiveTask(id)} />
      </label>

      <label htmlFor={`title-${id}`} aria-label={title} className="title">
        <input
          type="text"
          value={title}
          readOnly={true}
          name="title"
          id={`title-${id}`}
          placeholder="Input title"
        />
      </label>
      {state !== "TASK_ARCHIVED" && (
        <button
          className="pin-button"
          onClick={() => onPinTask(id)}
          id={`pinTask-${id}`}
          aria-label={`pinTask-${id}`}
          key={`pinTask-${id}`}
        >
          <span className={`icon-star`} />
        </button>
      )}
    </div>
  );
};

export default Task;
```

### Story

```tsx
// src/components/Task.stories.tsx
import { fn } from "storybook/test";
import Task from "./Task";
import type { Meta, StoryObj } from "@storybook/react-vite";

const ActionsData = {
  onArchiveTask: fn(), // 👈 creates a callback that appears in the Actions panel of the Storybook UI
  onPinTask: fn(),
};

const meta = {
  component: Task,
  title: "Task",
  tags: ["autodocs"],
  // 👇 Our exports that end in "Data" aren't stories
  excludeStories: /.Data%/,
  args: {
    ...ActionsData,
  },
} satisfies Meta<typeof Task>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    task: {
      id: "1",
      title: "Test Task",
      state: "TASK_INBOX",
    },
  },
};

export const Pinned: Story = {
  args: {
    task: {
      ...Default.args.task,
      state: "TASK_PINNED",
    },
  },
};

export const Archived: Story = {
  args: {
    task: {
      ...Default.args.task,
      state: "TASK_ARCHIVED",
    },
  },
};
```

- Actions are used to show that an event handler (callback) has been called, and to display its arguments. The actions panel can show both story args and other function calls.
  - Actions help you verify interactions when building UI components in isolation. Oftentimes you won't have access to the functions and state you have in context of the app. Use `fn()` to stub them in.
- To tell storybook about the component we're testing, we create a `default` export that contains:
  - `component`: the component itself
  - `title`: how to group or categorize the component in the Storybook sidebar
  - `tags`: to automatically generate documentation for our components
  - `excludeStories`: additional information required by the story but should not be rendered in Storybook
  - `args`: define the action `args` that the component expects to mock out the custom events

### Configuration

```ts
// .storybook/main.ts
import type { StorybookConfig } from "@storybook/react-vite";

const config: StorybookConfig = {
  stories: ["../src/components/**/*.stories.@(ts|tsx)"], // 👈 pick-up our new stories
  staticDirs: ["../public"],
  addons: [
    "@storybook/addon-docs",
    "@storybook/addon-vitest",
    "@chromatic-com/storybook",
  ],
  framework: {
    name: "@storybook/react-vite",
    options: {},
  },
};

export default config;
```

```ts
// .storybook/preview.ts
import type { Preview } from '@storybook/react-vite';

+ import '../src/index.css'; // 👈 import our custom CSS file

const preview: Preview = {
  parameters: { // 👈 used to control the behaviour of Storybook's features and addons
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/,
      },
    },
  },
};

export default preview;
```

## Building Composite Components

```tsx
import type { TaskData } from "../types";
import Task from "./Task";

type TaskListProps = {
  // Checks if it's in loading state
  loading?: boolean;
  // List of tasks
  tasks: TaskData[];
  // Event to change the task to pinned
  onPinTask: (id: string) => void;
  // Event to change the task to archived
  onArchiveTask: (id: string) => void;
};

const TaskList = ({
  loading = false,
  tasks,
  onPinTask,
  onArchiveTask,
}: TaskListProps) => {
  const events = {
    onPinTask,
    onArchiveTask,
  };

  const LoadingRow = (
    <div className="loading-item">
      <span className="glow-checkbox" />
      <span className="glow-text">
        <span>Loading</span> <span>cool</span> <span>state</span>
      </span>
    </div>
  );
  if (loading) {
    return (
      <div className="list-items" data-testid="loading" key={"loading"}>
        {LoadingRow}
        {LoadingRow}
        {LoadingRow}
        {LoadingRow}
        {LoadingRow}
        {LoadingRow}
      </div>
    );
  }
  if (tasks.length === 0) {
    return (
      <div className="list-items" key={"empty"} data-testid="empty">
        <div className="wrapper-message">
          <span className="icon-check" />
          <p className="title-message">You have no tasks</p>
          <p className="subtitle-message">Sit back and relax</p>
        </div>
      </div>
    );
  }

  const tasksInOrder = [
    ...tasks.filter((t) => t.state === "TASK_PINNED"),
    ...tasks.filter((t) => t.state !== "TASK_PINNED"),
  ];
  return (
    <div className="list-items">
      {tasksInOrder.map((task) => (
        <Task key={task.id} task={task} {...events} />
      ))}
    </div>
  );
};

export default TaskList;
```

```tsx
import type { Meta, StoryObj } from "@storybook/react-vite";
import TaskList from "./TaskList";
import * as TaskStories from "./Task.stories.tsx";

const meta = {
  component: TaskList,
  title: "TaskList",
  decorators: [(story) => <div style={{ margin: "3rem" }}>{story()}</div>],
  tags: ["autodocs"],
  args: {
    ...TaskStories.ActionsData,
  },
} satisfies Meta<typeof TaskList>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    // Shaping the stories through args composition
    // The data was inherited from the Default story in Task.stories.tsx
    tasks: [
      { ...TaskStories.Default.args.task, id: "1", title: "Task 1" },
      { ...TaskStories.Default.args.task, id: "2", title: "Task 2" },
      { ...TaskStories.Default.args.task, id: "3", title: "Task 3" },
      { ...TaskStories.Default.args.task, id: "4", title: "Task 4" },
      { ...TaskStories.Default.args.task, id: "5", title: "Task 5" },
      { ...TaskStories.Default.args.task, id: "6", title: "Task 6" },
    ],
  },
};

export const WithPinnedTasks: Story = {
  args: {
    tasks: [
      ...Default.args.tasks.slice(0, 5),
      { id: "6", title: "Task 6 (pinned)", state: "TASK_PINNED" },
    ],
  },
};

export const Loading: Story = {
  args: {
    tasks: [],
    loading: true,
  },
};

export const Empty: Story = {
  args: {
    // Shaping the stories through args composition.
    // Inherited data coming from the Loading story
    ...Loading.args,
    loading: false,
  },
};
```

- Decorators are a way to provide arbitrary wrappers to stories.
  - e.g. we're adding some margin around the rendered story component.
  - They can also be used to wrap stories in `providers` i.e. library components that set [[React Context]].

## Wire in Data

- Install [[Redux]] with [[Redux Toolkit]]: `yarn add @reduxjs/toolkit react-redux`
- Create the store as follows:

```ts
/* A simple redux store/actions/reducer implementation.
 * A true app would be more complex and separated into different files.
 */
import type { TaskData } from "../types";

import {
  configureStore,
  createSlice,
  type PayloadAction,
} from "@reduxjs/toolkit";

interface TaskBoxState {
  tasks: TaskData[];
  status: "idle" | "loading" | "failed" | "succeeded";
  error: string | null;
}

/*
 * The initial state of our store when the app loads.
 * Usually, you would fetch this from a server. Let's not worry about that now
 */
const defaultTasks: TaskData[] = [
  { id: "1", title: "Something", state: "TASK_INBOX" },
  { id: "2", title: "Something more", state: "TASK_INBOX" },
  { id: "3", title: "Something else", state: "TASK_INBOX" },
  { id: "4", title: "Something again", state: "TASK_INBOX" },
];

const TaskBoxData: TaskBoxState = {
  tasks: defaultTasks,
  status: "idle",
  error: null,
};

/*
 * The store is created here.
 * You can read more about Redux Toolkit's slices in the docs:
 * https://redux-toolkit.js.org/api/createSlice
 */
const TasksSlice = createSlice({
  name: "taskbox",
  initialState: TaskBoxData,
  reducers: {
    updateTaskState: (
      state,
      action: PayloadAction<{ id: string; newTaskState: TaskData["state"] }>,
    ) => {
      const task = state.tasks.find((task) => task.id === action.payload.id);
      if (task) {
        task.state = action.payload.newTaskState;
      }
    },
  },
});

// The actions contained in the slice are exported for usage in our components
export const { updateTaskState } = TasksSlice.actions;

/*
 * Our app's store configuration goes here.
 * Read more about Redux's configureStore in the docs:
 * https://redux-toolkit.js.org/api/configureStore
 */

const store = configureStore({
  reducer: {
    taskbox: TasksSlice.reducer,
  },
});

// Define RootState and AppDispatch types
export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

export default store;
```

- Update the component:

```tsx
import type { RootState, AppDispatch } from "../lib/store";
import Task from "./Task";
import { useDispatch, useSelector } from "react-redux";
import { updateTaskState } from "../lib/store";

export default function TaskList() {
  // We're retrieving our state from the store
  const tasks = useSelector((state: RootState) => {
    const tasksInOrder = [
      ...state.taskbox.tasks.filter((t) => t.state === "TASK_PINNED"),
      ...state.taskbox.tasks.filter((t) => t.state !== "TASK_PINNED"),
    ];
    const filteredTasks = tasksInOrder.filter(
      (t) => t.state === "TASK_INBOX" || t.state === "TASK_PINNED",
    );
    return filteredTasks;
  });
  const { status } = useSelector((state: RootState) => state.taskbox);
  const dispatch = useDispatch<AppDispatch>();
  const pinTask = (value: string) => {
    // We're dispatching the Pinned event back to our store
    dispatch(updateTaskState({ id: value, newTaskState: "TASK_PINNED" }));
  };
  const archiveTask = (value: string) => {
    // We're dispatching the Archive event back to our store
    dispatch(updateTaskState({ id: value, newTaskState: "TASK_ARCHIVED" }));
  };
  const LoadingRow = (
    <div className="loading-item">
      <span className="glow-checkbox" />
      <span className="glow-text">
        <span>Loading</span> <span>cool</span> <span>state</span>
      </span>
    </div>
  );
  if (status === "loading") {
    return (
      <div className="list-items" data-testid="loading" key="loading">
        {LoadingRow}
        {LoadingRow}
        {LoadingRow}
        {LoadingRow}
        {LoadingRow}
        {LoadingRow}
      </div>
    );
  }
  if (tasks.length === 0) {
    return (
      <div className="list-items" key="empty" data-testid="empty">
        <div className="wrapper-message">
          <span className="icon-check" />
          <p className="title-message">You have no tasks</p>
          <p className="subtitle-message">Sit back and relax</p>
        </div>
      </div>
    );
  }

  return (
    <div className="list-items" data-testid="success" key="success">
      {tasks.map((task) => (
        <Task
          key={task.id}
          task={task}
          onPinTask={pinTask}
          onArchiveTask={archiveTask}
        />
      ))}
    </div>
  );
}
```

- Update the story:

```tsx
import type { Meta, StoryObj } from "@storybook/react-vite";

import type { TaskData } from "../types";

import { Provider } from "react-redux";

import { configureStore, createSlice } from "@reduxjs/toolkit";

import TaskList from "./TaskList";

import * as TaskStories from "./Task.stories";

// A super-simple mock of the state of the store
export const MockedState = {
  tasks: [
    { ...TaskStories.Default.args.task, id: "1", title: "Task 1" },
    { ...TaskStories.Default.args.task, id: "2", title: "Task 2" },
    { ...TaskStories.Default.args.task, id: "3", title: "Task 3" },
    { ...TaskStories.Default.args.task, id: "4", title: "Task 4" },
    { ...TaskStories.Default.args.task, id: "5", title: "Task 5" },
    { ...TaskStories.Default.args.task, id: "6", title: "Task 6" },
  ] as TaskData[],
  status: "idle",
  error: null,
};

// A super-simple mock of a redux store
const Mockstore = ({
  taskboxState,
  children,
}: {
  taskboxState: typeof MockedState;
  children: React.ReactNode;
}) => (
  <Provider
    store={configureStore({
      reducer: {
        taskbox: createSlice({
          name: "taskbox",
          initialState: taskboxState,
          reducers: {
            updateTaskState: (state, action) => {
              const { id, newTaskState } = action.payload;
              const task = state.tasks.findIndex((task) => task.id === id);
              if (task >= 0) {
                state.tasks[task].state = newTaskState;
              }
            },
          },
        }).reducer,
      },
    })}
  >
    {children}
  </Provider>
);

const meta = {
  component: TaskList,
  title: "TaskList",
  decorators: [(story) => <div style={{ margin: "3rem" }}>{story()}</div>],
  tags: ["autodocs"],
  excludeStories: /.*MockedState$/,
} satisfies Meta<typeof TaskList>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  decorators: [
    (story) => <Mockstore taskboxState={MockedState}>{story()}</Mockstore>,
  ],
};

export const WithPinnedTasks: Story = {
  decorators: [
    (story) => {
      const pinnedtasks: TaskData[] = [
        ...MockedState.tasks.slice(0, 5),
        { id: "6", title: "Task 6 (pinned)", state: "TASK_PINNED" },
      ];

      return (
        <Mockstore
          taskboxState={{
            ...MockedState,
            tasks: pinnedtasks,
          }}
        >
          {story()}
        </Mockstore>
      );
    },
  ],
};

export const Loading: Story = {
  decorators: [
    (story) => (
      <Mockstore
        taskboxState={{
          ...MockedState,
          status: "loading",
        }}
      >
        {story()}
      </Mockstore>
    ),
  ],
};

export const Empty: Story = {
  decorators: [
    (story) => (
      <Mockstore
        taskboxState={{
          ...MockedState,
          tasks: [],
        }}
      >
        {story()}
      </Mockstore>
    ),
  ],
};
```

- `excludeStories` is a Storybook configuration field that prevents our mocked state to be treated as a story.
