---
tags: [production, genre, captions, sme]
authority: 9
updated: 2026-06-12
---

# Genre & tag taxonomy → generation captions

How genre/style vocabulary maps onto the caption string that conditions the engine.
[[prompt-translation]] consults this note when compiling captions; [[best-of-n-evaluation]]
uses it to decide which genre norms (tempo bands, loudness bands, arrangement
conventions) apply to a candidate.

## The tag hierarchy
Captions are ordered from coarse to fine, because earlier tokens steer the engine
hardest:

1. **Genre** — the top-level family: `pop`, `rock`, `hip-hop`, `electronic`, `jazz`,
   `folk`, `classical`, `r&b`, `country`, `metal`.
2. **Subgenre** — narrows the rhythm/timbre priors decisively: `house` vs `techno` vs
   `drum and bass` imply different `bpm` bands ([[rhythm-and-meter]]) and drum
   vocabularies; `trap` vs `boom bap` imply swung 16th hats vs swung 8th kicks.
3. **Mood/affect** — `melancholic`, `euphoric`, `menacing`, `nostalgic`; correlates
   with mode choice ([[harmony-and-voice-leading]]) and tempo within the band.
4. **Instrumentation** — concrete `track_classes` hints: `808 bass`, `acoustic guitar`,
   `analog synth pads`, `live drums`. Envelope words help ([[orchestration-and-timbre]]):
   `plucked`, `swelling`, `stabby`.
5. **Era/production style** — `80s`, `lo-fi`, `tape-saturated`, `modern polished`;
   steers timbre and the implied loudness/crest profile
   ([[mastering-and-loudness]]).
6. **Vocal descriptors** — `female vocal`, `rap verse`, `airy harmonies`, or
   `instrumental`.

Example compile: *"something dark and bouncy to drive to at night"* →
`electronic, deep house, dark, hypnotic, analog synth bass, sparse percussion, moody pads, night drive, male vocal chops` + pinned `bpm: 122`,
`key_scale: F minor`, `time_signature: 4/4`.

## Mapping rules
- **Never encode pinned metadata in prose.** `bpm`, `key_scale`, `time_signature`,
  duration are fields; "120 bpm" inside the caption invites conflict between prose and
  field.
- **One genre family per caption.** Fusion is expressed as genre + borrowed
  *instrumentation/mood* tags (`hip-hop, jazz piano, brushed drums`), not as two genres
  fighting (`jazz, drum and bass` is a coin flip).
- **Tags must be checkable.** Prefer descriptors with measurable consequences (tempo
  band, swing, instrumentation present, loudness band) — they become
  [[best-of-n-evaluation]] gates. `vibey` checks nothing.
- **Stem captions inherit, then specialize.** A per-stem caption fragment
  ([[glossary|StemSpec]]) keeps the global genre tokens and adds role words: parent
  caption + `driving sub bass, side-chained` for the bass stem in a `lego` call.

## Genre norms the evaluator applies
| Family | Tempo band | Loudness norm | Signature checks |
| --- | --- | --- | --- |
| house/techno | 120–145 | −9 to −7 LUFS (club) | four-on-floor kick, off-beat hats |
| trap/hip-hop | 130–160 halftime (or 80–100) | −10 to −8 | 808 glide, swung hats |
| DnB | 170–178 | −9 to −7 | breakbeat, sub weight |
| pop | 90–120 | −11 to −9 | backbeat, verse/chorus tessitura lift ([[melody-and-motif]]) |
| ballad/folk | 60–90 | −14 to −12 | dynamic LRA preserved |

When a candidate violates its family's norms, that's evidence of caption failure —
route the fix to the caption/blueprint via [[prompt-translation]], not to post-processing.
