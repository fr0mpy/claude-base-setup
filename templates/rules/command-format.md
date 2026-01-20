<!-- SUMMARY: Follow standard format when creating slash commands -->
<!-- TRIGGER: command -->
# RULE: Command Format

**ACTIVE RULE** - Apply when creating or modifying slash commands.

## Enforcement

**When creating commands, you MUST:**
1. Keep prompts short (under 15 lines)
2. Use numbered steps
3. Include `$ARGUMENTS` if user input is needed
4. Place in `.claude/commands/` directory

---

## Template

```markdown
Brief description of what this command does.

1. First step
2. Second step
3. Third step

$ARGUMENTS
```

---

## Principles

- **Concise** - Commands are prompts, not documentation
- **Action-oriented** - Each step is a verb
- **No fluff** - Skip explanations, just list steps
- **Flexible** - Use `$ARGUMENTS` for user parameters

---

## Examples

**Good:**
```markdown
Run tests and fix failures.

1. Detect test runner
2. Run tests
3. Fix any failures
4. Re-run until passing

$ARGUMENTS
```

**Bad:**
```markdown
This command will help you run tests in your project.
It supports multiple test frameworks including Jest, Vitest, and pytest.
When tests fail, it will analyze the error messages...
[too verbose]
```
