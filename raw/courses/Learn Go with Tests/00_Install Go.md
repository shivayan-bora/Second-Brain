---
creation date: 2026-06-01 20:58
modification date: Monday 1st June 2026 20:58:04
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 00_Install Go
---

## Install Go

- [Github Repository](https://github.com/shivayan-bora/Learn-Go-With-Tests)
- Run the command: `go mod init shivayan-bora/Learn-Go-With-Tests`

## Go Modules

- [[Go]] `v1.11` introduced [[Go Modules]] and this is the default build mode since `v1.16` and the use of `GOPATH` is no longer recommended.
- Modules aim to solve problems related to dependency management, version selection and reproducible builds.
- They also enable users to run Go code outside of `GOPATH`.
- To use Go modules, initialize your project with running the following command at the root:

```bash
go mod init <modulepath>
```

- If no `<modulepath>` is specified, the command will try to guess the module path from the directory structure.
- This generates a `go.mod` file which is similar to `package.json` in [[Node.js]] projects or `requirements.txt` for [[Python]] projects.

```go
module shivayan-bora/Learn-Go-With-Tests

go 1.26.3
```
