#!/usr/bin/env bash
# Smart Context Injection
# - Injects behavioral rules
# - Suggests agents for tasks that would bloat context

set -euo pipefail

CLAUDE_DIR=""
CURRENT_DIR="$(pwd)"
while [[ "$CURRENT_DIR" != "/" ]]; do
  if [[ -d "$CURRENT_DIR/.claude/rules" ]]; then
    CLAUDE_DIR="$CURRENT_DIR/.claude"
    break
  fi
  CURRENT_DIR="$(dirname "$CURRENT_DIR")"
done

[[ -z "$CLAUDE_DIR" ]] && { echo "<context_injection>⚠️ .claude directory not found</context_injection>"; exit 0; }

RULES_DIR="$CLAUDE_DIR/rules"
AGENTS_DIR="$CLAUDE_DIR/agents"
TRIGGERS_FILE="$CLAUDE_DIR/hooks/triggers.json"

# ============================================================================
# FUNCTIONS
# ============================================================================

get_summary() {
  head -1 "$1" 2>/dev/null | grep '<!-- SUMMARY:' | sed 's/.*<!-- SUMMARY: //;s/ -->$//' || echo ""
}

get_trigger() {
  head -2 "$1" 2>/dev/null | grep '<!-- TRIGGER:' | sed 's/.*<!-- TRIGGER: //;s/ -->$//' || echo "always"
}

get_rule_name() {
  basename "$1" .md | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1'
}

get_agent_name() {
  grep '^name:' "$1" 2>/dev/null | sed 's/name: *//' || basename "$1" .md
}

get_agent_desc() {
  grep '^description:' "$1" 2>/dev/null | sed 's/description: *//' | head -c 80 || echo ""
}

parse_json_array() {
  local trigger="$1"
  local in_array=0
  local keywords=""

  while IFS= read -r line; do
    if [[ $in_array -eq 0 ]] && echo "$line" | grep -q "\"$trigger\":"; then
      in_array=1
      continue
    fi
    if [[ $in_array -eq 1 ]]; then
      if echo "$line" | grep -q '\]'; then
        break
      fi
      local kw=$(echo "$line" | tr -d '",[] ' | tr -d '\t')
      [[ -n "$kw" ]] && keywords="$keywords|$kw"
    fi
  done < "$TRIGGERS_FILE"

  echo "$keywords" | sed 's/^|//'
}

# ============================================================================
# MAIN
# ============================================================================

PROMPT=""
[[ ! -t 0 ]] && PROMPT=$(cat)
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

MATCHED_TRIGGERS=""

if [[ -f "$TRIGGERS_FILE" ]]; then
  TRIGGER_NAMES=$(grep '": \[' "$TRIGGERS_FILE" | grep -v '_comment' | sed 's/.*"\([^"]*\)".*/\1/')

  for trigger in $TRIGGER_NAMES; do
    KEYWORDS=$(parse_json_array "$trigger")
    if [[ -n "$KEYWORDS" ]] && echo "$PROMPT_LOWER" | grep -qiE "$KEYWORDS"; then
      MATCHED_TRIGGERS="$MATCHED_TRIGGERS $trigger"
    fi
  done
fi

MATCHED_TRIGGERS=$(echo "$MATCHED_TRIGGERS" | sed 's/^ //')

# ============================================================================
# CHECK CONTEXT FRESHNESS
# ============================================================================

CONTEXT_FILE="$CLAUDE_DIR/CONTEXT.md"
CONTEXT_STATUS="fresh"
CONTEXT_AGE=""

if [[ ! -f "$CONTEXT_FILE" ]]; then
  CONTEXT_STATUS="missing"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  file_age=$(( $(date +%s) - $(stat -f %m "$CONTEXT_FILE") ))
  CONTEXT_AGE="${file_age}s"
  [[ $file_age -gt 3600 ]] && CONTEXT_STATUS="stale"
else
  file_age=$(( $(date +%s) - $(stat -c %Y "$CONTEXT_FILE") ))
  CONTEXT_AGE="${file_age}s"
  [[ $file_age -gt 3600 ]] && CONTEXT_STATUS="stale"
fi

# ============================================================================
# OUTPUT
# ============================================================================

echo "<context_injection>"
echo "┌─────────────────────────────────────────────┐"
echo "│ 🎯 PROMPT RECEIVED                          │"

# Context status line
case "$CONTEXT_STATUS" in
  fresh)
    echo "│ ├─ 📊 Context: ✅ fresh ($CONTEXT_AGE ago)     │"
    ;;
  stale)
    echo "│ ├─ 📊 Context: ⚠️ stale ($CONTEXT_AGE ago)     │"
    ;;
  missing)
    echo "│ ├─ 📊 Context: ❌ missing                     │"
    ;;
