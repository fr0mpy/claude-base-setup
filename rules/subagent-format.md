<!-- SUMMARY: Follow standard format when creating or modifying subagents -->
<!-- TRIGGER: subagent -->
# RULE: Subagent Format

⚠️ **ACTIVE RULE** - Apply when creating or modifying subagent files.

## 🔐 Enforcement

**When creating/modifying subagents, you MUST:**
1. Use YAML frontmatter with required fields
2. Keep prompts concise and actionable
3. Place in `.claude/agents/` directory

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

[Expected output structure]

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

## Best Practices

- Write clear `description` - Claude uses this to decide when to delegate
- Limit to 3-4 subagents total per project
- Use `haiku` model for simple searches
- Use `sonnet` for complex reasoning
- Keep prompts focused on one task
