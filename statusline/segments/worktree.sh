#!/bin/bash
# Segment: 🌿 worktree name (Cyan 51)

segment_worktree() {
    if [[ -n "$wt_name" ]]; then
        sep; printf "🌿 "; color "$wt_name" "$C_CYAN"
    fi
}
