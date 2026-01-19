#!/bin/bash
set -euo pipefail

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
TRIGGERS_FILE="$CLAUDE_DIR/hooks/triggers.json"

# Check if rules directory exists
[[ -d "$RULES_DIR" ]] || exit 0
[[ -f "$TRIGGERS_FILE" ]] || exit 0

# Lowercase the prompt for matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Function to check if any keyword matches
check_trigger() {
    local trigger_name="$1"
    local keywords
    keywords=$(jq -r ".$trigger_name[]" "$TRIGGERS_FILE" 2>/dev/null) || return 1

    while IFS= read -r keyword; do
        if [[ "$PROMPT_LOWER" == *"$keyword"* ]]; then
            return 0
        fi
    done <<< "$keywords"
    return 1
}

# Collect matched triggers
MATCHED_TRIGGERS=()

for trigger in code package structure rules subagent; do
    if check_trigger "$trigger"; then
        MATCHED_TRIGGERS+=("$trigger")
    fi
done

# Collect active rules - ALWAYS include "always" trigger rules
ACTIVE_RULES=()
for rule_file in "$RULES_DIR"/*.md; do
    [[ -f "$rule_file" ]] || continue
    RULE_TRIGGER=$(grep -m1 "<!-- TRIGGER:" "$rule_file" 2>/dev/null | sed 's/.*TRIGGER: *\([^-]*\) *-->.*/\1/' | tr -d ' ')
    RULE_NAME=$(basename "$rule_file" .md)

    # Always include "always" trigger rules
    if [[ "$RULE_TRIGGER" == "always" ]]; then
        ACTIVE_RULES+=("$RULE_NAME")
    # Include rules matching keyword triggers
    elif [[ ${#MATCHED_TRIGGERS[@]} -gt 0 ]]; then
        for matched in "${MATCHED_TRIGGERS[@]}"; do
            if [[ "$RULE_TRIGGER" == "$matched" ]]; then
                ACTIVE_RULES+=("$RULE_NAME")
                break
            fi
        done
    fi
done

# Collect suggested agents
SUGGESTED_AGENTS=()
for trigger in "${MATCHED_TRIGGERS[@]}"; do
    case "$trigger" in
        code) SUGGESTED_AGENTS+=("pre-code-check") ;;
        package) SUGGESTED_AGENTS+=("package-checker") ;;
        structure) SUGGESTED_AGENTS+=("structure-validator") ;;
    esac
done

OUTPUT="<user-prompt-submit-hook>\n"

if [[ ${#ACTIVE_RULES[@]} -gt 0 ]]; then
    OUTPUT+="📋 Rules: $(IFS=,; echo "${ACTIVE_RULES[*]}")\n"
else
    OUTPUT+="📋 Rules: none\n"
fi

if [[ ${#SUGGESTED_AGENTS[@]} -gt 0 ]]; then
    OUTPUT+="🤖 Agents: $(IFS=,; echo "${SUGGESTED_AGENTS[*]}")\n"
else
    OUTPUT+="🤖 Agents: none\n"
fi

OUTPUT+="</user-prompt-submit-hook>"

echo -e "$OUTPUT"
