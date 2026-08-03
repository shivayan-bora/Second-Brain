---
id: Reading a New Codebase
aliases: []
tags:
  - video
creation date: 2026-06-27 08:30
modification date: Saturday 27th June 2026 08:30:30
source:
  - https://www.youtube.com/watch?v=4t8QcDdrL6Y
  - https://www.youtube.com/watch?v=gkrF0o96VXM
  - https://www.youtube.com/watch?v=kA1T0zDPtQo
  - https://www.youtube.com/watch?v=Rcjjk6Ci6VI
  - https://www.youtube.com/watch?v=jqHXJ3O7WGw
  - https://www.youtube.com/watch?v=5sohKNjKF5k
status:
  - completed
---

## Techniques for Understanding a Codebase

### Prerequisites for Basic High Level Understanding of the Codebase

- To understand the codebase, it's always better to understand the functionality first as a user of the project. So play with the project for a couple of weeks trying to understand the functionality of the project.
- Usually enterprise codebases may have an architecture overview or documentation that we should go through. We should try and understand the different parts of the architecture and how they fit together.
- Setup the project locally and run the project.

### Entry Point

- Find the entry point of an application/feature and start from there instead of skimming through all the files.
  - Pick a feature you are working or are interested to explore. If it's frontend code, start from the routes and if it's backend code, start from the controllers.
- If you're analysing the login flow of an application, search where the `login` function call is and then follow the call stack.
- If you're picking up a bug or an issue:
  - Reproduce the issue locally.
  - Follow the error and perform a stack trace by yourself and maybe draw a flow diagram.

### Read the Tests

- Read the appropriate tests which tells you the happy and error paths.
- Happy paths will tell you what the contracts of a function e.g. from the above, the flow is, you put in credentials and you get an output token used to login.
- Tests aren't the whole story but it gives you a starting point to see where to go from here.
- Run the tests and understand the flow and contracts for the target feature or bug.

### Follow the Data

- Follow the data and not the functions e.g. in the login flow, the object that matters is the `user`.
  - An example flow would be:
    - Find a user by the input email: `const user = await User.findByEmail(email)`
    - Compare encrypted password of the found user with the input password: `bcrypt.compare(password, user.passwordHash) `
    - Then if the credentials match, create a [[JWT]] token for the user with the user ID: `jwt.sign({ userId: user.id, exp: ... })`
    - Send the token through the response: `res.json({ token })`
- The best way to follow the data is through debugging and using `print` or `console` statements. Run the code and follow the data.

### Skip What You Don't Need on the First Pass

- Skip diving into deep implementation of every line/function.
- For what you're investigating, only consume when they:
  - change the request
  - block the flow
  - explain the bug

### Follow One Failure Path

- Once the happy path investigation is complete, follow one failure path.
  - Probe like an attacker.
- `Happy path === What it does`
- `Failure path === What it gets wrong`

### Get your Hands Dirty

- Start by making small changes in both happy and failure paths and check the tests if it behaves as expected.

### Draw Mindmaps and Take Notes

- Take notes for all your learnings and questions that you have during the learning process.
- Draw a mindmap for the flow in your own style and understanding and keep validating as soon as you gain new information.
- Try teaching or sharing your learnings - Feynman Technique and for feedback as well.
- Documentation is important for yourself and for other people in the team.

> [!IMPORTANT]
> While learning the codebase is important, it's equally important to understand the architecture and the domain which makes us even better understand the codebase on what was implemented and why.
