---
creation date: 2026-06-03 01:33
modification date: Wednesday 3rd June 2026 01:33:48
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 00_Introduction to Nx
---

- Open Source Build System
- Integrated Monorepo
- Features:
  - Allows you to run your build, lint and tests much faster by
    - Caching
    - Faster and more intelligent parallelization
  - Has great scaffolding mechanisms to create your project, preconfigure your workspace with all necessary tooling

## Challenges of Monorepos

- As teams and codebases grow, monorepos are hard to scale:
  - **Slow builds and tests**: Hundreds or thousands of tasks compete for CI resources.
  - **Complex task pipelines**: Projects depend on each other, so tasks need to run in the right order, and that's hard to manage by hand.
  - **Flaky CI**: Longer pipelines lead to random failures and inconsistent results between local and CI environments.
  - **Architectural erosion**: Without clear boundaries, unwanted dependencies creep in and projects become tightly coupled.

## What Nx does?

- [[Nx]] reduces friction across your entire development cycle with intelligent caching, task orchestration and deep understanding of your codebase.
  - **Runs tasks fast**: [Caches results](https://nx.dev/docs/features/cache-task-results) so you never rebuild the same code twice.
  - **Understands your codebase**: Builds [project and task graphs](https://nx.dev/docs/features/explore-graph) showing how everything connects.
  - **Orchestrates intelligently**: Runs tasks in the [right order](https://nx.dev/docs/concepts/task-pipeline-configuration), parallelizing when possible.
  - **Enforces boundaries**: [Module boundary rules](https://nx.dev/docs/features/enforce-module-boundaries) prevent unwanted dependencies between projects.
  - **Handles flakiness**: [Automatically re-runs flaky tasks](https://nx.dev/docs/features/ci-features/flaky-tasks) and [self-heals CI failures](https://nx.dev/docs/features/ci-features/self-healing-ci).

## Nx Modules

![[Pasted image 20260603013910.png]]

- **Nx Core**: Base functionalities e.g. task running, caching, distribution, workspace analysis etc.
  - Caches results to make future tasks faster
  - You can run tasks in parallel
  - Creates a dependency graph of your various packages
- **Nx Plugins**: Extra added functionalities and technology specific automations (generators, executors, dependency detection)
- **Nx Console**: Editor extension with visual UI and AI Assistance
- **Nx Cloud**: [Remote caching](https://nx.dev/docs/features/ci-features/remote-cache), [affected commands](https://nx.dev/docs/features/ci-features/affected) and [self-healing CI](https://nx.dev/docs/features/ci-features/self-healing-ci)

## Setting up Nx

- **Existing Project**: Add in `devDependencies` of your root `package.json` or alternatively, run `npx nx@latest init`
- **New Project**: `npx create-nx-workspace@latest myorg`
- To check the dependency graph of your application: `npx nx graph`
- To run many tasks: `npx nx run-many -t build test lint`
- Comes with automatic package upgrade command: `npx nx migrate latest`

## Tasks in Nx

- Nx is a highly optimized [[Rust]] based task runner.
  - Easily run multiple targets for projects in parallel.
  - Define task pipelines to run tasks in the correct order.
  - Only run tasks for projects affected by a given change.
  - Speed up task execution with caching.

### Defining Tasks

- [[Nx]] combines three sources to determine the tasks in a particular repository.
  - It scans the `pnpm-workspace.yaml` to go through each package's `package.json` to create tasks.
  - Tasks are also inferred from tooling configuration files. e.g. Nx Plugins can detect your tooling configurations e.g. `vite.config.ts` or `.eslintrc.json` and automatically configure runnable tasks including Nx Cache.
    - e.g. `@nx/jest` will automatically create a `test` task for a project that uses [[Jest]]. As shown below, the names can be configured in the `nx.json` file.
  - Apart from that, tasks can also be defined in a `project.json`.

```json
// libs/mylib/package.json
{
  "name": "mylib",
  "scripts": {
    "build": "tsc -p tsconfig.lib.json",
    "test": "jest"
  }
}
```

```json
// libs/mylib/project.json
{
  "root": "libs/mylib",
  "targets": {
    "build": {
      "command": "tsc -p tsconfig.lib.json"
    },
    "test": {
      "executor": "@nx/jest:jest",
      "options": {
        /* ... */
      }
    }
  }
}
```

```json
// nx.json
{
  ...
  "plugins": [
    {
      "plugin": "@nx/vite/plugin",
      "options": {
        "buildTargetName": "build",
        "testTargetName": "test",
        "serveTargetName": "serve",
        "previewTargetName": "preview",
        "serveStaticTargetName": "serve-static"
      }
    },
    {
      "plugin": "@nx/eslint/plugin",
      "options": {
        "targetName": "lint"
      }
    },
    {
      "plugin": "@nx/jest/plugin",
      "options": {
        "targetName": "test"
      }
    }
  ],
  ...
}
```

#### Inferred Tasks

- How does an Nx plugin infer tasks?
  - The Nx Plugin will search the corresponding tooling configuration in the workspace e.g. `@nx/webpack` will search for `webpack.config.js`
  - The plugin then configures tasks with a name that you specified in the plugin's configuration in `nx.json`. The settings for the task are determined by the tool configuration.
    - e.g. `@nx/webpack` plugin creates tasks named build, serve and preview by default and it automatically sets the task caching settings based on the values in the webpack configuration files.

##### What is inferred?

- Nx plugins infer the following properties by analyzing the tool configuration.
  - Command - How is the tool invoked
  - Cacheability - Whether the task will be cached by Nx. When the Inputs have not changed the Outputs will be restored from the cache.
  - Inputs - Inputs are used by the task to produce Outputs. Inputs are used to determine when the Outputs of a task can be restored from the cache.
  - Outputs - Outputs are the results of a task. Outputs are restored from the cache when the Inputs are the same as a previous run.
  - Task Dependencies - The list of other tasks which must be completed before running this task.

##### Nx uses plugins to build the graph

- A typical workspace will have many plugins inferring tasks. Nx processes all the plugins registered in `nx.json` to create project configuration for individual projects and a project and task graph that shows the connections between them all.
- **Order Matters**: Plugins are processed in the order that they appear in the plugins array in `nx.json`. So, if multiple plugins create a task with the same name, the plugin listed last will win.
- Nx hashes the project graph node produced by each plugin to determine whether cached task results can be reused.
- **Scope plugins to specific projects**: To scope plugins to specific projects:

```json
// nx.json
{
  "plugins": [
    {
      "plugin": "@nx/jest/plugin",
      "include": ["packages/**/*"],
      "exclude": ["**/*-e2e/**/*"]
    }
  ]
}
```

- **Vieweing Inferred Tasks**: Run this command: `nx show project my-project --web`
- Read [this](https://nx.dev/docs/concepts/inferred-tasks) to learn more about inferred tasks.

> [!NOTE]
> If you have an existing Nx Workspace and upgrade to the latest Nx version, a migration will automatically set `useInferencePlugins` to `false` in `nx.json`. This property allows you to continue to use Nx without inferred tasks.

### Running Tasks

- Nx uses the following syntax:

  ![[Pasted image 20260603151333.png]]

- Running a single task e.g. running `test` task for the `header` project: `npx nx test header`
- Running tasks for multiple projects:
  - `build` task for all projects: `npx nx run-many -t build`
  - `build`, `lint` and `test` for all projects: `npx nx run-many -t build lint test`
  - `build`, `lint` and `test` for `header` and `footer` projects: `npx nx run-many build lint test -p header footer`
- Running tasks on projects affected by a PR: `npx nx affected -t test`

### Defining a task pipeline

- There maybe an interdependency between various tasks.
- Nx can automatically detect the dependencies between projects ([project graph](https://nx.dev/docs/features/explore-graph)).

![[Pasted image 20260603151916.png]]

- You need to specify for which targets this ordering is important. e.g. in the below configuration, we're telling that before running the `build` target, it needs to run the `build` target on all the projects the current project depends on:

```json
// nx.json
{
  ...
  "targetDefaults": {
    "build": {
      "dependsOn": ["^build"]
    }
  }
}
```

### Reducing repetitive configuration

- We can use `targetDefaults` to reduce repetitive configuration.

### Running root level tasks

- Sometimes, you need tasks that apply to the entire codebase rather than a single project. To still benefit from caching, we can run these tasks through the "Nx pipeline".
- We need to define them in the root-level `package.json` or `project.json` as follows:

```json
// package.json
{
  "name": "myorg",
  "scripts": {
    "docs": "nx exec -- node ./generateDocsSite.js" // 👈 if you want nx to cache the task, but prefer npm (pnpm/yarn) to run the script
  },
  "nx": {} // 👈 necessary to inform nx about this root-level project
}
```

```json
// project.json
{
  "name": "myorg",
  ...
  "targets": {
    "docs": {
      "command": "node ./generateDocsSite.js"
    }
  }
}
```

- To invoke the task: `npx nx docs`

## Caching Task Results

- [Cache Task Results](https://nx.dev/docs/features/cache-task-results) #todo
- [How Caching Works](https://nx.dev/docs/concepts/how-caching-works) #todo

## Generating Code

- [Generate Code](https://nx.dev/docs/features/generate-code) #todo

## Automate Updating Dependencies

- [Reference](https://nx.dev/docs/features/automate-updating-dependencies)
- The Nx migrate functionality provides a way for you to:
  - automatically update your `package.json` dependencies
  - migrate your configuration files (e.g. [[Jest]], [[ESLint]], Nx configuration)
  - adjust your source code to match the new versions of packages (e.g. migrating across breaking changes)
- Run this command: `npx nx@latest migrate latest`

> [!NOTE]
> This will migrate [[Nx]] to the latest version, however, it's better to migrate one step at a time.

### How does it work?

- Nx knows where its configuration files are located and ensures they match the expected format.
- If you leverage plugins, each plugin can provide migrations for it's area of competency.
- When running `nx migrate latest`, Nx parses all the available plugins and their migration files and applies the necessary changes to your workspace.
- e.g. Nx [[React]] plugin defines the following migration script (`./src/migrations/.../add-babel-core`) that runs when upgrading to Nx `16.7.0-beta.2` (or higher):

```json
// migrations.json
{
  "generators": {
    ...
    "add-babel-core": {
       ...
      "version": "16.7.0-beta.2",
      "implementation": "./src/migrations/update-16-7-0/add-babel-core"
    },
  },
}
```

### Steps for migration

- Updating your Nx workspace happens in three steps:

#### Step 1: Update dependencies and generate migrations

- The installed dependencies, including the `package.json` and `node_modules`, are updated.
- Run this: `nx migrate latest`
- This results in:
  - The `package.json` being updated
  - A `migrations.json` being generated if there are pending migrations.
- At this point, no packages have been installed, and no other files have been touched.
- You can inspect the `package.json` and `migrations.json` to see if the changes make sense.

#### Step 2: Run migrations

- Now run the migrations: `nx migrate --run-migrations`
- This might update the source code and configurations in your workspace. However, all the changes are unstaged and can be reviewed.

#### Step 3: Clean up

- After you run all the migrations, you can remove `migrations.json` and commit any outstanding changes.

> [!NOTE]
> You may want to keep the `migrations.json` until every branch that was created before the migration has been merged. Leaving the `migrations.json` in place allows devs to run `nx migrate --run-migrations` to apply the same migration process to their newly merged code as well.

#### Step 4: Update community plugins (optional)

- Update any available community plugins: `nx migrate my-plugin`
- To list all the currently installed plugins: `nx report`

> [!IMPORTANT]
>
> - When you run `nx migrate`, the `nx` package and all the `@nx/` packages get updated to the same version. It is important to keep these versions in sync to have Nx work properly.
> - As long as you run nx migrate instead of manually changing the version numbers, you shouldn't have to worry about it.
> - Also, when you add a new plugin, use `nx add <plugin>` to automatically install the version that matches your repository's version of Nx.

> [!NOTE]
> Sometimes you need to temporarily opt-out from some migrations because your workspace is not ready yet. You can manually adjust the migrations.json or run the update with the --interactive flag to choose which migrations you accept.

- Find more details in the [Advanced Update Process](https://nx.dev/docs/guides/tips-n-tricks/advanced-update) guide.
