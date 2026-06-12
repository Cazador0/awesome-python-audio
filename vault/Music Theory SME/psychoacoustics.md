---
tags: [production, psychoacoustics, sme]
authority: 9
updated: 2026-06-12
---

# Psychoacoustics

How hearing actually works — the science under [[mixing-fundamentals]] and
[[orchestration-and-timbre]].

## Critical bands
The cochlea analyzes sound in overlapping frequency channels (**critical bands**,
~24 Bark bands; bandwidth ≈ 100 Hz below 500 Hz, roughly a third-octave above). Two
tones within one band interact — they beat, mask each other, and sum loudness less than
two tones in separate bands. Consequences: dense voicings low in the spectrum sound
muddy because intervals that span multiple bands at 1 kHz cram into one band at 100 Hz
(the classical "low interval limit": keep thirds above ~E2 territory); and spreading an
arrangement across bands is what makes it sound *big* without being loud.

## Masking
A loud sound raises the audibility threshold for nearby sounds:
- **Simultaneous masking** — strongest within the same critical band, and asymmetric:
  low frequencies mask upward more than highs mask downward. A thick bass eats the
  low-mids of everything above it.
- **Temporal masking** — sounds are masked up to ~20 ms *before* (backward) and
  ~100–200 ms *after* (forward) a masker. This is why a hat right after a snare hit
  vanishes, and why nudging conflicting hits apart (or sidechain-ducking pads under the
  kick) restores clarity.

Mixing is largely masking management: the complementary EQ pockets in
[[mixing-fundamentals]] exist to take competing stems out of each other's bands.

## Equal loudness (Fletcher–Munson)
Sensitivity varies with frequency *and level* (equal-loudness contours, ISO 226): the
ear peaks at 2–5 kHz and rolls off steeply in the lows, but the contours **flatten as
playback gets louder**. Hence: a mix balanced at high monitoring level loses its bass
and air when played quietly; "louder sounds better" in A/B comparisons even when
nothing else changed. Operational rules: mix at moderate level, check at low level
(the balance that survives quiet playback is the robust one), and **level-match every
comparison** — including candidate ranking in [[best-of-n-evaluation]], which is why
loudness normalization precedes scoring (see [[mastering-and-loudness]]).

## Localization and the Haas effect
Below ~700 Hz we localize by interaural time difference, above ~1.5 kHz by level
difference — one reason low frequencies are mixed mono ([[mixing-fundamentals]]). The
**Haas (precedence) effect**: a copy delayed 1–30 ms fuses with the original and the
pair localizes to the earlier arrival — usable for width, but it comb-filters in mono,
which is the classic phase trap flagged in [[stem-engineering]].

## Why MDS encodes this
These effects are *measurable*, so they become automatic checks: per-band masking
ratios between stems, loudness-normalized scoring, mono fold-down deltas. Perceptual
science is the part of "professional standards" that doesn't require taste to verify.
