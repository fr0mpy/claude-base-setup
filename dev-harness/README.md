# Dev Harness

A local development environment for testing the `claude-base-setup` package without publishing.

## Usage

```bash
cd dev-harness

# Install the package (creates .claude/ directory)
npm run setup

# Reinstall fresh (removes existing .claude/ first)
npm run setup:fresh

# Install with API key prompt
npm run setup:with-key

# Remove .claude/ directory
npm run teardown

# Update specific components
npm run update:agents
npm run update:rules
npm run update:hooks
npm run update:commands
```

## What This Tests

1. **CLI installation** - Does `bin/cli.js` correctly copy templates?
2. **Directory structure** - Are all folders created (hooks, rules, agents, commands, skills, component-recipes)?
3. **File permissions** - Are shell scripts executable?
4. **Settings config** - Is `settings.json` correctly configured based on API key presence?
5. **Update flags** - Do partial updates work without overwriting other files?

## After Setup

Once installed, you can inspect the `.claude/` directory to verify:

- `settings.json` - Hook configuration
- `hooks/` - Shell scripts with correct permissions
- `rules/` - Behavioral rules
- `agents/` - Task agents
- `commands/` - Slash commands
- `skills/` - Context-triggered skills (styling.md)
- `component-recipes/` - UI component templates

## Notes

- This directory is git-ignored (except for package.json and README.md)
- The `.claude/` directory created here is for testing only
- Run `npm run teardown` to clean up after testing
