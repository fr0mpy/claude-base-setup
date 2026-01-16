#!/usr/bin/env bash
# Session Start Hook
# - Checks if context is stale
# - Outputs instruction for Claude to use context-loader agent

set -euo pipefail

CLAUDE_DIR=""
CURRENT_DIR="$(pwd)"
while [[ "$CURRENT_DIR" != "/" ]]; do
  if [[ -d "$CURRENT_DIR/.claude" ]]; then
    CLAUDE_DIR="$CURRENT_DIR/.claude"
    break
  fi
  CURRENT_DIR="$(dirname "$CURRENT_DIR")"
done

[[ -z "$CLAUDE_DIR" ]] && exit 0

CONTEXT_FILE="$CLAUDE_DIR/CONTEXT.md"
FRESHNESS_THRESHOLD=3600  # 1 hour in seconds

# ============================================================================
# FUNCTIONS
# ============================================================================

is_fresh() {
  [[ ! -f "$CONTEXT_FILE" ]] && return 1

  local file_age
  if [[ "$OSTYPE" == "darwin"* ]]; then
    file_age=$(( $(date +%s) - $(stat -f %m "$CONTEXT_FILE") ))
  else
    file_age=$(( $(date +%s) - $(stat -c %Y "$CONTEXT_FILE") ))
  fi

  [[ $file_age -lt $FRESHNESS_THRESHOLD ]]
}

get_context_summary() {
  if [[ -f "$CONTEXT_FILE" ]]; then
    # Extract quick stats section
    grep -A5 "## Quick Stats" "$CONTEXT_FILE" 2>/dev/null | tail -4 | sed 's/^/  /'
  fi
}

# ============================================================================
# MAIN
# ============================================================================

echo "<session_context>"

if [[ ! -f "$CONTEXT_FILE" ]]; then
  cat << 'EOF'
📋 No project context found.

⚠️ ACTION REQUIRED: Use the `context-loader` agent to scan the codebase and generate .claude/CONTEXT.md

This will help you understand the project structure and current implementation status.
EOF

elif ! is_fresh; then
  echo "📋 Project context is STALE (>1h old)"
  echo ""
  get_context_summary
  echo ""
  cat << 'EOF'
⚠️ ACTION REQUIRED: Use the `context-loader` agent to refresh .claude/CONTEXT.md
EOF

else
  echo "📋 Project context loaded (fresh)"
  echo ""
  get_context_summary
  echo ""
  echo "📁 Full details: .claude/CONTEXT.md"
fi

echo "</session_context>"
