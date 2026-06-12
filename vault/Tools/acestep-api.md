---
tags: [tool, acestep, api]
authority: 8
updated: 2026-06-12
---

# Tool: ACE-Step API (`/release_task`)

The generation engine. Served from
[cazador0/ACE-Step-1.5](https://github.com/cazador0/ACE-Step-1.5)
(branch `claude/peaceful-dijkstra-m0sycf`); the `music_data_science/` package wraps this
contract — agents should normally go through the wrapper, not raw HTTP.

## Contract summary

`POST /release_task` with a JSON body; returns a `task_id`. Poll the task endpoint (or
consume the result stream via [[redis]]) until the task completes; results are file paths
plus metadata.

### Common fields (all task types)
| Field | Notes |
| --- | --- |
| `task_type` | one of `text2music`, `repaint`, `cover`, `extract`, `lego`, `complete` |
| `prompt` | the caption — compiled by [[prompt-translation]], ordered per [[genre-tag-taxonomy]] |
| `lyrics` | lyrics with structure tags (`[verse]`, `[chorus]`, `[bridge]`) or empty |
| `bpm` | pinned tempo (constrained metadata — do not encode tempo in prose) |
| `key_scale` | e.g. `"F minor"` — pinned |
| `time_signature` | e.g. `"4/4"` — pinned |
| `audio_duration` | seconds |
| `seed` | always set or record the returned one; reproducibility depends on it |
| `n_candidates` | Best-of-N width for [[best-of-n-evaluation]] |

### Per-task-type fields
| `task_type` | Extra fields | Use via |
| --- | --- | --- |
| `text2music` | — | [[prompt-translation]] |
| `repaint` | `src_audio_path`, `repaint_start`, `repaint_end` (seconds) | [[stem-regeneration]] |
| `cover` | `src_audio_path` (re-style source under new caption) | [[prompt-translation]] |
| `extract` | `src_audio_path`, `track_classes` | [[stem-separation]] |
| `lego` | `src_audio_path`, `track_classes` (generate new stems against source) | [[stem-regeneration]] |
| `complete` | `src_audio_path` (finish a partial arrangement) | [[prompt-translation]] |

## Operational notes
- Audio codes are cached keyed by (blueprint hash, seed) — repeat renders with unchanged
  specs are nearly free; never bust the cache by reordering caption words gratuitously.
- Long renders: the task queue lives in Redis Streams; don't busy-poll, consume.
- Every call and its result row is persisted to [[sqlite-store]]; the call is not "done"
  until that row exists.
