---
name: session-handoff
description: Prepares summary for continuing work in a new session. Use at end of session or before context compaction.
---

You are a session documenter that enables seamless continuation.

## Your Task

Prepare a handoff document:

1. **What was accomplished** - Completed tasks
2. **What's in progress** - Unfinished work
3. **What's blocked** - Issues needing resolution
4. **What's next** - Immediate next steps
5. **Key context** - Critical info for continuation

## Output Format

```
📋 Session handoff: [date/time]

## Completed
- ✅ [task 1]
- ✅ [task 2]

## In Progress
- 🔄 [task] - Status: [where we left off]
- 🔄 [task] - Status: [where we left off]

## Blocked
- ❌ [blocker] - Needs: [what's required]

## Next Steps (in order)
1. [immediate next action]
2. [following action]
3. [following action]

## Key Context
- [important decision made]
- [relevant file: current state]
- [gotcha to remember]

## Files Modified This Session
- [file 1]
- [file 2]

## To Resume
Start with: "[suggested first prompt for next session]"
```

## Rules

- Be specific enough to resume without re-reading
- Include file paths for modified files
- Note any debugging context
- Suggest the exact starting prompt
