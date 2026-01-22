# Avatar Component Recipe

## Structure
- Circular container for image or fallback
- Support image, initials fallback, or icon fallback
- Multiple sizes
- Optional status indicator (online/offline)
- Avatar group for stacking

## Tailwind Classes

### Container
```
relative flex shrink-0 overflow-hidden rounded-full
```

### Sizes
```
xs: h-6 w-6 text-xs
sm: h-8 w-8 text-xs
md: h-10 w-10 text-sm (default)
lg: h-12 w-12 text-base
xl: h-16 w-16 text-lg
2xl: h-24 w-24 text-xl
```

### Image
```
aspect-square h-full w-full object-cover
```

### Fallback (initials or icon)
```
flex h-full w-full items-center justify-center rounded-full
bg-muted text-muted-foreground font-medium
```

### Status Indicator
```
absolute bottom-0 right-0 h-3 w-3 rounded-full border-2 border-background
online:  bg-green-500
offline: bg-gray-400
busy:    bg-red-500
away:    bg-yellow-500
```

### Avatar Group
```
flex -space-x-2
[&>*]:ring-2 [&>*]:ring-background
```

## Props Interface
```typescript
interface AvatarProps {
  src?: string
  alt?: string
  fallback?: string | React.ReactNode
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl'
  status?: 'online' | 'offline' | 'busy' | 'away'
}

interface AvatarGroupProps {
  max?: number
  children: React.ReactNode
}
```

## Do
- Use Radix Avatar for image loading states
- Show fallback immediately while image loads
- Support both initials and icon fallbacks
- Use ring for avatar group overlap effect

## Don't
- Hardcode colors
- Forget alt text for images
- Use non-square aspect ratios
- Skip loading state handling

## Example
```tsx
import * as AvatarPrimitive from '@radix-ui/react-avatar'
import { cn } from '@/lib/utils'
import { User } from 'lucide-react'

const avatarSizes = {
  xs: 'h-6 w-6 text-xs',
  sm: 'h-8 w-8 text-xs',
  md: 'h-10 w-10 text-sm',
  lg: 'h-12 w-12 text-base',
  xl: 'h-16 w-16 text-lg',
  '2xl': 'h-24 w-24 text-xl',
}

const statusColors = {
  online: 'bg-green-500',
  offline: 'bg-gray-400',
  busy: 'bg-red-500',
  away: 'bg-yellow-500',
}

const Avatar = ({ src, alt, fallback, size = 'md', status, className }) => (
  <div className="relative inline-block">
    <AvatarPrimitive.Root
      className={cn(
        'relative flex shrink-0 overflow-hidden rounded-full',
        avatarSizes[size],
        className
      )}
    >
      <AvatarPrimitive.Image
        src={src}
        alt={alt}
        className="aspect-square h-full w-full object-cover"
      />
      <AvatarPrimitive.Fallback
        className="flex h-full w-full items-center justify-center rounded-full bg-muted text-muted-foreground font-medium"
      >
        {fallback || <User className="h-1/2 w-1/2" />}
      </AvatarPrimitive.Fallback>
    </AvatarPrimitive.Root>
    {status && (
      <span
        className={cn(
          'absolute bottom-0 right-0 h-3 w-3 rounded-full border-2 border-background',
          statusColors[status]
        )}
      />
    )}
  </div>
)

// Helper to get initials from name
const getInitials = (name: string) => {
  return name
    .split(' ')
    .map(n => n[0])
    .join('')
    .toUpperCase()
    .slice(0, 2)
}

// Avatar group for stacking
const AvatarGroup = ({ max = 4, children }) => {
  const avatars = React.Children.toArray(children)
  const shown = avatars.slice(0, max)
  const remaining = avatars.length - max

  return (
    <div className="flex -space-x-2">
      {shown.map((avatar, i) => (
        <div key={i} className="ring-2 ring-background rounded-full">
          {avatar}
        </div>
      ))}
      {remaining > 0 && (
        <div className="flex h-10 w-10 items-center justify-center rounded-full bg-muted text-muted-foreground text-sm font-medium ring-2 ring-background">
          +{remaining}
        </div>
      )}
    </div>
  )
}
```
