---
creation date: 2026-04-24 11:37
modification date: Friday 24th April 2026 11:37:14
tags:
  - chapter
status:
  - in-progress
---

## TypeScript's Relationship with JavaScript

- [[TypeScript]] is syntactic sugar sprinkled on top of [[JavaScript]] (also known as a superset of [[JavaScript]]), to help build stronger, performant and robust applications.
	- Browsers don't understand [[TypeScript]] and it needs to get compiled down to [[JavaScript]] to run your code.
- The tooling for [[JavaScript]] is quite shitty and even though IDEs helped, you didn't have features available like in other [[Statically Typed Programming Languages|typed]] languages like:
	- autocomplete
	- type checking
- This implies as the application grew bigger, [[JavaScript]]was quite difficult to work with and if you had to do any refactors, you'd have to do that entirely manually.
- At [[Microsoft]] in 2010, [[C#]] was used in the form of [[ScriptSharp]] to allow people to write typed [[JavaScript]] which was then compiled down to regular [[JavaScript]].
	- Then [[Microsoft]] productized this and created a language of their own which was [[TypeScript]].

## JavaScript Vs TypeScript in the Build Process

- With a JavaScript-only setup, you would typically be crafting code in [[JavaScript]] files, namely `.js` or possibly `.jsx` files.
- These files are then utilized directly by the browser and runtime environments like [[Node.js]], making it a basic and straightforward process.

![[Pasted image 20260424213042.png]]

- With [[TypeScript]], you'd be writing code in `.ts` or `.tsx` files.
- Your IDE's TypeScript [[Language Server Protocol (LSP) Server|LSP]] server watches the code you write, giving autocomplete as well as feedback for errors.
- These TypeScript files are compiled by the [[TypeScript Compiler (tsc)]] which is a CLI tool which converts the `.ts` code into `.js` code.
	- This is usually also a part of the build step in your pipelines.
- This `.js` code is similarly then consumed by the browser or [[Node.js]] to run the code similar to above.
