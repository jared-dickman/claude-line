#!/bin/bash
# Segment: "commit message" age (Purple 141 + Gray 240)

segment_commit() {
    if [[ -n "$commit_msg" ]]; then
        sep
        color "\"$commit_msg\"" "$C_PURPLE"
        if [[ -n "$commit_age" ]]; then
            printf " "
            color "$commit_age" "$C_GRAY"
        fi
    fi
}
