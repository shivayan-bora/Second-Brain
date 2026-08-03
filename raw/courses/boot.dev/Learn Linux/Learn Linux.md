---
id: Learn Linux
aliases: []
tags:
  - course
creation date: 2026-06-25 19:22
modification date: Thursday 25th June 2026 19:22:54
source: https://www.boot.dev/courses/learn-linux
status:
  - in-progress
---

## Few Basic Terminologies

- Historically, a **Terminal** is a physical interface, usually with a keyboard and a monitor, that allows us to to write and give commands to a computer.
- These days, a terminal usually means a **Terminal Emulator**, which is emulates a physical terminal.
  - Basically it's a software/program that allows us to type commands into a window on our computer.
- **Shell** is a software/program that runs the above commands.
  - Shells do a lot of things, but their main job is to interpret the commands you type and execute them.

## Shell

- Shells are often referred to as "REPLs." **REPL** stands for
  - Read
  - Evaluate
  - Print
  - Loop
- This is a fancy way of saying that shells are programs that:
  - Read the commands you type
  - Evaluate those commands, usually by running other programs on your computer
  - Print the output of those commands
  - Give you a new prompt to type another command and repeat
- Some examples of shells are [[bash]], [[zsh]], [[fish]] etc.
- Both Bash and zsh are shells, and they also happen to be powerful programming languages. They have variables, functions, loops, and more.
- Shells are optimized for running other programs and writing small scripts, not for writing large applications.

### Variables

- Create a variable:

```bash
$ name="Shivayan"
```

- In `fish`:

```fish
$ set name "Shivayan"
```

- Using the variable:

```fish
$ echo $name
Shivayan
```

- Interpolation of a variable in a string:

```fish
$ echo Hello, $name
Hello, Shivayan
```

### History

- To check the history of commands that you ran, run `history`.
- You can press up and down arrows to scroll through the history in the CLI.

### Clear

- You can type `clear` or press `ctrl + l` to clear the terminal.

## File System

![[Pasted image 20260626203117.png]]

- A file is a dump of raw binary data i.e. 0's and 1's.
  - The bytes in a file can represent anything like documents, audio, video, images etc.
- Directories (or folders in Windows) are containers for other directories files in your system.
- All files and directories are organised into a tree like structure starting with the root directory at the top.
- To check which directory you're currently in, type `pwd`, short for present working directory.
- `pwd` outputs the filepath which is a string describing the location of a file or a directory on your computer. It looks something like this:

```bash
/Users/wagslane
```

- The first slash (/) represents the root directory.
- The next part (Users) is the name of a directory inside the root directory.
- Finally, the last part (`wagslane`) is the name of a directory inside the Users directory.
- So this path represents a directory 2 levels down from the root directory:

```bash
root
  └── Users
        └── wagslane
```
