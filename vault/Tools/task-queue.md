---
tags: [tool, queue, redis, data-layer]
authority: 7
updated: 2026-06-12
---

# Tool: Task queue (Redis Streams)

The work queue of Strategy A, implemented in `music_data_science/data/queue.py`
([cazador0/ACE-Step-1.5](https://github.com/cazador0/ACE-Step-1.5)). It rides on the
[[redis]] hot path (Valkey works identically — the queue speaks plain RESP) and lets
several agents claim generation/evaluation work cooperatively without stepping on each
other.

## Streams

| Stream | Carries | Consumed by |
| --- | --- | --- |
| `mds:queue:generation` | blueprint/edit jobs for [[acestep-api]] | pipeline-agent |
| `mds:queue:evaluation` | Best-of-N candidate batches for [[best-of-n-evaluation]] | data-agent |
| `mds:queue:ui` | vault/log update jobs | ui-agent |

Messages are flat `str -> str` field maps (the Streams data model); anything structured
goes in as JSON in one field, with the [[sqlite-store]] row remaining the truth.

## Claim/ack semantics

- `enqueue(stream, fields)` appends and returns a message id.
- `claim(stream, group, consumer, count)` delivers new messages to one consumer in a
  consumer group; independent groups each see every message, consumers within a group
  split them.
- A claimed message stays **pending** for its group until `ack(stream, group, id)` —
  this is the crash-safety guarantee: a crashed agent's unfinished work remains visible
  via `pending(stream, group)` and can be reclaimed at startup rather than silently lost.
- **Ack only after the matching [[sqlite-store]] row is in a terminal state.** Ack-then-
  write inverts the reconciliation protocol from [[decisions]] ADR-002.

## Fallback

`create_queue(redis_url)` is the only entry point agents should use: it returns a
`RedisStreamQueue` when a URL is given and the optional `redis` package is importable
(`pip install music-data-science[data]`), otherwise a `MemoryStreamQueue` with the same
consumer-group semantics. Importing the module never requires redis, so dry runs and
tests work on a bare machine — but the in-memory queue dies with the process, so it is
never a substitute for [[redis]] in a live multi-agent session.

## When to use it

Any work another agent (or a later restart) must be able to pick up: enqueue, don't
message. [[scrum-master-mcp]] signals coordinate *people-shaped* decisions; the queue
carries the *jobs*. If losing the message would lose work, it belongs on a stream.
