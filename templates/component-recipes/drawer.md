# Drawer Component Recipe

## Structure
- Slide-out panel from edge of screen
- Support for left, right, top, bottom positions
- Overlay backdrop
- Optional close button
- Content area with header/body/footer

## Tailwind Classes

### Overlay
```
fixed inset-0 z-50 bg-black/80
data-[state=open]:animate-in data-[state=closed]:animate-out
data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0
```

### Content (Base)
```
fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out
data-[state=open]:animate-in data-[state=closed]:animate-out
data-[state=closed]:duration-300 data-[state=open]:duration-500
```

### Position Variants
```
left:
  inset-y-0 left-0 h-full w-3/4 sm:max-w-sm border-r border-border
  data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left

right:
  inset-y-0 right-0 h-full w-3/4 sm:max-w-sm border-l border-border
  data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right

top:
  inset-x-0 top-0 border-b border-border
  data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top

bottom:
  inset-x-0 bottom-0 border-t border-border
  data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom
```

### Header
```
flex flex-col space-y-2
```

### Title
```
text-lg font-semibold text-foreground
```

### Description
```
text-sm text-muted-foreground
```

### Footer
```
flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2
```

### Close Button
```
absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background
transition-opacity hover:opacity-100
focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2
```

## Props Interface
```typescript
interface DrawerProps {
  open?: boolean
  onOpenChange?: (open: boolean) => void
  side?: 'left' | 'right' | 'top' | 'bottom'
  children: React.ReactNode
}

interface DrawerContentProps {
  className?: string
  children: React.ReactNode
}

interface DrawerHeaderProps {
  className?: string
  children: React.ReactNode
}

interface DrawerTitleProps {
  className?: string
  children: React.ReactNode
}

interface DrawerDescriptionProps {
  className?: string
  children: React.ReactNode
}

interface DrawerFooterProps {
  className?: string
  children: React.ReactNode
}
```

## Do
- Use Radix Dialog as base (or vaul for mobile-friendly)
- Trap focus within drawer when open
- Close on Escape key
- Close on overlay click
- Support swipe-to-close on mobile

## Don't
- Hardcode colors or dimensions
- Forget scroll handling (body scroll lock)
- Skip keyboard accessibility
- Allow content behind to be interactive

## Example
```tsx
import * as DialogPrimitive from '@radix-ui/react-dialog'
import { X } from 'lucide-react'
import { cn } from '@/lib/utils'

const Drawer = DialogPrimitive.Root
const DrawerTrigger = DialogPrimitive.Trigger
const DrawerClose = DialogPrimitive.Close
const DrawerPortal = DialogPrimitive.Portal

const drawerSideVariants = {
  left: 'inset-y-0 left-0 h-full w-3/4 sm:max-w-sm border-r data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left',
  right: 'inset-y-0 right-0 h-full w-3/4 sm:max-w-sm border-l data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right',
  top: 'inset-x-0 top-0 border-b data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top',
  bottom: 'inset-x-0 bottom-0 border-t data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom',
}

const DrawerOverlay = ({ className, ...props }) => (
  <DialogPrimitive.Overlay
    className={cn(
      'fixed inset-0 z-50 bg-black/80',
      'data-[state=open]:animate-in data-[state=closed]:animate-out',
      'data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0',
      className
    )}
    {...props}
  />
)

const DrawerContent = ({ side = 'right', className, children, ...props }) => (
  <DrawerPortal>
    <DrawerOverlay />
    <DialogPrimitive.Content
      className={cn(
        'fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out',
        'data-[state=open]:animate-in data-[state=closed]:animate-out',
        'data-[state=closed]:duration-300 data-[state=open]:duration-500',
        drawerSideVariants[side],
        className
      )}
      {...props}
    >
      {children}
      <DialogPrimitive.Close className="absolute right-4 top-4 rounded-sm opacity-70 hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-primary">
        <X className="h-4 w-4" />
        <span className="sr-only">Close</span>
      </DialogPrimitive.Close>
    </DialogPrimitive.Content>
  </DrawerPortal>
)

const DrawerHeader = ({ className, ...props }) => (
  <div className={cn('flex flex-col space-y-2', className)} {...props} />
)

const DrawerTitle = ({ className, ...props }) => (
  <DialogPrimitive.Title
    className={cn('text-lg font-semibold text-foreground', className)}
    {...props}
  />
)

const DrawerDescription = ({ className, ...props }) => (
  <DialogPrimitive.Description
    className={cn('text-sm text-muted-foreground', className)}
    {...props}
  />
)

const DrawerFooter = ({ className, ...props }) => (
  <div
    className={cn('flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2', className)}
    {...props}
  />
)
```
