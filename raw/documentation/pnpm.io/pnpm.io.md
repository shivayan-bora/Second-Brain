---
id: pnpm.io
aliases: []
tags:
  - documentation
creation date: 2026-05-31 00:29
modification date: Sunday 31st May 2026 00:29:58
source: https://pnpm.io/
status:
  - in-progress
---

- [Perplexity Chat Thread](https://www.perplexity.ai/search/67921761-dff4-4614-b8df-c4c8e56a9e76?sm=d)

## What is pnpm?

- [[pnpm]](Performant `npm`) is a package manager and a competitor to [[npm]] where it prioritizes fast installation speeds, and a smarter, safer way to manage dependencies.

## Why use pnpm?

### Theo switched package managers from npm to pnpm

- To understand at a high level as to why [[Theo.gg]] uses [[pnpm]] instead, here's a [video from theo.gg](https://www.youtube.com/watch?v=ZIKDJBrk56k)
  - Problems with [[npm]] highlighted:
    - Massive size of `node_modules`.
    - Slowness in installing and managing dependencies.
  - Advantages of [[pnpm]]:
    - Fast install times
      - Especially reinstall times and installing on separate projects when you have some of the dependencies already installed.
    - Readable and minimal lock files written in [[YAML]]: `pnpm-lock.yaml`
      - Diffs well, so in code reviews and [[Github Pull Requests|PRs]], its much less likely to encounter a conflict.
        - Theo mentions where in one PR, he was using a different version of a dependency and his team mate just merged a PR which had another version of dependency. Theo didn't encounter any merge conflicts when he pulled the code.

### What problem pnpm solves?

- `pnpm` exists to solve two main structural problems baked into [[npm]] and classic [[Yarn]].
  - **Disk Waste**: With [[npm]], if 100 projects use [[lodash]], you get 100 physical copies of `lodash` on disk.
  - **Dependency Dishonesty**: [[npm]]'s flat hoisted `node_modules`, where transitive dependencies get lifted to the top level, letting your code `import` packages you never declared, also known as **phantom dependencies**.

#### What is this Dependency Hoisting and Phantom Dependency?

##### Dependency Hoisting

- Consider that your project depends on two packages, `package-a` and `package-b`. These two packages internally depend on `lodash`.
- Now if the dependencies are nested without hoisting:

```
node_modules/
├── package-a/
│   └── node_modules/
│       └── lodash/      ← copy #1
└── package-b/
    └── node_modules/
        └── lodash/      ← copy #2 (duplicate!)
```

- Now what if for optimization, we hoist that dependency at the top level:

```
node_modules/
├── package-a/
├── package-b/
└── lodash/              ← one shared copy, lifted to the top
```

- We can see, if the dependency isn't hoisted, each package will nest it's own copy of shared dependency, in this case `lodash`, causing duplication.
- With hoisting, `npm`/Yarn moves a package to the highest possible level so one copy is shared.
- The benefits are:
  - **Disk Space Savings**: Combines duplicate packages into one.
  - **Faster installation**: Fewer downloads and extractions.
  - **Simplified dependency resolution**: Easy to trace due to the flat structure.

##### Phantom Dependency

- While this optimization does solve issues with disk space and performance, it introduces a new issue, i.e. **phantom dependency**.
- What this means is that once a shared dependency(transitive dependency) sits at the top of the `node_modules`, the [[Node.js]]'s resolver can find it resulting in your code being able to `import` it even though its nowhere there on your `package.json`.
  - The name for this is exactly **phantom dependency**, where the package you rely on are **ghosts** i.e. present on the disk but invisible to your declared dependency.
- Say your `package.json` depends on a UI library:

```json
{
  "name": "my-app",
  "dependencies": {
    "some-ui-library": "^2.0.0"
  }
}
```

- `some-ui-library` depends internally on `lucide-react`. Since `npm` hoists, `lucide-react` (a transitive dependency of `some-ui-library`) gets lifted to the top of `node_modules`:

```
node_modules/
├── some-ui-library/   ← depends on lucide-react internally
└── lucide-react/      ← HOISTED to the root, even though YOU never declared it
```

- Now you can write the following code:

```tsx
// components/Icon.tsx
import { Home } from "lucide-react"; // ⚠️ never added to package.json
```

- This works perfectly on your machine. [[Node.js]] walks up looking for `node_modules/lucide-react`, finds the hoisted copy, and resolves it happily. You'd never know anything was wrong.

###### Why is this being dishonest?

- Your `package.json` is supposed to be your single source of truth when it comes to dependencies.
  - Phantom Dependency effectively makes that a lie since you're able to use a dependency that's not defined in your `package.json`.
- There are different modes of failure for this:
  - **It breaks when the indirect dependency changes**. If `some-ui-library` upgrades and drops `lucide-react`, or pins a different major version, your hoisted ghost vanishes or changes shape — and your import suddenly throws `Cannot find module 'lucide-react'`, even though you changed nothing.
  - **The classic "works on my machine" failure**. Hoisting is non-deterministic in layout across `npm` versions and install orders, so the package that's conveniently hoisted on your laptop may not be on a teammate's machine or in CI — producing builds that pass locally and fail in the pipeline.
  - **Silent version roulette**. You never specified a version for the ghost, so you get whatever version your dependency happened to pull in — and it can shift out from under you on any reinstall.

- Further reading:
  - [Package hoisting and flat module resolution](https://app.studyraid.com/en/read/13159/436734/package-hoisting-and-flat-module-resolution)
  - [ ] [Preventing 'Works on My Machine' Issues: npm Hoisting and Phantom Dependencies Explained](https://zenn.dev/mountain1009/articles/f5b73198393cca?locale=en)

### How does pnpm solve these issues?

- `pnpm` solves the issue of disk space and phantom dependencies both by managing `node_modules` with **hard links and symlinks into a global content-addressable store**.

#### What are Hard links and Symlinks?

- [The Linux Filesystem](https://www.youtube.com/watch?v=lpyKA30GCPY&list=PL6IQ3nFZzWfpvsGBcSATIntBA740LADxW&index=3)
- [Hard Links and Symbolic Links](https://www.youtube.com/watch?v=rQpT0bRpV3Y)
- These links are at the [[Operating System (OS)]] level and `pnpm` uses these for dependency management.

##### Foundation: inode

- On a Unix-style file system, the actual data of a file plus it's metadata lives in a structure identified by an `inode` number; a filename is just a directory entry that maps a human readable name to that `inode`.
- So a filename and the data it represents are two separate things, which is why links are possible.

```bash
ls -i myfile.txt
# 8623104 myfile.txt   ← that number is the inode
```

##### Hard Link: Second name for the same data

- A hard link is an additional directory entry pointing to the exact same `inode` as the original or another name for the identical underlying data, not a copy.
- To any program e.g. [[Node.js]], a hard link is just a regular file. There's nothing link-like about how it behaves:
- Imagine this as a pointer to a file.

```bash
echo "hello" > original.txt
ln original.txt hardlink.txt        # create a hard link (no -s)
ls -i original.txt hardlink.txt
# 8623104 original.txt
# 8623104 hardlink.txt              ← SAME inode → same data
```

- Key behaviors that fall out of sharing an `inode`:
  - Edit the data through either name and both reflect it — same bytes on disk.
  - Delete the original and the data survives, reachable through the remaining hard link; the data is only freed when the link count hits zero.
  - A hard link cannot point to a directory, and cannot cross file systems / partitions, because `inode` numbers are only unique within one file system.

##### Symlink: Small file that stores a path

- A symbolic link (soft link) is a separate file with its own `inode`, whose contents are simply the path to another file — like a shortcut or a web hyperlink.
- It doesn't contain the target's data; it just says "the real thing is over there".
- Imagine this as a pointer to a pointer to a file.

```bash
ln -s /home/shivayan/original.txt symlink.txt   # note the -s
ls -li original.txt symlink.txt
# 8623104 ... original.txt
# 9001234 ... symlink.txt -> /home/shivayan/original.txt   ← different inode, holds a path
```

- Key behaviours:
  - Can point to directories and can cross file systems — both things hard links cannot do.
  - Delete or move the target and the symlink breaks, becoming a "dangling" pointer to nothing.
  - There's "one indirection": the OS reads the path, then goes to resolve it.

#### How pnpm uses both?

- In [[pnpm]], every file of every package in `node_modules` is a hard link to the content-addressable store, and directories are wired together with symlinks to build the nested dependency graph.

##### Why files are hard-linked?

- Hard-linking package files from the store means the same version exists once physically, shared across every project at zero extra disk cost.
- When we do an `ls`, it will show both the files and show their sizes as the same.
  - `ls` reports the size of the `inode`'s data, not the disk space the directory entry consumes — so two names pointing at one `inode` each "report" the full size, but that size is counted only once physically.
- To confirm, do this:

```bash
# du counts each inode's blocks ONCE, even with multiple names:
du -ch original.txt hardlink.txt
#  8.0K  original.txt
#  0      hardlink.txt      ← 0! its blocks were already counted via original
#  8.0K  total              ← total disk used = ONE file's worth, not two

# Contrast with a real copy:
cp original.txt copy.txt
du -ch original.txt copy.txt
# 8.0K  original.txt
# 8.0K  copy.txt            ← a genuine second copy
# 16K   total               ← double the disk
```

- Node treats a hard link as a distinct, real file at its own path.

##### Why are directories symlinked?

- After hard-linking files, `pnpm` lays down symlinks between directories to assemble the dependency tree.
- Here Node's symlink-dereferencing behavior is exactly what `pnpm` wants: when a package is reached through a symlinked directory, Node resolves it to its real location and then finds that package's dependencies sitting beside it.

- Putting it all together, installing `foo@1.0.0` which depends on bar@1.0.0, and pnpm produces:

```
node_modules/
├── foo -> ./.pnpm/foo@1.0.0/node_modules/foo      (SYMLINK — your direct dep)
└── .pnpm/
    ├── foo@1.0.0/node_modules/
    │   ├── foo/    (HARD LINKS to the store — the only "real" files)
    │   └── bar -> ../../bar@1.0.0/node_modules/bar (SYMLINK to foo's dependency)
    └── bar@1.0.0/node_modules/
        └── bar/    (HARD LINKS to the store)
```

- The two design choices pnpm bakes in here are worth calling out:
  - Each package is hard-linked into its own `node_modules` subfolder (`foo@1.0.0/node_modules/foo`) so a package can import itself (e.g. `require('foo/package.json')`) and to avoid circular symlinks.
  - When `foo/index.js` does `require('bar')`, Node ignores the symlink-as-location and resolves bar to its real path `bar@1.0.0/node_modules/bar`, which means `bar` can then resolve its own dependencies sitting in`bar@1.0.0/node_modules`.
- [Further reading](https://www.perplexity.ai/search/67921761-dff4-4614-b8df-c4c8e56a9e76?sm=d#10)

> [!NOTE]
> Every actual file inside `node_modules` is a hard link to the store. `pnpm` uses hard links rather than symlinks for the package files for a specific reason: Node treats a hard link as just an ordinary, real file at its own path, so it resolves that package's own dependencies relative to that path. If the files were symlinked straight to the store, Node would "dereference" them to the store's real path and then fail to find their dependencies, because the store isn't structured as a dependency tree.
>
> But, you cannot hard-link a directory — hard links only work on files. So directories are wired up with symlinks instead, and Node dereferences a symlinked directory to its real location and resolves files from there, which is exactly the behavior `pnpm` wants.

##### How these map into pnpm's commands?

- `file`: protocol in dependencies → the linked local package is hard-linked into your `node_modules`, and `pnpm` installs its dependencies, overriding the linked package's own `node_modules`; recommended when peer dependencies are involved because it resolves them from your project.
- `pnpm link` → the package is symlinked from its source, changes reflect live, but `pnpm` does not install the linked package's dependencies — you manage those yourself.
- [Reference](https://www.perplexity.ai/search/67921761-dff4-4614-b8df-c4c8e56a9e76?sm=d#11)

#### Global Content Addressable Store

- There are three layers to it effectively:
  - The content-addressable store (CAS) — one physical copy of every file, ever, on your machine.
  - The virtual store (`.pnpm`) — the dependency-graph "scaffolding" built from links into the CAS.
  - The project `node_modules` top level — symlinks to just your direct dependencies.

##### Layer 1: Content-Addressable Store (CAS)

- A content-addressable store means `pnpm` stores each file on disk indexed by a hash of that file's contents, not by package name. The "address" of a file is its content — identical content always maps to the same location, so it can only ever be stored once.
- The data structure is essentially a giant hash map: `hash(file_contents)` → file on disk. Two powerful properties follow directly:
  - File-level deduplication. If a new version of `lodash` changes only 1 of its 100 files, only that 1 new file's hash is new, so `pnpm update` adds just 1 file; the other 99 hashes already exist and are reused.
  - One physical copy, globally. All files live in a single place, and installs link to them rather than copying, consuming no additional disk space. Linking uses hard links or reflinks (copy-on-write clones).
- Run `pnpm store path` to see where it lives (e.g. `/Users/shivayan/Library/pnpm/store/v10`).

##### Layer 2: The virtual store (.pnpm) — the bridge

- The CAS stores files as a flat hash bucket which means nothing to [[Node.js]], since it needs a real dependency tree to resolve modules.
- The virtual store (`.pnpm`) bridges that gap.
- This folder is created by default inside each project's `node_modules`. This acts as the virtual store as it contains hard links to files in CAS.
  - The file contents exist only once on disk (in the CAS), but the directory structure is recreated per project so that Node.js's module-resolution algorithm can find the right dependencies for each package.

```
CAS (hash → file, one copy)
   ↑ hard links
.pnpm/ virtual store  (real directory tree Node can resolve)
   ↑ symlinks
node_modules/ top level (your direct deps only)
```

##### Layer 3: Linking it together

- Every file of every package inside `node_modules` is a hard link to the content-addressable store; once all packages are hard-linked in, symbolic links are created to build the nested dependency-graph structure.
- Why the split though?
  - Node treats a hard link as a genuinely different, real file, so it resolves that package's dependencies relative to the file's own location rather than redirecting to the store — which is exactly why `pnpm` hard-links files instead of symlinking them.
  - Directories, which can't be hard-linked, are symlinked, and Node helpfully dereferences a symlinked directory to its real location to resolve files.

> [!NOTE]
> Q: Does a project with its own `package.json` NOT create `node_modules` and pick up deps from the CAS via config?
>
> A: It still creates a `node_modules` folder. The nuance is what's inside it and that depends on which mode we're in:
>
> - **Default (classic) mode**: the project gets its own `node_modules`, including its own `node_modules/.pnpm` virtual store whose files are hard links into the global CAS. So the file bytes come from the global store, but each project rebuilds its own `.pnpm` directory tree.
> - **Global Virtual Store mode (`enableGlobalVirtualStore: true`, introduced in v10.12)**: instead of each project having its own `node_modules/.pnpm`, `pnpm` maintains a single shared virtual store at `<store-path>/links/`, and each project's `node_modules` contains only symlinks pointing into that shared location. There's no per-project `.pnpm` directory, and identical dependency graphs are shared across projects for massive disk savings.

### Reasons to use pnpm

#### Saving disk space

![[Pasted image 20260531170315.png]]

- When using `npm`, if you have 100 projects using a dependency, you will have 100 copies of that dependency saved on disk. With `pnpm`, the dependency will be stored in a content-addressable store, so:
  - If you depend on different versions of the dependency, only the files that differ are added to the store. For instance, if it has 100 files, and a new version has a change in only one of those files, `pnpm` update will only add 1 new file to the store, instead of cloning the entire dependency just for the singular change.
  - All the files are saved in a single place on the disk. When packages are installed, their files are hard-linked from that single place, consuming no additional disk space. This allows you to share dependencies of the same version across projects.

#### Boosting installation speed

- `pnpm` performs installation in three stages:
  - **Dependency resolution**: All required dependencies are identified and fetched to the store.
  - **Directory structure calculation**: The `node_modules` directory structure is calculated based on the dependencies.
  - **Linking dependencies**: All remaining dependencies are fetched and hard linked from the store to `node_modules`.

#### Create a non-flat node_modules directory

- When installing dependencies with `npm` or Yarn Classic, all packages are hoisted to the root of the modules directory. As a result, source code has access to dependencies that are not added as dependencies to the project.
- By default, `pnpm` uses symlinks to add only the direct dependencies of the project into the root of the modules directory.

![[Pasted image 20260531170720.png]]

- Further Reading:
  - [Flat node_modules is not the only way](https://pnpm.io/blog/2020/05/27/flat-node-modules-is-not-the-only-way)
  - [Symlinked node_modules structure](https://pnpm.io/symlinked-node-modules-structure)
  - [Global Virtual Store](https://pnpm.io/global-virtual-store)

#### Peer dependency collision fixes

- A package's behavior can depend on which version of a peer it's paired with, `pnpm` may create multiple resolved variants of the same package, encoded in the `.pnpm` folder name.

```
.pnpm/
├── react-dom@18.2.0(react@18.2.0)/
└── some-lib@2.0.0(react@17.0.0)/
```

- The part in parentheses records the peer context that variant was resolved against, so two packages depending on different peer versions each get a correctly-wired copy without collision.

#### Ease in the Build Process

- Imagine you have an application with the structure like this:

![[Pasted image 20260531192314.png]]

- Here's the dependency chain: `react`, `hono` and `database` depend on the `schema` for validations and `hone` depends on the `database` since it needs to perform CRUD operations on the database.
- That would mean, we need to build `schema` first, then `database` and `react` can be built in parallel and then in the end, we build `hono`.
- When we run `pnpm -r run build`, `pnpm` will perform a [[Topological Sort]] on the dependencies and generate a dependency graph which it will use to build the project exactly in the above sequence.
  - _TLDR_ Topological sorting is putting the nodes of a directed acyclic graph in an order where every dependency comes before the package that depends on it.
    ![[Pasted image 20260531192927.png]]

- Regardless of Topological Sort, if you want to run the applications in parallel: `pnpm --parallel run dev`
- If you want to run a command for specific packages: `pnpm --filter "./packages/*" run dev` => Run the `dev` command on all packages inside the `packages` folder.

- Reference: [pnpm Workspaces Explained](https://www.youtube.com/watch?v=-Dq1Gj9S8ew)

## Configuration knobs that matter

- `pnpm` reads configuration from the CLI, environment variables, `.npmrc` and `pnpm-workspace.yaml`.
  - `node-linker`: `isolated` (default, the symlinked layout), `hoisted` (`npm`-style flat `node_modules` for tools that can't handle symlinks, like some React Native setups), or `pnp` (Yarn-PnP-style).
  - `shamefully-hoist`: hoists everything to the top level for legacy tools that rely on phantom deps; an escape hatch you should avoid unless forced.
  - `store-dir`: where the global content-addressable store lives.
  - `dependencies` are saved strictly: `pnpm` add always records to `package.json`, and `pnpm prune` always removes all extraneous/orphaned packages with no way to cherry-pick.

## Workspaces

- `pnpm` has a built-in [[Monorepo]] support via a `pnpm-workspace.yaml` file (which must be at the root) that lists which folders are packages:

```yaml
#pnpm-workspace.yaml
packages:
  - "apps/*"
  - "packages/*"
```

- Inside the monorepo, packages reference each other using the `workspace:` protocol, which tells `pnpm` to link the local package rather than fetch from the repository:

```json
{
  "name": "@acme/web",
  "dependencies": {
    "@acme/ui": "workspace:*"
  }
}
```

- When you run `pnpm install` at the root, `pnpm` builds one shared store-backed install for the whole repo and symlinks local packages into each other's `node_modules`.
- Editing `@acme/ui` is instantly reflected in `@acme/web` because they're linked, not copied.
- On `pnpm publish`, the `workspace:*` specifier is automatically rewritten to the real version number.
- Related `file:` dependencies are symlinked (and for `file:` `pnpm` hard-links and installs the linked package's deps), while `pnpm link` only symlinks source without installing its deps — useful but trickier with peers.

### pnpm-workspace.yaml

- Defines the root of the workspace and enables you to include / exclude directories from the workspace.
- If the `packages` field is ommitted, only the root package is included in the workspace.
- Read more about [Settings in pnpm-workspace.yaml](https://pnpm.io/settings).

```yaml
packages:
  # specify a package in a direct subdir of the root
  - "my-app"
  # all packages in direct subdirs of packages/
  - "packages/*"
  # all packages in subdirs of components/
  - "components/**"
  # exclude packages that are inside test directories
  - "!**/test/**"
```

#### Workspace Protocol (workspace:)

- If `linkWorkspacePackages` is set to `true`, `pnpm` will link packages from the workspace if the available packages match the declared ranges.
  - e.g. `foo@1.0.0` is linked into `bar` if `bar` has `"foo": "^1.0.0"` in its dependencies and `foo@1.0.0` is in the workspace.
  - However, if `bar` has `"foo": "2.0.0"` in dependencies and `foo@2.0.0` is not in the workspace, `foo@2.0.0` will be installed from the registry. This behavior introduces some uncertainty.
- Luckily, `pnpm` supports the `workspace:` protocol. When this protocol is used, `pnpm` will refuse to resolve to anything other than a local workspace package.
  - Therefore, if you set `"foo": "workspace:2.0.0"`, this time installation will fail because `foo@2.0.0` isn't present in the workspace.
- This protocol is especially useful when the `linkWorkspacePackages` option is set to `false`. In that case, `pnpm` will only link packages from the workspace if the `workspace:` protocol is used.

##### Referencing Workspace Packages via Aliases

- If you have a package in the workspace named `foo`, you would reference it as `"foo": "workspace:*"`.

##### Referencing Workspace Packages via Relative Path

- In a workspace with two packages:

```
+ packages
	+ foo
	+ bar
```

- `bar` may have `foo` in its dependencies declared as `"foo": "workspace:../foo"`.

##### Publishing Workspace Packages

- When a workspace package is packed into an archive (whether it's through `pnpm pack` or one of the publish commands like `pnpm publish`), we dynamically replace any `workspace:` dependency by:
  - The corresponding version in the target workspace (if you use `workspace:`, `workspace:*`, `workspace:~`, or `workspace:^`)
    - A bare `workspace:` without a version range is treated as `workspace:*`.
  - The associated `semver` range (for any other range type)
- e.g. if we have `foo`, `bar`, `qar`, `zoo` in the workspace and they all are at version `1.5.0`, the following:

```json
{
  "dependencies": {
    "foo": "workspace:*",
    "bar": "workspace:~",
    "qar": "workspace:^",
    "zoo": "workspace:^1.5.0"
  }
}
```

- Will be transformed into:

```json
{
  "dependencies": {
    "foo": "1.5.0",
    "bar": "~1.5.0",
    "qar": "^1.5.0",
    "zoo": "^1.5.0"
  }
}
```

- This feature allows you to depend on your local workspace packages while still being able to publish the resulting packages to the remote registry without needing intermediary publish steps - your consumers will be able to use your published workspaces as any other package, still benefitting from the guarantees semver offers.

#### packageConfigs

- Allows setting project-specific configuration for individual workspace packages. This replaces workspace project-specific `.npmrc` files.
- `packageConfigs` can be specified as a map of package names to `config` objects:

```yaml
packages:
  - "packages/project-1"
  - "packages/project-2"
packageConfigs:
  "project-1":
    saveExact: true
  "project-2":
    savePrefix: "~"
```

- Or as an array of pattern-matched rules:

```yaml
packages:
  - "packages/project-1"
  - "packages/project-2"
packageConfigs:
  - match: ["project-1", "project-2"]
    modulesDir: "node_modules"
    saveExact: true
```

#### Catalog

- [To read about catalogs](https://pnpm.io/catalogs)

#### Configuration Dependencies

- These allow you to share and centralize configuration files, settings and hooks across multiple projects.
- They are installed before all regular dependencies (`"dependencies"`, `"devDependencies"`, `"optionalDependencies"`), making them ideal for setting up custom hooks, patches, and catalog entries.
- Config dependencies help you keep all the hooks, settings, patches, overrides, catalogs, rules in a single place and use them across multiple repositories.
- If your config dependency is named following the `pnpm-plugin-*`, `@*/pnpm-plugin-*`, or `@pnpm/plugin-*` pattern, `pnpm` will automatically load its `pnpmfile.mjs` (falling back to `pnpmfile.cjs`) from the package root.
- Config dependencies are defined in your `pnpm-workspace.yaml`. Their integrity checksums are stored in `pnpm-lock.yaml` (in a dedicated `env` lockfile document).
- For example, running `pnpm add --config my-configs` will add this entry to your `pnpm-workspace.yaml`:

```yaml
configDependencies:
  my-configs: "1.0.0"
```

> [!IMPORTANT]
>
> - Config dependencies cannot have their own regular dependencies. They can declare `optionalDependencies`, but only one level deep — `optionalDependencies` of `optionalDependencies` are ignored.
> - Config dependencies cannot define lifecycle scripts (like `preinstall`, `postinstall`, etc.).

## .pnpmfile.mjs

- Lets you hook directly into the installation process via special functions (hooks).
- These hooks can be declared in a file called `.pnpmfile.mjs`([[JavaScript ES6 Modules]]) or `.pnpmfile.cjs`([[CommonJS]]).
- By default, `.pnpmfile.mjs` should be located in the same directory as the lockfile. For instance, in a workspace with a shared lockfile, `.pnpmfile.mjs` should be in the root of the monorepo.
- Read more about [.pnpmfile.mjs](https://pnpm.io/pnpmfile)

### Hooks

- `hooks.readPackage(pkg, context): pkg`
  - Process: Called after `pnpm` parses the dependency's package manifest
  - Usage: Allows you to mutate a dependency's `package.json`
- `hooks.afterAllResolved(lockfile, context): lockfile`
  - Process: Called after the dependencies have been resolved.
  - Usage: Allows you to mutate the lockfile.
- `hooks.beforePacking(pkg): pkg`:
  - Process: Called before creating a tarball during pack/publish
  - Usage: Allows you to customize the published `package.json`
- `resolvers`:
  - Process: Called during package resolution
  - Usage: Allows you to register custom package resolvers
- `fetchers`:
  - Process: Called during package fetching.
  - Usage: Allows you to register custom package fetchers.

## Aliases

- Aliases lets you install packages with custom names.
- Imagine `lodash` is being used all over your project and you encounter a bug in it which is a breaking bug. You have a fix but `lodash` won't fix it. You have two options here:
  - Install `lodash` from your fork directly (as a git-hosted dependency)
  - Publish it with a different name: In this case, you would need to replace all its references with the new package name.
- You can publish a new package named `awesome-lodash` and install it using `lodash` alias:

```bash
pnpm add lodash@npm:awesome-lodash
```

- If you want to use two different versions of a package in your project:

```bash
pnpm add lodash1@npm:lodash@1
pnpm add lodash2@npm:lodash@2
```

- This gets even more powerful when combined with hooks. Maybe you want to replace `lodash` with `awesome-lodash` in all the packages in `node_modules`. You can easily achieve that with the following `.pnpmfile.mjs`:

```js
function readPackage(pkg) {
  if (pkg.dependencies && pkg.dependencies.lodash) {
    pkg.dependencies.lodash = "npm:awesome-lodash@^1.0.0";
  }
  return pkg;
}

export const hooks = {
  readPackage,
};
```
