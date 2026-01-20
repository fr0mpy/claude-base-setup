<!-- SUMMARY: Follow standard format when creating or modifying rules -->
<!-- TRIGGER: rules -->
# RULE: Rule Format - Standard Structure for All Rules

⚠️ **ALWAYS-ACTIVE RULE** - Apply when creating or modifying any rule file.

## 🔐 Enforcement

**When creating/modifying rules, you MUST:**
1. Follow the exact template below
2. Keep content concise - no filler words
3. Use the metadata comments for hook integration

---

## Template

```markdown
<!-- SUMMARY: One-line description (max 80 chars) -->
<!-- TRIGGER: code | package | structure | always -->
# RULE: Name - Short Description

⚠️ **ALWAYS-ACTIVE RULE** - Brief scope statement.

## 🔐 Enforcement

**[When this triggers], you MUST:**
1. Step one
2. Step two
3. Step three

---

## What to Check

- Bullet point checks
- Keep actionable

## Quick Reference

| Do | Don't |
|----|-------|
| Good example | Bad example |
```

---

## Metadata Fields

| Field | Values | Purpose |
|-------|--------|---------|
| `SUMMARY` | Max 80 chars | Displayed in lightweight mode |
| `TRIGGER` | `code`, `package`, `structure`, `always` | When hook injects this rule |

---

## Principles

1. **Concise** - No paragraphs explaining why. Just what to do.
2. **Actionable** - Every line should be a clear instruction.
3. **Scannable** - Use tables, bullets, code blocks. No walls of text.
4. **Self-contained** - Rule should work without reading other docs.

---

## Anti-Patterns

❌ Long explanations of "why" this rule exists
❌ Multiple examples when one suffices
❌ Repeating the same instruction in different words
❌ Sections that don't add actionable value
❌ "Philosophy" or "Background" sections
