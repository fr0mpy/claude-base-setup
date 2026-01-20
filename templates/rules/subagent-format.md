<!-- SUMMARY: Follow standard format when creating or modifying subagents -->
<!-- TRIGGER: subagent -->
# RULE: Subagent Format

⚠️ **ACTIVE RULE** - Apply when creating or modifying subagent files.

## 🔐 Enforcement

**When creating/modifying subagents, you MUST:**
1. Use YAML frontmatter with required fields
2. Include structured output format for context return
3. Keep prompts concise and actionable
4. Place in `.claude/agents/` directory

---

## Template

```markdown
---
name: agent-name
description: Brief description. When to use this agent proactively.
tools: Grep, Glob, Read, WebSearch, Bash
model: haiku
---

You are a [role] for [project type].

## Your Task

1. Step one
2. Step two
3. Step three

## Output Format

Return findings in this EXACT structure for context handoff:

### RESULT: [found | not-found | partial]

### FILES FOUND:
- `path/to/file.ts:line` - [what's there]
- `path/to/other.ts:line` - [what's there]

### PATTERNS DETECTED:
- [existing pattern 1]
- [existing pattern 2]

### GAPS:
- [what's missing]

### RECOMMENDATION:
[Specific action to take based on findings]

## Rules

- Rule one
- Rule two
```

---

## Required Fields

| Field | Purpose |
|-------|---------|
| `name` | Unique identifier (kebab-case) |
| `description` | When Claude should delegate to this agent |
| `tools` | Allowed tools (Grep, Glob, Read, WebSearch, Bash, Write, Edit) |
| `model` | `haiku` for fast/cheap, `sonnet` for complex |

---

## Output Structure (Required)

All agents MUST return structured findings:

| Section | Required | Content |
|---------|----------|---------|
| RESULT | Yes | `found` / `not-found` / `partial` |
| FILES FOUND | If found | File paths with line numbers |
| PATTERNS | If found | Existing code patterns |
| GAPS | If any | What's missing |
| RECOMMENDATION | Yes | Specific next action |

---

## Best Practices

- Write clear `description` - Claude uses this to decide when to delegate
- Always include file:line references
- Be specific in recommendations
- Use `haiku` model for simple searches
- Use `sonnet` for complex reasoning
