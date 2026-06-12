---
tags: [production, stems, sme]
authority: 10
updated: 2026-06-12
---

# Stem engineering

What makes a *good* stem — the central deliverable of MDS, so this note carries maximum
authority. A stem is one track-class submix exported such that summing all stems
reproduces the mix. The criteria below are the standards [[best-of-n-evaluation]]
applies to `extract` and generated-stem candidates, and the contract
[[stem-separation]]/[[stem-regeneration]] hand off against.

## Bleed
Bleed is energy from other sources inside a stem: drum bleed in a vocal stem (recorded
sources) or separation residue (extracted stems). Why it matters operationally: any
processing or [[glossary|repaint]] applied to a bleedy stem processes the bleed too —
mute the vocal stem and the chorus drums get quieter; regenerate the bass stem and a
ghost of the old kick survives in it. Standards: bleed ≥ ~40 dB below the stem's
program level is workable; audible musical bleed (you can name the tune from it) fails.
Measure by soloing the stem during the source's rests.

## Phase coherence
Stems must sum coherently. The **null test** is the acceptance check: sum of all stems,
polarity-inverted against the reference mix, should approach silence (residual below
roughly −40 dB). Failure causes: time misalignment between stems (even sub-millisecond
shifts comb-filter shared content), width tricks that put anti-phase content in two
stems, or separation artifacts. Low end is most fragile — kick and bass stems that
each sound fine can hollow each other out when summed (see [[psychoacoustics]] on why
the ear forgives high-frequency phase but the meter doesn't forgive cancelled bass).

## Headroom
Stems are delivered **pre-master**: each stem peaking ≤ −6 dBFS, the *sum* peaking
≤ −3 dBFS with no limiter on the stem bus. A stem rendered through mix-bus limiting is
poisoned — the limiter's gain reduction was computed from the full mix, so the soloed
stem pumps to the rhythm of instruments it doesn't contain. Loudness targets apply to
the final master only ([[mastering-and-loudness]]), never to stems.

## Bus structure
Good stems mirror a sane bus tree ([[mixing-fundamentals]]): stems are cut at function
buses (drums / bass / music / vocals, or finer per `track_classes`), **including** each
bus's own processing and its share of send effects. The reverb question must be decided
explicitly: either each stem carries its own wet signal (stems sum to the exact mix;
default for MDS) or effects ship as a separate stem (more remix freedom). Mixing the two
conventions in one stem set is a defect.

## Practical checklist
1. All stems same length, same start point, same sample rate/bit depth.
2. Null test against reference mix passes.
3. Solo check: no nameable foreign material (bleed).
4. Peak headroom per stem and on the sum.
5. Wet/dry convention recorded in the [[glossary|StemSpec]] metadata in
   [[sqlite-store]].
