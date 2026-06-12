---
tags: [production, mastering, loudness, sme]
authority: 9
updated: 2026-06-12
---

# Mastering and loudness

## What mastering is
The last 10%: a finished stereo mix is tonally balanced against the genre reference,
brought to delivery loudness, and quality-checked as a deliverable. It cannot fix a
mix — if mastering moves require more than a few dB anywhere, the fix belongs upstream
in [[mixing-fundamentals]] or the stems.

## Loudness measurement
Loudness is measured in **LUFS** (Loudness Units relative to Full Scale; ITU-R BS.1770
K-weighted, gated): *integrated* (whole program), *short-term* (3 s), *momentary*
(400 ms). **True peak** (dBTP) measures inter-sample peaks after reconstruction —
a file can show −0.1 dBFS sample peaks yet clip converters at +0.5 dBTP.
**LRA** (loudness range) and **crest factor** (peak-to-RMS) describe how dynamic the
program is.

## Targets that matter in practice
- **Streaming normalization**: Spotify/YouTube/Tidal normalize to roughly **−14 LUFS**
  integrated (Apple Music ~−16 with Sound Check). Masters louder than the target are
  simply turned down — the loudness war buys nothing on these platforms except crushed
  dynamics at equal playback volume.
- **Sensible delivery**: integrated **−14 to −9 LUFS** depending on genre (singer-
  songwriter near −14, dense EDM/hip-hop often −9 to −8 by convention even though it's
  normalized down), with **true peak ≤ −1.0 dBTP** (codec headroom for lossy encoding).
- Club/DJ deliverables run hotter (−8 to −6 LUFS) because playback chains there don't
  normalize.

## The chain (typical order)
1. Corrective EQ (linear-phase if surgical) — match spectral tilt to references.
2. Gentle bus compression (≤ 2 dB GR) for glue.
3. Saturation/excitation if density is wanted.
4. Stereo management — keep ≲120 Hz mono; widen only above.
5. **Limiter last**: set ceiling −1.0 dBTP, push input until integrated LUFS hits
   target; if you need > 3–4 dB of limiting to get there, return to the mix.
6. Dither when reducing bit depth (24 → 16-bit).

## Why MDS cares
Loudness conformance is a **hard gate** in [[best-of-n-evaluation]]: candidates are
checked for integrated LUFS within the genre band (per [[genre-tag-taxonomy]]), true
peak ≤ −1 dBTP, and crest factor sane for the style. Equal-loudness comparison also
underpins fair candidate ranking — louder candidates otherwise win on
[[psychoacoustics]] alone, not on quality. Stems are delivered *pre-master* with
headroom (see [[stem-engineering]]); the master is rendered from the summed mix, never
the other way around.
