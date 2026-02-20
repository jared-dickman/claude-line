#!/bin/bash
# Segment: ctx:N% (scaled to compaction threshold) + $cost

segment_context() {
    # Context window (ctx:N% — scaled to compaction threshold)
    #   Green 114 <50%, Yellow 220 50-80%, Red 196 >80%
    COMPACT_THRESHOLD="${COMPACT_THRESHOLD:-77}"
    raw_pct="$(echo "$input" | jq -r '.context_window.used_percentage // empty')"
    used_pct=""
    if [[ -n "$raw_pct" ]]; then
        used_pct="$(awk "BEGIN { v=($raw_pct/$COMPACT_THRESHOLD)*100; if(v>100) v=100; printf \"%.0f\", v }")"
    fi
    total_cost="$(echo "$input" | jq -r '.context_window.total_cost_usd // empty')"

    if [[ -n "$used_pct" ]]; then
        if   (( used_pct > 80 ));  then ctx_col="$C_RED"
        elif (( used_pct >= 50 )); then ctx_col="$C_YELLOW"
        else                            ctx_col="$C_GREEN"
        fi
        sep; color "ctx:${used_pct}%" "$ctx_col"
    fi

    # Session cost (Gray 240, hidden when zero)
    if [[ -n "$total_cost" && "$total_cost" != "null" && "$total_cost" != "0" ]]; then
        formatted="$(printf "%.2f" "$total_cost" 2>/dev/null || echo "")"
        if [[ -n "$formatted" && "$formatted" != "0.00" ]]; then
            sep; color "\$${formatted}" "$C_GRAY"
        fi
    fi
}
