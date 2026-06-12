---
tags: [skill, stems, extraction]
authority: 8
updated: 2026-06-12
---

# Skill: Stem separation

Decompose a mixed audio file into per-track-class stems so they can be edited,
re-rendered, or recombined individually.

## When to use
- The user supplies finished audio ("here's my demo") and wants stem-level edits.
- A [[stem-regeneration]] request targets a track class that doesn't yet exist as a stem.
- Building reference material for [[best-of-n-evaluation]] (compare candidate bass stem
  against the extracted bass of a reference).

Do **not** use it when stems already exist in the store ([[sqlite-store]] keeps stem
provenance) — extraction is lossy relative to natively generated stems.

## ACE-Step call
- `task_type`: **`extract`**
- Key parameters:
  - `src_audio_path` — the mixed source audio
  - `track_classes` — which classes to pull, e.g. `["vocals", "drums", "bass", "guitar", "keyboard"]`
  - `audio_duration` — match the source; do not truncate mid-phrase
  - `seed` — record it even here, per [[conventions]] reproducibility rules

Submit via the [[acestep-api]] `/release_task` contract; the result is one audio file per
requested class plus the residual.

## Inputs
- Mixed audio (wav/flac preferred; lossy sources degrade separation quality)
- Target `track_classes` list

## Outputs
- One stem per class + residual, registered in [[sqlite-store]] with source hash,
  task id, and class label
- A [[Logs/_index|log]] entry noting bleed/artifact observations

## Quality checks (before handing off)
Apply [[stem-engineering]] criteria: audible **bleed** between classes, **phase**
coherence when stems are summed against the source (null test: sum of stems minus
original should approach silence), and clipping introduced by separation. Score and note
failures — downstream `repaint` on a bleedy stem will bake the bleed in.

## Hand-off
Post a `handoff` signal via [[scrum-master-mcp]] with stem paths and the null-test
result, then reassign the board task.
