---
id: MERN Mastery with Microservices
aliases: []
tags:
  - course
creation date: 2026-08-03 09:21
modification date: Monday 3rd August 2026 09:21:38
source: https://learn.codersgyan.com/learn/mern-mastery-with-microservices/mernplus-microservice-scratching-the-surface/mernplus-introduction-to-microservices-video
status:
  - in-progress
---

## Microservices vs Monoliths

- [[Microservice Architecture|Microservices]] are independently deployable services.
  - Created by breaking down your different services into separate independent entities with it's own servers.
- [[Monolithic Architecture|Monoliths]] are single big application with all services combined.

### Advantages of Microservices vs Monoliths

- Zero-downtime independent deployability:
  - **Microservices**:
    - You can deploy each one of the services independently reducing the downtime where only the current service being deployed may have a downtime => To make this zero, there are ways e.g. [[Green-Blue Deployments]]
    - You can perform [[Horizontal Scaling]] on individual services i.e. increasing the number of machines serving the particular service based on the requirement and how much load do they take.
      - The traffic is routed to each individual server through a [[Load Balancer]].
  - **Monoliths**:
    - You need to deploy the entire application in one go which takes a lot of time.
    - While you can perform [[Horizontal Scaling]], the first step is [[Vertical Scaling]] which is increasing the individual machines power e.g. [[RAM]], [[CPU]] etc. Horizontal Scaling here is wasteful because we have unbalanced load on individual features so if we do horizontal scaling, the rest of features won't need that much amount of power which is wasteful.
- Reflect your team's structure:
  - **Microservices**:
    - Focused and independent teams on one aspect of the application.
    - Developers can work on features in parallel i.e. lesser chances of merge conflicts.
    - Light-weight [[CI/CD]] pipelines.
    - To be effective, developers only need the domain knowledge surrounding the specific aspect of the application.
    - Each service is language agnostic i.e. you can have a [[Node.js]] service for one part and a [[Go]] service for another.
  - **Monoliths**:
    - Huge teams where people need to know the domain surrounding the entire application.
    - Bloated and time consuming [[CI/CD]] process where each merge takes a long time to get built and deployed. Here also, we would be building the entire application even if only a specific area of code is touched.
    - More people === more merge conflicts.
- Self-contained data and logic:
  - **Microservices**:
    - Loosely coupled
    - Self contained entity where if any one of the services fail, it doesn't impact the other services maintaining a good [[User Experience (UX)|UX]].
  - **Monoliths**:
    - Tightly coupled.
    - Even if a specific part of the application fails, the entire application fails.

### Why not Microservices?

- Infrastructure complexity:
  - Microservices need a lot of configuration e.g. connection details between individual services, environment variables, security measures etc. where Monoliths get away with only a single configuration and everything else at one place.
- Latency:
  - Since there's inter-service communication in microservices, it can introduce latency unlike monoliths.
- Risk of failure cascades:
  - If a service is down, all it's dependant services will start failing in the application for a microservices architecture.

> [!NOTE]
> Microservices should never be the default option. Always start with a monolith and then start evolving as needed.

## Planning a Microservice Architecture
