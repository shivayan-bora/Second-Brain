---
title: "Microservices"
pillar: software-engineering
type: concept
tags: [architecture, microservices, distributed-systems, backend]
status: in-progress
sources: ["[[fm-enterprise-ui-00-architecture-patterns]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Microservices

## Definition

**Microservices** is a backend architectural style in which a single application is structured as a collection of small, independently-deployable services that communicate over a network. Each service owns a bounded slice of the domain, has its own data store, and can be developed, deployed, and scaled independently of the others.

## Why it matters

For a staff engineer working on the frontend side of a microservices org, microservices is the architectural assumption that shapes nearly everything: API surface area, auth flows, deployment topology, the inevitable BFF (backend-for-frontend) pattern. Understanding the *backend* architecture is required to make sound *frontend* decisions about it — especially around [[micro-frontends|micro-frontends]], where the temptation to mirror the backend split is strong.

## Why this page is brief

This page exists primarily as a wikilink target — the concept comes up in [[ui-arch-three-axes]], [[micro-frontends]], and [[fm-enterprise-ui-00-architecture-patterns]] as a *contrast* to frontend architecture. The wiki currently has no dedicated microservices sources; this page is a stub that will grow when those sources are ingested.

## Key properties (the canonical framing)

- **Bounded context per service.** Each service owns one slice of the business domain.
- **Independent deployment.** Service A can ship without coordinating with B.
- **Independent storage.** Services don't share databases; cross-service data exchange goes through APIs.
- **Network communication.** Services talk via HTTP/gRPC/message queues — never in-process.
- **Independent scaling.** Hot services scale up; cold services don't.
- **Polyglot allowed.** Different services can use different languages/runtimes.

## The frontend-relevant contrast

The thing **frontend architects always get told** about microservices, from [[fm-enterprise-ui-00-architecture-patterns]]:

> *"Unlike backend microservices, where each service is designed to be independent and isolated, frontend developers need to be mindful of the fact that we need to create a consistent user experience which hides this separation."*

This is the central asymmetry. Backend services hide their seams from each other. Frontend slices ([[micro-frontends]]) must hide their seams from the *user*. A pattern that works for backend doesn't translate one-for-one to frontend.

## Open questions

- The wiki hasn't ingested any first-class microservices content yet (Sam Newman, Building Microservices, the Reactive Manifesto, Bounded Contexts from DDD). When it does, this page should deepen substantially.
- What's the right introduction source — Newman's book, Fowler's seminal article, or a more current opinion piece (microservices vs majestic monolith)?
- How does this interact with backend-for-frontend (BFF) — is BFF a microservice, an anti-pattern, or both depending on context?

## Related

- [[micro-frontends]] — the frontend variant; same independence claim, different constraints.
- [[ui-arch-three-axes]] — frontend architecture has different axes than backend.
- [[deployment-topology]] — both microservices and microfrontends are claims about independent deploys.

## Sources

- [[fm-enterprise-ui-00-architecture-patterns]] — referenced as the canonical contrast for frontend architecture.
