#!/bin/bash
# Collect all git data into variables for segment consumption

wt_name="" branch="" commit_msg="" commit_age="" dirty=0 stash=0
pr_num="" pr_url="" pr_commits=""
ci_status="" ci_fail_url=""
test_fail=0
in_git=0

if [[ -d "$cwd" ]]; then
    cd "$cwd" 2>/dev/null
    if git rev-parse --git-dir &>/dev/null 2>&1; then
        in_git=1

        wt_name="$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")"
        branch="$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "")"
        commit_msg="$(git log -1 --pretty=format:'%s' 2>/dev/null | cut -c1-30)"

        commit_ts="$(git log -1 --pretty=format:'%ct' 2>/dev/null)"
        if [[ -n "$commit_ts" ]]; then
            now=$(date +%s)
            diff=$(( now - commit_ts ))
            if   (( diff < 60 ));    then commit_age="now"
            elif (( diff < 3600 ));  then commit_age="$(( diff / 60 ))m"
            elif (( diff < 86400 )); then commit_age="$(( diff / 3600 ))h"
            else                          commit_age="$(( diff / 86400 ))d"
            fi
        fi

        dirty=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
        stash=$(git stash list 2>/dev/null | wc -l | tr -d ' ')

        pr_json="$(gh pr view --json number,url,state,commits 2>/dev/null || echo "")"
        if [[ -n "$pr_json" ]]; then
            pr_state="$(echo "$pr_json" | jq -r '.state // ""')"
            if [[ "$pr_state" == "OPEN" ]]; then
                pr_num="$(echo "$pr_json" | jq -r '.number // ""')"
                pr_url="$(echo "$pr_json" | jq -r '.url // ""')"
                pr_commits="$(echo "$pr_json" | jq -r '(.commits | length) // ""')"
            fi
        fi

        # CI check status (only when PR exists)
        if [[ -n "$pr_num" ]]; then
            ci_json="$(gh pr checks --json name,state,link 2>/dev/null || echo "")"
            if [[ -n "$ci_json" && "$ci_json" != "[]" ]]; then
                if echo "$ci_json" | jq -e '[.[] | select(.state=="FAILURE")] | length > 0' &>/dev/null; then
                    ci_status="fail"
                    ci_fail_url="$(echo "$ci_json" | jq -r '[.[] | select(.state=="FAILURE")] | first | .link // ""')"
                elif echo "$ci_json" | jq -e '[.[] | select(.state=="IN_PROGRESS" or .state=="QUEUED" or .state=="PENDING")] | length > 0' &>/dev/null; then
                    ci_status="pending"
                else
                    ci_status="pass"
                fi
            fi
        fi

        # Test results
        results_file="$cwd/.test-results"
        if [[ -f "$results_file" ]]; then
            if grep -qv "PASS" "$results_file" 2>/dev/null; then
                test_fail=1
            fi
        fi
    fi
fi
