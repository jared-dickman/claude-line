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

    # Active MCPs (all orange 208 — script returns space-separated short names)
    if [[ -x "$HOME/.local/bin/active-mcps" ]]; then
        mcps_out="$("$HOME/.local/bin/active-mcps" 2>/dev/null || true)"
        mcps_out="$(echo "$mcps_out" | tr -s '[:space:]' | sed 's/^ //;s/ $//')"
        if [[ -n "$mcps_out" ]]; then
            sep; color "mcp:${mcps_out}" "$C_ORANGE"
        fi
    fi
}
