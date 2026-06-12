---
tags: [tool, mcp, coordination]
authority: 8
updated: 2026-06-12
---

# Tool: Scrum-master MCP server

Coordination layer for all MDS agents, from
[cazador0/mcp-servers](https://github.com/cazador0/mcp-servers)
(branch `claude/peaceful-dijkstra-m0sycf`, `src/scrum-master/`). It exists so that **no
coding agent plays scrum master** — full rationale in `project/SCRUM_CEREMONIES.md`.
The server is auto-registered for every agent via this repo's `.mcp.json` — no manual
MCP setup needed.

## Tools

| Tool | Use |
| --- | --- |
| `post_message` | Send a signal-tagged, self-contained message to an agent/role/team |
| `check_inbox` | Explicitly drain unread messages (rare — digests usually suffice) |
| `standup` | File did / doing / blocked once per working session |
| `manage_task` | Create / claim / move / close board tasks |
| `get_board` | Snapshot the kanban board |

Every tool response piggybacks a digest of unread messages and board deltas —
coordination costs **zero extra turns**.

## Prompts (ceremonies)

| Prompt | Ceremony |
| --- | --- |
| `sprint-planning` | Goal selection + backlog slicing into board tasks |
| `daily-standup` | Compile standup entries into the shared digest |
| `retrospective` | Turn praise/frustration history into [[conventions]] updates and tasks |
| `unblock` | Blocker triage: what's blocked, who clears it, cheapest workaround |
| `handoff` | Enforced hand-off contract: task id, artifact paths, verified/unverified, next action |

## Signal taxonomy for `post_message`

`blocked` · `confused` · `frustrated` · `praise` · `handoff` · `help_wanted` · `fyi` · `done`

Pick exactly one. `blocked` auto-routes to `unblock`; `done` unblocks dependent board
tasks; `praise`/`frustrated` feed the next `retrospective`.

## House rules
- Messages must be self-contained: artifact paths, task ids, exact next action. If the
  receiver would need to ask a question, the message isn't done.
- Standup before deep work, not after — your `blocked` line is what gets you unblocked.
- Outcomes that should outlive the sprint go to [[decisions]] or [[conventions]], not
  just into a message.
