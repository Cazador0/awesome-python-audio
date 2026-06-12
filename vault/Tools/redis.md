---
tags: [tool, redis, data-layer]
authority: 7
updated: 2026-06-12
---

# Tool: Redis (hot path)

Redis Stack (or Valkey) carries the MDS **hot path** under Strategy A of
`project/DATA_STRATEGY.md`. It is deliberately *not* the system of record — that is
[[sqlite-store]]. Losing Redis loses only recomputable state.

## What lives here

| Concern | Mechanism | Keys/streams |
| --- | --- | --- |
| Task queue | **Redis Streams** + consumer groups per agent role — see [[task-queue]] | `mds:queue:generation`, `mds:queue:evaluation`, `mds:queue:ui` |
| Cache | plain keys with TTL | `cache:codes:{blueprint_hash}:{seed}` (audio codes), `cache:blueprint:{hash}` |
| Hot vectors | vector index over recent candidate embeddings | `vec:candidates:*` (current sprint only) |
| Digest fan-out | pub/sub for [[scrum-master-mcp]] piggyback digests | `mds:digest:{agent}` |

## Usage rules
- **Consume, don't poll.** `XREADGROUP` with blocking reads; reclaim stuck entries with
  `XAUTOCLAIM` on startup (crash recovery comes free with consumer groups).
- A Streams entry is a *trigger*; the matching [[sqlite-store]] row is the *truth*.
  Reconciliation runs at startup: any SQLite task without a terminal state is re-queued.
- Hot vector index holds only recent/in-flight embeddings. Durable RAG over the vault
  lives in the embedded store (sqlite-vec/LanceDB) — see the verdict in
  `project/DATA_STRATEGY.md`: at this scale an embedded store beats a server for pure
  vector RAG.
- Cache keys are content-addressed (blueprint hash + seed); never invent ad hoc keys.

## Licensing note
Redis ≥ 7.4 is dual-licensed **RSALv2/SSPLv1** — usable here, but not OSI-approved.
**Valkey** (Linux Foundation fork) is the drop-in open alternative; the wrapper in
`music_data_science/` speaks RESP and does not care which is running.
