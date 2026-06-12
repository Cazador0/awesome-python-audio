# `.lumen/` — headless agent definitions

This directory holds the **headless agent role definitions** for the Music Data
Science (MDS) engagement layer. Each file under `agents/` is one role card: a
self-contained brief that any agent harness can load as a system prompt (or
subagent definition) to put a worker on the team.

The same roles are mirrored in `.claude/agents/` in Claude Code's subagent
format, so `claude` picks them up automatically. `.lumen/` is the
harness-neutral source of truth; if you edit a role, update both copies.

## The contract every role shares

1. **Connect to the scrum-master MCP server** (registered in the repo-root
   `.mcp.json`; it expects a sibling checkout of
   [`cazador0/mcp-servers`](https://github.com/cazador0/mcp-servers) built with
   `npm install && npm run build`).
2. **Open with `standup`** — post `did / doing / blockers`; the response is the
   whole team's digest, so you start every session fully oriented in one call.
3. **Work only your layer** (see each role card); collaborate through signals,
   not by editing another role's files.
4. **Signal, don't stall**: `blocked`, `confused`, and `help_wanted` messages
   must say what would unblock you (`needs`) — the server rejects them
   otherwise. Use `praise` when another agent's output saved you work, and
   `handoff` (with the prompt of the same name) to transfer a task with full
   context.
5. **Never play scrum master.** Ceremonies are the server's prompts
   (`sprint-planning`, `daily-standup`, `retrospective`, `unblock`,
   `handoff`) — invoke them; don't improvise process.

## Roles

| Role | Layer | Home repo |
| --- | --- | --- |
| [`pipeline-agent`](agents/pipeline-agent.md) | Generation engine + stem workflows | `cazador0/ACE-Step-1.5` (`music_data_science/`) |
| [`data-agent`](agents/data-agent.md) | Data + Memory & Context layers | `cazador0/ACE-Step-1.5` (`music_data_science/data`, `memory`) |
| [`ui-agent`](agents/ui-agent.md) | Engagement & UI layer (this vault) | `cazador0/awesome-python-audio` |
