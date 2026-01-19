#!/bin/bash
set -euo pipefail

# Find .claude directory (current or parent)
find_claude_dir() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.claude" ]]; then
            echo "$dir/.claude"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

CLAUDE_DIR=$(find_claude_dir) || {
    echo "<user-prompt-submit-hook>"
    echo "⚠️ No .claude directory found."
    echo ""
    echo "Run the \`context-loader\` agent to generate .claude/CONTEXT.md"
    echo "</user-prompt-submit-hook>"
    exit 0
}

CONTEXT_FILE="$CLAUDE_DIR/CONTEXT.md"

# Check if CONTEXT.md exists
if [[ ! -f "$CONTEXT_FILE" ]]; then
    echo "<user-prompt-submit-hook>"
    echo "⚠️ No project context found."
    echo ""
    echo "Run the \`context-loader\` agent to generate .claude/CONTEXT.md"
    echo "</user-prompt-submit-hook>"
    exit 0
fi

# Check if context is stale (older than 1 hour)
if [[ "$(uname)" == "Darwin" ]]; then
    FILE_AGE=$(( $(date +%s) - $(stat -f %m "$CONTEXT_FILE") ))
else
    FILE_AGE=$(( $(date +%s) - $(stat -c %Y "$CONTEXT_FILE") ))
fi

HOUR_IN_SECONDS=3600

if [[ $FILE_AGE -gt $HOUR_IN_SECONDS ]]; then
    echo "<user-prompt-submit-hook>"
    echo "⚠️ Project context is stale ($(( FILE_AGE / 60 )) minutes old)."
    echo ""
    echo "Consider running the \`context-loader\` agent to refresh .claude/CONTEXT.md"
    echo "</user-prompt-submit-hook>"
    exit 0
fi

# Extract quick stats from CONTEXT.md
QUICK_STATS=$(sed -n '/## Quick Stats/,/## /p' "$CONTEXT_FILE" | head -n -1)

echo "<user-prompt-submit-hook>"
echo "✅ Project context loaded"
echo ""
echo "$QUICK_STATS"
echo ""
echo "Full context: .claude/CONTEXT.md"
echo "</user-prompt-submit-hook>"
