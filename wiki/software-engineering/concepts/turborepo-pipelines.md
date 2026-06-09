---
title: "Turborepo Pipelines (`turbo.json`)"
pillar: software-engineering
type: concept
tags: [turborepo, monorepo, task-orchestration, configuration]
status: stable
sources: ["[[turborepo-00-understanding-monorepos]]", "[[video-monorepos-fireship]]", "[[video-turborepo-monorepos-explained]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Turborepo Pipelines (`turbo.json`)

## Definition

`turbo.json` is Turborepo's central configuration file — the declaration of which scripts are runnable, what each one depends on, what outputs it produces (and should be cached), and how it interacts with the [[monorepo-package-graph|package graph]]. The structure is task-centric: each top-level entry in `tasks` is a script name that exists in one or more `package.json` files.

## Why it matters

`turbo.json` is the centerpiece of any Turborepo-based monorepo. Reading it tells you what tasks the project understands, how they're ordered, and what gets cached. For PR review and onboarding, it's often more informative than any README.

## Anatomy

```json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],

  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**"]
    },
    "test": {
      "dependsOn": ["^build"],
      "outputs": ["coverage/**"]
    },
    "lint": {
      "dependsOn": ["^lint"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

### Top-level fields

- **`$schema`** — JSON schema URL for editor auto-complete; ignored by Turbo.
- **`globalDependencies`** — files that, if changed, invalidate the entire cache. `.env.*local` is the canonical example; touch any env file and everything re-builds.

### Per-task fields

- **`dependsOn`** — what must run before this task.
  - `"build"` (no caret) — task on the same package; must run before the current task on this package.
  - `"^build"` (with caret) — task on this package's **upstream** dependencies; build all upstream packages first.
  - `"$VAR"` (with dollar) — environment variable that's part of the cache key.
- **`outputs`** — files/directories produced; cached and restored on cache hit. Glob syntax, with `!` for exclusions.
- **`cache: false`** — skip caching this task. Use for `dev`, `start`, anything stateful.
- **`persistent: true`** — declares a long-running task (dev server). Turbo handles cleanup differently.
- **`inputs`** — restrict the cache key to specific files (advanced). Default is "everything in the package."
- **`env`** — environment variables that affect this task's output. Adding `["NODE_ENV"]` makes builds with different `NODE_ENV` produce different cache entries.

## The `dependsOn` syntax in depth

```json
"dependsOn": [
  "^build",      // upstream package builds (most common)
  "compile",     // same-package "compile" task before this one
  "$API_URL"     // declares API_URL as part of the cache key
]
```

The mix of caret / no-caret / dollar lets you express most real-world pipelines. The `dependsOn` is *the* mechanism for "this task needs that one first."

## Common patterns

### "Build upstream first"

```json
"build": {
  "dependsOn": ["^build"]
}
```

When you `turbo run build`, every package's `build` waits for its dependencies' `build` to finish.

### "Test depends on build"

```json
"test": {
  "dependsOn": ["build"]
}
```

Same-package: this package's build must finish before its tests run.

### Combined

```json
"test": {
  "dependsOn": ["^build", "build"]
}
```

Build all upstream first, then this package's own build, then run tests.

### Dev server (no cache, persistent)

```json
"dev": {
  "cache": false,
  "persistent": true
}
```

### Outputs declared correctly

```json
"build": {
  "dependsOn": ["^build"],
  "outputs": [
    ".next/**",
    "!.next/cache/**",     // exclude Next.js's own cache
    "dist/**",
    "build/**"
  ]
}
```

If `outputs` is incomplete, the cache might restore a partial build → silent breakage.

## Running tasks

```bash
turbo run build                # build everything
turbo run build --filter web   # one package
turbo run build --filter='./apps/*'
turbo run build test lint      # multiple targets, parallel
turbo run build --filter='...[main..HEAD]'  # affected since main
```

The `--filter` syntax is rich:
- `web` — package name.
- `./apps/*` — glob path.
- `...[main..HEAD]` — affected since git ref.
- `...web` — `web` and everything it depends on.
- `web...` — `web` and everything that depends on it.

## The "root orchestrates, apps implement" pattern

Per [[turborepo-00-understanding-monorepos]]:

```json
// Root package.json
{
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev"
  }
}
```

```json
// apps/web/package.json
{
  "scripts": {
    "build": "next build",
    "dev": "next dev"
  }
}
```

The root scripts delegate to Turborepo; each app's scripts implement the actual work. The root doesn't know about Next.js; each app doesn't know about Turborepo orchestration.

## Pitfalls

- **Forgetting `outputs`.** Cache hits restore nothing if `outputs` is empty.
- **`outputs` including `node_modules/**` or other dirs that change for unrelated reasons.** Overly broad outputs make caching brittle.
- **`globalDependencies` missing a critical file.** Changes to `tsconfig.base.json` should invalidate everything; if not declared, you'll ship stale builds.
- **Env vars not in `env`.** Builds with different `NODE_ENV` or `API_URL` should produce different cache entries; if not declared, they'll share one and the wrong one wins.

## Related

- [[task-orchestration]] — the broader concept.
- [[monorepo-package-graph]] — what `^` traverses.
- [[remote-caching]] — Turborepo pairs with Vercel for this.
- [[nx-affected]] — Nx's equivalent of `--filter='[main..HEAD]'`.

## Sources

- [[turborepo-00-understanding-monorepos]] — full `turbo.json` walkthrough.
- [[video-monorepos-fireship]] — Turborepo positioning.
- [[video-turborepo-monorepos-explained]] — minimal intro.
