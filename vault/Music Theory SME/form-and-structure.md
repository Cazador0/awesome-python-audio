---
tags: [music-theory, form, sme]
authority: 9
updated: 2026-06-12
---

# Form and structure

## Sectional functions
Sections are defined by *function*, not just label:
- **Intro** — establish tempo/key/timbre palette; promise the genre.
- **Verse** — narrative, low tessitura, harmonic motion away from tonic permitted.
- **Pre-chorus** — accelerate (sentence-form fragmentation, rising line, dominant
  preparation; see [[melody-and-motif]], [[harmony-and-voice-leading]]).
- **Chorus** — thesis statement: hook, tessitura peak, densest arrangement, strongest
  cadences. Same lyric each time by default.
- **Bridge** — one deliberate contrast (new chord area, often the relative or parallel
  mode), then back.
- **Outro** — dissipate or loop out.

## Standard forms
- **Verse–chorus** (the pop default):
  Intro–V1–PC–C–V2–PC–C–Bridge–C–C(out). ~3–4 min at typical tempi.
- **AABA** (32-bar standard form): two statements, contrasting B ("middle eight"),
  return. Jazz standards, Beatles-era pop.
- **12-bar blues**: I–I–I–I / IV–IV–I–I / V–IV–I–(V turnaround); the harmonic loop *is*
  the form.
- **Strophic** — one repeating section (folk, hymns); **through-composed** — no repeats
  (art song, some film cues).
- **EDM build–drop**: Intro(16)–Build(8/16)–Drop(16/32)–Break(16)–Build–Drop2–Outro,
  in 8/16/32-bar blocks; the **drop** is the chorus-equivalent and the **break** does
  the verse's job of clearing space.

## The energy curve
Form is experienced as an energy contour: arrangement density, register, rhythmic
subdivision, and loudness rising into choruses/drops and clearing afterward. A static
curve bores; a sawtooth that never clears exhausts. The [[glossary|SongBlueprint]]
encodes per-section energy targets precisely so [[best-of-n-evaluation]] can check the
rendered curve (RMS/onset-density envelope per section) against intent — and so the most
common generation failure mode, *sections that all sound the same density*, is caught
mechanically.

## Bar-count discipline
Sections run in multiples of 4 (usually 8/16/32) bars. This matters operationally: the
blueprint's bar map converts section boundaries to seconds
(`bars × beats_per_bar × 60 / bpm`), and every [[stem-regeneration]] repaint window and
`lego`/`complete` join point snaps to these boundaries. An odd-length section is a legal
artistic choice but must be *recorded in the blueprint*, otherwise downstream windows
misalign.

## Evaluation criteria
- Section boundaries detectable where the blueprint says they are (novelty curve peaks).
- Chorus/drop sections measurably denser and louder than verses (energy curve matches
  targets).
- Hook recurrence at fixed formal positions (see [[melody-and-motif]]).
- For `complete` tasks: the generated continuation must respect the established form,
  not restart it.
