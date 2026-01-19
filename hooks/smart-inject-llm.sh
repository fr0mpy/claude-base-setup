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

CLAUDE_DIR=$(find_claude_dir) || exit 0

RULES_DIR="$CLAUDE_DIR/rules"
AGENTS_DIR="$CLAUDE_DIR/agents"

# Check directories exist
[[ -d "$RULES_DIR" ]] || exit 0

# Get API key from environment
API_KEY="${ANTHROPIC_API_KEY:-}"
[[ -n "$API_KEY" ]] || { echo "⚠️ ANTHROPIC_API_KEY not set - using static fallback" >&2; exec "$CLAUDE_DIR/hooks/smart-inject-rules.sh" <<< "$PROMPT"; }

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
        \"model\": \"claude-3-5-haiku-latest\",
        \"max_tokens\": 256,
        \"messages\": [{
            \"role\": \"user\",
            \"content\": $ESCAPED_USER
        }],
        \"system\": $ESCAPED_SYSTEM
    }" 2>/dev/null) || { exec "$CLAUDE_DIR/hooks/smart-inject-rules.sh" <<< "$PROMPT"; }

# Extract JSON from response
LLM_OUTPUT=$(echo "$RESPONSE" | jq -r '.content[0].text // empty' 2>/dev/null) || { exec "$CLAUDE_DIR/hooks/smart-inject-rules.sh" <<< "$PROMPT"; }

[[ -n "$LLM_OUTPUT" ]] || { exec "$CLAUDE_DIR/hooks/smart-inject-rules.sh" <<< "$PROMPT"; }

# Parse LLM response
ACTIVE_RULES=$(echo "$LLM_OUTPUT" | jq -r '.active_rules[]? // empty' 2>/dev/null)
SUGGESTED_AGENTS=$(echo "$LLM_OUTPUT" | jq -r '.suggested_agents[]? // empty' 2>/dev/null)
ENFORCEMENT=$(echo "$LLM_OUTPUT" | jq -r '.enforcement // empty' 2>/dev/null)

OUTPUT="<user-prompt-submit-hook>\n"

# Add active rules
if [[ -n "$ACTIVE_RULES" ]]; then
    OUTPUT+="📋 Rules: $(echo "$ACTIVE_RULES" | tr '\n' ', ' | sed 's/,$//')\n"
else
    OUTPUT+="📋 Rules: none\n"
fi

# Add suggested agents
if [[ -n "$SUGGESTED_AGENTS" ]]; then
    OUTPUT+="🤖 Agents: $(echo "$SUGGESTED_AGENTS" | tr '\n' ', ' | sed 's/,$//')\n"
else
    OUTPUT+="🤖 Agents: none\n"
fi

# Add enforcement instruction if present
if [[ -n "$ENFORCEMENT" ]]; then
    OUTPUT+="⚠️ $ENFORCEMENT\n"
fi

OUTPUT+="</user-prompt-submit-hook>"

echo -e "$OUTPUT"
