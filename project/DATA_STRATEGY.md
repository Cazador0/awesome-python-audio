# MDS Data Strategy

The data layer has four jobs: (1) a **hot path** — cache and task queue between agents
and the generation engine; (2) **vector RAG** over the vault and over audio/caption
embeddings; (3) a **durable system of record** for tasks, blueprints, stems, and eval
verdicts; (4) **analytical frames** for Best-of-N evaluation and longitudinal quality
tracking. Three complete strategies follow; each could ship the whole project.

---

## Strategy A (recommended): "Redis-hot / embedded-durable"

### Components
- **Redis Stack** (or **Valkey** + RediSearch-compatible modules) for:
  - cache: prompt → audio-code cache, blueprint cache, model warm state
  - **Redis Streams** as the task queue (consumer groups per agent role, `XAUTOCLAIM`
    for crash recovery, dead-letter stream for poisoned tasks)
  - vector search over *hot* embeddings (recent stems, current sprint's candidates)
- **SQLite** as the durable system of record: tasks, SongBlueprints, StemSpecs, seeds,
  file hashes, eval verdicts. WAL mode; one writer (the store service), many readers.
- **Parquet + pandas** for analytical/eval frames: every Best-of-N round appends a
  Parquet partition; pandas (or DuckDB ad hoc) reads them for threshold tuning.

### Strengths
- Redis Streams is a genuinely good small-team task queue: consumer groups, pending-entry
  lists, and replay come free; latency is sub-millisecond.
- Clean hot/cold separation: losing Redis loses only recomputable state; SQLite holds
  truth.
- Each piece is boring, documented, and known to every agent's training data.

### Weaknesses
- One server to run, monitor, and persist (RDB/AOF choices).
- **Licensing**: Redis 7.4+ is dual-licensed RSALv2/SSPLv1 — fine for this project's use,
  but not OSI-approved open source. **Valkey** (Linux Foundation fork of Redis 7.2.4) is
  the drop-in open alternative if that matters.
- Two stores means a (small) consistency protocol: Streams entry is the trigger, SQLite
  row is the truth, and reconciliation runs on startup.

### When to choose it
Multiple concurrent agents, a real queue with crash recovery, and hot embedding lookups
in the generation loop — i.e., this project as designed.

---

## Strategy B: "Embedded-everything (zero servers)"

### Components
- **SQLite + sqlite-vec** (or **LanceDB**) for vectors: embeddings live next to the rows
  they describe; one file, one backup.
- **DuckDB** for analytics directly over the Parquet eval frames (no load step).
- **Filesystem queue**: a `queue/` directory with atomic renames
  (`pending/` → `claimed/<agent>/` → `done/`), which is portable and inspectable with `ls`.

### Strengths
- Zero servers, zero ports, zero ops. `git clone` + `uv sync` and the data layer exists.
- Maximum portability and local-first ethos; everything is a file you can copy.
- sqlite-vec/LanceDB brute-force or ANN search is more than fast enough at this
  project's scale (thousands–low millions of vectors).

### Weaknesses
- Lower concurrency: SQLite allows one writer; the filesystem queue has no consumer
  groups, no blocking reads (poll or `inotify`), and weaker crash-recovery semantics.
- No shared cache across machines; multi-host agents would each carry their own state.
- You end up re-implementing queue features Redis gives you for free.

### When to choose it
Single-machine deployments, demos, CI, or any contributor who refuses to run a daemon.

---

## Strategy C: "Consolidated Postgres"

### Components
- **PostgreSQL** as the single store: relational system of record, JSONB for blueprints.
- **pgvector** for all vector search (HNSW indexes).
- **LISTEN/NOTIFY** + a jobs table (`SELECT ... FOR UPDATE SKIP LOCKED`) as the queue.

### Strengths
- One ACID store for everything: queue entry, blueprint, embedding, and eval verdict can
  commit in a single transaction — no reconciliation protocol at all.
- Best multi-user/production story: roles, row-level security, replication, backups.
- pgvector is mature and the jobs-table pattern is battle-tested.

### Weaknesses
- Heaviest ops of the three: a real server, tuning, migrations, connection pooling.
- LISTEN/NOTIFY is at-most-once and connection-bound; you still need the polling
  fallback, so the queue is more code than Redis Streams.
- Overkill for a handful of local agents; the hot path is slower than Redis for cache
  semantics (TTLs, eviction) you'd have to emulate.

### When to choose it
A hosted, multi-user MDS with real customers and a team that already runs Postgres.

---

## Verdict

**Redis is hard to beat for the hot path.** Streams-based queueing with consumer groups
and sub-millisecond cache reads is exactly what the agent loop needs, and nothing in B or
C matches it without extra code.

**But for pure vector RAG at this project's scale, an embedded store beats running a
Redis server.** The vault is thousands of notes, not billions of vectors; sqlite-vec or
LanceDB answers a RAPTOR retrieval in milliseconds from a local file, survives restarts
without persistence config, and keeps the memory layer as portable as the markdown it
indexes.

**Recommendation: Strategy A with Strategy B's embedded vector store as the memory
layer.** Redis (or Valkey) carries the queue, cache, and *hot* candidate embeddings;
SQLite remains the system of record; the RAPTOR tree over the vault lives in
sqlite-vec/LanceDB beside it; Parquet + pandas handle eval analytics. This is what
`music_data_science/` in [cazador0/ACE-Step-1.5](https://github.com/cazador0/ACE-Step-1.5)
implements.
