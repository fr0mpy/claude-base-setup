# Badge Component Recipe

## Structure
- Inline `<span>` or `<div>` element
- Support variants for different contexts
- Optional icon or close button
- Compact sizing

## Tailwind Classes

### Base
```
inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium
transition-colors
```

### Variants
```
default:     bg-primary text-primary-foreground
secondary:   bg-secondary text-secondary-foreground
outline:     border border-border text-foreground bg-transparent
destructive: bg-destructive text-destructive-foreground
success:     bg-green-500/10 text-green-600 border border-green-500/20
warning:     bg-yellow-500/10 text-yellow-600 border border-yellow-500/20
```

### Sizes
```
sm: px-2 py-0.5 text-xs
md: px-2.5 py-0.5 text-xs (default)
lg: px-3 py-1 text-sm
```

### With Icon
```
gap-1
Icon: h-3 w-3
```

### With Close Button
```
pr-1
Close button: ml-1 h-3 w-3 hover:bg-black/10 rounded-full
```

### Interactive (clickable)
```
cursor-pointer hover:opacity-80
```

## Props Interface
```typescript
interface BadgeProps {
  variant?: 'default' | 'secondary' | 'outline' | 'destructive' | 'success' | 'warning'
  size?: 'sm' | 'md' | 'lg'
  icon?: React.ReactNode
  onClose?: () => void
  children: React.ReactNode
}
```

## Do
- Use `rounded-full` for pill shape (or `{tokens.radius}` for consistency)
- Keep text short (1-2 words typically)
- Use semantic variants (success, warning, destructive)
- Support icon placement

## Don't
- Make badges too large
- Use for long text content
- Hardcode colors
- Forget hover state for interactive badges

## Example
```tsx
import { cn } from '@/lib/utils'
import { X } from 'lucide-react'

const badgeVariants = {
  default: 'bg-primary text-primary-foreground',
  secondary: 'bg-secondary text-secondary-foreground',
  outline: 'border border-border text-foreground bg-transparent',
  destructive: 'bg-destructive text-destructive-foreground',
  success: 'bg-green-500/10 text-green-600 border border-green-500/20',
  warning: 'bg-yellow-500/10 text-yellow-600 border border-yellow-500/20',
}

const badgeSizes = {
  sm: 'px-2 py-0.5 text-xs',
  md: 'px-2.5 py-0.5 text-xs',
  lg: 'px-3 py-1 text-sm',
}

const Badge = ({
  variant = 'default',
  size = 'md',
  icon,
  onClose,
  className,
  children,
  ...props
}) => (
  <span
    className={cn(
      'inline-flex items-center rounded-full font-medium transition-colors',
      badgeVariants[variant],
      badgeSizes[size],
      icon && 'gap-1',
      onClose && 'pr-1',
      className
    )}
    {...props}
  >
    {icon && <span className="h-3 w-3">{icon}</span>}
    {children}
    {onClose && (
      <button
        onClick={onClose}
        className="ml-1 rounded-full p-0.5 hover:bg-black/10"
      >
        <X className="h-3 w-3" />
      </button>
    )}
  </span>
)
```
