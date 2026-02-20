#!/bin/bash
# Claude Code Statusline — thin entrypoint
# 🌿 worktree | branch | "commit" age 📁 dirty | #PR ✓/✗/○ commits | mcp:names | ctx:N% $cost
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/statusline"

# ── Read JSON stdin once ─────────────────────────────────────────────────────
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // "."')

# ── Source shared modules ────────────────────────────────────────────────────
source "$DIR/colors.sh"
source "$DIR/helpers.sh"
source "$DIR/git-data.sh"

# ── Source & run each segment in order ───────────────────────────────────────
source "$DIR/segments/worktree.sh";  segment_worktree
source "$DIR/segments/branch.sh";    segment_branch
source "$DIR/segments/commit.sh";    segment_commit
source "$DIR/segments/dirty.sh";     segment_dirty
source "$DIR/segments/pr.sh";        segment_pr
source "$DIR/segments/infra.sh";     segment_infra
source "$DIR/segments/context.sh";   segment_context

exit 0
