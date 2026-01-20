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
echo "┌─────────────────────────────────────────────┐"
echo "│ 🚀 SESSION STARTED                          │"

if [[ ! -f "$CONTEXT_FILE" ]]; then
  echo "│ ├─ 📊 Context: ❌ NOT FOUND                 │"
  echo "│ ├─ 📁 Expected: .claude/CONTEXT.md         │"
  echo "│ └─ ⚠️ Action: Run context-loader agent     │"
  echo "└─────────────────────────────────────────────┘"
  echo ""
  echo "📋 NEXT STEPS:"
  echo "   1. 🚀 DELEGATE TO: context-loader"
  echo "   2. Agent will scan codebase"
  echo "   3. Generate .claude/CONTEXT.md"
  echo ""
  echo "⚠️ ENFORCEMENT: Run context-loader BEFORE any code tasks"

elif ! is_fresh; then
  # Calculate human-readable age
  if [[ "$OSTYPE" == "darwin"* ]]; then
    file_age=$(( $(date +%s) - $(stat -f %m "$CONTEXT_FILE") ))
  else
    file_age=$(( $(date +%s) - $(stat -c %Y "$CONTEXT_FILE") ))
  fi
  hours=$((file_age / 3600))
  mins=$(( (file_age % 3600) / 60 ))

  echo "│ ├─ 📊 Context: ⚠️ STALE (${hours}h ${mins}m old)    │"
  echo "│ ├─ 📁 File: .claude/CONTEXT.md             │"
  echo "│ └─ ⚠️ Action: Refresh recommended          │"
  echo "└─────────────────────────────────────────────┘"
  echo ""
  echo "📋 CURRENT CONTEXT (stale):"
  get_context_summary
  echo ""
  echo "💡 RECOMMENDATION: Run context-loader to refresh"

else
  # Calculate age
  if [[ "$OSTYPE" == "darwin"* ]]; then
    file_age=$(( $(date +%s) - $(stat -f %m "$CONTEXT_FILE") ))
  else
    file_age=$(( $(date +%s) - $(stat -c %Y "$CONTEXT_FILE") ))
  fi
  mins=$((file_age / 60))

  echo "│ ├─ 📊 Context: ✅ FRESH (${mins}m ago)         │"
  echo "│ ├─ 📁 File: .claude/CONTEXT.md             │"
  echo "│ └─ ✅ Ready to proceed                     │"
  echo "└─────────────────────────────────────────────┘"
  echo ""
  echo "📋 PROJECT SUMMARY:"
  get_context_summary
  echo ""
  echo "📁 Full details: .claude/CONTEXT.md"
fi

echo "</session_context>"
