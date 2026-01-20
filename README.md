# claude-base-setup

A reusable `.claude` configuration for Claude Code projects with smart context injection, rules, agents, and slash commands.

## Installation

```bash
npx claude-base-setup
```

This creates a `.claude/` directory in your project with:

- **CLAUDE.md** - Project context (auto-loaded by Claude)
- **hooks/** - Smart context injection on every prompt
- **rules/** - Behavioral guidelines injected into context
- **agents/** - Task workers (pre-code-check, package-checker, etc.)
- **commands/** - Slash commands (/review, /test, /commit)
- **settings.json** - Hook configuration

## CLI Options

```bash
# Initialize (interactive - prompts for API key)
npx claude-base-setup

# Initialize without API key prompt (CI/automation)
npx claude-base-setup --skip-api-key

# Overwrite existing .claude directory
npx claude-base-setup --force

# Remove .claude directory
npx claude-base-setup --remove

# Update specific components (preserves settings.json and CLAUDE.md)
npx claude-base-setup --update-hooks
npx claude-base-setup --update-agents
npx claude-base-setup --update-rules
npx claude-base-setup --update-commands

# Show help
npx claude-base-setup --help
```

### What it does

1. **On every prompt**: Analyzes your input and injects relevant rules
2. **On session start**: Checks if project context is fresh, suggests refresh if stale
3. **Before creating code**: Suggests running `pre-code-check` agent to avoid duplicates
4. **Before installing packages**: Suggests running `package-checker` for version compatibility

## Included Rules

| Rule | Trigger | Description |
|------|---------|-------------|
| code-standards | code keywords | No hardcoding, dynamic discovery |
| announce-actions | always | Announce actions, track agent usage |
| rule-format | "rule" keywords | How to create rules |
| subagent-format | "agent" keywords | How to create agents |
| command-format | "command" keywords | How to create slash commands |

## Included Agents (23 specialized agents)

### Core Agents
| Agent | Purpose |
|-------|---------|
| pre-code-check | Search for existing code before creating new |
| package-checker | Check package versions and compatibility |
| context-loader | Scan codebase and generate CONTEXT.md |
| structure-validator | Validate project structure after file ops |

### Planning & Requirements
| Agent | Purpose |
|-------|---------|
| intent-clarifier | Clarifies requirements before coding starts |
| assumption-challenger | Reviews plans and lists hidden assumptions |
| breaking-change-predictor | Predicts what might break from changes |

### Code Quality
| Agent | Purpose |
|-------|---------|
| legacy-archaeologist | Explains why old code exists and its history |
| dependency-detective | Investigates packages before adding them |
| test-gap-finder | Finds untested code paths and logic gaps |
| refactor-scope-limiter | Defines minimum safe scope for refactoring |

### Workflow
| Agent | Purpose |
|-------|---------|
| pr-narrator | Writes PR descriptions from commits/diffs |
| migration-planner | Plans safe database/API migrations |
| incident-replayer | Traces errors through code to explain them |

### Session Management
| Agent | Purpose |
|-------|---------|
| context-curator | Summarizes conversation and suggests compaction |
| decision-logger | Records architectural decisions as ADRs |
| session-handoff | Prepares summary for continuing later |
| scope-creep-detector | Monitors if work is drifting from task |

### Domain-Specific
| Agent | Purpose |
|-------|---------|
| api-contract-guardian | Ensures API changes don't break consumers |
| accessibility-auditor | Checks UI code for a11y issues |
| performance-profiler | Finds obvious performance issues |
| error-boundary-designer | Suggests where to add error handling |

### Thinking Partners
| Agent | Purpose |
|-------|---------|
| rubber-duck | Helps think through problems via questions |
| devils-advocate | Argues against solutions to stress-test them |
| 10x-simplifier | Challenges code to be radically simpler |
| future-you | Reviews code as if maintaining it 6 months later |

## Included Commands

| Command | Purpose |
|---------|---------|
| /review | Review current changes for issues |
| /test | Run tests and fix failures |
| /commit | Stage and commit changes |

## Customization

After installation, modify files in `.claude/` to fit your project:

- Add project-specific rules in `rules/`
- Customize keyword triggers in `hooks/triggers.json`
- Add custom agents in `agents/`
- Add custom slash commands in `commands/`
- Update `settings.json` for permissions

## License

MIT
