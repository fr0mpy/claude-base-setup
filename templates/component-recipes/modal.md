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
data-open:animate-in data-closed:animate-out
data-closed:fade-out-0 data-open:fade-in-0
```

### Panel/Content
```
fixed left-1/2 top-1/2 z-50 -translate-x-1/2 -translate-y-1/2
w-full max-w-lg {tokens.radius} border border-border bg-background p-6 {tokens.shadow}
data-open:animate-in data-closed:animate-out
data-closed:fade-out-0 data-open:fade-in-0
data-closed:zoom-out-95 data-open:zoom-in-95
data-closed:slide-out-to-left-1/2 data-closed:slide-out-to-top-[48%]
data-open:slide-in-from-left-1/2 data-open:slide-in-from-top-[48%]
```

### Header
```
flex flex-col space-y-1.5 text-center sm:text-left
```

### Title
```
font-heading font-semibold text-lg text-foreground
```

### Description
```
font-body text-sm text-muted-foreground
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
- Use Base UI Dialog for accessibility
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
import { Dialog } from '@base-ui/react/dialog'
import { X } from 'lucide-react'
import { cn } from '@/lib/utils'

const Modal = Dialog.Root
const ModalTrigger = Dialog.Trigger

const ModalContent = ({ className, children, ...props }) => (
  <Dialog.Portal>
    <Dialog.Backdrop className="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm" />
    <Dialog.Popup
      className={cn(
        'fixed left-1/2 top-1/2 z-50 -translate-x-1/2 -translate-y-1/2',
        'w-full max-w-lg rounded-lg border border-border bg-background p-6 shadow-lg',
        className
      )}
      {...props}
    >
      {children}
      <Dialog.Close className="absolute right-4 top-4 rounded-sm opacity-70 hover:opacity-100">
        <X className="h-4 w-4" />
      </Dialog.Close>
    </Dialog.Popup>
  </Dialog.Portal>
)

const ModalHeader = ({ className, ...props }) => (
  <div className={cn('flex flex-col space-y-1.5', className)} {...props} />
)

const ModalTitle = ({ className, ...props }) => (
  <Dialog.Title className={cn('font-heading font-semibold text-lg', className)} {...props} />
)

const ModalDescription = ({ className, ...props }) => (
  <Dialog.Description className={cn('font-body text-sm text-muted-foreground', className)} {...props} />
)

const ModalFooter = ({ className, ...props }) => (
  <div className={cn('flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2 mt-4', className)} {...props} />
)
```
