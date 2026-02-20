# claude-line

```
     ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗      ██╗     ██╗███╗   ██╗███████╗
    ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝      ██║     ██║████╗  ██║██╔════╝
    ██║     ██║     ███████║██║   ██║██║  ██║█████╗  █████╗██║     ██║██╔██╗ ██║█████╗
    ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝  ╚════╝██║     ██║██║╚██╗██║██╔══╝
    ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗      ███████╗██║██║ ╚████║███████╗
     ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝      ╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝

    ┌──────────────────────────────────────────────────────────────────────────────────────┐
    │ 🌿 nalu │ main │ "fix: upgrade all ast-grep" 33m 📁 1 │ #16 ✗ 32 │ ctx:78% │ $1.50│
    └──────────────────────────────────────────────────────────────────────────────────────┘
```

> **A modular, portable statusline for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).**
> One install. Every machine. Forever.

---

## Features

- **🌿 Worktree** — repo name with plant emoji
- **Branch** — skipped if it matches worktree name
- **"Commit" age** — last commit in quotes + relative time
- **📁 Dirty count** — files changed with folder emoji
- **Jira ticket** — extracted from branch name, clickable OSC 8 link
- **PR + CI + Commits** — `#N ✓/✗/○ Nc` with clickable links
- **Stash warning** — red `stash:N` when stashes exist
- **Localhost ports** — each port clickable (via `~/.local/bin/localhost-ports`)
- **MCP servers** — each server in its own color (via `~/.local/bin/active-mcps`)
- **Context %** — scaled to compaction threshold, not raw usage
- **Session cost** — hidden when zero

## Quick Install

```bash
git clone https://github.com/jared-dickman/claude-line.git
cd claude-line
./install.sh
```

That's it. Restart Claude Code and your statusline is live.

## Manual Install

```bash
cp statusline-command.sh ~/.claude/
cp -r statusline/ ~/.claude/statusline/
```

Add to `~/.claude/settings.json`:

```json
{
  "statusline": {
    "command": "bash ~/.claude/statusline-command.sh"
  }
}
```

## Architecture

```
statusline-command.sh          ← Entrypoint (reads stdin, runs segments)
statusline/
├── colors.sh                  ← ANSI 256 color constants
├── helpers.sh                 ← sep() color() link()
├── git-data.sh                ← Git / PR / CI data collection
└── segments/
    ├── worktree.sh            ← 🌿 repo name
    ├── branch.sh              ← branch name
    ├── commit.sh              ← "msg" age
    ├── dirty.sh               ← 📁 N + ❌ test fail
    ├── pr.sh                  ← jira, PR, CI, stash
    ├── infra.sh               ← ports, MCPs
    └── context.sh             ← ctx:N% + $cost
```

Every file does **one thing**. Add a segment, remove a segment, customize colors — each is independent.

## Context Scaling

Context % shows **how close you are to compaction**, not raw usage:

```
scaled = min(100, (raw / threshold) * 100)

60% raw  →  (60/77)*100  →  ctx:78%   (yellow — getting close)
77% raw  →  (77/77)*100  →  ctx:100%  (red — compaction imminent)
30% raw  →  (30/77)*100  →  ctx:39%   (green — plenty of room)
```

Default threshold: `77`. Override with `COMPACT_THRESHOLD` env var.

## Color Reference

| Section | Color | ANSI |
|---------|-------|------|
| Worktree (🌿) | Cyan | `38;5;51` |
| Branch | Blue | `38;5;75` |
| Commit msg | Purple | `38;5;141` |
| Commit age | Gray | `38;5;240` |
| Files changed (📁) | Purple | `38;5;141` |
| Jira / PR number | Purple | `38;5;141` |
| PR status (✓/✗/○) | Bare text | — |
| PR commits | Gray | `38;5;240` |
| Stash | Red | `38;5;196` |
| Localhost ports | Green | `38;5;114` |
| MCP servers | Per-server cycle | `38;5;208+` |
| Context <50% | Green | `38;5;114` |
| Context 50–80% | Yellow | `38;5;220` |
| Context >80% | Red | `38;5;196` |
| Cost ($) | Gray | `38;5;240` |
| Separators (│) | Gray | `38;5;240` |

## License

MIT
