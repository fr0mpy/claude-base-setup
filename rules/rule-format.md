---
description: Template for creating/modifying rule files. Use when user asks to create, add, or modify a rule.
---
<!-- TRIGGER: rules -->
# RULE: Rule File Format

⚠️ **ALWAYS-ACTIVE RULE** - Use this template for all rule files.

## 🔐 Enforcement

**Every rule file MUST have:**
1. YAML frontmatter with `description` field
2. TRIGGER comment
3. Clear rule name
4. Enforcement section
5. Actionable checks

---

## Template

```markdown
---
description: [What this rule does and when it applies - used by LLM to select rules]
---
<!-- TRIGGER: [code|package|structure|always] -->
# RULE: [Name]

⚠️ **ALWAYS-ACTIVE RULE** - [when this applies]

## 🔐 Enforcement

**For [context], you MUST:**
1. [Action 1]
2. [Action 2]
3. [Action 3]

---

## [Main Section]

| ❌ Don't | ✅ Do |
|----------|-------|
| [bad]    | [good]|

---

## Quick Reference

| Trigger | Action |
|---------|--------|
| [when]  | [what] |
```

---

## Frontmatter Fields

| Field | Required | Notes |
|-------|----------|-------|
| `description` | ✅ | LLM reads this to decide when rule applies. Be specific about triggers. |

## TRIGGER Comment

- `code` - Creating/modifying code
- `package` - Installing dependencies
- `structure` - File/folder operations
- `always` - Every prompt

---

## Principles

1. **Concise** - No fluff or explanations
2. **Actionable** - Clear do/don't instructions
3. **Scannable** - Tables, bullets, formatting
4. **Self-contained** - No external references needed

---

## Anti-Patterns

❌ Long explanations of why
❌ Multiple examples saying the same thing
❌ Philosophical background
❌ Sections that don't instruct
