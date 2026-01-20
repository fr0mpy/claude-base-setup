<!-- SUMMARY: Announce actions, track agent usage, prevent duplicates -->
<!-- TRIGGER: always -->
# RULE: Announce Actions

## 🔐 Enforcement

**For every operation, you MUST:**
1. Announce action before starting
2. Use lifecycle messages for agents (see agent-lifecycle-messages rule)
3. Report results with specific details
4. **NEVER run the same agent twice in one prompt**

---

## Action Messages

```
🔧 ACTION: [what you're doing]
✅ DONE: [specific result]
❌ FAILED: [what went wrong]
```

---

## Agent Deduplication

⚠️ **CRITICAL**: Each agent runs ONCE per user prompt, max.

Before invoking:
- Check if already used this turn
- If ran → use cached findings
- Output skip message with cached result

---

## Quick Reference

| Event | Format |
|-------|--------|
| Starting action | `🔧 ACTION: [what]` |
| Delegating | `🚀 DELEGATING: [agent]` |
| Context passed | `📥 CONTEXT → [agent]` |
| Agent done | `✅ COMPLETE: [agent]` |
| Returning | `🔄 RETURNING TO MAIN` |
| Skipping | `⏭️ SKIP: [agent] (cached)` |
| Action done | `✅ DONE: [result]` |
| Failed | `❌ FAILED: [reason]` |

---

## Agent Triggers

| Trigger | Agent | When |
|---------|-------|------|
| Creating code | `pre-code-check` | BEFORE writing |
| Installing packages | `package-checker` | BEFORE installing |
| File operations | `structure-validator` | AFTER creating |
| Session start | `context-loader` | On stale context |
