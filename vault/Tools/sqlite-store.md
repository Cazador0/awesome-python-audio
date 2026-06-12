---
tags: [tool, sqlite, data-layer, memory]
authority: 7
updated: 2026-06-12
---

# Tool: SQLite store (system of record)

The durable spine of the Memory & Context layer: one WAL-mode SQLite database owned by
the store service in `music_data_science/`
([cazador0/ACE-Step-1.5](https://github.com/cazador0/ACE-Step-1.5)). Everything the
system must not forget is a row here; [[redis]] only accelerates it.

## Tables (conceptual)

| Table | Holds |
| --- | --- |
| `tasks` | every `/release_task` call: type, payload hash, seed, state, timing |
| `blueprints` | SongBlueprints, content-addressed by hash, with `assumptions` |
| `stem_specs` | per-stem specs linked to their blueprint |
| `stems` | rendered artifacts: file path, content hash, source task, track class |
| `evals` | per-candidate scores, threshold, verdict (mirrored to Parquet frames) |
| `vault_notes` | indexed note metadata: path, `authority`, `updated`, embedding id |

## Embedded vector RAG
Per the verdict in `project/DATA_STRATEGY.md`, durable vectors live **embedded**
(sqlite-vec or LanceDB) right beside these tables — the RAPTOR tree over this vault is
built here, and retrieval for [[best-of-n-evaluation]] weights results by each note's
`authority` frontmatter field. Re-index when `Music Theory SME` or `Skills` notes change
(`updated` field newer than the index).

## Usage rules
- **One writer.** Agents write through the store service, never open the file for write
  themselves. Reads are unrestricted (WAL).
- Generation isn't "done" until its `tasks` + `stems` rows exist — a `done` signal via
  [[scrum-master-mcp]] without rows is a defect.
- Analytical questions ("are repaint acceptance rates improving?") go to the Parquet
  eval frames with pandas/DuckDB, not to ad hoc SQL over the live db.
- Schema changes are architecture decisions: log them in [[decisions]] first.
