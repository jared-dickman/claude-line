#!/bin/bash
# Statusline helper functions — sep(), color(), link()

_need_sep=0
sep() {
    if [[ $_need_sep -eq 1 ]]; then
        printf " \033[${C_GRAY}m│\033[0m "
    fi
    _need_sep=1
}

color() { printf "\033[%sm%s\033[0m" "$2" "$1"; }

link() {
    local text="$1" url="$2" col="${3:-}"
    if [[ -n "$col" ]]; then
        printf "\033]8;;%s\007\033[%sm%s\033[0m\033]8;;\007" "$url" "$col" "$text"
    else
        printf "\033]8;;%s\007%s\033]8;;\007" "$url" "$text"
    fi
}
