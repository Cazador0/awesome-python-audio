---
tags: [skill, blueprint, nlp]
authority: 9
updated: 2026-06-12
---

# Skill: Prompt translation

Compile a natural-language request into the structured intermediate representation:
**SongBlueprint → StemSpec[]**. Free text never reaches the generation engine directly;
this skill is the only place language becomes parameters.

## When to use
- Every new song request (`text2music`).
- Every edit request — edits compile to StemSpec *deltas*, which then drive
  [[stem-regeneration]].
- Re-interpreting user feedback during human-in-the-loop convergence.

## The two-stage compile

### Stage 1 — SongBlueprint (global intent)
Extract or decide:
- **caption** — genre/style/mood/instrumentation/era words, ordered per
  [[genre-tag-taxonomy]] (genre → subgenre → mood → instrumentation → production)
- **lyrics** — verbatim if supplied, else structure tags only (`[verse]`, `[chorus]`)
- **form** — section list with bar counts, per [[form-and-structure]]
- **energy curve** — per-section intensity targets
- constrained metadata: **`bpm`**, **`key_scale`** (e.g. `"F minor"`),
  **`time_signature`**, **`duration`** — pinned as fields, never left to caption prose

When the user doesn't specify, choose from genre norms (see [[rhythm-and-meter]] for
tempo ranges, [[harmony-and-voice-leading]] for key/mode affect) and record the choice
as an assumption in the blueprint so it can be challenged later.

### Stage 2 — StemSpec per track
For each entry in `track_classes`: role (per [[orchestration-and-timbre]]), register,
rhythmic density, entry/exit bars, and a per-stem caption fragment.

## ACE-Step call (new material)
- `task_type`: **`text2music`**
- `prompt` ← blueprint caption, `lyrics` ← blueprint lyrics
- `bpm`, `key_scale`, `time_signature`, `audio_duration` ← pinned metadata
- `seed` — random but **recorded**; `n_candidates` ≥ 4 for [[best-of-n-evaluation]]
- Related task types this skill also feeds: `cover` (re-style existing material) and
  `complete` (finish a partial arrangement)

Submit via [[acestep-api]].

## Inputs / Outputs
- In: user message + conversation context + prior blueprint (for deltas)
- Out: blueprint + specs persisted to [[sqlite-store]] (hash-keyed), call payloads for
  the engine

## Quality bar
A blueprint is done when a different agent could render from it without asking
questions — the same self-containedness rule as [[scrum-master-mcp]] messages.
Ambiguity that survives compilation must be listed in the blueprint's `assumptions`
field, not silently resolved.
