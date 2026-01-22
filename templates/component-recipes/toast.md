# Toast/Notification Component Recipe

## Structure
- Viewport container (fixed position, stacks toasts)
- Individual toast with title, description, action
- Auto-dismiss with progress indicator (optional)
- Support variants: default, success, error, warning

## Tailwind Classes

### Viewport (container for all toasts)
```
fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse p-4
sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]
```

### Toast
```
group pointer-events-auto relative flex w-full items-center justify-between space-x-2
overflow-hidden {tokens.radius} border border-border p-4 pr-6 {tokens.shadow}
transition-all
data-[swipe=cancel]:translate-x-0
data-[swipe=end]:translate-x-[var(--radix-toast-swipe-end-x)]
data-[swipe=move]:translate-x-[var(--radix-toast-swipe-move-x)]
data-[swipe=move]:transition-none
data-[state=open]:animate-in data-[state=closed]:animate-out
data-[swipe=end]:animate-out
data-[state=closed]:fade-out-80
data-[state=closed]:slide-out-to-right-full
data-[state=open]:slide-in-from-top-full
data-[state=open]:sm:slide-in-from-bottom-full
```

### Variants
```
default:     bg-background text-foreground
success:     bg-green-500 text-white border-green-600
error:       bg-destructive text-destructive-foreground border-destructive
warning:     bg-yellow-500 text-white border-yellow-600
```

### Title
```
text-sm font-semibold [&+div]:text-xs
```

### Description
```
text-sm opacity-90
```

### Action Button
```
inline-flex h-8 shrink-0 items-center justify-center {tokens.radius}
border border-border bg-transparent px-3 text-sm font-medium
transition-colors hover:bg-secondary
focus:outline-none focus:ring-1 focus:ring-ring
disabled:pointer-events-none disabled:opacity-50
group-[.destructive]:border-muted/40 group-[.destructive]:hover:border-destructive/30
group-[.destructive]:hover:bg-destructive group-[.destructive]:hover:text-destructive-foreground
group-[.destructive]:focus:ring-destructive
```

### Close Button
```
absolute right-1 top-1 rounded-md p-1 text-foreground/50
opacity-0 transition-opacity hover:text-foreground
focus:opacity-100 focus:outline-none focus:ring-1
group-hover:opacity-100
group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50
group-[.destructive]:focus:ring-red-400 group-[.destructive]:focus:ring-offset-red-600
```

## Props Interface
```typescript
interface ToastProps {
  id: string
  title?: string
  description?: string
  action?: React.ReactNode
  variant?: 'default' | 'success' | 'error' | 'warning'
  duration?: number
  onOpenChange?: (open: boolean) => void
}

interface ToastActionProps {
  altText: string
  onClick: () => void
  children: React.ReactNode
}

// Hook interface
function useToast(): {
  toast: (props: Omit<ToastProps, 'id'>) => void
  dismiss: (id?: string) => void
  toasts: ToastProps[]
}
```

## Do
- Use a toast provider at app root
- Support swipe-to-dismiss on mobile
- Include close button
- Use appropriate variant for context
- Limit visible toasts (3-5 max)

## Don't
- Hardcode colors
- Skip auto-dismiss (except for errors)
- Use for critical information (use Alert)
- Stack too many toasts

## Example
```tsx
import * as ToastPrimitives from '@radix-ui/react-toast'
import { X } from 'lucide-react'
import { cn } from '@/lib/utils'

const ToastProvider = ToastPrimitives.Provider

const ToastViewport = ({ className, ...props }) => (
  <ToastPrimitives.Viewport
    className={cn(
      'fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse p-4',
      'sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]',
      className
    )}
    {...props}
  />
)

const toastVariants = {
  default: 'bg-background text-foreground border-border',
  success: 'bg-green-500 text-white border-green-600',
  error: 'bg-destructive text-destructive-foreground border-destructive',
  warning: 'bg-yellow-500 text-white border-yellow-600',
}

const Toast = ({ className, variant = 'default', ...props }) => (
  <ToastPrimitives.Root
    className={cn(
      'group pointer-events-auto relative flex w-full items-center justify-between space-x-2',
      'overflow-hidden rounded-lg border p-4 pr-6 shadow-lg transition-all',
      'data-[swipe=cancel]:translate-x-0',
      'data-[swipe=end]:translate-x-[var(--radix-toast-swipe-end-x)]',
      'data-[swipe=move]:translate-x-[var(--radix-toast-swipe-move-x)]',
      'data-[swipe=move]:transition-none',
      'data-[state=open]:animate-in data-[state=closed]:animate-out',
      'data-[swipe=end]:animate-out data-[state=closed]:fade-out-80',
      'data-[state=closed]:slide-out-to-right-full',
      'data-[state=open]:slide-in-from-top-full',
      'data-[state=open]:sm:slide-in-from-bottom-full',
      toastVariants[variant],
      className
    )}
    {...props}
  />
)

const ToastAction = ({ className, ...props }) => (
  <ToastPrimitives.Action
    className={cn(
      'inline-flex h-8 shrink-0 items-center justify-center rounded-md',
      'border bg-transparent px-3 text-sm font-medium',
      'hover:bg-secondary focus:outline-none focus:ring-1',
      className
    )}
    {...props}
  />
)

const ToastClose = ({ className, ...props }) => (
  <ToastPrimitives.Close
    className={cn(
      'absolute right-1 top-1 rounded-md p-1 text-foreground/50',
      'opacity-0 transition-opacity hover:text-foreground',
      'focus:opacity-100 focus:outline-none group-hover:opacity-100',
      className
    )}
    {...props}
  >
    <X className="h-4 w-4" />
  </ToastPrimitives.Close>
)

const ToastTitle = ({ className, ...props }) => (
  <ToastPrimitives.Title className={cn('text-sm font-semibold', className)} {...props} />
)

const ToastDescription = ({ className, ...props }) => (
  <ToastPrimitives.Description className={cn('text-sm opacity-90', className)} {...props} />
)

// Usage with hook
const { toast } = useToast()

toast({
  title: 'Success!',
  description: 'Your changes have been saved.',
  variant: 'success',
})

toast({
  title: 'Error',
  description: 'Something went wrong.',
  variant: 'error',
  action: <ToastAction altText="Try again" onClick={retry}>Try again</ToastAction>,
})
```
