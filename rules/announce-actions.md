---
description: Announce all actions with emoji prefixes, track agent usage, prevent duplicate agent runs. Applies to ALL prompts.
---
<!-- TRIGGER: always -->
# RULE: Announce Actions

## Enforcement

**For every operation:**
1. Announce what you're doing
2. Announce when delegating to an agent
3. Report results
4. **NEVER run the same agent twice in one prompt**

---

## Agent Deduplication

⚠️ **CRITICAL**: Each agent runs ONCE per user prompt, max.

Before invoking an agent, check if you already used it this turn:
- If `pre-code-check` already ran → skip, use cached result
- If `context-loader` already ran → skip, context is loaded
- If `structure-validator` already ran → skip

---

## Format

```
🔧 [Action]: [what]
✅ Done: [result]
```

**When using agents (use present continuous):**
```
🤖 Searching for existing code...
🤖 Checking package versions...
🤖 Validating project structure...
🤖 Loading project context...
   [agent does work]
✅ Done: [summary]
```

**When agent already ran:**
```
⏭️ Skipping [agent-name] (already ran this prompt)
```

---

## Quick Reference

| Trigger | Action | Max runs |
|---------|--------|----------|
| Creating code | `pre-code-check` first | 1 |
| Installing packages | `package-checker` first | 1 |
| File operations | `structure-validator` after | 1 |
| Session start | `context-loader` | 1 |

---
