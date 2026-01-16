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

[[ -z "$CLAUDE_DIR" ]] && exit 0

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
# OUTPUT
# ============================================================================

echo "<context_injection>"

# Rules status
echo "RULES:"
for f in "$RULES_DIR"/*.md; do
  [[ ! -f "$f" ]] && continue
  local_summary=$(get_summary "$f")
  local_trigger=$(get_trigger "$f")
  [[ -z "$local_summary" ]] && continue

  if echo " $MATCHED_TRIGGERS " | grep -q " $local_trigger "; then
    echo "✅ $(get_rule_name "$f")"
  else
    echo "◽ $(get_rule_name "$f")"
  fi
done

# Agent suggestions based on triggers
SUGGESTED_AGENTS=""
for trigger in $MATCHED_TRIGGERS; do
  case "$trigger" in
    code) SUGGESTED_AGENTS="$SUGGESTED_AGENTS pre-code-check" ;;
    package) SUGGESTED_AGENTS="$SUGGESTED_AGENTS package-checker" ;;
    structure) SUGGESTED_AGENTS="$SUGGESTED_AGENTS structure-validator" ;;
  esac
done

if [[ -n "$SUGGESTED_AGENTS" ]]; then
  echo ""
  echo "USE AGENTS:"
  for agent in $SUGGESTED_AGENTS; do
    agent_file="$AGENTS_DIR/${agent}.md"
    if [[ -f "$agent_file" ]]; then
      echo "🤖 $agent: $(get_agent_desc "$agent_file")"
    fi
  done
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
