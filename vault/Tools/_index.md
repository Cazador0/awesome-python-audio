---
tags: [index, tools]
authority: 6
updated: 2026-06-12
---

# Tools

External systems the agents call, with just enough contract detail to use them without
leaving the vault.

- [[acestep-api]] — the generation engine's `/release_task` contract
- [[scrum-master-mcp]] — coordination tools and ceremony prompts
- [[redis]] — hot path: cache, Streams queue, hot vectors
- [[sqlite-store]] — durable system of record + embedded vector RAG
- [[task-queue]] — Redis Streams work queue: claim/ack semantics, fallback
- [[vector-store]] — embedded vectors + RAPTOR persist/restore
- [[blueprint-refiner]] — optional Claude refinement behind the translator hooks

See [[project-context]] for how these map onto the four-layer pipeline.
