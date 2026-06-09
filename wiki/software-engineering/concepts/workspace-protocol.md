---
title: "Workspace Protocol (`workspace:*`)"
pillar: software-engineering
type: concept
tags: [pnpm, yarn, monorepo, dependency-management]
status: stable
sources: ["[[mastering-pnpm-workspaces]]", "[[pnpm-io-overview]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Workspace Protocol (`workspace:*`)

## Definition

The **workspace protocol** is a special version specifier in `package.json` that tells the package manager "this dependency is an in-monorepo workspace package — resolve to the local copy via symlink rather than the npm registry." pnpm, Yarn (2+), and Bun support it; npm does not (as of the time of source ingestion).

```json
{
  "dependencies": {
    "@workspace/ui": "workspace:*"
  }
}
```

## Why it matters

Without the workspace protocol, intra-monorepo dependencies have to be expressed either as relative file paths (which break publishability) or as registry versions (which require publishing every shared package to the registry before each consumer can use it). The protocol gives you the best of both: local linking during development + publishability without rewriting `package.json` at build time.

## Mechanics

### The specifier shapes

```json
"@workspace/ui": "workspace:*"      // any version in the workspace — most common
"@workspace/ui": "workspace:^1.0"   // SemVer-compatible; pinned at publish time
"@workspace/ui": "workspace:~1.0"   // ~ range; pinned at publish time
"@workspace/ui": "workspace:1.0.0"  // exact pin; rewritten to "1.0.0" at publish
```

### How the resolution works

1. At `pnpm install`, the package manager sees `workspace:*` and looks for a workspace package matching the dep name (`@workspace/ui`).
2. It creates a symlink in `node_modules` pointing to the in-monorepo package.
3. Your code's `import { Button } from '@workspace/ui'` resolves through the symlink to the live source/dist.

### At publish time

When you publish a workspace package to npm, the package manager **rewrites** `workspace:` specifiers to the actual published version:

- `workspace:*` → `^1.2.3` (the version of `@workspace/ui` at the time)
- `workspace:^1.0` → `^1.0.0`
- `workspace:1.0.0` → `1.0.0` (already a pin)

So the published `package.json` looks normal — registry consumers see regular SemVer ranges.

## Why not just use file paths?

```json
"@workspace/ui": "file:../packages/ui"
```

This works for local development but:

- **Not publishable.** Cannot be rewritten to a registry version automatically.
- **Brittle paths.** Moving the consumer breaks the link.
- **Doesn't deduplicate.** Each consumer gets its own copy of dependent files.
- **Lockfile noise.** Different paths for different consumers.

The workspace protocol is the proper solution for monorepo dep linking.

## Why not just use SemVer ranges?

```json
"@workspace/ui": "^1.0.0"
```

This requires you to publish `@workspace/ui@1.0.0` to npm before consumers can install it. For internal-only packages or rapid iteration, this is painful — every shared-package change requires a publish before consumers see it. Workspace protocol short-circuits this for in-monorepo packages.

## When you want `workspace:*` vs `workspace:^1.0`

- **`workspace:*`** — always link to whatever's in the workspace, regardless of declared version. Best for monorepos where everything moves together.
- **`workspace:^1.0`** — link to the workspace package, but pin a SemVer range at publish time. Best when packages will be published independently and consumers should pin a specific compatible range.

## Common pitfalls

- **npm doesn't support it** (as of source ingestion date). Migrating to npm from pnpm/Yarn would require rewriting workspace specifiers.
- **Some publishing tools strip workspace specifiers wrongly.** Always test `npm pack` or `pnpm pack` before publishing to verify the rewritten output.
- **Mixed `workspace:*` and SemVer in the same monorepo** is legal but confusing. Pick a convention.

## Related

- [[pnpm-workspaces]] — the broader context.
- [[monorepo-package-graph]] — workspace deps are what the graph traverses.

## Sources

- [[mastering-pnpm-workspaces]] — `"@workspace/ui-components": "workspace:*"` examples throughout.
- [[pnpm-io-overview]] — workspace-protocol mention.
