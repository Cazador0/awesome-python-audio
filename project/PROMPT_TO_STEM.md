# Prompt → Stem: the research problem

The core MDS problem: translate a natural-language prompt into **Stem objects** —
individually editable, recombinable audio tracks — while maximizing the probability that
the rendered output matches user intent.

## Honesty first

**100% certainty that output == intent is an open research problem in music data
science**, and we should say so plainly. Three gaps compound:

1. **Intent is underspecified.** "A warmer chorus" admits many valid realizations; the
   user often cannot articulate the target until they hear candidates. No representation
   closes this gap — only interaction does.
2. **Generation is stochastic.** Diffusion-based engines like ACE-Step sample; even a
   fixed prompt yields a distribution over outputs, and semantic conditioning is
   approximate (captions steer, they don't specify).
3. **Evaluation is unsolved.** There is no agreed computable metric for "matches the
   user's musical intent". Proxy scores (tag classifiers, tempo/key detectors, embedding
   similarity, loudness conformance) correlate with intent; they do not equal it.

So the target is not certainty — it is **calibrated probability of acceptance, raised
iteration by iteration**, with the cost of each iteration driven down.

## The engineering path

Implemented in `music_data_science/` of
[cazador0/ACE-Step-1.5](https://github.com/cazador0/ACE-Step-1.5)
(branch `claude/peaceful-dijkstra-m0sycf`):

### 1. Structured intermediate representation: SongBlueprint → StemSpec
Prompts are first compiled into a **SongBlueprint** (global intent: caption, lyrics,
form, energy curve) which expands into per-track **StemSpecs** (one per stem: track
class, role, register, density, entry/exit bars). Every downstream call is generated
from this IR, never from free text — so the system can diff intent, explain decisions,
and re-render any single stem. See the vault's `Skills/prompt-translation` note.

### 2. Constrained metadata
The IR pins the enumerable axes — `bpm`, `key_scale`, `time_signature`, and
`track_classes` — as hard fields rather than caption words. Constraining what *can* be
constrained removes whole error classes (wrong tempo, wrong key) from the stochastic
part of the problem and makes them mechanically checkable after generation.

### 3. Reproducibility: seed pinning + audio-code caching
Every render records its seed; intermediate audio codes are cached keyed by
(blueprint hash, seed). Re-rendering with one StemSpec field changed reuses everything
untouched, making generation **referentially transparent enough to iterate on**: same
inputs, same stems.

### 4. Minimal-diff edits: windowed repaint
Edits compile to ACE-Step `repaint` calls scoped to a time window and stem, not to full
re-generation. The user's accepted material is never put back at risk; the diff between
revisions is as small as the request implies.

### 5. Best-of-N + automatic scoring + acceptance thresholds
Each render produces N candidates. The eval pipeline scores them against constraints
(tempo/key/duration conformance), embedding similarity to the blueprint caption, and
professional standards retrieved by RAPTOR from the vault's `Music Theory SME` library
(weighted by note `authority`). Candidates below the acceptance threshold are never shown;
the threshold is tuned from the Parquet eval frames over time. Best-of-N converts "the
model is stochastic" from a bug into a search strategy.

### 6. Human-in-the-loop convergence
The remaining intent gap is closed interactively: the user reacts to top-K candidates,
reactions are compiled back into blueprint deltas (not new free-text prompts), and the
loop repeats with cached codes keeping each round cheap. Acceptance history per user
trains the scorer's priors — the system's calibration improves with use.

## Posture

Treat P(output == intent) as a metric to **measure, report, and raise** — via constraints
(remove error classes), reproducibility (make iteration safe), search (Best-of-N),
retrieval-grounded scoring (RAPTOR over the vault), and tight human feedback loops — not
as a property to claim.
