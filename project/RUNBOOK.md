# MDS Runbook — end to end on your hardware

One page from bare machine to a prompt-edited song with the full Strategy A
stack running. Hardware floor for the generation engine: an NVIDIA GPU with
≥ 8 GB VRAM for turbo models, ≥ 12 GB (20 GB recommended) for base/XL models —
**stem operations (`extract`, `lego`, `complete`) require a base model**.
Apple Silicon works via the macOS launcher (MLX). Everything except step 2 also
runs on a laptop with no GPU using the dry-run mode in step 6.

## 1. Clone the three repos as siblings

```sh
git clone https://github.com/cazador0/ACE-Step-1.5
git clone https://github.com/cazador0/mcp-servers
git clone https://github.com/cazador0/awesome-python-audio
```

The `.mcp.json` in `awesome-python-audio` assumes this sibling layout.

## 2. Start the generation engine (GPU box)

```sh
cd ACE-Step-1.5
./install_uv.sh && uv sync
./start_api_server.sh        # Linux/CUDA — serves http://127.0.0.1:8001
# macOS: ./start_api_server_macos.sh   ROCm: ./start_api_server_rocm.sh
```

First run downloads model weights. To unlock stem tasks, configure a base
(non-turbo) model in the launcher config. Verify:
`curl http://127.0.0.1:8001/health` (or watch the startup log).

## 3. Start the data layer (optional but recommended)

```sh
docker run -d --name mds-redis -p 6379:6379 valkey/valkey:8
```

Skip this and every adapter falls back to in-memory automatically — fine for a
single process, no good for multi-agent.

## 4. Install the application

```sh
cd ACE-Step-1.5/music_data_science
uv venv && uv pip install -e ".[data,llm]"   # drop extras you don't need
```

## 5. Build the scrum-master server

```sh
cd mcp-servers
npm install && npm run build --workspace=src/scrum-master
```

## 6. Smoke-test the whole loop (no server needed)

```sh
cd ACE-Step-1.5/music_data_science
PYTHONPATH=. uv run python examples/end_to_end.py --dry-run
```

Then the real thing, with vault-backed memory:

```sh
python examples/end_to_end.py --base-url http://127.0.0.1:8001 \
  --vault ../../awesome-python-audio/vault \
  --redis-url redis://localhost:6379/0
```

## 7. Open the Engagement & UI layer

- Open `awesome-python-audio/vault/` as an Obsidian vault. It ships with the
  **agent-ops** layout; switch with
  `vault/configs/use-layout.sh producer-console` (or `researcher-graph`).
- Install the community plugins each layout recommends
  (`vault/configs/*/community-plugins.json`) — Dataview powers the dashboard.

## 8. Run the agent team

```sh
cd awesome-python-audio
claude          # picks up .mcp.json (scrum-master) + .claude/agents/ roles
```

Kick off with the `sprint-planning` prompt from the scrum-master server, then
delegate to `pipeline-agent`, `data-agent`, and `ui-agent`. Their role cards
live in `.lumen/agents/`; the communication contract is in `.lumen/README.md`.
The shared board lands in `.mds/scrum-board.json` (gitignored state — set
`SCRUM_BOARD_PATH` in `.mcp.json` to move it).

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `extract`/`lego` rejected | Server is running a turbo model — load a base model (see `TASK_TYPES_BASE` in `acestep/constants.py`). |
| Queue/cache silently in-memory | `redis` package not installed or URL unreachable — install the `[data]` extra and check `--redis-url`. |
| scrum-master tools missing in Claude Code | Build step 5 not run, or repos not cloned as siblings — fix the path in `.mcp.json`. |
| Dashboard tables empty in Obsidian | Dataview plugin not installed/enabled. |
| Blueprint refinement raises `ImportError` | Install the `[llm]` extra and set `ANTHROPIC_API_KEY`. |
