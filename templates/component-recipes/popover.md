# Popover Component Recipe

## Structure
- Trigger element
- Floating content panel
- Arrow pointing to trigger (optional)
- Support multiple placements
- Click outside to close

## Tailwind Classes

### Content
```
z-50 w-72 {tokens.radius} border border-border bg-background p-4 text-foreground {tokens.shadow}
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
fill-background stroke-border
```

### Close Button (optional)
```
absolute right-2 top-2 rounded-sm opacity-70 hover:opacity-100
focus:outline-none focus:ring-1 focus:ring-primary
```

### Header (if structured content)
```
mb-2
```

### Title
```
font-medium leading-none
```

### Description
```
text-sm text-muted-foreground mt-1
```

## Props Interface
```typescript
interface PopoverProps {
  open?: boolean
  onOpenChange?: (open: boolean) => void
  defaultOpen?: boolean
  modal?: boolean
  children: React.ReactNode
}

interface PopoverTriggerProps {
  asChild?: boolean
  children: React.ReactNode
}

interface PopoverContentProps {
  side?: 'top' | 'right' | 'bottom' | 'left'
  sideOffset?: number
  align?: 'start' | 'center' | 'end'
  alignOffset?: number
  className?: string
  children: React.ReactNode
}

interface PopoverArrowProps {
  className?: string
  width?: number
  height?: number
}
```

## Do
- Use Base UI Popover for accessibility
- Include enter/exit animations
- Support arrow pointing to trigger
- Handle viewport collision (flip/shift)

## Don't
- Hardcode dimensions (use sensible defaults but allow override)
- Forget focus management
- Skip keyboard support (Escape to close)
- Use for tooltips (use Tooltip component)

## Example
```tsx
import { Popover as PopoverPrimitive } from '@base-ui/react/popover'
import { cn } from '@/lib/utils'

const Popover = PopoverPrimitive.Root
const PopoverTrigger = PopoverPrimitive.Trigger
const PopoverAnchor = PopoverPrimitive.Anchor

const PopoverContent = ({
  className,
  align = 'center',
  sideOffset = 4,
  ...props
}) => (
  <PopoverPrimitive.Portal>
    <PopoverPrimitive.Content
      align={align}
      sideOffset={sideOffset}
      className={cn(
        'z-50 w-72 rounded-lg border border-border bg-background p-4 shadow-md outline-none',
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
  </PopoverPrimitive.Portal>
)

const PopoverArrow = ({ className, ...props }) => (
  <PopoverPrimitive.Arrow
    className={cn('fill-background stroke-border', className)}
    {...props}
  />
)

// Usage
<Popover>
  <PopoverTrigger asChild>
    <Button variant="outline">Open popover</Button>
  </PopoverTrigger>
  <PopoverContent>
    <div className="grid gap-4">
      <div className="space-y-2">
        <h4 className="font-medium leading-none">Dimensions</h4>
        <p className="text-sm text-muted-foreground">
          Set the dimensions for the layer.
        </p>
      </div>
      <div className="grid gap-2">
        <Input placeholder="Width" />
        <Input placeholder="Height" />
      </div>
    </div>
  </PopoverContent>
</Popover>
```
