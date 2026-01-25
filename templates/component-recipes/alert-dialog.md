# Alert Dialog Component Recipe

## Structure
- Modal dialog for confirmations requiring explicit user action
- Cannot be dismissed by clicking overlay or pressing Escape
- Must choose Cancel or Confirm action
- Used for destructive actions, irreversible operations, important confirmations

## Tailwind Classes

### Overlay
```
fixed inset-0 z-50 bg-black/80
animate-in fade-in-0
```

### Content
```
fixed left-1/2 top-1/2 z-50 grid w-full max-w-md -translate-x-1/2 -translate-y-1/2
gap-4 border border-border bg-background p-6 {tokens.shadow} {tokens.radius}
animate-in fade-in-0 zoom-in-95
```

### Header
```
flex flex-col space-y-2 text-center sm:text-left
```

### Footer
```
flex flex-col-reverse gap-2 sm:flex-row sm:justify-end
```

### Title
```
font-heading text-lg font-semibold leading-none tracking-tight
```

### Description
```
font-body text-sm text-muted-foreground
```

### Cancel Button
```
Use Button component with variant="outline"
```

### Action Button (Destructive)
```
Use Button component with variant="destructive"
```

## Props Interface
```typescript
interface AlertDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  children: React.ReactNode
}

interface AlertDialogContentProps {
  className?: string
  children: React.ReactNode
}

interface AlertDialogHeaderProps {
  className?: string
  children: React.ReactNode
}

interface AlertDialogFooterProps {
  className?: string
  children: React.ReactNode
}

interface AlertDialogTitleProps {
  className?: string
  children: React.ReactNode
}

interface AlertDialogDescriptionProps {
  className?: string
  children: React.ReactNode
}

interface AlertDialogActionProps {
  className?: string
  children: React.ReactNode
  onClick?: () => void
}

interface AlertDialogCancelProps {
  className?: string
  children: React.ReactNode
  onClick?: () => void
}
```

## Do
- Use for destructive/irreversible actions (delete, remove, discard)
- Clearly describe what will happen in the description
- Use destructive variant for dangerous actions
- Focus the cancel button by default (safer default)
- Keep title and description concise
- Trap focus within the dialog

## Don't
- Hardcode colors
- Allow dismissal by clicking outside
- Allow dismissal by pressing Escape
- Use for non-critical confirmations (use Dialog instead)
- Forget to provide both cancel and confirm options
- Use vague action labels like "OK" - be specific ("Delete", "Remove", "Discard")

