# Dialog Component Recipe

## Structure
- Same as Modal but semantically for confirmations/actions
- Typically smaller, more focused
- Usually has cancel + confirm actions
- Used for alerts, confirmations, forms

## Tailwind Classes

### Overlay
```
fixed inset-0 z-50 bg-black/80
data-open:animate-in data-closed:animate-out
data-closed:fade-out-0 data-open:fade-in-0
```

### Content
```
fixed left-1/2 top-1/2 z-50 grid w-full max-w-lg -translate-x-1/2 -translate-y-1/2
gap-4 border border-border bg-background p-6 {tokens.shadow} {tokens.radius}
duration-200
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

### Footer
```
flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2
```

### Title
```
font-heading text-lg font-semibold leading-none tracking-tight
```

### Description
```
font-body text-sm text-muted-foreground
```

### Close Button
```
absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background
transition-opacity hover:opacity-100
focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2
disabled:pointer-events-none
data-open:bg-accent data-open:text-muted-foreground
```

## Alert Dialog Variant (for destructive confirmations)
```
Same structure but:
- No close button (must make explicit choice)
- Cannot close by clicking overlay
- Destructive action uses destructive button variant
```

## Props Interface
```typescript
interface DialogProps {
  open?: boolean
  onOpenChange?: (open: boolean) => void
  children: React.ReactNode
}

interface DialogContentProps {
  className?: string
  children: React.ReactNode
}

interface DialogHeaderProps {
  className?: string
  children: React.ReactNode
}

interface DialogFooterProps {
  className?: string
  children: React.ReactNode
}

interface DialogTitleProps {
  className?: string
  children: React.ReactNode
}

interface DialogDescriptionProps {
  className?: string
  children: React.ReactNode
}
```

## Do
- Use for focused interactions requiring user decision
- Include clear action buttons
- Use AlertDialog for destructive actions
- Focus first interactive element on open

## Don't
- Hardcode colors
- Use for complex multi-step flows (use full modal)
- Allow dismissal of AlertDialog by clicking outside
- Forget keyboard navigation

## Example
```tsx
import { Dialog } from '@base-ui/react/dialog'
import { X } from 'lucide-react'
import { cn } from '@/lib/utils'

const DialogRoot = Dialog.Root
const DialogTrigger = Dialog.Trigger
const DialogPortal = Dialog.Portal
const DialogClose = Dialog.Close

const DialogBackdrop = ({ className, ...props }) => (
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

const DialogContent = ({ className, children, ...props }) => (
  <DialogPortal>
    <DialogBackdrop />
    <Dialog.Popup
      className={cn(
        'fixed left-1/2 top-1/2 z-50 grid w-full max-w-lg -translate-x-1/2 -translate-y-1/2',
        'gap-4 border border-border bg-background p-6 shadow-lg rounded-lg duration-200',
        'data-open:animate-in data-closed:animate-out',
        'data-closed:fade-out-0 data-open:fade-in-0',
        'data-closed:zoom-out-95 data-open:zoom-in-95',
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
  </DialogPortal>
)

const DialogHeader = ({ className, ...props }) => (
  <div className={cn('flex flex-col space-y-1.5 text-center sm:text-left', className)} {...props} />
)

const DialogFooter = ({ className, ...props }) => (
  <div className={cn('flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2', className)} {...props} />
)

const DialogTitle = ({ className, ...props }) => (
  <Dialog.Title className={cn('font-heading text-lg font-semibold leading-none tracking-tight', className)} {...props} />
)

const DialogDescription = ({ className, ...props }) => (
  <Dialog.Description className={cn('font-body text-sm text-muted-foreground', className)} {...props} />
)

// Usage
<DialogRoot>
  <DialogTrigger asChild>
    <Button variant="outline">Edit Profile</Button>
  </DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Edit profile</DialogTitle>
      <DialogDescription>Make changes to your profile here.</DialogDescription>
    </DialogHeader>
    <div className="grid gap-4 py-4">
      {/* Form fields */}
    </div>
    <DialogFooter>
      <Button type="submit">Save changes</Button>
    </DialogFooter>
  </DialogContent>
</DialogRoot>
```
