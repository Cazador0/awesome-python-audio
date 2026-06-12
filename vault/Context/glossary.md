---
tags: [context, glossary]
authority: 8
updated: 2026-06-12
---

# Glossary

Shared vocabulary. If a term is used inconsistently in messages or notes, this note wins.

- **Stem** — a single, individually editable track of a song (e.g. the bass stem),
  rendered or extracted so that summing all stems reproduces the mix. Quality criteria:
  [[stem-engineering]].
- **Track class** — the enumerated category a stem belongs to (`vocals`, `drums`,
  `bass`, `guitar`, `keyboard`, ...); part of the constrained metadata.
- **SongBlueprint** — the structured global intent compiled from a prompt: caption,
  lyrics, form, energy curve, pinned `bpm`/`key_scale`/`time_signature`/`duration`, and
  recorded assumptions. Produced by [[prompt-translation]].
- **StemSpec** — the per-stem expansion of a blueprint: track class, role, register,
  density, entry/exit bars. Edits are StemSpec *deltas*.
- **Repaint** — ACE-Step task that regenerates only a time window of existing audio;
  MDS's minimal-diff edit primitive. See [[stem-regeneration]].
- **Lego** — ACE-Step task that generates *new* stems conditioned on existing ones
  (add a bass line that locks to these drums).
- **Cover** — ACE-Step task that re-styles existing material under a new caption.
- **Extract** — ACE-Step task that separates a mix into stems. See [[stem-separation]].
- **Complete** — ACE-Step task that finishes a partial arrangement.
- **Caption** — the prose conditioning string for generation, written per
  [[genre-tag-taxonomy]]; steering, not specification.
- **Best-of-N** — render N candidates per call, score automatically, surface only those
  above the acceptance threshold. See [[best-of-n-evaluation]].
- **RAPTOR** — Recursive Abstractive Processing for Tree-Organized Retrieval: builds a
  tree of summaries over this vault so retrieval can answer at the right abstraction
  level; MDS weights retrieval by note `authority`.
- **Authority** — frontmatter field (1–10) expressing how much the retriever should
  trust a note; see [[conventions]] for the scale.
- **Acceptance threshold** — per-task-type score floor below which candidates are never
  shown; tuned from eval frames only.
- **Seed pinning** — recording the RNG seed of every render so it can be reproduced;
  with audio-code caching, makes iteration cheap and safe.
- **Audio codes** — the engine's intermediate latent representation, cached by
  (blueprint hash, seed) in [[redis]].
- **System of record** — [[sqlite-store]]; if Redis and SQLite disagree, SQLite is true.
- **Digest** — the unread-messages/board-delta summary piggybacked on every
  [[scrum-master-mcp]] tool response; the reason coordination costs zero extra turns.
- **Signal** — the one-word triage tag on every message: `blocked`, `confused`,
  `frustrated`, `praise`, `handoff`, `help_wanted`, `fyi`, `done`.
