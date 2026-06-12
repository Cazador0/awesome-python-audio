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
