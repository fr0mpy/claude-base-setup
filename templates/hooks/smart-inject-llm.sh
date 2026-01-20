#!/bin/bash
set -euo pipefail

# LLM-powered smart rule/agent injection using Claude Haiku
# Replaces static keyword matching with semantic understanding

# Read prompt from stdin
PROMPT=$(cat)

# Find .claude directory
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

CLAUDE_DIR=$(find_claude_dir) || { echo "<user-prompt-submit-hook>⚠️ .claude directory not found</user-prompt-submit-hook>"; exit 0; }

RULES_DIR="$CLAUDE_DIR/rules"
AGENTS_DIR="$CLAUDE_DIR/agents"

# Check directories exist
[[ -d "$RULES_DIR" ]] || { echo "<user-prompt-submit-hook>⚠️ Rules directory not found at $RULES_DIR</user-prompt-submit-hook>"; exit 0; }

# Get API key and model from environment
API_KEY="${ANTHROPIC_API_KEY:-}"
[[ -n "$API_KEY" ]] || { echo "<user-prompt-submit-hook>ℹ️ ANTHROPIC_API_KEY not set - using keyword matching</user-prompt-submit-hook>"; exec "$CLAUDE_DIR/hooks/smart-inject-rules.sh" <<< "$PROMPT"; }

MODEL="${ANTHROPIC_MODEL:-}"
[[ -n "$MODEL" ]] || { echo "<user-prompt-submit-hook>❌ ANTHROPIC_MODEL not set. Add ANTHROPIC_MODEL to your .env file (e.g., claude-3-5-haiku-latest)</user-prompt-submit-hook>"; exit 1; }

# Build rules summary (name + description from YAML frontmatter)
RULES_SUMMARY=""
for rule_file in "$RULES_DIR"/*.md; do
    [[ -f "$rule_file" ]] || continue
    RULE_NAME=$(basename "$rule_file" .md)
    # Try YAML frontmatter first, fall back to SUMMARY comment
    RULE_DESC=$(sed -n '/^---$/,/^---$/p' "$rule_file" 2>/dev/null | grep -m1 "^description:" | sed 's/description: *//' | tr -d '\n')
    if [[ -z "$RULE_DESC" ]]; then
        RULE_DESC=$(grep -m1 "<!-- SUMMARY:" "$rule_file" 2>/dev/null | sed 's/.*SUMMARY: *\([^-]*\) *-->.*/\1/' | tr -d '\n')
    fi
    [[ -n "$RULE_DESC" ]] && RULES_SUMMARY+="- $RULE_NAME: $RULE_DESC\n"
done

# Build agents summary
AGENTS_SUMMARY=""
if [[ -d "$AGENTS_DIR" ]]; then
    for agent_file in "$AGENTS_DIR"/*.md; do
        [[ -f "$agent_file" ]] || continue
        AGENT_NAME=$(basename "$agent_file" .md)
        AGENT_DESC=$(grep -m1 "^description:" "$agent_file" 2>/dev/null | sed 's/description: *//' | tr -d '\n')
        AGENTS_SUMMARY+="- $AGENT_NAME: $AGENT_DESC\n"
    done
fi

# Escape prompt for JSON
ESCAPED_PROMPT=$(echo "$PROMPT" | jq -Rs '.')
ESCAPED_RULES=$(echo -e "$RULES_SUMMARY" | jq -Rs '.')
ESCAPED_AGENTS=$(echo -e "$AGENTS_SUMMARY" | jq -Rs '.')

# Build dynamic system prompt from actual files
SYSTEM_PROMPT="You analyze user prompts and select relevant rules/agents. Respond ONLY with valid JSON.

Output format:
{
  \"active_rules\": [\"rule-name\"],
  \"suggested_agents\": [\"agent-name\"],
  \"enforcement\": \"Brief instruction Claude MUST follow\"
}

Available rules (select based on their descriptions):
$(echo -e "$RULES_SUMMARY")

Available agents (select based on their descriptions):
$(echo -e "$AGENTS_SUMMARY")

Selection guidelines:
- Read each rule/agent description to understand when it applies
- Select rules that match the user's intent, not just keywords
- Select agents that should run BEFORE or AFTER the task
- If no rules/agents apply, return empty arrays

Enforcement rules:
- If you select ANY agent, enforcement MUST say \"YOU MUST run [agent-name] FIRST\" or \"YOU MUST run [agent-name] AFTER\"
- If you select rules, include their key requirement in enforcement
- Enforcement should be SHORT (<100 chars) but MANDATORY language

Good enforcement examples:
- \"YOU MUST run pre-code-check BEFORE writing code\"
- \"YOU MUST run package-checker BEFORE installing\"
- \"Prefix actions with 🔧. YOU MUST run pre-code-check FIRST\"

Bad enforcement examples:
- \"Consider running pre-code-check\" (too weak)
- \"pre-code-check suggested\" (not mandatory)
"

USER_MSG="User prompt: $PROMPT

Based on the prompt, select relevant rules and agents. Return JSON only."

ESCAPED_SYSTEM=$(printf '%s' "$SYSTEM_PROMPT" | jq -Rs '.')
ESCAPED_USER=$(printf '%s' "$USER_MSG" | jq -Rs '.')

