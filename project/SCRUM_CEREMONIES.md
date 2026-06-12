# Prompt-Based Scrum Ceremonies

MDS agents do not hold meetings, and no agent is the scrum master. Every ceremony is a
**prompt** served by the scrum-master MCP server
([cazador0/mcp-servers](https://github.com/cazador0/mcp-servers), branch
`claude/peaceful-dijkstra-m0sycf`, `src/scrum-master/`), backed by five tools:

| Tool | Purpose |
| --- | --- |
| `post_message` | Send a signal-tagged message to one agent, a role, or the team |
| `check_inbox` | Drain unread messages (rarely needed — see digests below) |
| `standup` | File a structured standup entry (did / doing / blocked) |
| `manage_task` | Create/claim/move/close tasks on the shared board |
| `get_board` | Snapshot the kanban board (columns, owners, blockers) |

## The two principles

1. **Self-contained messages.** Every message must be actionable without follow-up
   questions: what happened, what is needed, where the artifacts are (vault path, task id,
   commit SHA). A message that requires a clarifying round-trip is a defect.
2. **Piggybacked digests = zero extra turns.** Every tool call an agent makes for its
   *real* work returns a compact digest of unread messages and board deltas in the
   response. Agents never poll, never schedule a "check messages" step, and never spend a
   turn on coordination alone. Because messages are self-contained (principle 1), the
   digest is usually all an agent ever needs to read.

Together these mean scrum costs the coding agents nothing: the server does the
facilitation, and the network does the routing.

## Communication signal taxonomy

Every `post_message` carries exactly one signal so receivers can triage from the digest
line alone:

| Signal | Meaning | Expected reaction |
| --- | --- | --- |
| `blocked` | Cannot proceed; names the blocking task/agent/resource | Server escalates via the `unblock` prompt; anyone able to clear it, does |
| `confused` | Spec or context is ambiguous; asks a concrete question | Owner of the ambiguous artifact answers in one self-contained reply |
| `frustrated` | Repeated failure on the same task; burning budget | Triggers reassignment consideration at next standup digest |
| `praise` | Something worked well and should be repeated | Candidate input for `retrospective`; may become a `vault/Memory/conventions` entry |
| `handoff` | Work transferred with full context attached | Receiver claims the task via `manage_task`; no re-discovery allowed |
| `help_wanted` | Non-blocking request for expertise | Optional pickup; expires silently |
| `fyi` | Context broadcast, no action expected | None |
| `done` | Task complete with links to artifacts | Dependent tasks unblock automatically on the board |

## The ceremonies

### Sprint planning — prompt `sprint-planning`
Inputs: the backlog (`get_board`), open `Memory/decisions` entries, capacity per agent.
The prompt walks whoever invokes it (usually `ui-agent`, but any agent can) through
selecting a sprint goal, slicing it into board tasks via `manage_task`, and posting one
`fyi` sprint-goal message. Output: a populated "Sprint" column; no meeting occurred.

### Daily standup — prompt `daily-standup`
Each agent calls `standup` once per working session (did / doing / blocked). The server
compiles entries into the digest that piggybacks on everyone's next tool call. `blocked`
entries auto-open the unblock flow. Nobody collects status; status collects itself.

### Retrospective — prompt `retrospective`
Run at sprint close against the sprint's `standup` history, `praise`/`frustrated`
signals, and closed tasks. The prompt produces concrete deltas: each "keep" becomes or
updates a note in `vault/Memory/conventions.md`; each "change" becomes a board task.
Retro output that doesn't land in the vault or on the board is discarded by convention.

### Backlog grooming
A standing variant of `sprint-planning` scoped to the "Backlog" column: merge duplicate
tasks, attach acceptance criteria, re-rank. Any agent noticing a stale backlog may run
it; `manage_task` edits are the only output.

### Blocker triage — prompt `unblock`
Fired when a `blocked` signal lands. The prompt forces the classic decomposition: what
exactly is blocked, who/what can clear it, what's the cheapest workaround, and is the
task worth rerouting around entirely. Resolution is posted as a self-contained reply;
the board task is moved or re-owned via `manage_task`.

### Handoff — prompt `handoff`
Used when an agent finishes its layer of a task (e.g. `pipeline-agent` hands generated
stems to `eval-agent`). The prompt enforces the handoff contract: task id, artifact
locations (file paths, Redis keys, SQLite row ids), what was verified, what wasn't, and
the exact next action. The `handoff` message plus a `manage_task` reassignment is the
entire ceremony.

## Worked example (one turn, three agents)

1. `pipeline-agent` finishes a `repaint` job and calls
   `manage_task(close, T-142)` — its digest shows `eval-agent` posted `help_wanted`
   about scoring thresholds an hour ago. It ignores it (non-blocking).
2. It posts `handoff` → `eval-agent` with stem paths and the seed used.
3. `eval-agent`'s next tool call (it was already scoring T-139) carries the digest with
   the handoff; it claims T-142. Zero dedicated coordination turns were spent.
