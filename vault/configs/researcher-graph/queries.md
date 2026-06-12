---
tags: [config, dataview, queries]
authority: 5
updated: 2026-06-12
---

# Researcher queries (Dataview DQL)

Example queries for the researcher-graph layout. Requires **Dataview**; the graph-query
examples at the bottom require **Juggl**. Juggl renders Cytoscape.js graphs driven by
queries — the closest practical thing to a graph database over a markdown vault. If you
outgrow it (multi-hop queries, real Cypher), the heavier alternative is syncing the
vault into Kùzu or Neo4j with an export script; that buys query power at the cost of a
second store to keep fresh.

## Authority audit — what does RAPTOR trust most?

```dataview
TABLE WITHOUT ID file.link AS "Note", authority AS "Authority", updated AS "Updated", file.folder AS "Folder"
WHERE authority != null
SORT authority DESC, updated DESC
LIMIT 20
```

## Stale high-authority notes (review candidates)

```dataview
TABLE WITHOUT ID file.link AS "Note", authority AS "Authority", updated AS "Updated"
WHERE authority >= 8 AND updated < date(today) - dur(90 days)
SORT updated ASC
```

## Most-linked notes (hubs in the graph)

```dataview
TABLE WITHOUT ID file.link AS "Note", length(file.inlinks) AS "Inlinks", authority AS "Authority"
WHERE length(file.inlinks) > 0
SORT length(file.inlinks) DESC
LIMIT 15
```

## Orphans (no inlinks — wire them in or delete them)

```dataview
LIST
WHERE length(file.inlinks) = 0 AND !contains(file.path, "configs") AND file.name != "DASHBOARD"
```

## SME ↔ Skills cross-references

```dataview
TABLE WITHOUT ID file.link AS "SME note", filter(file.outlinks, (l) => contains(string(l), "Skills")) AS "Links into Skills"
FROM "Music Theory SME"
WHERE file.name != "_index"
```

## Juggl graph queries

Open a Juggl pane and use these as starting points:

- Workspace graph seeded from the SME index, depth 2 — shows how standards connect to
  [[Skills/_index|Skills]]:
  code block ` ```juggl ` with `local: "Music Theory SME/_index"` and `depth: 2`
- Style nodes by folder to mirror the global graph's color groups (Skills green, Tools
  orange, SME purple, Memory blue — same palette as `graph.json`).
