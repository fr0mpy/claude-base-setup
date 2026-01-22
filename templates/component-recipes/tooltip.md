# Tooltip Component Recipe

## Structure
- Trigger element (wraps any interactive element)
- Content popup with arrow
- Support multiple positions
- Delay on hover before showing

## Tailwind Classes

### Content
```
z-50 overflow-hidden {tokens.radius} bg-foreground px-3 py-1.5 text-xs text-background
animate-in fade-in-0 zoom-in-95
data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95
data-[side=bottom]:slide-in-from-top-2
data-[side=left]:slide-in-from-right-2
data-[side=right]:slide-in-from-left-2
data-[side=top]:slide-in-from-bottom-2
```

### Arrow
```
fill-foreground
```

### Alternative Light Style
```
bg-background border border-border text-foreground {tokens.shadow}
Arrow: fill-background stroke-border
```

## Props Interface
```typescript
interface TooltipProps {
  content: React.ReactNode
  side?: 'top' | 'right' | 'bottom' | 'left'
  align?: 'start' | 'center' | 'end'
  delayDuration?: number
  children: React.ReactNode
}
```

## Configuration
- Default delay: 200ms (adjust based on UX needs)
- Default side: 'top'
- Skip delay on hover when moving between tooltips

## Do
- Use Radix Tooltip for accessibility
- Include enter/exit animations
- Support arrow pointing to trigger
- Use inverted colors (dark bg, light text) for contrast

## Don't
- Show tooltip on disabled elements without wrapper
- Use too long delay (frustrating UX)
- Put interactive content in tooltips (use popover instead)
- Hardcode colors

## Example
```tsx
import * as TooltipPrimitive from '@radix-ui/react-tooltip'
import { cn } from '@/lib/utils'

const TooltipProvider = TooltipPrimitive.Provider

const Tooltip = TooltipPrimitive.Root

const TooltipTrigger = TooltipPrimitive.Trigger

const TooltipContent = ({ className, sideOffset = 4, ...props }) => (
  <TooltipPrimitive.Content
    sideOffset={sideOffset}
    className={cn(
      'z-50 overflow-hidden rounded-md bg-foreground px-3 py-1.5 text-xs text-background',
      'animate-in fade-in-0 zoom-in-95',
      'data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95',
      'data-[side=bottom]:slide-in-from-top-2',
      'data-[side=left]:slide-in-from-right-2',
      'data-[side=right]:slide-in-from-left-2',
      'data-[side=top]:slide-in-from-bottom-2',
      className
    )}
    {...props}
  />
)

const TooltipArrow = ({ className, ...props }) => (
  <TooltipPrimitive.Arrow
    className={cn('fill-foreground', className)}
    {...props}
  />
)

// Simplified wrapper component
const SimpleTooltip = ({ content, side = 'top', delayDuration = 200, children }) => (
  <TooltipProvider>
    <Tooltip delayDuration={delayDuration}>
      <TooltipTrigger asChild>{children}</TooltipTrigger>
      <TooltipContent side={side}>
        {content}
        <TooltipArrow />
      </TooltipContent>
    </Tooltip>
  </TooltipProvider>
)

// Usage
<SimpleTooltip content="Add to library">
  <Button variant="ghost" size="icon">
    <Plus className="h-4 w-4" />
  </Button>
</SimpleTooltip>
```
