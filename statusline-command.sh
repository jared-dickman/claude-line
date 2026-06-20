#!/bin/bash
# Claude Code Statusline — thin entrypoint
# ctx:N% $cost | worktree | branch | 📁 dirty | #PR ✓/✗/○ commits | mcp:names
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/statusline"

# ── Read JSON stdin once ─────────────────────────────────────────────────────
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // "."')

# ── Source shared modules ────────────────────────────────────────────────────
source "$DIR/colors.sh"
source "$DIR/helpers.sh"
source "$DIR/git-data.sh"

# ── Source & run each segment in order (ctx first) ───────────────────────────
source "$DIR/segments/context.sh";   segment_context
source "$DIR/segments/worktree.sh";  segment_worktree
source "$DIR/segments/branch.sh";    segment_branch
source "$DIR/segments/dirty.sh";     segment_dirty
source "$DIR/segments/pr.sh";        segment_pr
source "$DIR/segments/infra.sh";     segment_infra

exit 0
