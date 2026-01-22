# Spinner Component Recipe

## Structure
- Animated loading indicator
- SVG-based for crisp rendering
- Support for multiple sizes
- Optional label text
- Accessible with aria-label

## Tailwind Classes

### Base
```
animate-spin text-primary
```

### SVG Structure
```
<svg className="animate-spin" viewBox="0 0 24 24" fill="none">
  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
</svg>
```

### Sizes
```
xs: h-3 w-3
sm: h-4 w-4
md: h-6 w-6 (default)
lg: h-8 w-8
xl: h-12 w-12
```

### With Label
```
Container: inline-flex items-center gap-2
Label: text-sm text-muted-foreground
```

### Overlay Spinner
```
Container: fixed inset-0 z-50 flex items-center justify-center bg-background/80 backdrop-blur-sm
```

### Button Spinner (inline)
```
mr-2 h-4 w-4 animate-spin
```

### Colors
```
default: text-primary
muted: text-muted-foreground
white: text-white
current: text-current (inherits)
```

## Props Interface
```typescript
interface SpinnerProps {
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
  color?: 'default' | 'muted' | 'white' | 'current'
  className?: string
  label?: string
  'aria-label'?: string
}

interface LoadingOverlayProps {
  visible: boolean
  label?: string
  blur?: boolean
}
```

## Do
- Always include aria-label for screen readers
- Use currentColor for flexible coloring
- Match spinner size to context (button, page, etc.)
- Consider reduced motion preferences

## Don't
- Hardcode colors
- Use CSS-only spinners (less control)
- Forget loading state announcements
- Make spinners too large or distracting

## Example
```tsx
import { cn } from '@/lib/utils'

const spinnerSizes = {
  xs: 'h-3 w-3',
  sm: 'h-4 w-4',
  md: 'h-6 w-6',
  lg: 'h-8 w-8',
  xl: 'h-12 w-12',
}

const spinnerColors = {
  default: 'text-primary',
  muted: 'text-muted-foreground',
  white: 'text-white',
  current: 'text-current',
}

const Spinner = ({
  size = 'md',
  color = 'default',
  className,
  label,
  'aria-label': ariaLabel = 'Loading',
}: SpinnerProps) => {
  const spinner = (
    <svg
      className={cn(
        'animate-spin',
        spinnerSizes[size],
        spinnerColors[color],
        className
      )}
      viewBox="0 0 24 24"
      fill="none"
      aria-label={ariaLabel}
      role="status"
    >
      <circle
        className="opacity-25"
        cx="12"
        cy="12"
        r="10"
        stroke="currentColor"
        strokeWidth="4"
      />
      <path
        className="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      />
    </svg>
  )

  if (label) {
    return (
      <div className="inline-flex items-center gap-2">
        {spinner}
        <span className="text-sm text-muted-foreground">{label}</span>
      </div>
    )
  }

  return spinner
}

// Dots variant spinner
const DotsSpinner = ({ size = 'md', className }: SpinnerProps) => (
  <div className={cn('flex items-center gap-1', className)}>
    {[0, 1, 2].map((i) => (
      <div
        key={i}
        className={cn(
          'rounded-full bg-primary animate-bounce',
          size === 'sm' ? 'h-1.5 w-1.5' : 'h-2 w-2'
        )}
        style={{ animationDelay: `${i * 0.1}s` }}
      />
    ))}
  </div>
)

// Loading overlay
const LoadingOverlay = ({
  visible,
  label = 'Loading...',
  blur = true,
}: LoadingOverlayProps) => {
  if (!visible) return null

  return (
    <div
      className={cn(
        'fixed inset-0 z-50 flex flex-col items-center justify-center',
        'bg-background/80',
        blur && 'backdrop-blur-sm'
      )}
    >
      <Spinner size="xl" />
      {label && (
        <p className="mt-4 text-sm text-muted-foreground">{label}</p>
      )}
    </div>
  )
}

// Button with loading state
const LoadingButton = ({ loading, children, ...props }) => (
  <Button disabled={loading} {...props}>
    {loading && <Spinner size="sm" color="current" className="mr-2" />}
    {children}
  </Button>
)

// Usage examples
<Spinner />
<Spinner size="lg" color="muted" />
<Spinner size="sm" label="Loading data..." />
<DotsSpinner />
<LoadingOverlay visible={isLoading} label="Saving changes..." />

<LoadingButton loading={isSubmitting}>
  {isSubmitting ? 'Saving...' : 'Save'}
</LoadingButton>
```

## Reduced Motion Support
```css
@media (prefers-reduced-motion: reduce) {
  .animate-spin {
    animation: none;
    opacity: 0.5;
  }
  .animate-bounce {
    animation: none;
  }
}
```
