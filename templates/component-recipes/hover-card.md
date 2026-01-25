# Hover Card Component Recipe

## Structure
- Trigger element (usually a link or button)
- Floating card that appears on hover
- Arrow pointing to trigger
- Rich content support (images, text, actions)
- Delay before showing/hiding

## Tailwind Classes

### Content
```
z-50 w-64 {tokens.radius} border border-border bg-background p-4 text-foreground {tokens.shadow}
outline-none
data-open:animate-in data-closed:animate-out
data-closed:fade-out-0 data-open:fade-in-0
data-closed:zoom-out-95 data-open:zoom-in-95
data-[side=bottom]:slide-in-from-top-2
data-[side=left]:slide-in-from-right-2
data-[side=right]:slide-in-from-left-2
data-[side=top]:slide-in-from-bottom-2
```

### Arrow
```
fill-background
```

### Arrow with Border
```
fill-background stroke-border
```

### User Card Layout
```
Container: flex flex-col gap-4
Avatar section: flex items-center gap-4
Info section: space-y-1
Stats section: flex gap-4 pt-2
```

### Link Preview Layout
```
Container: space-y-3
Image: aspect-video w-full rounded-md object-cover
Title: font-medium leading-none
Description: text-sm text-muted-foreground line-clamp-2
```

## Props Interface
```typescript
interface HoverCardProps {
  open?: boolean
  onOpenChange?: (open: boolean) => void
  defaultOpen?: boolean
  openDelay?: number // default 700ms
  closeDelay?: number // default 300ms
  children: React.ReactNode
}

interface HoverCardTriggerProps {
  asChild?: boolean
  children: React.ReactNode
}

interface HoverCardContentProps {
  side?: 'top' | 'right' | 'bottom' | 'left'
  sideOffset?: number
  align?: 'start' | 'center' | 'end'
  alignOffset?: number
  className?: string
  children: React.ReactNode
}

interface HoverCardArrowProps {
  className?: string
  width?: number
  height?: number
}
```

## Configuration
- Default open delay: 700ms (prevents accidental triggers)
- Default close delay: 300ms (allows moving to card)
- Supports collision detection

## Do
- Use for supplementary, non-essential information
- Keep content scannable (not too much)
- Include visual hierarchy in content
- Support touch devices with click fallback

## Don't
- Use for critical information (use tooltip or inline)
- Put interactive forms inside
- Use too short delay (annoying)
- Block content underneath

## Example
```tsx
import { PreviewCard as HoverCardPrimitive } from '@base-ui/react/preview-card'
import { cn } from '@/lib/utils'

const HoverCard = HoverCardPrimitive.Root
const HoverCardTrigger = HoverCardPrimitive.Trigger

const HoverCardContent = ({
  className,
  align = 'center',
  sideOffset = 4,
  ...props
}) => (
  <HoverCardPrimitive.Content
    align={align}
    sideOffset={sideOffset}
    className={cn(
      'z-50 w-64 rounded-lg border border-border bg-background p-4 shadow-md outline-none',
      'data-open:animate-in data-closed:animate-out',
      'data-closed:fade-out-0 data-open:fade-in-0',
      'data-closed:zoom-out-95 data-open:zoom-in-95',
      'data-[side=bottom]:slide-in-from-top-2',
      'data-[side=left]:slide-in-from-right-2',
      'data-[side=right]:slide-in-from-left-2',
      'data-[side=top]:slide-in-from-bottom-2',
      className
    )}
    {...props}
  />
)

const HoverCardArrow = ({ className, ...props }) => (
  <HoverCardPrimitive.Arrow
    className={cn('fill-background', className)}
    {...props}
  />
)

// User profile card
const UserHoverCard = ({ user, children }) => (
  <HoverCard>
    <HoverCardTrigger asChild>{children}</HoverCardTrigger>
    <HoverCardContent className="w-80">
      <div className="flex justify-between space-x-4">
        <Avatar>
          <AvatarImage src={user.avatar} />
          <AvatarFallback>{user.initials}</AvatarFallback>
        </Avatar>
        <div className="space-y-1">
          <h4 className="text-sm font-semibold">{user.name}</h4>
          <p className="text-sm text-muted-foreground">@{user.username}</p>
          <p className="text-sm">{user.bio}</p>
          <div className="flex items-center pt-2">
            <span className="text-xs text-muted-foreground">
              Joined {user.joinedDate}
            </span>
          </div>
        </div>
      </div>
      <HoverCardArrow />
    </HoverCardContent>
  </HoverCard>
)

// Link preview card
const LinkHoverCard = ({ url, title, description, image, children }) => (
  <HoverCard>
    <HoverCardTrigger asChild>{children}</HoverCardTrigger>
    <HoverCardContent className="w-80">
      <div className="space-y-3">
        {image && (
          <img
            src={image}
            alt={title}
            className="aspect-video w-full rounded-md object-cover"
          />
        )}
        <div className="space-y-1">
          <h4 className="text-sm font-semibold leading-none">{title}</h4>
          <p className="text-sm text-muted-foreground line-clamp-2">
            {description}
          </p>
          <p className="text-xs text-muted-foreground">{url}</p>
        </div>
      </div>
      <HoverCardArrow />
    </HoverCardContent>
  </HoverCard>
)

// Product preview card
const ProductHoverCard = ({ product, children }) => (
  <HoverCard>
    <HoverCardTrigger asChild>{children}</HoverCardTrigger>
    <HoverCardContent className="w-72">
      <div className="space-y-3">
        <img
          src={product.image}
          alt={product.name}
          className="aspect-square w-full rounded-md object-cover"
        />
        <div className="space-y-1">
          <div className="flex items-center justify-between">
            <h4 className="font-medium">{product.name}</h4>
            <span className="font-semibold">${product.price}</span>
          </div>
          <p className="text-sm text-muted-foreground line-clamp-2">
            {product.description}
          </p>
          <div className="flex items-center gap-1">
            {Array.from({ length: 5 }).map((_, i) => (
              <Star
                key={i}
                className={cn(
                  'h-3 w-3',
                  i < product.rating ? 'fill-yellow-400 text-yellow-400' : 'text-muted'
                )}
              />
            ))}
            <span className="text-xs text-muted-foreground">
              ({product.reviewCount})
            </span>
          </div>
        </div>
      </div>
      <HoverCardArrow />
    </HoverCardContent>
  </HoverCard>
)
```
