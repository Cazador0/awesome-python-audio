---
tags: [context, architecture]
authority: 9
updated: 2026-06-12
---

# Project context: Music Data Science

MDS turns natural-language musical intent into professional-quality, individually
editable **stems**, using a fleet of coding agents over a shared memory — this vault.

## The four layers and where they live

1. **Engagement (AI agents) + UI (Obsidian)** — agents converse and coordinate; this
   vault hosts the agent-facing views (see `configs/` for the three layouts). Repo:
   `cazador0/awesome-python-audio` (here) + the [[scrum-master-mcp]] server in
   `cazador0/mcp-servers`.
2. **Data** — [[redis]] hot path (cache, Streams queue, hot vectors), vector RAG, and
   RAPTOR Best-of-N evaluation against professional music community standards. Repo:
   `cazador0/ACE-Step-1.5`, `music_data_science/`.
3. **Memory & Context** — [[sqlite-store]] system of record plus this markdown vault:
   [[Skills/_index|Skills]], [[Tools/_index|Tools]], Context, [[Memory/_index|Memory]],
   [[Logs/_index|Logs]], and the [[Music Theory SME/_index|Music Theory SME]] library.
4. **Generation engine** — ACE-Step behind [[acestep-api]], task types `text2music`,
   `repaint`, `cover`, `extract`, `lego`, `complete`.

All three repos work on branch `claude/peaceful-dijkstra-m0sycf`.

## The one non-obvious thing

**This vault is live infrastructure, not documentation.** The RAPTOR retriever indexes
these notes and weights them by their `authority` frontmatter field; eval scoring quotes
the [[Music Theory SME/_index|SME library]] as its standard. Editing a note here changes
what the system generates and accepts. Treat edits with the care of a schema migration —
which is why [[conventions]] and [[decisions]] exist.

## The core problem

Translating prompts to Stem objects with calibrated confidence that output matches
intent — honestly an open research problem; our engineering path (blueprint IR, pinned
metadata, seed pinning, windowed repaint, Best-of-N) is laid out in
`project/PROMPT_TO_STEM.md` and operationalized in [[prompt-translation]],
[[stem-regeneration]], and [[best-of-n-evaluation]].
