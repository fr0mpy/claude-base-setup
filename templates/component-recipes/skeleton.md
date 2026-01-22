# Skeleton Component Recipe

## Structure
- Placeholder shapes that mimic content layout
- Subtle animation (pulse or shimmer)
- Various preset shapes (text, circle, rectangle)
- Composable for complex layouts

## Tailwind Classes

### Base
```
animate-pulse rounded-md bg-muted
```

### Shapes
```
text:      h-4 w-full rounded
heading:   h-6 w-3/4 rounded
paragraph: h-4 w-full rounded (multiple with varying widths)
circle:    rounded-full aspect-square
rectangle: rounded-md
avatar:    h-10 w-10 rounded-full
button:    h-10 w-24 rounded-lg
card:      h-48 w-full rounded-lg
image:     aspect-video w-full rounded-lg
```

### Animation Variants
```
pulse:   animate-pulse (default, uses opacity)
shimmer: animate-shimmer (gradient sweep)

@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

shimmer class:
  bg-gradient-to-r from-muted via-muted/50 to-muted
  bg-[length:200%_100%] animate-shimmer
```

### Sizes
```
sm: Scale down by 75%
md: Default size
lg: Scale up by 125%
```

## Props Interface
```typescript
interface SkeletonProps {
  className?: string
  variant?: 'pulse' | 'shimmer'
}

interface SkeletonTextProps extends SkeletonProps {
  lines?: number
}

interface SkeletonAvatarProps extends SkeletonProps {
  size?: 'sm' | 'md' | 'lg'
}

interface SkeletonCardProps extends SkeletonProps {
  hasImage?: boolean
  hasTitle?: boolean
  hasDescription?: boolean
}
```

## Do
- Match skeleton shapes to actual content layout
- Use consistent animation across page
- Provide presets for common patterns
- Keep animations subtle (not distracting)

## Don't
- Hardcode colors
- Use jarring animations
- Show skeleton indefinitely (add timeout)
- Mix different animation styles

## Example
```tsx
import { cn } from '@/lib/utils'

const Skeleton = ({ className, ...props }) => (
  <div
    className={cn('animate-pulse rounded-md bg-muted', className)}
    {...props}
  />
)

// Shimmer variant
const SkeletonShimmer = ({ className, ...props }) => (
  <div
    className={cn(
      'rounded-md bg-gradient-to-r from-muted via-muted/50 to-muted',
      'bg-[length:200%_100%] animate-shimmer',
      className
    )}
    {...props}
  />
)

// Text skeleton (multiple lines)
const SkeletonText = ({ lines = 3, className }) => (
  <div className={cn('space-y-2', className)}>
    {Array.from({ length: lines }).map((_, i) => (
      <Skeleton
        key={i}
        className={cn(
          'h-4',
          i === lines - 1 ? 'w-4/5' : 'w-full' // Last line shorter
        )}
      />
    ))}
  </div>
)

// Avatar skeleton
const SkeletonAvatar = ({ size = 'md', className }) => {
  const sizes = {
    sm: 'h-8 w-8',
    md: 'h-10 w-10',
    lg: 'h-12 w-12',
  }
  return <Skeleton className={cn('rounded-full', sizes[size], className)} />
}

// Card skeleton
const SkeletonCard = ({ hasImage = true, className }) => (
  <div className={cn('rounded-lg border border-border p-4 space-y-4', className)}>
    {hasImage && <Skeleton className="aspect-video w-full rounded-lg" />}
    <div className="space-y-2">
      <Skeleton className="h-5 w-2/3" />
      <Skeleton className="h-4 w-full" />
      <Skeleton className="h-4 w-4/5" />
    </div>
  </div>
)

// Table row skeleton
const SkeletonTableRow = ({ columns = 4 }) => (
  <div className="flex items-center space-x-4 py-3">
    {Array.from({ length: columns }).map((_, i) => (
      <Skeleton
        key={i}
        className={cn(
          'h-4',
          i === 0 ? 'w-8' : 'flex-1'
        )}
      />
    ))}
  </div>
)

// Full page skeleton (dashboard example)
const SkeletonDashboard = () => (
  <div className="space-y-6 p-6">
    {/* Header */}
    <div className="flex items-center justify-between">
      <Skeleton className="h-8 w-48" />
      <Skeleton className="h-10 w-32" />
    </div>

    {/* Stats row */}
    <div className="grid grid-cols-4 gap-4">
      {Array.from({ length: 4 }).map((_, i) => (
        <div key={i} className="rounded-lg border border-border p-4 space-y-2">
          <Skeleton className="h-4 w-20" />
          <Skeleton className="h-8 w-16" />
        </div>
      ))}
    </div>

    {/* Content area */}
    <div className="grid grid-cols-2 gap-6">
      <SkeletonCard />
      <SkeletonCard />
    </div>
  </div>
)
```
