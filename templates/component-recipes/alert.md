# Alert Component Recipe

## Structure
- Container with icon, title, and description
- Support variants: info, success, warning, error/destructive
- Optional dismiss button
- Optional action buttons

## Tailwind Classes

### Container
```
relative w-full {tokens.radius} border p-4
[&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:h-4 [&>svg]:w-4
[&>svg+div]:translate-y-[-3px] [&:has(svg)]:pl-11
```

### Variants
```
default:     bg-background border-border text-foreground [&>svg]:text-foreground
info:        bg-blue-500/10 border-blue-500/20 text-blue-600 [&>svg]:text-blue-600
success:     bg-green-500/10 border-green-500/20 text-green-600 [&>svg]:text-green-600
warning:     bg-yellow-500/10 border-yellow-500/20 text-yellow-600 [&>svg]:text-yellow-600
destructive: bg-destructive/10 border-destructive/20 text-destructive [&>svg]:text-destructive
```

### Title
```
font-heading mb-1 font-medium leading-none tracking-tight
```

### Description
```
font-body text-sm [&_p]:leading-relaxed
```

### Dismiss Button
```
absolute right-2 top-2 {tokens.radius} p-1 opacity-70
hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-primary
```

## Props Interface
```typescript
interface AlertProps {
  variant?: 'default' | 'info' | 'success' | 'warning' | 'destructive'
  icon?: React.ReactNode
  title?: string
  onDismiss?: () => void
  children: React.ReactNode
}

interface AlertTitleProps {
  className?: string
  children: React.ReactNode
}

interface AlertDescriptionProps {
  className?: string
  children: React.ReactNode
}
```

## Icons per Variant
```
info:        <Info /> or <AlertCircle />
success:     <CheckCircle />
warning:     <AlertTriangle />
destructive: <XCircle /> or <AlertOctagon />
default:     <Info /> or custom
```

## Do
- Include appropriate icon for each variant
- Use semantic colors from tokens where possible
- Support composable pattern (Alert.Title, Alert.Description)
- Add dismiss functionality when needed

## Don't
- Hardcode colors
- Make alerts too visually heavy
- Forget to position icon properly
- Skip the semantic meaning of variants

## Example
```tsx
import { cn } from '@/lib/utils'
import { AlertCircle, CheckCircle, AlertTriangle, XCircle, X, Info } from 'lucide-react'

const alertVariants = {
  default: 'bg-background border-border text-foreground',
  info: 'bg-blue-500/10 border-blue-500/20 text-blue-600 [&>svg]:text-blue-600',
  success: 'bg-green-500/10 border-green-500/20 text-green-600 [&>svg]:text-green-600',
  warning: 'bg-yellow-500/10 border-yellow-500/20 text-yellow-600 [&>svg]:text-yellow-600',
  destructive: 'bg-destructive/10 border-destructive/20 text-destructive [&>svg]:text-destructive',
}

const alertIcons = {
  default: Info,
  info: AlertCircle,
  success: CheckCircle,
  warning: AlertTriangle,
  destructive: XCircle,
}

const Alert = ({ variant = 'default', title, onDismiss, className, children, ...props }) => {
  const Icon = alertIcons[variant]

  return (
    <div
      role="alert"
      className={cn(
        'relative w-full rounded-lg border p-4',
        '[&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:h-4 [&>svg]:w-4',
        '[&>svg+div]:translate-y-[-3px] [&:has(svg)]:pl-11',
        alertVariants[variant],
        className
      )}
      {...props}
    >
      <Icon className="h-4 w-4" />
      <div>
        {title && <AlertTitle>{title}</AlertTitle>}
        <AlertDescription>{children}</AlertDescription>
      </div>
      {onDismiss && (
        <button
          onClick={onDismiss}
          className="absolute right-2 top-2 rounded p-1 opacity-70 hover:opacity-100"
        >
          <X className="h-4 w-4" />
        </button>
      )}
    </div>
  )
}

const AlertTitle = ({ className, ...props }) => (
  <h5 className={cn('font-heading mb-1 font-medium leading-none tracking-tight', className)} {...props} />
)

const AlertDescription = ({ className, ...props }) => (
  <div className={cn('font-body text-sm [&_p]:leading-relaxed', className)} {...props} />
)
```
