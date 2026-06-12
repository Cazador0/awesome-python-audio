---
tags: [music-theory, rhythm, sme]
authority: 9
updated: 2026-06-12
---

# Rhythm and meter

## Pulse, beat hierarchy, meter
Meter is a *hierarchy* of pulses, not just a count: in 4/4 the strength ordering is
beat 1 > 3 > 2 = 4, with eighth- and sixteenth-level subdivisions nested below.
**Simple** meters divide the beat in two (2/4, 3/4, 4/4); **compound** meters divide it
in three (6/8, 9/8, 12/8). 6/8 vs 3/4 is the classic ambiguity — same six eighths,
different grouping (2×3 vs 3×2); a **hemiola** exploits exactly this by temporarily
regrouping. `time_signature` is pinned [[glossary|blueprint]] metadata because the
engine cannot be allowed to guess the hierarchy.

## Syncopation and groove
Syncopation places accents where the hierarchy predicts weakness — anticipations
(attacking an eighth early), off-beat chords, tied notes across strong beats. It creates
energy precisely because the meter is *maintained* underneath; pervasive syncopation
with no anchoring pulse reads as error, not funk. Genre conventions, roughly:
- **Backbeat** (snare on 2 and 4): rock, pop, soul — near-universal.
- **Swing**: subdivision pairs played long–short (ratio varies ~3:2 to 2:1 with tempo);
  jazz, shuffle blues, much hip-hop via swung sixteenths.
- **Clave-based** patterns (son 3-2/2-3): Afro-Cuban and reggaetón's dembow descend
  from these asymmetric timelines.
- **Four-on-the-floor**: kick on every beat — house/techno/disco foundation, with hats
  on off-eighths supplying the lift.

## Polyrhythm and metric dissonance
Polyrhythm superposes incommensurate groupings (3:2, 4:3); cross-rhythm sustains it.
Metric **displacement** (a pattern shifted by an eighth) and **grouping dissonance**
(4/4 drums under a 3-beat synth loop — the "turnaround" effect every 3 bars) are cheap,
powerful tension devices in electronic genres.

## Tempo and microtiming
`bpm` ranges carry genre identity: hip-hop ~80–100 (or double-time trap hats over
130–160 halftime), house 120–128, techno 125–145, DnB 170–178, ballads 60–80. Groove
also lives in **microtiming** — systematic sub-30ms deviations (laid-back snare, pushed
hats). Quantized-to-grid is itself an aesthetic (techno), not a default.

## Evaluation criteria
For [[best-of-n-evaluation]] and [[stem-regeneration]]:
- Detected tempo must match pinned `bpm` (accept the half/double-time octave only if the
  blueprint's genre admits it per [[genre-tag-taxonomy]]).
- Downbeats across stems must align — a drum stem and bass stem disagreeing on beat 1 is
  an automatic reject.
- Repaint windows snap to bar lines; cutting mid-beat smears transients (see
  [[stem-engineering]] on transient integrity).