esac

# Rules status
ACTIVE_RULES=""
for f in "$RULES_DIR"/*.md; do
  [[ ! -f "$f" ]] && continue
  local_summary=$(get_summary "$f")
  local_trigger=$(get_trigger "$f")
  [[ -z "$local_summary" ]] && continue

  if echo " $MATCHED_TRIGGERS " | grep -q " $local_trigger "; then
    rule_name=$(get_rule_name "$f")
    ACTIVE_RULES="$ACTIVE_RULES$rule_name, "
  fi
done
ACTIVE_RULES=$(echo "$ACTIVE_RULES" | sed 's/, $//')

if [[ -n "$ACTIVE_RULES" ]]; then
  echo "│ ├─ 📋 Rules: $ACTIVE_RULES"
else
  echo "│ ├─ 📋 Rules: (none matched)                  │"
fi

# Agent suggestions based on triggers
SUGGESTED_AGENTS=""
for trigger in $MATCHED_TRIGGERS; do
  case "$trigger" in
    code) SUGGESTED_AGENTS="$SUGGESTED_AGENTS pre-code-check" ;;
    package) SUGGESTED_AGENTS="$SUGGESTED_AGENTS package-checker" ;;
    structure) SUGGESTED_AGENTS="$SUGGESTED_AGENTS structure-validator" ;;
    planning) SUGGESTED_AGENTS="$SUGGESTED_AGENTS intent-clarifier" ;;
    debug) SUGGESTED_AGENTS="$SUGGESTED_AGENTS incident-replayer" ;;
    review) SUGGESTED_AGENTS="$SUGGESTED_AGENTS future-you" ;;
    refactor) SUGGESTED_AGENTS="$SUGGESTED_AGENTS refactor-scope-limiter" ;;
    test) SUGGESTED_AGENTS="$SUGGESTED_AGENTS test-gap-finder" ;;
  esac
done

if [[ -n "$SUGGESTED_AGENTS" ]]; then
  agent_list=$(echo "$SUGGESTED_AGENTS" | sed 's/^ //' | tr ' ' ', ')
  echo "│ └─ 🤖 Agents: $agent_list"
else
  echo "│ └─ 🤖 Agents: (none suggested)              │"
fi

echo "└─────────────────────────────────────────────┘"

# Detailed agent info with enforcement
if [[ -n "$SUGGESTED_AGENTS" ]]; then
  echo ""
  echo "📋 AGENT DETAILS:"
  for agent in $SUGGESTED_AGENTS; do
    agent_file="$AGENTS_DIR/${agent}.md"
    if [[ -f "$agent_file" ]]; then
      echo "   🤖 $agent"
      echo "      └─ $(get_agent_desc "$agent_file")"
    fi
  done
  echo ""
  first_agent=$(echo "$SUGGESTED_AGENTS" | awk '{print $1}')
  echo "⚠️ ENFORCEMENT: Run $first_agent BEFORE proceeding"
fi

# Context warning if stale/missing
if [[ "$CONTEXT_STATUS" != "fresh" ]]; then
  echo ""
  echo "⚠️ CONTEXT WARNING: Run context-loader to refresh project context"
fi

echo "</context_injection>"

# Inject full rules only for matched behavioral triggers
for trigger in $MATCHED_TRIGGERS; do
  for f in "$RULES_DIR"/*.md; do
    [[ ! -f "$f" ]] && continue
    if [[ "$(get_trigger "$f")" == "$trigger" ]]; then
      echo ""
      echo "<${trigger}_rule>"
      grep -v '^<!-- ' "$f" | head -40
      echo "</${trigger}_rule>"
    fi
  done
done

# Always inject lifecycle and context rules for agent operations
if [[ -n "$SUGGESTED_AGENTS" ]]; then
  if [[ -f "$RULES_DIR/agent-lifecycle-messages.md" ]]; then
    echo ""
    echo "<lifecycle_rule>"
    grep -v '^<!-- ' "$RULES_DIR/agent-lifecycle-messages.md" | head -50
    echo "</lifecycle_rule>"
  fi
  if [[ -f "$RULES_DIR/context-passing-protocol.md" ]]; then
    echo ""
    echo "<context_protocol_rule>"
    grep -v '^<!-- ' "$RULES_DIR/context-passing-protocol.md" | head -40
    echo "</context_protocol_rule>"
  fi
fi
