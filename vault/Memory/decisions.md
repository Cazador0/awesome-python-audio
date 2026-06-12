---
tags: [memory, decisions, adr]
authority: 9
updated: 2026-06-12
---

# Architecture decision log

Append-only. One entry per decision; reversals are new entries that reference the old.
Format: status, context, decision, consequences.

## ADR-001 — Repo mapping for the four-layer pipeline
**Status:** accepted · 2026-06-12

**Context:** MDS spans four layers (Engagement+UI → Data → Memory & Context →
Generation) and three existing repos; agents need an unambiguous answer to "where does
this code/note go".

**Decision:**
- `cazador0/awesome-python-audio` (this repo) → Engagement/UI + Memory & Context
  *content*: `project/` planning docs and this vault.
- `cazador0/mcp-servers` (`src/scrum-master/`) → agent communication: tools
  `post_message`/`check_inbox`/`standup`/`manage_task`/`get_board`, ceremony prompts.
- `cazador0/ACE-Step-1.5` (`music_data_science/`) → Data layer + Memory & Context
  *code* (store service, RAPTOR over this vault) + the ACE-Step generation engine.
- All work on branch `claude/peaceful-dijkstra-m0sycf`.

**Consequences:** the vault is cross-repo infrastructure — `music_data_science/` indexes
it remotely; vault edits are deploys (see [[project-context]]).

## ADR-002 — Data strategy: Redis-hot / embedded-durable hybrid
**Status:** accepted · 2026-06-12

**Context:** three candidate strategies were worked through in
`project/DATA_STRATEGY.md` (Redis-hot, embedded-everything, consolidated Postgres).

**Decision:** Strategy A with Strategy B's embedded vector store: [[redis]] (or Valkey)
for cache/Streams queue/hot vectors; [[sqlite-store]] as system of record; durable
vector RAG in sqlite-vec/LanceDB beside SQLite; Parquet + pandas for eval frames.

**Consequences:** two-store reconciliation protocol (stream = trigger, row = truth);
Redis licensing watched, Valkey as fallback; no Postgres ops burden until multi-user.

## ADR-003 — Obsidian as the UI layer, three switchable layouts
**Status:** accepted · 2026-06-12

**Context:** agents and humans need shared views over the same memory without building a
web app.

**Decision:** the vault *is* the UI. Three `.obsidian` config sets in `configs/`
(producer-console, researcher-graph, agent-ops) switched by `use-layout.sh`; agent-ops
is the default. Dashboards are Dataview queries over [[Logs/_index|Logs]] and Memory
(see `DASHBOARD.md`).

**Consequences:** notes must keep machine-readable frontmatter (see [[conventions]]) or
dashboards and RAPTOR weighting silently degrade.

## ADR-004 — Best-of-N acceptance thresholds are data-tuned only
**Status:** accepted · 2026-06-12

**Context:** the temptation during a bad batch is to lower the bar.

**Decision:** thresholds in [[best-of-n-evaluation]] change only from eval-frame history
and user acceptance outcomes, per task type; every change gets an entry here.

**Consequences:** zero-acceptable-candidate rounds emit `frustrated` and route to
blocker triage instead of silently shipping worse audio.

## ADR-005 — Strategy A adopted (confirmed and implemented)
**Status:** accepted · 2026-06-12

**Context:** ADR-002 chose Strategy A on paper; the user has now confirmed it and the
sprint shipped the code, so the decision is no longer provisional.

**Decision:** Redis/Valkey hot path + [[sqlite-store]] system of record + embedded
vector store, as designed. The [[task-queue]] (Streams, consumer groups, in-memory
fallback) and the embedded [[vector-store]] (Strategy B's store folded in, with RAPTOR
persist/restore) are the implementations of record in `music_data_science/`.

**Consequences:** the queue and vector store are now contracts, not sketches — agents
code against [[task-queue]] and [[vector-store]], and changes to their semantics are
new ADR entries. The RAPTOR tree survives restarts via persist/restore instead of
re-chunking this vault.

## ADR-006 — Authority scale: 1–10 in the vault, normalized at chunk time
**Status:** accepted · 2026-06-12

**Context:** vault frontmatter uses the human-friendly `authority: 1-10` scale from
[[conventions]], but retrieval scoring expects [0,1]; the markdown chunker previously
passed values through unchanged — a unit mismatch that over-weighted every vault note.

**Decision:** the vault keeps the 1–10 scale; the chunker in `music_data_science/`
normalizes it into [0,1] when building chunks. Note-writers keep using 1–10 and never
pre-normalize.

**Consequences:** retrieval weighting is correct without any vault migration; a
frontmatter `authority` above 1 is treated as 1–10 and divided by 10, values already in
[0,1] pass through. [[conventions]] stays the single source for what the numbers mean.
