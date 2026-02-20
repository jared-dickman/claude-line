#!/bin/bash
# Segment: branch name (Blue 75 — skip if suffix matches worktree)

segment_branch() {
    if [[ -n "$branch" ]]; then
        branch_suffix="${branch##*/}"
        if [[ "$branch_suffix" != "$wt_name" ]]; then
            sep; color "$branch" "$C_BLUE"
        fi
    fi
}
