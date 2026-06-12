---
tags: [tool, vectors, sqlite, memory]
authority: 7
updated: 2026-06-12
---

# Tool: Embedded vector store

Durable vectors for Strategy A, implemented as `SQLiteVectorStore` in
`music_data_science/memory/vector_store.py`
([cazador0/ACE-Step-1.5](https://github.com/cazador0/ACE-Step-1.5)). Embeddings live in
one SQLite table beside the [[sqlite-store]] system of record; search is a normalized
numpy matrix product (brute-force cosine) over a namespace.

## Why embedded, not a vector server

At vault scale — thousands of chunks, not millions — a brute-force scan over an
in-process table beats operating a separate service: no second daemon, no network hop,
no sync protocol between "the vectors" and "the rows". This is the verdict from
`project/DATA_STRATEGY.md` recorded in [[decisions]] ADR-002; hot in-flight embeddings
still belong to [[redis]], this store is the durable side only.

## Namespaces

Every vector is keyed `(namespace, ref)` — e.g. the RAPTOR tree under `raptor`, vault
chunks under their own namespace. `add`/`search`/`count`/`clear` all take the namespace,
so indexes can be rebuilt independently without touching each other.

## RAPTOR persist/restore

- `persist_raptor(tree, store)` clears the namespace and writes every tree node (text,
  embedding, level, source, `authority`, children) as one vector row.
- `restore_raptor(store, tree)` loads the node set back into a configured tree, skipping
  the build step entirely — retrieval over this vault works immediately after a restart
  **without re-chunking or re-embedding the notes**.

Rebuild (re-chunk → re-embed → `persist_raptor`) only when the vault actually changed:
the chunker compares each note's `updated` frontmatter against the index, per
[[conventions]]. Note: the chunker normalizes the vault's human-facing 1–10 `authority`
scale into [0,1] for scoring — keep writing 1–10 (see [[decisions]] ADR-006).

## Upgrade path

If a namespace ever outgrows brute force, `sqlite-vec` or LanceDB are drop-in
replacements behind the same interface — same file-beside-the-record deployment, no
architecture change. Don't reach for a vector server before that.
