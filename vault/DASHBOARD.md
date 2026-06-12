---
tags: [dashboard]
authority: 5
updated: 2026-06-12
---

# MDS Ops Dashboard

Live view over the vault (requires the **Dataview** community plugin — included in the
agent-ops layout recommendations). Start here; drill into [[project-context]] for
orientation or [[Logs/_index|Logs]] for raw activity.

## Open blockers

```dataview
TABLE WITHOUT ID file.link AS "Log", agent AS "Agent", blockers AS "Blockers", date AS "Date"
FROM "Logs"
WHERE status = "blocked" OR length(blockers) > 0
SORT date DESC
```

> Empty table = nothing blocked. Anything appearing here should also have fired a
> `blocked` signal via [[scrum-master-mcp]].

## Recent activity (Logs)

```dataview
TABLE WITHOUT ID file.link AS "Log", agent AS "Agent", status AS "Status", date AS "Date"
FROM "Logs"
WHERE contains(tags, "log") AND !contains(tags, "template")
SORT date DESC
LIMIT 14
```

## Memory (decisions & conventions)

```dataview
TABLE WITHOUT ID file.link AS "Note", authority AS "Authority", updated AS "Updated"
FROM "Memory"
SORT updated DESC
```

## Highest-authority knowledge (what RAPTOR trusts most)

```dataview
TABLE WITHOUT ID file.link AS "Note", authority AS "Authority", updated AS "Updated"
FROM "Music Theory SME" OR "Skills" OR "Tools"
WHERE authority >= 8
SORT authority DESC, updated DESC
```

## Quick links

- Today: [[2026-06-12]] · worksheet: [[stem-session]] · new log: [[daily-log-template]]
- Standards: [[Music Theory SME/_index|SME library]] · operations: [[Skills/_index|Skills]]
- Ground truth: [[decisions]] · [[conventions]] · [[glossary]]
