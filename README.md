# claude-base-setup

A reusable `.claude` configuration for Claude Code projects with smart context injection, rules, agents, slash commands, and a **component styling system** for consistent UI generation.

## Quick Start

**Step 1: Install in your terminal**

```bash
npx claude-base-setup
```

**Step 2: Open Claude Code** (the AI coding assistant app, not your terminal)

**Step 3: Type these slash commands in Claude Code's chat:**

- `/setup-styling` — Claude will ask about your design preferences and generate tokens
- `/component-harness` — Claude will scaffold a Vite preview gallery

> **Note:** Slash commands like `/setup-styling` are typed into Claude Code's chat interface, not your terminal. They're prompts that Claude interprets using the templates in `.claude/commands/`.

---

## Table of Contents

- [Installation](#installation)
- [CLI Options](#cli-options)
- [Styling System](#styling-system)
- [How It Works](#how-it-works)
- [Rules](#rules)
- [Agents](#agents)
- [Commands](#commands)
- [Customization](#customization)
- [License](#license)

---

## Installation

```bash
npx claude-base-setup
```

This creates a `.claude/` directory in your project with:

| Directory | Purpose |
|-----------|---------|
| `CLAUDE.md` | Project context (auto-loaded by Claude) |
| `hooks/` | Smart context injection on every prompt |
| `rules/` | Behavioral guidelines injected into context |
| `agents/` | Task workers for specialized operations |
| `commands/` | Slash commands (`/review`, `/test`, `/commit`) |
| `skills/` | Context-triggered knowledge (styling system) |
| `component-recipes/` | 40 UI component templates (Base UI) |
| `settings.json` | Hook configuration |

---

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

---

## Styling System

The styling system solves a common problem: **LLM-generated UIs are boring and samey**. This system lets you define YOUR aesthetic and have Claude consistently apply it.

### Setup

In Claude Code, run:

```
/setup-styling
```

You'll be asked about:
- **Overall feel** - Minimal, Bold, Playful, Enterprise
- **Colors** - Your brand colors or presets (monochrome, vibrant, pastels, earth tones)
- **Typography** - Sans, serif, monospace
- **Corners** - Sharp, subtle, rounded, pill
- **Shadows** - Flat, subtle, pronounced, glassmorphism
- **Density** - Compact, comfortable, spacious

This generates:
- `.claude/styling-config.json` - Your design tokens
- `.claude/component-recipes/` - 40 component templates (using Base UI)

### Preview Components

```
/component-harness
```

> **Tip:** When building components, consider running Claude Code in sandbox mode and allowing it to execute commands freely. This lets the agent iterate quickly on the preview gallery without constant permission prompts.

This scaffolds a Vite + React preview gallery where you can:
- Navigate through all 40 components
- See each variant (primary, secondary, outline, etc.)
- Toggle dark/light mode
- Request changes ("make buttons more rounded")

### How It Works

The `styling` skill in `.claude/skills/` is automatically applied when Claude generates UI code. It:
1. Loads your tokens from `styling-config.json`
2. Follows recipes from `component-recipes/` (built on [Base UI](https://base-ui.com) primitives)
3. Uses semantic colors (`bg-primary`) instead of hardcoded values (`bg-blue-500`)

### Component Recipes (40 included)

> Components use [Base UI](https://base-ui.com) headless primitives for accessibility, with Tailwind CSS for styling. Base UI is the spiritual successor to Radix, created by the same team with active maintenance and better performance.

<details>
<summary><strong>Form Components (10)</strong></summary>

button, input, textarea, select, combobox, checkbox, radio, switch, slider, label
</details>

<details>
<summary><strong>Layout Components (6)</strong></summary>

card, separator, collapsible, accordion, tabs, table
</details>

<details>
<summary><strong>Navigation Components (5)</strong></summary>

navigation-menu, breadcrumb, pagination, dropdown-menu, context-menu
</details>

<details>
<summary><strong>Overlay Components (6)</strong></summary>

modal, dialog, drawer, popover, hover-card, tooltip
</details>

<details>
<summary><strong>Feedback Components (5)</strong></summary>

alert, toast, progress, skeleton, spinner
</details>

<details>
<summary><strong>Display Components (4)</strong></summary>

badge, avatar, carousel, toggle-group
</details>

---

## How It Works

| Trigger | Action |
|---------|--------|
| **On every prompt** | Analyzes your input and injects relevant rules |
| **On session start** | Checks if project context is fresh, suggests refresh if stale |
| **Before creating code** | Suggests running `pre-code-check` agent to avoid duplicates |
| **Before installing packages** | Suggests running `package-checker` for version compatibility |
| **When generating UI** | Applies `styling` skill with your tokens and recipes |

---

## Rules

| Rule | Trigger | Description |
|------|---------|-------------|
| code-standards | code keywords | No hardcoding, dynamic discovery |
| announce-actions | always | Announce actions, track agent usage |
| rule-format | "rule" keywords | How to create rules |
| subagent-format | "agent" keywords | How to create agents |
| command-format | "command" keywords | How to create slash commands |

---

## Agents

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

---

## Commands

| Command | Purpose |
|---------|---------|
| `/review` | Review current changes for issues |
| `/test` | Run tests and fix failures |
| `/commit` | Stage and commit changes |
| `/setup-styling` | Interactive style interview to define your UI aesthetic |
| `/component-harness` | Launch visual component preview gallery |

---

## Customization

After installation, modify files in `.claude/` to fit your project:

| What | Where |
|------|-------|
| Project-specific rules | `rules/` |
| Keyword triggers | `hooks/triggers.json` |
| Custom agents | `agents/` |
| Custom slash commands | `commands/` |
| Hook permissions | `settings.json` |
| Design tokens | `styling-config.json` (after /setup-styling) |
| Component styling | `component-recipes/*.md` (after /setup-styling) |

---

## License

MIT
