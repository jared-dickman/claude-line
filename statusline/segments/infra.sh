#!/bin/bash
# Segment: localhost ports + MCP servers

segment_infra() {
    # Localhost ports (Green 114, each clickable)
    if [[ -x "$HOME/.local/bin/localhost-ports" ]]; then
        ports_out="$("$HOME/.local/bin/localhost-ports" 2>/dev/null || true)"
        if [[ -n "$ports_out" ]]; then
            while IFS= read -r port; do
                [[ -z "$port" ]] && continue
                sep; link ":${port}" "http://localhost:${port}" "$C_GREEN"
            done <<< "$ports_out"
        fi
    fi

    # Active MCPs (each server in its own color)
    if [[ -x "$HOME/.local/bin/active-mcps" ]]; then
        mcps_out="$("$HOME/.local/bin/active-mcps" 2>/dev/null || true)"
        if [[ -n "$mcps_out" ]]; then
            sep
            printf "mcp:"
            mcp_idx=0
            first=1
            while IFS= read -r mcp; do
                [[ -z "$mcp" ]] && continue
                if [[ $first -eq 0 ]]; then printf " "; fi
                first=0
                c="${MCP_COLORS[$((mcp_idx % ${#MCP_COLORS[@]}))]}"
                color "$mcp" "$c"
                mcp_idx=$((mcp_idx + 1))
            done <<< "$mcps_out"
        fi
    fi
}
