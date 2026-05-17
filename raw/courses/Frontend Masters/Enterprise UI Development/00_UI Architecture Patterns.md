---
creation date: 2026-05-16 16:55
modification date: Saturday 16th May 2026 16:55:42
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 00_UI Architecture Patterns
---

## The Three Axes of Architecture patterns

- Three main dimensions to consider when evaluating frontend architecture beyond just monolith vs microfrontend:
  - How the application is assembled at runtime: Whether it's one unit or independently deliverable slices.
  - Topology of the repositories: One repository with many applications vs many repositories.
  - Deployment Topology: Whether there's one or multiple independent deployments.

### Runtime Architecture

- A **frontend monolith** is one application built and deployed as a _single_ unit.
  - The most basic [[Monolithic Architecture|monolith]] is simple, easy and provides **one codebase**.
    - This eliminates the need to coordinate across different systems, handle [[API]] migrations or manage complex deployment sequences.
    - All code gets committed and deployed at the same time.
    - It's almost always a no-brainer to start with a monolith and then upgrade to a [[Microfrontend Architecture|microfrontend]] as and when the situation arises.
  - You can, however, have a polyrepo structure, but if all of them get built into one application that gets deployed at once, that's still a monolith.
- A **microfrontend** system is many _independently_ deliverable frontend slices composed into a _single_ user experience.
  - Unlike backend [[Microservice Architecture|microservices]], where each service is designed to be independent and isolated where they don't know about each other, frontend developers need to be mindful of the fact that we need to create a consistent [[User Experience (UX)|user experience]] which hides this separation.
    - Users expect one unified intercase and not different UI paradigms for each service, which creates an extra layer of complexity for frontend developers.

### Repository Topology

- A **monorepo** is _one_ repository holding _many_ applications and libraries.
- A **polyrepo** gives each project its _own_ repository.
  - **Pro:** Each team can make their _own_ organizational decisions.
  - **Tradeoff:**
    - _Harder_ code sharing
    - Repeated maintenance across repositories.

### Deployment Topology

- You can have _one_ deployable, _many_ deployables that still require lockstep coordination, or many deployables that are _genuinely independent_.

> [!NOTE]
> Build-time microfrontends lose the autonomy in deployments, as everything gets deployed at once. If the main goal of adopting microfrontends is to achieve autonomous deploys, build-time microfrontends would not achieve that goal despite taking on the complexity of a microfrontend architecture.

## Monoliths

### Hard Parts

- **Team Collisions:** Multiple teams editing the same files, stepping on each other's work, blocked by merge conflicts.
- **Build Times:** A one-line change rebuilds and retests everything.
  - [[Continuous Integration|CI]] takes 45 minutes and deployments become events.
- **Blast Radius:** A bug in Settings takes down Authentication. Every change is a risk to the whole product.
- **Dependency Hell:** Upgrading [[React]] means upgrading everything at once. So nobody upgrades anything.

#### Important Questions

- Q. What are the two main indicators that it's time to switch from a monolith architecture?
  - A. First, when multiple teams are editing the same files, leading to merge conflict nightmares. Second, when the sheer size of the codebase grows to the point where CI/CD takes an excessive amount of time to run (such as 25 minutes or more), significantly slowing down the feedback loop for production deployments.

- Q. What is the relationship between monolithic architecture and team decision-making when feedback loops become too long?
  - A. When the feedback loop for determining if something is ready for production becomes excessively long (such as 2 hours), the number of decisions you can make to fix issues begins to drop precipitously. This long feedback cycle significantly hampers the team's ability to iterate and respond to problems quickly.

- Q. What problem can arise when breaking code into separate sections, even for solo developers?
  - A. Breaking code into separate sections helps constrain work to specific areas. This is particularly useful when using AI tools, as it can prevent them from going on 'side quests' and refactoring unrelated parts of the codebase (like the sign-in page when you only needed to update the privacy policy).
