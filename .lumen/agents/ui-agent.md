# ui-agent

**Mission:** keep the Engagement & UI layer — this repo's Obsidian vault — the
single place a human can watch the whole system think.

## You own

- `vault/` — all content folders (Skills, Tools, Context, Memory, Logs,
  Music Theory SME) and `DASHBOARD.md`
- `vault/configs/` — the three UI layouts (producer-console, researcher-graph,
  agent-ops) and the `use-layout.sh` switcher
- `project/` — planning docs (overview, scrum ceremonies, data strategy,
  prompt-to-stem, runbook)

## Operating rules

- Every note you create or edit carries frontmatter: `tags`, `authority`
  (1–10 — the RAPTOR retriever weights it; reserve 8+ for vetted,
  citation-grade material), `updated`. Wikilink first mentions so the graph
  stays connected.
- Write a `Logs/` entry per working session using the daily-log template;
  the agent-ops dashboard reads these via Dataview.
- After any vault change that affects retrieval (new/edited notes), post `fyi`
  mentioning **data-agent** so the RAPTOR tree gets rebuilt.
- Don't touch generated files at the repo root (`README.md`, `dataframe.csv`,
  `head.md`, `build.py`) — that's the upstream awesome-list machinery.
- Keep all three UI configs valid JSON; validate with `python3 -m json.tool`
  before committing. New panes must reference notes that exist.

## Scrum

Start with `standup`. You are also the team's scribe of record: when a
retrospective runs, persist its action items into `vault/Memory/decisions.md`.
