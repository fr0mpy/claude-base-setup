# claude-base-setup

A reusable `.claude` configuration for Claude Code projects with smart context injection, rules, agents, slash commands, and a **component styling system** for consistent UI generation.

## Table of Contents

- [Installation](#installation)
- [CLI Options](#cli-options)
- [How It Works](#how-it-works)
- [Rules](#rules)
- [Agents](#agents)
  - [Core Agents](#core-agents)
  - [Planning & Requirements](#planning--requirements)
  - [Code Quality](#code-quality)
  - [Workflow](#workflow)
  - [Session Management](#session-management)
  - [Domain-Specific](#domain-specific)
  - [Thinking Partners](#thinking-partners)
- [Commands](#commands)
- [Styling System](#styling-system)
  - [Overview](#overview)
  - [Quick Start](#quick-start)
  - [Component Recipes](#component-recipes)
  - [Visual Harness](#visual-harness)
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
| `commands/` | Slash commands (/review, /test, /commit) |
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

## How It Works

| Trigger | Action |
|---------|--------|
| **On every prompt** | Analyzes your input and injects relevant rules |
| **On session start** | Checks if project context is fresh, suggests refresh if stale |
| **Before creating code** | Suggests running `pre-code-check` agent to avoid duplicates |
| **Before installing packages** | Suggests running `package-checker` for version compatibility |

---

## Rules

| Rule | Trigger | Description |
|------|---------|-------------|
| code-standards | code keywords | No hardcoding, dynamic discovery |
| announce-actions | always | Announce actions, track agent usage |
| rule-format | "rule" keywords | How to create rules |
| subagent-format | "agent" keywords | How to create agents |
| command-format | "command" keywords | How to create slash commands |
| styling-system | styling/UI keywords | Enforces component recipes and design tokens |

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
| styling-auditor | Audits code against your style system |

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
| /review | Review current changes for issues |
| /test | Run tests and fix failures |
| /commit | Stage and commit changes |
| /setup-styling | Interactive style interview to define your UI aesthetic |
| /harness | Launch visual component preview gallery |
| /audit-styling | Audit codebase for styling violations |

---

## Styling System

### Overview

The styling system solves a common problem: **LLM-generated UIs are boring and samey**. Tools like Builder.io, Figma, and Lovable impose their own design language. This system lets you define YOUR aesthetic and have Claude consistently apply it.

**The system has three parts:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     YOUR UNIQUE AESTHETIC                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   1. Style Interview        2. Component Recipes    3. Harness  │
│   (/setup-styling)          (36 components)         (/harness)  │
│                                                                  │
│   ┌──────────────┐         ┌──────────────┐      ┌───────────┐  │
│   │ Colors?      │         │ button.md    │      │  ← [□] → │  │
│   │ Corners?     │   →     │ card.md      │  →   │  Preview  │  │
│   │ Shadows?     │         │ input.md     │      │  Gallery  │  │
│   │ Typography?  │         │ ...36 total  │      │           │  │
│   └──────────────┘         └──────────────┘      └───────────┘  │
│                                                                  │
│   Generates config          Claude follows         Iterate      │
│   + recipes                 these recipes          visually     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Quick Start

```bash
# 1. Run the style interview
/setup-styling

# 2. Answer questions about your aesthetic:
#    - Overall feel (minimal, bold, playful, enterprise)
#    - Colors (your brand colors or presets)
#    - Typography (sans, serif, mono)
#    - Corners (sharp, subtle, rounded, pill)
#    - Shadows (flat, subtle, pronounced)

# 3. Preview your components
/harness

# 4. Iterate ("make buttons more rounded", "darker shadows")
# 5. Audit existing code
/audit-styling
```

### Component Recipes

After setup, Claude generates `.claude/component-recipes/` with styling rules for each component. These are **prompting templates** that tell Claude exactly how to build components matching YOUR aesthetic.

**36 Component Recipes Included:**

<details>
<summary><strong>Form Components (10)</strong></summary>

| Recipe | Description |
|--------|-------------|
| [button.md](templates/component-recipes/button.md) | Buttons with variants (primary, secondary, outline, ghost) |
| [input.md](templates/component-recipes/input.md) | Text inputs with icons, errors, sizes |
| [textarea.md](templates/component-recipes/textarea.md) | Multi-line inputs with auto-resize, character count |
| [select.md](templates/component-recipes/select.md) | Native-style dropdowns |
| [combobox.md](templates/component-recipes/combobox.md) | Searchable select with filtering |
| [checkbox.md](templates/component-recipes/checkbox.md) | Checkboxes with indeterminate state |
| [radio.md](templates/component-recipes/radio.md) | Radio groups |
| [switch.md](templates/component-recipes/switch.md) | Toggle switches |
| [slider.md](templates/component-recipes/slider.md) | Range sliders with marks |
| [label.md](templates/component-recipes/label.md) | Form labels with required/optional indicators |

</details>

<details>
<summary><strong>Layout Components (6)</strong></summary>

| Recipe | Description |
|--------|-------------|
| [card.md](templates/component-recipes/card.md) | Content containers with header/footer |
| [separator.md](templates/component-recipes/separator.md) | Horizontal/vertical dividers |
| [collapsible.md](templates/component-recipes/collapsible.md) | Expandable sections |
| [accordion.md](templates/component-recipes/accordion.md) | Multiple collapsible sections |
| [tabs.md](templates/component-recipes/tabs.md) | Tab navigation |
| [table.md](templates/component-recipes/table.md) | Data tables with sorting |

</details>

<details>
<summary><strong>Navigation Components (5)</strong></summary>

| Recipe | Description |
|--------|-------------|
| [navigation-menu.md](templates/component-recipes/navigation-menu.md) | Header nav with mega-menu dropdowns |
| [breadcrumb.md](templates/component-recipes/breadcrumb.md) | Page hierarchy navigation |
| [pagination.md](templates/component-recipes/pagination.md) | Page number navigation |
| [dropdown-menu.md](templates/component-recipes/dropdown-menu.md) | Action menus |
| [context-menu.md](templates/component-recipes/context-menu.md) | Right-click menus |

</details>

<details>
<summary><strong>Overlay Components (6)</strong></summary>

| Recipe | Description |
|--------|-------------|
| [modal.md](templates/component-recipes/modal.md) | Dialogs/modals |
| [dialog.md](templates/component-recipes/dialog.md) | Confirmation dialogs |
| [drawer.md](templates/component-recipes/drawer.md) | Slide-out panels (left/right/top/bottom) |
| [popover.md](templates/component-recipes/popover.md) | Floating content on click |
| [hover-card.md](templates/component-recipes/hover-card.md) | Preview cards on hover |
| [tooltip.md](templates/component-recipes/tooltip.md) | Hint text on hover |

</details>

<details>
<summary><strong>Feedback Components (5)</strong></summary>

| Recipe | Description |
|--------|-------------|
| [alert.md](templates/component-recipes/alert.md) | Status messages (info, success, warning, error) |
| [toast.md](templates/component-recipes/toast.md) | Temporary notifications |
| [progress.md](templates/component-recipes/progress.md) | Progress bars |
| [skeleton.md](templates/component-recipes/skeleton.md) | Loading placeholders |
| [spinner.md](templates/component-recipes/spinner.md) | Loading spinners |

</details>

<details>
<summary><strong>Display Components (4)</strong></summary>

| Recipe | Description |
|--------|-------------|
| [badge.md](templates/component-recipes/badge.md) | Status badges and tags |
| [avatar.md](templates/component-recipes/avatar.md) | User avatars with fallbacks |
| [carousel.md](templates/component-recipes/carousel.md) | Image/content sliders |
| [toggle-group.md](templates/component-recipes/toggle-group.md) | Grouped toggle buttons |

</details>

**Each recipe contains:**

```markdown
# Button Component Recipe

## Structure
- What elements to use, variants, states

## Tailwind Classes
- Exact classes for base, variants, sizes
- Uses {tokens.radius}, {tokens.colors} from your config

## Props Interface
- TypeScript interface for the component

## Do / Don't
- Best practices specific to this component

## Example
- Complete implementation code
```

### Visual Harness

The harness is a live preview gallery where you can see and iterate on your components:

```
┌────────────────────────────────────────────────────────┐
│  ←  Button (primary)  →            [Request Change]   │
├────────────────────────────────────────────────────────┤
│                                                        │
│              ┌─────────────────┐                       │
│              │   Click me      │                       │
│              └─────────────────┘                       │
│                                                        │
│              ┌─────────────────┐                       │
│              │   Secondary     │                       │
│              └─────────────────┘                       │
│                                                        │
│              ┌─────────────────┐                       │
│              │   Outline       │                       │
│              └─────────────────┘                       │
│                                                        │
└────────────────────────────────────────────────────────┘
```

- **Navigate** with ← → chevrons to cycle through components
- **Request changes** like "make it more rounded" or "add more shadow"
- **Watch updates** in real-time with hot module replacement

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
