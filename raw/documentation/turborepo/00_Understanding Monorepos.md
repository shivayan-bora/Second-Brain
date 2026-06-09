---
creation date: 2026-06-02 18:18
modification date: Tuesday 2nd June 2026 18:18:25
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 00_Understanding Monorepos
---

## Case for Monorepos

- You're building a platform with a marketing site, a web app, and documentation. Each shares UI components, utilities and [[TypeScript]] configurations.
- Managing them as separate repository means:
  - Coordinating changes across repositories
  - Keeping dependencies in sync manually
  - Copying configurations everywhere
- [[Monorepo]]s solve this problem by bringing related projects into a single repository where it can reuse configurations, UI components and utilities while maintaining clear boundaries and enabling powerful tooling.

### Polyrepo vs Monorepo

- **Monorepos**: Multiple related apps sharing code
- **Polyrepos**: Truly independent projects with different stacks/teams
- Where polyrepo shines in autonomy and independence it suffers in coordination.
- If there's a change in dependency or configuration which spans across multiple repositories, monorepos can shine there a lot.
- So here's the key points to consider:
  - **Coordination Tax**: Time and effort spent synchronizing changes across repositories
  - **Atomic changes**: Updating interface and all consumers in one commit
  - **Version Dependency Chaos**: Managing npm versions across multiple repos
  - **[[TypeScript]] Verification**: Compiler catches all breaking changes instantly in a monorepo
- Choose Monorepos When:
  - Multiple related apps share code (UI components, utilities, configs)
  - You make frequent cross-project changes
  - You want atomic commits across project boundaries
  - Consistent tooling matters (TypeScript, ESLint, tests)
- Choose Polyrepos When:
  - Projects are completely independent (no shared code)
  - Different tech stacks that can't share tooling
  - Strict access control (teams can't see each other's code)
  - Different teams, different release cycles, zero coordination

> [!IMPORTANT]
> **Rule of thumb**: If your projects share more than just configs, monorepo likely fits. If they're truly independent, polyrepo might work better.

> [!NOTE]
> Splitting a monorepo into separate repos is painful but possible. Merging multiple repos while preserving git history can be challenging.
>
> Start with a monorepo. If it doesn't fit, you'll know quickly and can adjust.

## Deploy to vercel

- This link will fork the GeniusGarage starter code and deploy it to production: [Deploy GeniusGarage](https://vercel.com/new/clone?repository-url=https://github.com/vercel/production-monorepos-starter&project-name=geniusgarage&repository-name=geniusgarage&root-directory=apps/web)
- [[Vercel]] detects this is a monorepo built with [[Turborepo]], deploys it and enables Turborepo's intelligent Remote Caching. This means when we push changes to [[GitHub]], Vercel will automatically rebuild and deploy only what's changed.
- [Repository](https://github.com/shivayan-bora/geniusgarage/)
- [Vercel Project](https://vercel.com/shivayanboras-projects/geniusgarage/6FpSnxRtVF8zekNdPe69vvzLxTSp#L13)
- [Deployed URL](https://geniusgarage-git-main-shivayanboras-projects.vercel.app/)

## Monorepo Structure

```
  geniusgarage/
  ├── apps/                   # Deployable applications
  │   └── web/                # The marketing site (Next.js app)
  ├── .gitignore
  ├── package.json            # Root workspace config
  ├── pnpm-lock.yaml          # Dependency lockfile
  ├── pnpm-workspace.yaml     # Workspace definition
  ├── README.md               # Project README
  └── turbo.json              # Task orchestration (Turborepo config)
```

## Important Files

### pnpm-workspace.yaml

```yaml
packages:
  - "apps/*"
  - "packages/*"
```

- Every directory under `apps` and `packages` is a workspace package.

### Root package.json

```json
{
  "name": "geniusgarage",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev",
    "lint": "turbo run lint",
    "format": "prettier --write \"**/*.{ts,tsx,md}\""
  },
  "devDependencies": {
    "prettier": "^3.2.5",
    "turbo": "^2.3.3"
  },
  "packageManager": "pnpm@9.1.0",
  "engines": {
    "node": ">=20.9.0"
  }
}
```

- Only `turbo` and `prettier` defined in the root.
- All scripts point to `turbo run <task>` where Turborepo orchestrates everything.

### Apps/web/package.json

```json
{
  "name": "@geniusgarage/web",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^16.0.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  },
  "devDependencies": {
    "@types/node": "^22",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "eslint": "^9",
    "eslint-config-next": "^16.0.0",
    "typescript": "^5"
  }
}
```

- `@geniusgarage/web`: Namespaced package name
- `Next.js` listed as a dependency
- Standard scripts and no `turbo run` scripts

> [!IMPORTANT]
> The pattern to recognize here is that the **root orchestrates and apps implement**.

## Key Characteristics

- Vercel automatically detects the monorepo and built it correctly.
- Remote caching enabled: Future builds will be faster
- Independent deployments: Each app can deploy separately despite living together.

## Turbo Cache

- Turborepo has two cache layers:
  - A local cache (`.turbo/cache/`)
  - a remote cache (shared across machines/CI via an HTTP backend like Vercel).
- **Remote caching** adds value when you have other machines (teammates, CI, preview deploys) that should be able to skip work already done elsewhere.
- To check if a project is linked to a remote cache provider or not, these are the three signals we should look for:
  - No `.vercel` directory in the repo root: `turbo link` would created one with a `project.json` pointing to a Vercel team + project.
  - No `~/.turbo` directory in home folder: `turbo login` will store an auth token there.
  - No `TURBO_TOKEN` / `TURBO_TEAM` environment variables set.
- So when `turbo run build` starts, it checks "do I have credentials for a remote cache?" → no → prints Remote caching disabled and falls back to local-only.
- Turbo's cache is content-addressed: it hashes source files + dependencies + environment variables + configurations.
- Key concepts:
  - Hashing inputs: Turborepo hashes source + deps to create cache key
  - Cache hit: Same hash = restore from cache instantly
  - Cache miss: Different hash = rebuild and create new cache
  - Selective rebuilding: Only changed packages rebuild, others use cache

![[Pasted image 20260603012439.png]]

### turbo.json

```json
{
  "$schema": "https://turbo.build/schema.json", // 👈 pulls in schema mostly for auto-complete in code editors, ignored by Turborepo
  "globalDependencies": ["**/.env.*local"], // 👈 Tells turbo to invalidate all it's cache

  "tasks": {
    // 👇 Each entry is a key which is a script inside one or more package's package.json
    "build": {
      // 👇 This task depends on the same-named task in all upstream workspace dependencies or "dependencies' build tasks"
      "dependsOn": ["^build"], // 👈 Before building this package, build all packages it depends on first
      // 👇 What to cache
      "outputs": [".next/**", "!.next/cache/**"] // 👈 ignore Next.js internal cache
    },
    "lint": {
      // 👇 lint upstream packages first
      "dependsOn": ["^lint"]
    },
    "dev": {
      // 👇 Never cache dev
      "cache": false,
      // 👇 this task does not exit on its own, it's a long-running watcher (Next.js dev server, in this case)
      "persistent": true
    }
  }
}
```
