<!-- SUMMARY: Ensure agents receive and return context correctly -->
<!-- TRIGGER: always -->
# RULE: Context Passing Protocol

⚠️ **ALWAYS-ACTIVE RULE** - Apply when delegating to or receiving from agents.

## 🔐 Enforcement

**When delegating, you MUST pass:**
1. Project type and stack
2. Relevant file paths/directories
3. User's stated intent
4. Specific patterns to search for

**When agent returns, you MUST:**
1. Acknowledge findings explicitly
2. State how findings affect your approach
3. Reference specific files/lines from agent

---

## Outbound Context (Main → Agent)

| Field | Required | Example |
|-------|----------|---------|
| Project | Yes | "Next.js 14 + TypeScript" |
| Scope | Yes | "src/auth/, src/lib/" |
| Patterns | Yes | "authentication, OAuth, login" |
| Intent | Yes | "Add Google OAuth login" |
| Constraints | If any | "Must use existing session utils" |

---

## Inbound Context (Agent → Main)

| Field | Required | Example |
|-------|----------|---------|
| Result | Yes | "found" / "not-found" / "partial" |
| Files | If found | "src/lib/auth.ts:42-68" |
| Patterns | If found | "useSession hook, JWT validation" |
| Gaps | If any | "No OAuth provider setup exists" |
| Recommendation | Yes | "Extend auth.ts, add new oauth.ts" |

---

## Quick Reference

### Pass TO agent:
```
📥 CONTEXT → [agent]:
   • Project: [stack]
   • Scope: [paths]
   • Patterns: [keywords]
   • Intent: [goal]
```

### Receive FROM agent:
```
📤 RECEIVED ← [agent]:
   • Found: [files:lines]
   • Patterns: [what exists]
   • Gaps: [what's missing]
   • Action: [what to do]
```

---

## Anti-Patterns

| Don't | Do |
|-------|-----|
| "Search the codebase" | "Search src/auth/ for OAuth patterns" |
| "Found some code" | "Found auth logic at src/lib/auth.ts:42" |
| "It didn't find anything" | "No OAuth patterns in src/. Will create new." |
| Skip acknowledgment | Always state how findings change approach |
