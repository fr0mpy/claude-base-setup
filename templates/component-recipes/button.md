# Button Component Recipe

## Structure
- Use `<button>` element with `type` attribute (default: "button")
- Support variants: primary, secondary, outline, ghost, destructive
- Support sizes: sm, md, lg
- Include states: loading, disabled
- Optionally support `asChild` for composition (render as link, etc.)

## Tailwind Classes

### Base
```
inline-flex items-center justify-center gap-2 font-medium transition-colors
focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2
disabled:pointer-events-none disabled:opacity-50
```

### Variants
```
primary:     bg-primary text-primary-foreground hover:bg-primary/90 focus-visible:ring-primary
secondary:   bg-secondary text-secondary-foreground hover:bg-secondary/90 focus-visible:ring-secondary
outline:     border border-border bg-transparent hover:bg-surface focus-visible:ring-primary
ghost:       bg-transparent hover:bg-surface focus-visible:ring-primary
destructive: bg-destructive text-destructive-foreground hover:bg-destructive/90 focus-visible:ring-destructive
```

### Sizes
```
sm: h-8 px-3 text-sm {tokens.radius}
md: h-10 px-4 text-sm {tokens.radius}
lg: h-12 px-6 text-base {tokens.radius}
```

### States
```
loading: relative [&>*]:invisible
         Add spinner overlay with absolute positioning
disabled: opacity-50 cursor-not-allowed
```

## Props Interface
```typescript
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'destructive'
  size?: 'sm' | 'md' | 'lg'
  loading?: boolean
  disabled?: boolean
  asChild?: boolean
  children: React.ReactNode
}
```

## Do
- Use `cn()` utility for class merging
- Include `focus-visible` ring for accessibility
- Support icon-only buttons (square aspect ratio)
- Use semantic color tokens from config

## Don't
- Hardcode colors (use `bg-primary` not `bg-blue-500`)
- Forget hover states
- Skip focus indicators
- Use inline styles

## Example
```tsx
import { cn } from '@/lib/utils'

const Button = ({ variant = 'primary', size = 'md', loading, disabled, className, children, ...props }) => {
  return (
    <button
      className={cn(
        'inline-flex items-center justify-center gap-2 font-medium transition-colors',
        'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2',
        'disabled:pointer-events-none disabled:opacity-50',
        variants[variant],
        sizes[size],
        loading && 'relative [&>*]:invisible',
        className
      )}
      disabled={disabled || loading}
      {...props}
    >
      {loading && <Spinner className="absolute" />}
      {children}
    </button>
  )
}
```
