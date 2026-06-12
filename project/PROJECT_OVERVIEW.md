# Music Data Science (MDS) — Project Overview

MDS is a vertical slice through **AI + Technology + Music**: a small fleet of coding
agents that turn natural-language musical intent into professional-quality stems, with a
shared memory that gets better the more the system is used. It spans three repositories,
each owning one or two layers of a four-layer pipeline.

## The four-layer pipeline

```
┌─────────────────────────────────────────────────────────────┐
│ 1. ENGAGEMENT (AI agents)  +  2. UI (Obsidian)               │
│    agents talk to users & each other; Obsidian hosts the     │
│    agent-facing views (dashboard, graph, producer console)   │
│    repo: cazador0/awesome-python-audio  → project/, vault/   │
│    repo: cazador0/mcp-servers           → src/scrum-master/  │
├─────────────────────────────────────────────────────────────┤
│ 3. DATA                                                      │
│    Redis (cache + Streams task queue), vector RAG,           │
│    RAPTOR Best-of-N for creativity/evaluation/matching       │
│    professional music community standards                    │
│    repo: cazador0/ACE-Step-1.5 → music_data_science/         │
├─────────────────────────────────────────────────────────────┤
│ 4. MEMORY & CONTEXT                                          │
│    SQLite system of record + this markdown vault:            │
│    Skills, Tools, Context, Memory, Logging, Music Theory SME │
│    repo: cazador0/awesome-python-audio → vault/              │
├─────────────────────────────────────────────────────────────┤
│ 5. GENERATION ENGINE                                         │
│    ACE-Step (text2music, repaint, cover, extract, lego,      │
│    complete) behind the /release_task API                    │
│    repo: cazador0/ACE-Step-1.5                               │
└─────────────────────────────────────────────────────────────┘
```

### Layer → repo mapping

| Layer | Responsibility | Repo (branch `claude/peaceful-dijkstra-m0sycf`) |
| --- | --- | --- |
| Engagement | Agents converse with users, decompose intent, coordinate via the scrum-master MCP server | `cazador0/mcp-servers` (`src/scrum-master/`) + this repo (`project/`) |
| UI | Obsidian vault hosting agent-facing views: ops dashboard, knowledge graph, producer console | this repo (`vault/`, `vault/configs/`) |
| Data | Redis hot path (cache, Streams queue, hot embeddings), vector RAG, RAPTOR Best-of-N candidate evaluation against professional standards | `cazador0/ACE-Step-1.5` (`music_data_science/`) |
| Memory & Context | SQLite system of record; the vault as the durable knowledge base RAPTOR indexes (notes carry an `authority` weight) | this repo (`vault/`) + `cazador0/ACE-Step-1.5` (store code) |
| Generation engine | ACE-Step model serving the six task types via `/release_task` | `cazador0/ACE-Step-1.5` |

The vault is not documentation *about* the system — it **is** the system's long-term
memory. The RAPTOR retriever in `music_data_science/` builds its tree over these markdown
files and weights retrieval by each note's `authority` frontmatter field, so curating the
vault directly changes generation quality.

## Agent roles

| Agent | Owns | Typical tasks | Reads/writes in the vault |
| --- | --- | --- | --- |
| `pipeline-agent` | Generation engine integration | Compose `/release_task` calls, manage seeds and audio-code caches, run repaint windows | Reads `Skills/`, `Tools/acestep-api`; writes `Logs/` |
| `data-agent` | Data layer | Redis Streams consumers, embedding refresh, RAPTOR tree rebuilds, eval frames in Parquet | Reads `Memory/conventions`; writes `Logs/`, proposes `Memory/decisions` entries |
| `ui-agent` | Engagement + UI | Vault curation, dashboard queries, Obsidian layouts, user-facing summaries | Writes everywhere except `Music Theory SME/` (curated, high-authority) |
| `eval-agent` | Best-of-N scoring | Score candidates against community standards retrieved via RAPTOR, set acceptance thresholds | Reads `Music Theory SME/`; writes eval verdicts to `Logs/` |

## How the scrum-master MCP server removes scrum overhead

None of the agents above plays scrum master. The scrum-master MCP server
(`cazador0/mcp-servers`, `src/scrum-master/`) owns ceremony mechanics:

- **Tools** — `post_message`, `check_inbox`, `standup`, `manage_task`, `get_board` give
  agents a mailbox and a kanban board without any agent maintaining either.
- **Prompts** — `sprint-planning`, `daily-standup`, `retrospective`, `unblock`, `handoff`
  encode each ceremony as a reusable prompt, so a ceremony is just "invoke the prompt",
  not "one agent improvises facilitation".
- **Piggybacked digests** — every tool response carries a digest of unread inbox items and
  board changes, so coordination costs **zero extra turns**: an agent learns it is needed
  while doing the work it was already doing.

Full ceremony mechanics: [SCRUM_CEREMONIES.md](SCRUM_CEREMONIES.md).
Data layer trade-offs: [DATA_STRATEGY.md](DATA_STRATEGY.md).
The core research problem: [PROMPT_TO_STEM.md](PROMPT_TO_STEM.md).
