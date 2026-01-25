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
data-open:animate-in data-closed:animate-out
data-closed:fade-out-0 data-open:fade-in-0
```

### Content (Base)
```
fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out
data-open:animate-in data-closed:animate-out
data-closed:duration-300 data-open:duration-500
```

### Position Variants
```
left:
  inset-y-0 left-0 h-full w-3/4 sm:max-w-sm border-r border-border
  data-closed:slide-out-to-left data-open:slide-in-from-left

right:
  inset-y-0 right-0 h-full w-3/4 sm:max-w-sm border-l border-border
  data-closed:slide-out-to-right data-open:slide-in-from-right

top:
  inset-x-0 top-0 border-b border-border
  data-closed:slide-out-to-top data-open:slide-in-from-top

bottom:
  inset-x-0 bottom-0 border-t border-border
  data-closed:slide-out-to-bottom data-open:slide-in-from-bottom
```

### Header
```
flex flex-col space-y-2
```

### Title
```
font-heading text-lg font-semibold text-foreground
```

### Description
```
font-body text-sm text-muted-foreground
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
- Use Base UI Dialog as base (or vaul for mobile-friendly)
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
import { Dialog } from '@base-ui-components/react/dialog'
import { X } from 'lucide-react'
import { cn } from '@/lib/utils'

const Drawer = Dialog.Root
const DrawerTrigger = Dialog.Trigger
const DrawerClose = Dialog.Close
const DrawerPortal = Dialog.Portal

const drawerSideVariants = {
  left: 'inset-y-0 left-0 h-full w-3/4 sm:max-w-sm border-r data-closed:slide-out-to-left data-open:slide-in-from-left',
  right: 'inset-y-0 right-0 h-full w-3/4 sm:max-w-sm border-l data-closed:slide-out-to-right data-open:slide-in-from-right',
  top: 'inset-x-0 top-0 border-b data-closed:slide-out-to-top data-open:slide-in-from-top',
  bottom: 'inset-x-0 bottom-0 border-t data-closed:slide-out-to-bottom data-open:slide-in-from-bottom',
}

const DrawerOverlay = ({ className, ...props }) => (
  <Dialog.Backdrop
    className={cn(
      'fixed inset-0 z-50 bg-black/80',
      'data-open:animate-in data-closed:animate-out',
      'data-closed:fade-out-0 data-open:fade-in-0',
      className
    )}
    {...props}
  />
)

const DrawerContent = ({ side = 'right', className, children, ...props }) => (
  <DrawerPortal>
    <DrawerOverlay />
    <Dialog.Popup
      className={cn(
        'fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out',
        'data-open:animate-in data-closed:animate-out',
        'data-closed:duration-300 data-open:duration-500',
        drawerSideVariants[side],
        className
      )}
      {...props}
    >
      {children}
      <Dialog.Close className="absolute right-4 top-4 rounded-sm opacity-70 hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-primary">
        <X className="h-4 w-4" />
        <span className="sr-only">Close</span>
      </Dialog.Close>
    </Dialog.Popup>
  </DrawerPortal>
)

const DrawerHeader = ({ className, ...props }) => (
  <div className={cn('flex flex-col space-y-2', className)} {...props} />
)

const DrawerTitle = ({ className, ...props }) => (
  <Dialog.Title
    className={cn('font-heading text-lg font-semibold text-foreground', className)}
    {...props}
  />
)

const DrawerDescription = ({ className, ...props }) => (
  <Dialog.Description
    className={cn('font-body text-sm text-muted-foreground', className)}
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
