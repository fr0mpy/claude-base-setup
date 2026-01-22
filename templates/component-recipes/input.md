# Input Component Recipe

## Structure
- Use `<input>` element
- Support common types: text, email, password, number, search, tel, url
- Include states: disabled, error, with icon
- Optionally wrap with label and error message

## Tailwind Classes

### Base Input
```
flex h-10 w-full {tokens.radius} border border-border bg-background px-3 py-2
text-sm text-foreground placeholder:text-muted-foreground
transition-colors
focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2
disabled:cursor-not-allowed disabled:opacity-50
```

### Error State
```
border-destructive focus:ring-destructive
```

### With Icon (left)
```
pl-10
Icon wrapper: absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground
```

### With Icon (right)
```
pr-10
Icon wrapper: absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground
```

## Props Interface
```typescript
interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  error?: boolean
  errorMessage?: string
  label?: string
  leftIcon?: React.ReactNode
  rightIcon?: React.ReactNode
}
```

## Wrapper Components

### InputWrapper (with label and error)
```tsx
<div className="space-y-2">
  {label && <Label htmlFor={id}>{label}</Label>}
  <Input ... />
  {errorMessage && <p className="text-sm text-destructive">{errorMessage}</p>}
</div>
```

## Do
- Use `bg-background` for input background
- Include `placeholder:text-muted-foreground`
- Add focus ring with primary color
- Support error states with destructive color
- Use relative/absolute for icon positioning

## Don't
- Hardcode colors
- Forget focus states
- Skip placeholder styling
- Use fixed widths (default to `w-full`)

## Example
```tsx
import { cn } from '@/lib/utils'
import { forwardRef } from 'react'

const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ className, type = 'text', error, leftIcon, rightIcon, ...props }, ref) => {
    return (
      <div className="relative">
        {leftIcon && (
          <div className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground">
            {leftIcon}
          </div>
        )}
        <input
          type={type}
          className={cn(
            'flex h-10 w-full rounded-lg border border-border bg-background px-3 py-2',
            'text-sm text-foreground placeholder:text-muted-foreground',
            'transition-colors',
            'focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2',
            'disabled:cursor-not-allowed disabled:opacity-50',
            error && 'border-destructive focus:ring-destructive',
            leftIcon && 'pl-10',
            rightIcon && 'pr-10',
            className
          )}
          ref={ref}
          {...props}
        />
        {rightIcon && (
          <div className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground">
            {rightIcon}
          </div>
        )}
      </div>
    )
  }
)

Input.displayName = 'Input'
```
