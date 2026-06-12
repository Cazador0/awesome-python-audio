---
tags: [skill, evaluation, raptor]
authority: 9
updated: 2026-06-12
---

# Skill: Best-of-N evaluation

Generate N candidates, score them automatically, and only surface candidates above the
acceptance threshold. This converts the engine's stochasticity into a search strategy
instead of a defect (see `project/PROMPT_TO_STEM.md`).

## When to use
- After **every** generation call — `text2music`, `repaint`, `lego`, `cover`,
  `complete`. No single-sample acceptance, ever.
- When tuning thresholds from accumulated eval frames.

## Inputs
- N candidate renders (stems or mixes) + the SongBlueprint/StemSpec they answer
- Professional standards retrieved by RAPTOR from [[Music Theory SME/_index|Music Theory SME]]
  notes — retrieval is weighted by each note's `authority` frontmatter field, which is
  why curating that folder matters
- Historical acceptance data (Parquet eval frames, see [[sqlite-store]])

## Scoring pipeline
1. **Constraint conformance** (hard gates): detected tempo vs `bpm`, detected key vs
   `key_scale`, duration vs `audio_duration`, clipping/true-peak sanity per
   [[mastering-and-loudness]]. Fail → discard, never shown.
2. **Embedding similarity**: candidate audio embedding vs blueprint caption embedding
   (hot vectors in [[redis]], durable copies embedded per the data strategy).
3. **Standards match**: RAPTOR retrieves the applicable SME notes (e.g.
   [[stem-engineering]] for stem jobs, [[mixing-fundamentals]] for mix checks,
   [[genre-tag-taxonomy]] for caption fidelity) and the scorer checks the candidate
   against their stated criteria.
4. **Composite score** → compare to the acceptance threshold for this task type.

## Outputs
- Ranked candidates above threshold (top-K to the user; K ≤ 3 to avoid choice overload)
- An eval frame row per candidate (Parquet): scores, threshold, verdict, seed
- A `done` or `frustrated` signal via [[scrum-master-mcp]] — `frustrated` if N rounds
  produce zero acceptable candidates, which routes to blocker triage

## Threshold discipline
Thresholds are **per task type** and tuned only from eval-frame history plus user
acceptance outcomes — never adjusted ad hoc to make a bad batch pass. Threshold changes
are logged in [[decisions]].
