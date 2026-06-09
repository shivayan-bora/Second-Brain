---
title: "pnpm Content-Addressable Store"
pillar: software-engineering
type: concept
tags: [pnpm, package-management, filesystem, performance]
status: stable
sources: ["[[pnpm-io-overview]]", "[[mastering-pnpm-workspaces]]"]
created: 2026-06-09
updated: 2026-06-09
---

# pnpm Content-Addressable Store

## Definition

pnpm stores every package version it has ever downloaded in a **content-addressable store** at `~/.pnpm-store` (the global default). Per-project `node_modules` are populated by **hard-linking** files from that store. The result: each version of each package exists *once* on disk, regardless of how many projects use it.

## Why it matters

This is pnpm's headline structural advantage over npm/Yarn. Disk usage stops scaling with the number of projects; installs of already-seen versions are near-instant; and the strict `node_modules` layout it enables prevents [[phantom-dependencies]]. For a developer with 50 projects on their machine, the disk savings are typically 10-30 GB.

## Mechanics

### The store

```
~/.pnpm-store/
└── v3/                       (store version)
    └── files/
        └── 00/
            └── ab12...cdef    (content-hashed file)
```

Each *file* (not each package) is hashed by content and stored once. Two packages that share a README, a license file, or even a JS module produce one copy in the store.

### node_modules population

```
my-project/
└── node_modules/
    ├── react -> ../../../.pnpm-store/v3/files/.../react@18.2.0/
    ├── lodash -> ../../../.pnpm-store/v3/files/.../lodash@4.17.21/
    └── .pnpm/
        ├── react@18.2.0/
        │   └── node_modules/
        │       └── react/    ← hard-linked from the store
        └── lodash@4.17.21/...
```

The actual data lives as **hard links** to the store. Same inode, no duplication.

### Hard links vs copies vs symlinks

- **Hard link** — multiple directory entries pointing to the same inode. Same data, no duplication, but each looks like an independent file.
- **Symlink** — a pointer to another path. Following it goes to the other path; the data isn't there.
- **Copy** — duplicated data.

pnpm uses **hard links** for file content (the data) and **symlinks** for the package directory structure (so each `node_modules` looks isolated).

### What this enables

- **Disk efficiency.** 100 projects using `lodash` = 1 copy on disk, not 100.
- **Fast installs.** Hard-linking is filesystem-level; near-instant once the file is in the store.
- **Strict `node_modules` layout.** Because pnpm controls the symlink structure, it can guarantee each package only sees its declared dependencies — preventing [[phantom-dependencies]].
- **Reproducibility.** Same `pnpm-lock.yaml` + same store version = byte-identical `node_modules` across machines.

## Caveats

- **Filesystems must support hard links.** True for ext4, APFS, NTFS. Some Docker overlay filesystems and network mounts don't.
- **Cross-volume disables it.** Hard links must be on the same filesystem as the source. If the store is on `/home` and the project on a different mount, pnpm falls back to copy mode.
- **Store growth.** The store accumulates every version of every package you've ever installed across all projects. `pnpm store prune` cleans up versions no project references.
- **Permissions surprises.** Editing a file in `node_modules` modifies the store copy too (because they're the same inode). Most build tools don't write into `node_modules`; if yours does, watch out.

## Configuration

- **Store location**: `~/.pnpm-store` by default. Override with `pnpm config set store-dir <path>`.
- **Strict mode**: on by default (default `node-linker: isolated`). Other modes (`hoisted`, `pnp`) trade some of these benefits for different compatibility characteristics.
- **CI optimization**: cache the *store* across CI runs, not just `node_modules` — same content-addressed model means cross-build cache hits.

## Comparison

| | npm | Yarn (classic) | Yarn PnP | pnpm |
|---|---|---|---|---|
| Multiple copies on disk | ✓ | ✓ | ✗ | ✗ |
| Phantom dependencies | ✓ | ✓ | ✗ | ✗ |
| Filesystem layout | Hoisted | Hoisted | None (zip-based) | Strict |
| Install speed (cold) | Slow | Medium | Fast | Fast |
| Install speed (warm, version seen) | Slow | Slow | Fast | Near-instant |

## Related

- [[pnpm-workspaces]] — the higher-level abstraction the store underlies.
- [[phantom-dependencies]] — what the strict layout prevents.
- [[dependency-hoisting]] — npm/Yarn's approach pnpm avoids.

## Sources

- [[pnpm-io-overview]] — covers the structural model.
- [[mastering-pnpm-workspaces]] — disk efficiency framing.
