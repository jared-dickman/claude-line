#!/bin/bash
# claude-line installer — copies statusline to ~/.claude/ and wires up settings
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.claude"
SETTINGS="$DEST/settings.json"

echo "🌿 Installing claude-line..."

# Copy statusline files
cp "$SCRIPT_DIR/statusline-command.sh" "$DEST/"
rm -rf "$DEST/statusline"
cp -r "$SCRIPT_DIR/statusline" "$DEST/statusline"
chmod +x "$DEST/statusline-command.sh" "$DEST/statusline/"*.sh "$DEST/statusline/segments/"*.sh

# Install helper scripts
mkdir -p "$HOME/.local/bin"
if [[ -d "$SCRIPT_DIR/helpers" ]]; then
    cp "$SCRIPT_DIR/helpers/"* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/active-mcps"
    echo "✓ Installed helpers to ~/.local/bin/"
fi

# Wire up settings.json
if [[ -f "$SETTINGS" ]]; then
    if command -v jq &>/dev/null; then
        tmp=$(mktemp)
        jq '.statusline.command = "bash ~/.claude/statusline-command.sh"' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
        echo "✓ Updated $SETTINGS"
    else
        echo "⚠ jq not found — add this to $SETTINGS manually:"
        echo '  "statusline": { "command": "bash ~/.claude/statusline-command.sh" }'
    fi
else
    mkdir -p "$DEST"
    echo '{ "statusline": { "command": "bash ~/.claude/statusline-command.sh" } }' > "$SETTINGS"
    echo "✓ Created $SETTINGS"
fi

echo "✓ Installed to $DEST/"
echo "  Restart Claude Code to activate."
