#!/bin/bash
# Segment: #PR ✓/✗/○ commits, stash

segment_pr() {
    # PR number + CI status + commit count
    if [[ -n "$pr_num" ]]; then
        sep

        # PR number (Purple 141)
        if [[ -n "$pr_url" ]]; then
            link "#$pr_num" "$pr_url" "$C_PURPLE"
        else
            color "#$pr_num" "$C_PURPLE"
        fi

        # PR status (no color wrap — bare text)
        case "$ci_status" in
            pass)
                printf " "
                if [[ -n "$pr_url" ]]; then
                    link "✓" "$pr_url/files"
                else
                    printf "✓"
                fi ;;
            fail)
                printf " "
                if [[ -n "$ci_fail_url" ]]; then
                    link "✗" "$ci_fail_url"
                elif [[ -n "$pr_url" ]]; then
                    link "✗" "$pr_url/checks"
                else
                    printf "✗"
                fi ;;
            pending)
                printf " "
                if [[ -n "$pr_url" ]]; then
                    link "○" "$pr_url/checks"
                else
                    printf "○"
                fi ;;
        esac

        # PR commits (Gray 240)
        if [[ -n "$pr_commits" && "$pr_commits" != "0" ]]; then
            printf " "; color "$pr_commits" "$C_GRAY"
        fi
    fi

    # Stash warning (Red 196)
    if [[ -n "$stash" && "$stash" != "0" ]]; then
        sep; color "stash:${stash}" "$C_RED"
    fi
}
