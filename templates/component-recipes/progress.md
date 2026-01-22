# Progress Component Recipe

## Structure
- Track container with filled indicator
- Support determinate (percentage) and indeterminate (loading)
- Optional label and value display
- Circular variant option

## Tailwind Classes

### Linear Progress

#### Root/Track
```
relative h-2 w-full overflow-hidden rounded-full bg-muted
```

#### Indicator (filled)
```
h-full w-full flex-1 bg-primary transition-all
```

#### Indeterminate Animation
```
animate-progress-indeterminate
@keyframes progress-indeterminate {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}
```

### Sizes
```
sm: h-1
md: h-2 (default)
lg: h-3
xl: h-4
```

### Variants
```
default:     bg-primary
success:     bg-green-500
warning:     bg-yellow-500
destructive: bg-destructive
```

### With Label
```
Container: space-y-2
Label row: flex justify-between text-sm
Label: text-muted-foreground
Value: font-medium
```

### Circular Progress
```
Container: relative inline-flex
SVG: -rotate-90 transform
Track circle: stroke-muted
Indicator circle: stroke-primary transition-all
  stroke-dasharray: circumference
  stroke-dashoffset: circumference - (value/100 * circumference)
```

## Props Interface
```typescript
interface ProgressProps {
  value?: number // 0-100, undefined = indeterminate
  max?: number
  variant?: 'default' | 'success' | 'warning' | 'destructive'
  size?: 'sm' | 'md' | 'lg' | 'xl'
  showValue?: boolean
  label?: string
}

interface CircularProgressProps extends ProgressProps {
  strokeWidth?: number
  diameter?: number
}
```

## Do
- Use Radix Progress for accessibility
- Support both determinate and indeterminate states
- Include aria-valuenow, aria-valuemin, aria-valuemax
- Animate smoothly between values

## Don't
- Hardcode colors
- Forget accessibility attributes
- Use jerky animations
- Skip indeterminate state support

## Example
```tsx
import * as ProgressPrimitive from '@radix-ui/react-progress'
import { cn } from '@/lib/utils'

const progressVariants = {
  default: 'bg-primary',
  success: 'bg-green-500',
  warning: 'bg-yellow-500',
  destructive: 'bg-destructive',
}

const progressSizes = {
  sm: 'h-1',
  md: 'h-2',
  lg: 'h-3',
  xl: 'h-4',
}

const Progress = ({
  value,
  variant = 'default',
  size = 'md',
  className,
  ...props
}) => (
  <ProgressPrimitive.Root
    className={cn(
      'relative w-full overflow-hidden rounded-full bg-muted',
      progressSizes[size],
      className
    )}
    {...props}
  >
    <ProgressPrimitive.Indicator
      className={cn(
        'h-full w-full flex-1 transition-all',
        progressVariants[variant],
        value === undefined && 'animate-progress-indeterminate'
      )}
      style={{ transform: value !== undefined ? `translateX(-${100 - value}%)` : undefined }}
    />
  </ProgressPrimitive.Root>
)

// With label and value
const ProgressWithLabel = ({ label, value, ...props }) => (
  <div className="space-y-2">
    <div className="flex justify-between text-sm">
      <span className="text-muted-foreground">{label}</span>
      <span className="font-medium">{value}%</span>
    </div>
    <Progress value={value} {...props} />
  </div>
)

// Circular progress
const CircularProgress = ({ value, size = 40, strokeWidth = 4 }) => {
  const radius = (size - strokeWidth) / 2
  const circumference = radius * 2 * Math.PI
  const offset = value !== undefined
    ? circumference - (value / 100) * circumference
    : 0

  return (
    <svg width={size} height={size} className="-rotate-90 transform">
      <circle
        cx={size / 2}
        cy={size / 2}
        r={radius}
        fill="none"
        stroke="currentColor"
        strokeWidth={strokeWidth}
        className="text-muted"
      />
      <circle
        cx={size / 2}
        cy={size / 2}
        r={radius}
        fill="none"
        stroke="currentColor"
        strokeWidth={strokeWidth}
        strokeDasharray={circumference}
        strokeDashoffset={offset}
        strokeLinecap="round"
        className="text-primary transition-all"
      />
    </svg>
  )
}
```
