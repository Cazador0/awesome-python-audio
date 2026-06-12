# Obsidian layouts for the MDS vault

Three complete `.obsidian/` config sets, switched with `use-layout.sh`. The vault ships
with **agent-ops** installed as the default `.obsidian/`, so it opens working.

| Layout | For | Opens with | Community plugins recommended |
| --- | --- | --- | --- |
| `producer-console` | Editing sessions | `Logs/stem-session.md` pinned + today's log; backlinks right; graph off | `obsidian-kanban`, `obsidian-audio-player` |
| `researcher-graph` | Knowledge-graph exploration | Global graph (folder color groups) + `queries.md`; local graph + backlinks right | `dataview`, `juggl` (Cytoscape graph queries — closest practical thing to a graph DB over markdown; Kùzu/Neo4j sync is the heavier alternative) |
| `agent-ops` | Live ops dashboard (default) | `DASHBOARD.md` (Dataview over Logs/Memory/blockers) pinned + today's log + decisions | `homepage`, `dataview`, `templater-obsidian` |

## Switching

```sh
./use-layout.sh agent-ops          # or producer-console / researcher-graph
```

The script backs up the current `vault/.obsidian/` to `vault/.obsidian.bak.<timestamp>/`
before copying the chosen set in. Restart Obsidian (or reload the vault) afterwards.

## Notes

- `community-plugins.json` lists plugin **ids** Obsidian should treat as enabled; the
  plugins themselves still need to be installed once via Settings → Community plugins
  (or by dropping them into `.obsidian/plugins/`). Until then Obsidian simply ignores
  the entries — nothing breaks.
- Hotkeys: all layouts bind `Mod+Shift+L` → open today's daily note (created in `Logs/`
  from `Logs/daily-log-template`). agent-ops adds `Mod+[`/`Mod+]` history navigation,
  `Mod+Shift+G` graph, `Mod+Shift+F` search, `Mod+Shift+B` backlinks.
- Layout changes worth keeping should be edited in the config set here, then re-applied
  with the script — the live `.obsidian/` is disposable state.