## Example
```tsx
import { useEffect, useRef } from 'react'
import { cn } from '@/lib/utils'
import { Button } from '@/components/ui/button'

interface AlertDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  children: React.ReactNode
}

const AlertDialog = ({ open, onOpenChange, children }: AlertDialogProps) => {
  const dialogRef = useRef<HTMLDivElement>(null)
  const previousActiveElement = useRef<HTMLElement | null>(null)

  // Store the previously focused element and focus trap
  useEffect(() => {
    if (open) {
      previousActiveElement.current = document.activeElement as HTMLElement

      // Focus the first focusable element (cancel button) after render
      setTimeout(() => {
        const cancelButton = dialogRef.current?.querySelector('[data-alert-dialog-cancel]') as HTMLElement
        cancelButton?.focus()
      }, 0)
    } else {
      // Restore focus when closing
      previousActiveElement.current?.focus()
    }
  }, [open])

  // Trap focus within dialog
  useEffect(() => {
    if (!open) return

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key !== 'Tab') return

      const focusableElements = dialogRef.current?.querySelectorAll(
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
      ) as NodeListOf<HTMLElement>

      if (!focusableElements || focusableElements.length === 0) return

      const firstElement = focusableElements[0]
      const lastElement = focusableElements[focusableElements.length - 1]

      if (e.shiftKey && document.activeElement === firstElement) {
        e.preventDefault()
        lastElement.focus()
      } else if (!e.shiftKey && document.activeElement === lastElement) {
        e.preventDefault()
        firstElement.focus()
      }
    }

    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [open])

  // Prevent body scroll when open
  useEffect(() => {
    if (open) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }
    return () => {
      document.body.style.overflow = ''
    }
  }, [open])

  if (!open) return null

  return (
    <div ref={dialogRef} role="alertdialog" aria-modal="true">
      {/* Overlay - clicking does NOT close */}
      <div className="fixed inset-0 z-50 bg-black/80 animate-in fade-in-0" />

      {/* Content */}
      <div className={cn(
        'fixed left-1/2 top-1/2 z-50 grid w-full max-w-md -translate-x-1/2 -translate-y-1/2',
        'gap-4 border border-border bg-background p-6 shadow-lg rounded-lg',
        'animate-in fade-in-0 zoom-in-95'
      )}>
        {children}
      </div>
    </div>
  )
}

const AlertDialogHeader = ({ className, children, ...props }) => (
  <div className={cn('flex flex-col space-y-2 text-center sm:text-left', className)} {...props}>
    {children}
  </div>
)

const AlertDialogFooter = ({ className, children, ...props }) => (
  <div className={cn('flex flex-col-reverse gap-2 sm:flex-row sm:justify-end', className)} {...props}>
    {children}
  </div>
)

const AlertDialogTitle = ({ className, children, ...props }) => (
  <h2 className={cn('font-heading text-lg font-semibold leading-none tracking-tight', className)} {...props}>
    {children}
  </h2>
)

const AlertDialogDescription = ({ className, children, ...props }) => (
  <p className={cn('font-body text-sm text-muted-foreground', className)} {...props}>
    {children}
  </p>
)

const AlertDialogAction = ({ className, onClick, children, ...props }) => (
  <Button
    variant="destructive"
    onClick={onClick}
    className={className}
    {...props}
  >
    {children}
  </Button>
)

const AlertDialogCancel = ({ className, onClick, children, ...props }) => (
  <Button
    variant="outline"
    onClick={onClick}
    data-alert-dialog-cancel
    className={className}
    {...props}
  >
    {children}
  </Button>
)

// Usage - Delete confirmation
const [showDeleteDialog, setShowDeleteDialog] = useState(false)

const handleDelete = async () => {
  await deleteItem()
  setShowDeleteDialog(false)
}

<Button variant="destructive" onClick={() => setShowDeleteDialog(true)}>
  Delete Account
</Button>

<AlertDialog open={showDeleteDialog} onOpenChange={setShowDeleteDialog}>
  <AlertDialogHeader>
    <AlertDialogTitle>Delete account?</AlertDialogTitle>
    <AlertDialogDescription>
      This action cannot be undone. This will permanently delete your account
      and remove all your data from our servers.
    </AlertDialogDescription>
  </AlertDialogHeader>
  <AlertDialogFooter>
    <AlertDialogCancel onClick={() => setShowDeleteDialog(false)}>
      Cancel
    </AlertDialogCancel>
    <AlertDialogAction onClick={handleDelete}>
      Delete
    </AlertDialogAction>
  </AlertDialogFooter>
</AlertDialog>

// Usage - Discard changes
const [showDiscardDialog, setShowDiscardDialog] = useState(false)

const handleNavigateAway = () => {
  if (hasUnsavedChanges) {
    setShowDiscardDialog(true)
  } else {
    navigate('/home')
  }
}

const handleDiscard = () => {
  setShowDiscardDialog(false)
  navigate('/home')
}

<AlertDialog open={showDiscardDialog} onOpenChange={setShowDiscardDialog}>
  <AlertDialogHeader>
    <AlertDialogTitle>Discard changes?</AlertDialogTitle>
    <AlertDialogDescription>
      You have unsaved changes. Are you sure you want to leave? Your changes will be lost.
    </AlertDialogDescription>
  </AlertDialogHeader>
  <AlertDialogFooter>
    <AlertDialogCancel onClick={() => setShowDiscardDialog(false)}>
      Keep editing
    </AlertDialogCancel>
    <AlertDialogAction onClick={handleDiscard}>
      Discard
    </AlertDialogAction>
  </AlertDialogFooter>
</AlertDialog>

// Usage - Confirm dangerous action
const [showConfirmDialog, setShowConfirmDialog] = useState(false)

<AlertDialog open={showConfirmDialog} onOpenChange={setShowConfirmDialog}>
  <AlertDialogHeader>
    <AlertDialogTitle>Reset all settings?</AlertDialogTitle>
    <AlertDialogDescription>
      This will reset all your preferences to their default values.
      You will need to reconfigure your settings after this action.
    </AlertDialogDescription>
  </AlertDialogHeader>
  <AlertDialogFooter>
    <AlertDialogCancel onClick={() => setShowConfirmDialog(false)}>
      Cancel
    </AlertDialogCancel>
    <AlertDialogAction onClick={handleReset}>
      Reset settings
    </AlertDialogAction>
  </AlertDialogFooter>
</AlertDialog>
```

## Accessibility
- Uses `role="alertdialog"` for screen reader announcement
- `aria-modal="true"` indicates modal behavior
- Focus is trapped within the dialog
- Focus moves to cancel button on open (safer default)
- Focus returns to trigger element on close
- Cannot be dismissed via Escape (explicit choice required)
- Cannot be dismissed by clicking overlay (explicit choice required)
