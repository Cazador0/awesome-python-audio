---
tags: [log, stem-session]
agent: pipeline-agent
date: 2026-06-12
status: in-progress
blockers: []
authority: 3
updated: 2026-06-12
---

# Stem session worksheet

Running worksheet for the active stem-editing session (the producer-console layout pins
this note). One block per render round; keep the latest round on top.

## Round template

```
### Round N — <task_type> — <date>
blueprint: <hash>          seed(s): <...>
window: bars <a>–<b> (<t0>s–<t1>s)   track_class: <...>
caption delta: <what changed and why>
candidates: N=<n> → accepted: <k>  (threshold: <τ>, per [[best-of-n-evaluation]])
verdict: <user reaction / next StemSpec delta>
```

## Round 0 — bootstrap — 2026-06-12
No renders yet. Next action per [[2026-06-12]]: `text2music` smoke test via
[[acestep-api]], then this worksheet tracks every [[stem-regeneration]] round.

Checks to run each round: bar-snapped repaint windows (see [[rhythm-and-meter]]),
null-test extracted stems (see [[stem-separation]]), masking pass on the summed mix
(see [[psychoacoustics]], [[mixing-fundamentals]]).
