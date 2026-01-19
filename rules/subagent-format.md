---
description: Template for creating/modifying subagent files. Use when user asks to create, add, or modify an agent.
---
<!-- TRIGGER: subagent -->
# RULE: Subagent File Format

⚠️ **ALWAYS-ACTIVE RULE** - Use this template for all subagent files.

## 🔐 Enforcement

**Every subagent file MUST have:**
1. YAML frontmatter (name, description, tools, model)
2. Clear task definition
3. Output format specification
4. Rules section

---

## Template

```markdown
---
name: [kebab-case-name]
description: [CRITICAL - LLM reads this to decide when to suggest this agent. Be specific about triggers and use cases.]
tools: [Glob, Grep, Read, WebSearch, Bash, Write, Edit]
model: [haiku|sonnet]
---

You are a [role] for [project type].

## Your Task

[Clear, specific instructions]

## [Context Section]

[Relevant project info if needed]

## Steps

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Output Format

**Success:**
\`\`\`
✅ [result]
   [details]
\`\`\`

**Failure/Warning:**
\`\`\`
⚠️ [issue]
   [action needed]
\`\`\`

## Rules

- [Rule 1]
- [Rule 2]
- [Rule 3]
```

---

## Frontmatter Fields

| Field | Required | Notes |
|-------|----------|-------|
| `name` | ✅ | Kebab-case, unique |
| `description` | ✅ | **LLM reads this to decide when to suggest agent.** Include: what it does, when to use it, trigger words. |
| `tools` | ✅ | Available tools |
| `model` | ✅ | haiku (fast) or sonnet (complex) |

---

## Writing Good Descriptions

The `description` field is **critical** - an LLM reads it to decide when to suggest this agent.

**Good examples:**
- `Searches for existing code before creating new components. Use when user asks to create, build, add, or make new code.`
- `Checks package versions before installation. Use when user mentions npm, install, add package, or dependencies.`

**Bad examples:**
- `Helps with code` (too vague)
- `Pre-code checker` (doesn't explain when to use)

---

## Model Selection

- **haiku** - Simple searches, validations, checks
- **sonnet** - Complex analysis, code generation
