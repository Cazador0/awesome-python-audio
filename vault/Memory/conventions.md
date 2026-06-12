---
tags: [memory, conventions]
authority: 9
updated: 2026-06-12
---

# Vault conventions

These keep the vault machine-readable: the RAPTOR retriever, the Dataview dashboards,
and the [[sqlite-store]] note index all parse what's described here.

## Frontmatter (every note)
```yaml
---
tags: [one-of-the-folder-tags, topic-tags...]
authority: 1-10
updated: YYYY-MM-DD
---
```
- **`authority`** — retrieval weight. Scale: 9–10 curated standards (Music Theory SME,
  decisions, conventions); 7–8 verified operational notes (Skills, Tools); 4–6 indexes
  and working context; 1–3 raw logs and unreviewed drafts. Raising a note's authority is
  a review act, not a formatting choice.
- **`updated`** — bump on every substantive edit; the embedded vector index re-embeds
  notes whose `updated` is newer than the index.

## Linking
- Use `[[wikilinks]]` for every first mention of another note; the graph view and local
  graph are navigation tools, so unlinked mentions are defects.
- Link to the most specific note ([[stem-engineering]], not the SME index).

## Folders
- `Skills/` — how to *do* something; must name the ACE-Step `task_type` and parameters.
- `Tools/` — contracts of external systems.
- `Context/` — background and [[glossary]] vocabulary.
- `Memory/` — durable decisions and these conventions; append-only spirit.
- `Logs/` — one note per day per agent activity stream, named `YYYY-MM-DD.md`; use the
  [[daily-log-template]]. Log frontmatter additionally carries `agent`, `status`
  (`done` | `in-progress` | `blocked`), and `blockers` (list) so `DASHBOARD.md` queries
  work.
- `Music Theory SME/` — curated lecture-note library; edits require review and an
  authority justification.

## Writing style
- Lead with when/why, then mechanics. No filler, no restating the obvious.
- Self-contained, like [[scrum-master-mcp]] messages: a reader should act without
  follow-up questions.
- Numbers over adjectives ("-14 LUFS", not "fairly loud") — see
  [[mastering-and-loudness]] for the spirit of this rule.

## Promotion path
Log observation → `retrospective` → [[conventions]]/[[decisions]] entry → (if it's a
standard) Music Theory SME note with raised authority.
