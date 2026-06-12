---
tags: [music-theory, harmony, sme]
authority: 9
updated: 2026-06-12
---

# Harmony and voice leading

## Chord construction
Tertian harmony stacks thirds: a triad is root–third–fifth; quality (major, minor,
diminished, augmented) is fixed by the third and fifth. Seventh chords add one more
third — the workhorses are the major 7th (Imaj7), minor 7th (ii7), and dominant 7th
(V7), whose tritone between its 3rd and 7th supplies the pull toward resolution. Most
popular-music harmony is diatonic seventh-chord vocabulary plus a handful of borrowings.

## Function
Tonal harmony is best understood as three functional families cycling
**Tonic → Predominant → Dominant → Tonic**: in a major key, T = {I, vi, iii},
PD = {ii, IV}, D = {V, vii°}. Progressions feel "right" when they descend this gradient
and "interrupted" when they retreat (V → IV is the classic rock reversal — a stylistic
marker, not an error). Cadences punctuate: authentic (V→I, conclusive), half (ends on V,
open), plagal (IV→I, soft), deceptive (V→vi, withheld resolution). A chorus typically
earns its arrival with a strong authentic cadence; verses can float on weaker ones.

## Color beyond the diatonic set
- **Secondary dominants** (V/x) tonicize any diatonic chord briefly — V/vi (E7 in C)
  before Am is the most common pop borrowing.
- **Modal interchange** borrows from the parallel mode: ♭VII, iv, and ♭VI in a major key
  give the darker lift heard across rock and synth-pop.
- **Mode choice** carries affect wholesale: Dorian's raised 6th brightens minor (funk,
  santana-style vamps); Mixolydian's ♭7 relaxes major (classic rock); Lydian's ♯4 floats
  (film/ambient). This is why `key_scale` is pinned metadata in the
  [[glossary|SongBlueprint]], not caption prose.

## Voice leading
Independent of *which* chords, **how voices move** decides smoothness:
1. Keep common tones; move the rest by step.
2. Prefer contrary or oblique motion between outer voices.
3. Avoid parallel perfect fifths/octaves between independent voices — they fuse the
   voices and collapse the texture (in synth stacks this fusion is sometimes *wanted*;
   know which effect you're choosing).
4. Resolve tendency tones: leading tone up to tonic, chordal 7th down by step.

## Evaluation criteria
When scoring candidates ([[best-of-n-evaluation]]):
- Harmonic rhythm should be regular or purposefully irregular — random chord-change
  spacing reads as incoherent.
- Detected key must match the pinned `key_scale`; transient tonicizations are fine,
  drifting tonal center is not.
- Bass and melody ([[melody-and-motif]]) should mostly move in contrary/oblique motion;
  pervasive parallels between them is a defect in most genres per
  [[genre-tag-taxonomy]].
