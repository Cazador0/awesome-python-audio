# Music Data Science (MDS) — Engagement, UI & Memory layer

This repository hosts layer 3 of the three-repo **Music Data Science** system: the
Engagement/UI layer (an Obsidian vault that agents and humans share) and the project
planning documents that coordinate the other two repos.

> The generated `README.md` (built by `build.py` from `dataframe.csv` + `head.md`) is the
> original awesome-list content of this fork and is unrelated to MDS. Everything MDS lives
> under `project/` and `vault/`.

## What is in this repo

| Path | Purpose |
| --- | --- |
| [`project/PROJECT_OVERVIEW.md`](project/PROJECT_OVERVIEW.md) | The four-layer pipeline, repo mapping, agent roles |
| [`project/SCRUM_CEREMONIES.md`](project/SCRUM_CEREMONIES.md) | Prompt-based scrum via the scrum-master MCP server |
| [`project/DATA_STRATEGY.md`](project/DATA_STRATEGY.md) | Three data-layer strategies and the verdict |
| [`project/PROMPT_TO_STEM.md`](project/PROMPT_TO_STEM.md) | The prompt-to-Stem research problem and engineering path |
| [`vault/`](vault/) | Working Obsidian vault: Skills, Tools, Context, Memory, Logs, Music Theory SME |
| [`vault/configs/`](vault/configs/) | Three switchable Obsidian UI layouts + `use-layout.sh` |

Open `vault/` in Obsidian and it works out of the box (the default `.obsidian/` is the
**agent-ops** dashboard layout). Switch layouts with
`vault/configs/use-layout.sh <producer-console|researcher-graph|agent-ops>`.

## Sibling repos

- **Agent communication / scrum-master MCP server** —
  [cazador0/mcp-servers](https://github.com/cazador0/mcp-servers), branch
  `claude/peaceful-dijkstra-m0sycf`, `src/scrum-master/`. Tools:
  `post_message`, `check_inbox`, `standup`, `manage_task`, `get_board`. Prompts:
  `sprint-planning`, `daily-standup`, `retrospective`, `unblock`, `handoff`.
- **Generation + data app** —
  [cazador0/ACE-Step-1.5](https://github.com/cazador0/ACE-Step-1.5), branch
  `claude/peaceful-dijkstra-m0sycf`, `music_data_science/`. Stem manipulation and
  RAPTOR Best-of-N memory over *this* vault, wrapping the ACE-Step task types
  `text2music` / `repaint` / `cover` / `extract` / `lego` / `complete`.
