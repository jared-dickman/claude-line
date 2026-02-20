#!/bin/bash
# Segment: test failure + 📝 files changed (Purple 141)

segment_dirty() {
    # Test failure
    if [[ $test_fail -eq 1 ]]; then
        printf " ❌"
    fi

    # Files changed
    if [[ -n "$dirty" && "$dirty" != "0" ]]; then
        printf " 📝 "; color "$dirty" "$C_PURPLE"
    fi
}
