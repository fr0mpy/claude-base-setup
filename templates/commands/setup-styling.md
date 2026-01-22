Define your unique UI aesthetic for consistent component generation.

This command creates a personalized styling system. Once configured, the `styling` skill will automatically apply these tokens and recipes when generating UI components.

## Workflow

1. **Check for existing tokens** - Look for `tailwind.config.*` or existing `.claude/styling-config.json`
2. **Ask aesthetic questions** using AskUserQuestion tool:

   **Q1: Import existing?**
   - If `tailwind.config.*` found: "Found tailwind config. Import colors/spacing from it?"
   - Options: [Yes, import] [No, start fresh]

   **Q2: Overall aesthetic feel**
   - Options: [Minimal - clean, lots of whitespace] [Bold - strong colors, high contrast] [Playful - rounded, colorful, fun] [Enterprise - professional, structured] [Custom - I'll describe it]

   **Q3: Color philosophy**
   - Options: [Monochrome - shades of one color] [Vibrant - bright, saturated colors] [Muted pastels - soft, calm colors] [Earth tones - natural, warm colors] [Custom - I'll provide hex values]
   - If Custom: Ask for primary, secondary, background, surface, text colors

   **Q4: Typography**
   - Options: [Modern sans (Inter/system)] [Classic serif] [Monospace/technical] [Custom font family]

   **Q5: Component personality**
   - Corners: [Sharp (rounded-none)] [Subtle (rounded-sm)] [Rounded (rounded-lg)] [Pill (rounded-full)]
   - Shadows: [Flat (no shadows)] [Subtle (shadow-sm)] [Pronounced (shadow-lg)] [Glassmorphism]
   - Density: [Compact (tight spacing)] [Comfortable (normal)] [Spacious (generous padding)]

3. **Generate `.claude/styling-config.json`** with structure:
```json
{
  "aesthetic": "minimal",
  "tokens": {
    "colors": {
      "primary": "#0066FF",
      "primary-foreground": "#FFFFFF",
      "secondary": "#6C5CE7",
      "secondary-foreground": "#FFFFFF",
      "background": "#FFFFFF",
      "foreground": "#1A1A1A",
      "surface": "#F5F5F5",
      "muted": "#6B7280",
      "muted-foreground": "#9CA3AF",
      "border": "#E5E7EB",
      "destructive": "#EF4444",
      "destructive-foreground": "#FFFFFF"
    },
    "radius": "rounded-lg",
    "shadow": "shadow-sm",
    "spacing": {
      "tight": "2",
      "normal": "4",
      "loose": "6"
    },
    "typography": {
      "family": "font-sans",
      "heading": "font-semibold tracking-tight",
      "body": "font-normal"
    }
  },
  "personality": {
    "corners": "rounded",
    "depth": "subtle-shadows",
    "density": "comfortable"
  }
}
```

4. **Generate `.claude/component-recipes/`** directory with recipes for each component type:
   - button.md, card.md, input.md, modal.md, select.md
   - checkbox.md, radio.md, badge.md, alert.md, avatar.md
   - tooltip.md, table.md, tabs.md, accordion.md, dialog.md, toast.md

   Each recipe should reference `{tokens.*}` from the config and follow the aesthetic choices.

5. **Ask about component-harness**: "Want me to scaffold the visual component-harness for previewing?"

## Recipe Template

When generating each recipe, follow this structure:
```markdown
# [Component] Component Recipe

## Structure
- HTML element to use
- Supported variants
- Supported sizes
- Required states (loading, disabled, etc.)

## Tailwind Classes
- Base: [base classes that apply to all variants]
- [Variant]: [classes for this variant using {tokens.*} references]
- Sizes: [size-specific classes]
- States: [hover, focus, disabled classes]

## Props Interface
- variant: [list of variants]
- size: [list of sizes]
- [other props]

## Do
- [best practices]

## Don't
- [anti-patterns]

## Example
[code example]
```

$ARGUMENTS
