---
tags: [music-theory, orchestration, timbre, sme]
authority: 9
updated: 2026-06-12
---

# Orchestration and timbre

## Registers and roles
An arrangement is a division of the frequency spectrum and the rhythmic grid among
instruments. The stable role archetypes, by register:
- **Sub/bass (≈30–250 Hz)** — one occupant at a time: bass guitar, synth bass, or 808.
  Two bass-register instruments fighting is the most common amateur-arrangement defect.
- **Low-mid (250–500 Hz)** — chord instruments' bodies (guitar/keys); the "mud" zone
  when over-occupied.
- **Mid (500 Hz–2 kHz)** — melodic core; the vocal lives here and everything else
  yields to it.
- **High-mid (2–6 kHz)** — presence, attack transients, intelligibility.
- **Air (6 kHz+)** — cymbals, breath, shimmer.

Each [[glossary|StemSpec]] assigns a register and role (foundation, pad, riff, lead,
counter-line, percussion) so that `track_classes` arrive at the engine as a coherent
*ensemble plan*, not a shopping list.

## Timbre mechanics
Timbre = spectral envelope + temporal envelope. The **ADSR** shape often matters more
than the waveform: a slow-attack pad and a plucked stab can share a spectrum and still
serve opposite roles. Brightness correlates with spectral centroid; perceived "warmth"
with strong low-order harmonics and soft attack. When captioning
([[genre-tag-taxonomy]]), envelope words ("plucked", "swelling", "stabby") steer the
engine at least as effectively as instrument names.

## Doubling and layering
- Octave doubling thickens without new harmony; unison doubling of different timbres
  (e.g. piano + strings) creates composite instruments.
- Layering rule: layers must *differ* on at least one axis (register, envelope, width)
  or they merely add mud and phase risk (see [[stem-engineering]]).
- Fusion vs segregation is a psychoacoustic outcome — shared onset times and harmonic
  coincidence fuse sources; see [[psychoacoustics]] on critical bands and masking.

## Density and the energy curve
Orchestration executes the [[form-and-structure]] energy curve: verses thin (3–4 active
roles), choruses full (6+), and the pre-chorus *adds* one element at a time. Subtraction
is the most underused tool — dropping the bass for the last pre-chorus bar makes the
chorus land harder than any addition could.

## Evaluation criteria
For [[best-of-n-evaluation]]:
- One bass-register owner at a time; spectral occupancy per register matches the
  StemSpec plan.
- Lead/vocal unmasked in the 1–4 kHz region (check against [[mixing-fundamentals]]).
- Layer count tracks the per-section energy targets; all-sections-equally-dense is a
  reject.
- For `lego` tasks specifically: the added stem must occupy the *requested* register and
  role, not duplicate an existing one.
