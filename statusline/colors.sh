#!/bin/bash
# ANSI 256-color constants — source of truth for statusline

C_CYAN="38;5;51"       # Worktree
C_BLUE="38;5;75"       # Branch
C_PURPLE="38;5;141"    # Commit msg, files changed, jira, PR number
C_GRAY="38;5;240"      # Commit age, PR commits, separators, cost
C_RED="38;5;196"       # Stash, context >80%
C_GREEN="38;5;114"     # Localhost ports, context <50%
C_ORANGE="38;5;208"    # MCP servers
C_YELLOW="38;5;220"    # Context 50-80%

# MCP per-server color cycle
MCP_COLORS=("38;5;208" "38;5;214" "38;5;220" "38;5;180" "38;5;174" "38;5;168" "38;5;139" "38;5;111")
