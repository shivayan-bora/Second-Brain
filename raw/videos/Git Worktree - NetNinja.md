---
id: Git Worktree - NetNinja
aliases: []
tags:
  - video
creation date: 2026-05-22 14:50
modification date: Friday 22nd May 2026 14:50:04
source: https://www.youtube.com/playlist?list=PL4cUxeGkcC9iUtQh7Aja3TGfbdd7Z-K0W
status:
  - in-progress
---

## What are Git Worktrees?

- A [[Git Worktrees|worktree]] is a folder which contains a checked-out version of a project.
  - Each worktree is tied to its own branch, which can include uncommitted changes.

## Why use Git Worktrees?

- When we clone a [[Git Repository|repository]] to our local machine, we get:
  - The `.git` folder which contains information about the repository like [[Git Commits|commits]], [[Git Branch|branches]], full project history, etc.
  - The default worktree which contains the project files that are checked out usually at the latest commit on the default branch, i.e. the main branch.

![[Pasted image 20260522145451.png]]

- If we're working on a new feature, we would create a new feature branch and make our code changes as shown below:

![[Pasted image 20260522150317.png]]

- Now, for whatever reason, if we want to go back to the main branch or work on a new feature, we would have to [[Git Commit|commit]] our changes or [[Git Stash|stash]] them before switching branches.
- Another option is to create a [[Git]] worktree. With this we don't have to switch branches within the same working directory anymore
  - We can just add a new worktree, checkout a new branch inside that worktree and work on that branch without affecting the other worktree and once we're done, we can get back to the main worktree and continue working on the main branch without any issues.

![[Pasted image 20260522163249.png]]

- Each worktree still shares the same [[Git History]], the same commits and the same [[Git Remote|remotes]] and so on.
  - This means worktrees gives us a different views of the same project using the same instance of the repository and don't duplicate anything.
  - A single fetch from any worktree updates everything.
- Git stops you from checking out the same branch twice within those different worktrees.

## Working with Git Worktree

### Cloning a Bare Repository

- First of all, we need to clone the [[Git Repository|repo]] and it's a good standard to clone using the `--bare` flag: `git clone https://github.com/iamshaunjp/portfolio-worktrees.git --bare`
  - This is a [[Git Bare Repository|bare repository]] which only downloads the `.git` folder and nothing else.

![[Pasted image 20260522184338.png]]

- This will however clone the bare repo in the current path.
- We need to create a folder and inside we need to run the clone command and put the bare repo inside a `.git` folder as follows:

```bash
git clone https://github.com/iamshaunjp/portfolio-worktrees.git --bare .git
```

![[Pasted image 20260522191712.png]]

- We can then add the `main` worktree via this: `git worktree add main` which will create a new folder with the `main` branch [[Git Checkout|checked out]].

### Add a Worktree

- Imagine you have to work on a new feature. So you create a new worktree as follows:

```bash
git worktree add -b <branch-name> <worktree-path> <remote>/<main-branch>

# in this case
git worktree add -b feature-a feature-a origin/main
```

- `-b` is for creating a new branch.
- If you're inside the `main` branch, the path to the new worktree would be `../feature-a`.
- If you create a new worktree branch from another, the new worktree branch will start from the latest commit of the other worktree branch i.e. the new worktree will start from the current `HEAD`.
- You then need to manually go to the worktree folder and start working on the new branch.
- You can now do your work and commit your changes in the new worktree without affecting the main worktree.

### Check available Worktrees

- To check all available worktrees:

```bash
git worktree list
```

### Deleting a Worktree

- To delete a worktree, you can use the following command:

```bash
git worktree remove <worktree-path>
```

- Git protects us from deleting the main worktree, so you can't delete the main worktree.
- You can't also delete a worktree if there are uncommitted changes in that worktree, so you need to either commit or stash those changes before deleting the worktree.
  - You can use the `-f` flag to force delete a worktree with uncommitted changes, but be careful with that as it will delete all those changes without any warning.

```bash
git worktree remove -f <worktree-path>
```
