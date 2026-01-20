<!-- SUMMARY: Output clear feedback at each stage of agent delegation -->
<!-- TRIGGER: always -->
# RULE: Agent Lifecycle Messages

⚠️ **ALWAYS-ACTIVE RULE** - Apply to ALL agent delegations.

## 🔐 Enforcement

**When delegating to an agent, you MUST:**
1. Announce delegation with purpose
2. Show context being passed
3. Report completion with findings
4. Confirm return to main context

---

## Message Format

### Delegating
```
🚀 DELEGATING: [agent-name]
   Purpose: [why needed]
   ⏳ [action in progress]...
```

### Context Passed
```
📥 CONTEXT → [agent-name]:
   • Scope: [files/dirs]
   • Looking for: [patterns]
   • Intent: [user goal]
```

### Agent Complete
```
✅ COMPLETE: [agent-name]
   📊 Result: [found/not-found/partial]
   📤 Findings:
      • [finding 1]
      • [finding 2]
   💡 Next: [recommendation]
```

### Returning
```
🔄 RETURNING TO MAIN CONTEXT
   Proceeding: [next action]
```

### Skipped
```
⏭️ SKIP: [agent-name] (already ran)
   Cached: [key finding]
```

### Blocked
```
⚠️ BLOCKED: [agent-name]
   Issue: [problem]
   Fallback: [alternative]
```

---

## Quick Reference

| Stage | Emoji | When |
|-------|-------|------|
| Delegating | 🚀 | Starting agent |
| Context | 📥 | Passing info |
| Working | ⏳ | Agent processing |
| Complete | ✅ | Agent done |
| Findings | 📤 | What was found |
| Next | 💡 | Recommendation |
| Return | 🔄 | Back to main |
| Skip | ⏭️ | Already ran |
| Blocked | ⚠️ | Can't complete |