# Call Haiku API
RESPONSE=$(curl -s --max-time 5 "https://api.anthropic.com/v1/messages" \
    -H "Content-Type: application/json" \
    -H "x-api-key: $API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -d "{
        \"model\": \"$MODEL\",
        \"max_tokens\": 256,
        \"messages\": [{
            \"role\": \"user\",
            \"content\": $ESCAPED_USER
        }],
        \"system\": $ESCAPED_SYSTEM
    }" 2>/dev/null) || { echo "<user-prompt-submit-hook>⚠️ LLM API call failed - using keyword matching</user-prompt-submit-hook>" >&2; exec "$CLAUDE_DIR/hooks/smart-inject-rules.sh" <<< "$PROMPT"; }

# Check for API errors
API_ERROR=$(echo "$RESPONSE" | jq -r '.error.message // empty' 2>/dev/null)
if [[ -n "$API_ERROR" ]]; then
    echo "<user-prompt-submit-hook>⚠️ API error: $API_ERROR - using keyword matching</user-prompt-submit-hook>" >&2
    exec "$CLAUDE_DIR/hooks/smart-inject-rules.sh" <<< "$PROMPT"
fi

# Extract JSON from response
LLM_OUTPUT=$(echo "$RESPONSE" | jq -r '.content[0].text // empty' 2>/dev/null) || { echo "<user-prompt-submit-hook>⚠️ Failed to parse LLM response - using keyword matching</user-prompt-submit-hook>" >&2; exec "$CLAUDE_DIR/hooks/smart-inject-rules.sh" <<< "$PROMPT"; }

[[ -n "$LLM_OUTPUT" ]] || { echo "<user-prompt-submit-hook>⚠️ Empty LLM response - using keyword matching</user-prompt-submit-hook>" >&2; exec "$CLAUDE_DIR/hooks/smart-inject-rules.sh" <<< "$PROMPT"; }

# Parse LLM response
ACTIVE_RULES=$(echo "$LLM_OUTPUT" | jq -r '.active_rules[]? // empty' 2>/dev/null)
SUGGESTED_AGENTS=$(echo "$LLM_OUTPUT" | jq -r '.suggested_agents[]? // empty' 2>/dev/null)
ENFORCEMENT=$(echo "$LLM_OUTPUT" | jq -r '.enforcement // empty' 2>/dev/null)

# Check context freshness
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

# Build rich output
OUTPUT="<user-prompt-submit-hook>\n"
OUTPUT+="┌─────────────────────────────────────────────┐\n"
OUTPUT+="│ 🎯 PROMPT ANALYZED (LLM)                    │\n"

# Context status
case "$CONTEXT_STATUS" in
    fresh)
        OUTPUT+="│ ├─ 📊 Context: ✅ fresh ($CONTEXT_AGE ago)     │\n"
        ;;
    stale)
        OUTPUT+="│ ├─ 📊 Context: ⚠️ stale ($CONTEXT_AGE ago)     │\n"
        ;;
    missing)
        OUTPUT+="│ ├─ 📊 Context: ❌ missing                     │\n"
        ;;
esac

# Add active rules
if [[ -n "$ACTIVE_RULES" ]]; then
    rules_list=$(echo "$ACTIVE_RULES" | tr '\n' ', ' | sed 's/,$//')
    OUTPUT+="│ ├─ 📋 Rules: $rules_list\n"
else
    OUTPUT+="│ ├─ 📋 Rules: (none matched)                  │\n"
fi

# Add suggested agents
if [[ -n "$SUGGESTED_AGENTS" ]]; then
    agents_list=$(echo "$SUGGESTED_AGENTS" | tr '\n' ', ' | sed 's/,$//')
    OUTPUT+="│ └─ 🤖 Agents: $agents_list\n"
else
    OUTPUT+="│ └─ 🤖 Agents: (none suggested)              │\n"
fi

OUTPUT+="└─────────────────────────────────────────────┘\n"

# Detailed agent info
if [[ -n "$SUGGESTED_AGENTS" ]]; then
    OUTPUT+="\n📋 AGENT DETAILS:\n"
    for agent in $SUGGESTED_AGENTS; do
        agent_file="$AGENTS_DIR/${agent}.md"
        if [[ -f "$agent_file" ]]; then
            agent_desc=$(grep -m1 "^description:" "$agent_file" 2>/dev/null | sed 's/description: *//' | head -c 80)
            OUTPUT+="   🤖 $agent\n"
            OUTPUT+="      └─ $agent_desc\n"
        fi
    done
fi

# Add enforcement instruction if present
if [[ -n "$ENFORCEMENT" ]]; then
    OUTPUT+="\n⚠️ ENFORCEMENT: $ENFORCEMENT\n"
fi

# Context warning if stale/missing
if [[ "$CONTEXT_STATUS" != "fresh" ]]; then
    OUTPUT+="\n⚠️ CONTEXT WARNING: Run context-loader to refresh project context\n"
fi

OUTPUT+="</user-prompt-submit-hook>"

echo -e "$OUTPUT"

# Inject lifecycle and context rules for agent operations
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
