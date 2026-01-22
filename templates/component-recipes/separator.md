# Separator Component Recipe

## Structure
- Simple divider line
- Support horizontal and vertical orientations
- Decorative by default (not announced by screen readers)
- Optional label in center

## Tailwind Classes

### Base
```
shrink-0 bg-border
```

### Horizontal (default)
```
h-px w-full
```

### Vertical
```
h-full w-px
```

### With Label
```
Container: relative flex items-center
Line: flex-1 h-px bg-border
Label: mx-4 text-xs text-muted-foreground uppercase tracking-wider
```

### Spacing Variants
```
sm: my-2 (horizontal) / mx-2 (vertical)
md: my-4 (horizontal) / mx-4 (vertical)
lg: my-6 (horizontal) / mx-6 (vertical)
```

### Style Variants
```
solid:  bg-border (default)
dashed: border-t border-dashed border-border bg-transparent h-0
dotted: border-t border-dotted border-border bg-transparent h-0
```

## Props Interface
```typescript
interface SeparatorProps {
  orientation?: 'horizontal' | 'vertical'
  decorative?: boolean
  className?: string
}

interface SeparatorWithLabelProps extends SeparatorProps {
  label: string
}
```

## Do
- Use Radix Separator for semantic correctness
- Set decorative={true} for visual-only separators
- Use consistent spacing in lists/groups
- Support both orientations

## Don't
- Hardcode colors
- Use <hr> without proper styling
- Forget to set decorative prop appropriately
- Over-use separators (whitespace often suffices)

## Example
```tsx
import * as SeparatorPrimitive from '@radix-ui/react-separator'
import { cn } from '@/lib/utils'

const Separator = ({
  className,
  orientation = 'horizontal',
  decorative = true,
  ...props
}) => (
  <SeparatorPrimitive.Root
    decorative={decorative}
    orientation={orientation}
    className={cn(
      'shrink-0 bg-border',
      orientation === 'horizontal' ? 'h-px w-full' : 'h-full w-px',
      className
    )}
    {...props}
  />
)

// With label
const SeparatorWithLabel = ({ label, className, ...props }) => (
  <div className={cn('relative flex items-center', className)} {...props}>
    <div className="flex-1 h-px bg-border" />
    <span className="mx-4 text-xs text-muted-foreground uppercase tracking-wider">
      {label}
    </span>
    <div className="flex-1 h-px bg-border" />
  </div>
)

// Usage examples
<div className="space-y-4">
  <div>Content above</div>
  <Separator />
  <div>Content below</div>
</div>

// Vertical in flex container
<div className="flex h-5 items-center space-x-4 text-sm">
  <div>Blog</div>
  <Separator orientation="vertical" />
  <div>Docs</div>
  <Separator orientation="vertical" />
  <div>Source</div>
</div>

// With label
<SeparatorWithLabel label="Or continue with" />
```
