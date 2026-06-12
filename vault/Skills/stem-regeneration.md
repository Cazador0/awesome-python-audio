---
tags: [skill, stems, repaint, lego]
authority: 8
updated: 2026-06-12
---

# Skill: Stem regeneration

Re-render **one stem, or one time window of one stem**, while leaving everything the user
has already accepted untouched. This is the minimal-diff edit primitive of MDS (see
`project/PROMPT_TO_STEM.md`).

## When to use
- "Make the bass busier in the second verse" — accepted material elsewhere must not move.
- A candidate failed [[best-of-n-evaluation]] on a single track class only.
- Adding a *new* stem against existing ones (use `lego`, below).

## ACE-Step calls

### Replace within an existing stem — `task_type: repaint`
- `src_audio_path` — the current stem (or mix, for context-aware repaint)
- `repaint_start` / `repaint_end` — the window in seconds; derive from the
  [[glossary|blueprint]]'s bar map, never eyeball it
- `prompt` (caption) — regenerate from the updated StemSpec via [[prompt-translation]],
  keeping `bpm`, `key_scale`, `time_signature` pinned
- `seed` — new seed per candidate; the *old* seed stays recorded for rollback
- `n_candidates` — feed Best-of-N; never accept a single sample blind

### Add a stem against existing material — `task_type: lego`
- `src_audio_path` — the existing stem(s) the new track must lock to
- `track_classes` — the class to add (e.g. `["bass"]`)
- caption + pinned metadata as above

`lego` is generation *conditioned on* existing stems; `repaint` is regeneration *within*
existing audio. Choosing wrong wastes a render: if the user wants new material that
didn't exist, it's `lego`; if they want existing material changed, it's `repaint`.

## Inputs
- Stem(s) + their StemSpecs and seeds from [[sqlite-store]]
- The edit request compiled to a StemSpec delta
- Window boundaries in bars → seconds (bpm × time signature arithmetic)

## Outputs
- N candidate stems → [[best-of-n-evaluation]]
- Updated StemSpec + seed recorded; audio-code cache entries reused for untouched regions

## Pitfalls
- Repaint windows that cut mid-note smear transients: snap windows to bar lines and add a
  short crossfade region (see [[rhythm-and-meter]] on beat hierarchy).
- Regenerating a stem without re-checking the mix bus for masking against its neighbors —
  see [[psychoacoustics]] and [[mixing-fundamentals]].
