---
tags: [production, mixing, sme]
authority: 9
updated: 2026-06-12
---

# Mixing fundamentals

## Gain staging
Set static levels *before* any processing: each stem peaking around −12 to −6 dBFS,
mix bus peaking below −6 dBFS, leaving headroom for [[mastering-and-loudness]]. A mix
that "needs" a limiter to avoid clipping is mis-staged. Balance first with faders only —
a surprising fraction of "EQ problems" are level problems.

## EQ: subtractive first
- **High-pass everything that isn't bass or kick** (gently, ~80–120 Hz) — cumulative
  low-frequency rumble from a dozen stems eats all the headroom.
- **Cut before boost**: find the offending resonance (narrow boost-and-sweep, then cut);
  cuts sound more transparent than boosts of equal size.
- Carve **complementary pockets** where stems collide: e.g. cut 2–4 kHz slightly in
  guitars where the vocal needs presence, dip the bass at the kick's fundamental.
  This is applied [[psychoacoustics]] — you are managing masking within critical bands.
- Mud lives at 250–500 Hz; harshness at 2.5–5 kHz; "boxiness" near 400–800 Hz.

## Compression
Parameters and what they do: **threshold/ratio** set how much; **attack** decides
whether transients pass (slow attack ≈ 30 ms+ preserves punch; fast attack rounds it
off); **release** sets pumping vs breathing (time it to the tempo — see
[[rhythm-and-meter]]). Typical uses: vocal leveling (2–4 dB gain reduction, 3:1),
bass consistency (faster attack), drum bus glue (1.5–2:1, slow attack, fast release).
Parallel (NY) compression — crushed copy blended under the dry signal — adds density
without killing dynamics.

## Panning and width
Low frequencies stay centered (mono-compatible energy, vinyl/club PA reality), as do
lead vocal, kick, snare, bass. Spread chordal and percussive color with intent
(e.g. hats 30% L, shaker 40% R); true stereo width belongs to pads, doubles, reverbs.
Check mono periodically — width built from phase tricks collapses (see
[[stem-engineering]] on phase coherence).

## Depth: reverb and delay
Depth is the third axis: dry/early-reflection sounds read as close, longer/darker
reverb tails as far. Use few shared spaces (one short room, one plate/hall, one tempo-
synced delay) on sends rather than per-stem inserts — shared spaces glue stems into one
scene and keep stems recombinable. Pre-delay (20–40 ms) keeps the vocal in front of its
own reverb.

## Bus structure
Route stems to function buses (drums, bass, music, vocals) and process the bus, not
just the parts — this is also exactly the structure that makes good stems exportable
(see [[stem-engineering]]). Reference against 2–3 commercial tracks in the genre at
matched loudness; level-matched comparison is the only honest one
([[psychoacoustics]]: louder reads as better).

## Evaluation criteria
For [[best-of-n-evaluation]] on mixed candidates: vocal intelligibility (presence-band
energy unmasked), low-end mono and single-owner ([[orchestration-and-timbre]]), no
sustained inter-stem masking, crest factor appropriate to genre, mono fold-down loses
ambience but not parts.
