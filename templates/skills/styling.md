# Styling System

Apply this skill when generating, modifying, or reviewing UI components.

## When to Apply

- Creating new UI components (buttons, cards, inputs, modals, etc.)
- Modifying existing component styles
- Reviewing code for styling consistency
- User asks about design tokens or component patterns

## Configuration Loading

Before generating any UI code:

1. **Check for config** at `.claude/styling-config.json`
2. **Check for recipes** in `.claude/component-recipes/`
3. If neither exists, suggest running `/setup-styling` to configure the design system

## Token Usage

When `.claude/styling-config.json` exists, use semantic tokens instead of hardcoded values:

| Instead of | Use |
|------------|-----|
| `bg-blue-500` | `bg-primary` |
| `#3b82f6` | Token from config |
| `rounded-lg` (assumed) | `{tokens.radius}` from config |
| `shadow-md` (assumed) | `{tokens.shadow}` from config |

### Token Reference

```
tokens.colors.primary         → bg-primary, text-primary, border-primary
tokens.colors.secondary       → bg-secondary, text-secondary
tokens.colors.destructive     → bg-destructive, text-destructive
tokens.colors.muted           → bg-muted, text-muted-foreground
tokens.colors.surface         → bg-surface (cards, panels)
tokens.colors.background      → bg-background (page)
tokens.colors.foreground      → text-foreground
tokens.colors.border          → border-border
tokens.radius                 → border radius class
tokens.shadow                 → shadow class
tokens.spacing.tight/normal/loose → padding values
tokens.typography.family      → font family class
```

## Recipe Compliance

If a recipe exists in `.claude/component-recipes/[component].md`:

1. Read the recipe first
2. Follow the defined structure
3. Use the exact variants specified
4. Apply the Tailwind classes from the recipe
5. Include all required states (hover, focus, disabled)

## Component Generation Checklist

Before delivering any UI component:

- [ ] Loaded styling config (if exists)
- [ ] Checked for component recipe (if exists)
- [ ] Using token-based colors (not hardcoded)
- [ ] Radius matches config personality
- [ ] Shadow matches config personality
- [ ] Spacing matches config density
- [ ] All interactive states included
- [ ] Accessible (focus-visible, aria labels where needed)

## Auditing (when asked to review/audit)

Scan UI files for violations:

### Critical Violations
- Hardcoded hex colors (`#[0-9a-fA-F]{3,8}`)
- Hardcoded rgb/rgba values
- Inline styles with color/spacing values
- Non-semantic Tailwind colors (`bg-blue-500` instead of `bg-primary`)

### Warnings
- Inconsistent border radius across components
- Inconsistent shadow depth
- Spacing that doesn't match density setting

### Audit Output Format

```
Styling Audit Report
====================
Configuration: [loaded | not found]
Files scanned: [count]

CRITICAL:
- file.tsx:24 → Hardcoded `#3b82f6` → Use `bg-primary`

WARNINGS:
- file.tsx:12 → `rounded-xl` but config is `rounded-lg`

Compliance: [X]%
```

## Fallback Behavior

If no styling config exists:
- Use sensible defaults: `rounded-md`, `shadow-sm`, system font
- Warn about inconsistency risk
- Suggest: "Run `/setup-styling` to define your project's design tokens"
