# Modal/Dialog Component Recipe

## Structure
- Overlay backdrop with `<div>` for dimming
- Container panel with `<div role="dialog">`
- Optional: Header, Body, Footer sections
- Close button in header or corner
- Focus trap and keyboard handling

## Tailwind Classes

### Overlay/Backdrop
```
fixed inset-0 z-50 bg-black/50 backdrop-blur-sm
data-[state=open]:animate-in data-[state=closed]:animate-out
data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0
```

### Panel/Content
```
fixed left-1/2 top-1/2 z-50 -translate-x-1/2 -translate-y-1/2
w-full max-w-lg {tokens.radius} border border-border bg-background p-6 {tokens.shadow}
data-[state=open]:animate-in data-[state=closed]:animate-out
data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0
data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95
data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%]
data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%]
```

### Header
```
flex flex-col space-y-1.5 text-center sm:text-left
```

### Title
```
{tokens.typography.heading} text-lg text-foreground
```

### Description
```
text-sm text-muted-foreground
```

### Footer
```
flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2 mt-4
```

### Close Button
```
absolute right-4 top-4 {tokens.radius} opacity-70 ring-offset-background
transition-opacity hover:opacity-100
focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2
disabled:pointer-events-none
```

## Props Interface
```typescript
interface ModalProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  children: React.ReactNode
}

interface ModalContentProps {
  className?: string
  children: React.ReactNode
}

interface ModalHeaderProps {
  className?: string
  children: React.ReactNode
}

interface ModalTitleProps {
  className?: string
  children: React.ReactNode
}

interface ModalDescriptionProps {
  className?: string
  children: React.ReactNode
}

interface ModalFooterProps {
  className?: string
  children: React.ReactNode
}
```

## Accessibility
- Use `role="dialog"` and `aria-modal="true"`
- Implement focus trap (focus stays within modal)
- Close on Escape key
- Close on backdrop click (optional)
- Return focus to trigger element on close

## Do
- Use Radix Dialog or similar for accessibility
- Add enter/exit animations
- Use `bg-background` for panel (not hardcoded white)
- Include close button with icon
- Trap focus within modal

## Don't
- Hardcode colors or shadows
- Forget backdrop blur/dim
- Skip keyboard handling (Escape to close)
- Allow body scroll when open

## Example
```tsx
import * as DialogPrimitive from '@radix-ui/react-dialog'
import { X } from 'lucide-react'
import { cn } from '@/lib/utils'

const Modal = DialogPrimitive.Root
const ModalTrigger = DialogPrimitive.Trigger

const ModalContent = ({ className, children, ...props }) => (
  <DialogPrimitive.Portal>
    <DialogPrimitive.Overlay className="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm" />
    <DialogPrimitive.Content
      className={cn(
        'fixed left-1/2 top-1/2 z-50 -translate-x-1/2 -translate-y-1/2',
        'w-full max-w-lg rounded-lg border border-border bg-background p-6 shadow-lg',
        className
      )}
      {...props}
    >
      {children}
      <DialogPrimitive.Close className="absolute right-4 top-4 rounded-sm opacity-70 hover:opacity-100">
        <X className="h-4 w-4" />
      </DialogPrimitive.Close>
    </DialogPrimitive.Content>
  </DialogPrimitive.Portal>
)

const ModalHeader = ({ className, ...props }) => (
  <div className={cn('flex flex-col space-y-1.5', className)} {...props} />
)

const ModalTitle = ({ className, ...props }) => (
  <DialogPrimitive.Title className={cn('font-semibold text-lg', className)} {...props} />
)

const ModalDescription = ({ className, ...props }) => (
  <DialogPrimitive.Description className={cn('text-sm text-muted-foreground', className)} {...props} />
)

const ModalFooter = ({ className, ...props }) => (
  <div className={cn('flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2 mt-4', className)} {...props} />
)
```
