# Textarea Component Recipe

## Structure
- Multi-line text input
- Support for auto-resize
- Character count option
- Error state
- Disabled state

## Tailwind Classes

### Base
```
flex min-h-[60px] w-full {tokens.radius} border border-border bg-background px-3 py-2
text-sm text-foreground placeholder:text-muted-foreground
transition-colors
focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2
disabled:cursor-not-allowed disabled:opacity-50
resize-none
```

### With Resize
```
resize-y (vertical only)
resize (both directions)
resize-none (no resize - default for controlled height)
```

### Sizes
```
sm: min-h-[40px] text-sm
md: min-h-[60px] text-sm (default)
lg: min-h-[80px] text-base
```

### Error State
```
border-destructive focus-visible:ring-destructive
```

### Character Count
```
Container: relative
Counter: absolute bottom-2 right-2 text-xs text-muted-foreground
Counter error: text-destructive
```

### With Label
```
Container: space-y-2
Label: text-sm font-medium leading-none
```

## Props Interface
```typescript
interface TextareaProps extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {
  error?: boolean
  errorMessage?: string
}

interface TextareaWithCountProps extends TextareaProps {
  maxLength: number
  showCount?: boolean
}

interface AutoResizeTextareaProps extends TextareaProps {
  minRows?: number
  maxRows?: number
}
```

## Auto-Resize Logic
```typescript
const adjustHeight = (textarea: HTMLTextAreaElement) => {
  textarea.style.height = 'auto'
  textarea.style.height = `${textarea.scrollHeight}px`
}
```

## Do
- Use for multi-line text (comments, descriptions, messages)
- Include placeholder with example format
- Show character count for limited inputs
- Support auto-resize for better UX

## Don't
- Hardcode colors
- Use for single-line inputs (use Input)
- Make too small (frustrating to type in)
- Forget to handle long content gracefully

## Example
```tsx
import { forwardRef, useRef, useEffect } from 'react'
import { cn } from '@/lib/utils'

const Textarea = forwardRef<HTMLTextAreaElement, TextareaProps>(
  ({ className, error, ...props }, ref) => {
    return (
      <textarea
        className={cn(
          'flex min-h-[60px] w-full rounded-lg border border-border bg-background px-3 py-2',
          'text-sm text-foreground placeholder:text-muted-foreground',
          'transition-colors',
          'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2',
          'disabled:cursor-not-allowed disabled:opacity-50',
          'resize-none',
          error && 'border-destructive focus-visible:ring-destructive',
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)

Textarea.displayName = 'Textarea'

// With character count
const TextareaWithCount = forwardRef<HTMLTextAreaElement, TextareaWithCountProps>(
  ({ maxLength, showCount = true, value, className, ...props }, ref) => {
    const count = String(value || '').length
    const isOverLimit = count > maxLength

    return (
      <div className="relative">
        <Textarea
          ref={ref}
          value={value}
          maxLength={maxLength}
          className={cn(showCount && 'pb-6', className)}
          {...props}
        />
        {showCount && (
          <span
            className={cn(
              'absolute bottom-2 right-3 text-xs',
              isOverLimit ? 'text-destructive' : 'text-muted-foreground'
            )}
          >
            {count}/{maxLength}
          </span>
        )}
      </div>
    )
  }
)

TextareaWithCount.displayName = 'TextareaWithCount'

// Auto-resize textarea
const AutoResizeTextarea = forwardRef<HTMLTextAreaElement, AutoResizeTextareaProps>(
  ({ minRows = 2, maxRows = 10, onChange, className, ...props }, ref) => {
    const textareaRef = useRef<HTMLTextAreaElement>(null)

    const adjustHeight = () => {
      const textarea = textareaRef.current
      if (!textarea) return

      textarea.style.height = 'auto'
      const lineHeight = parseInt(getComputedStyle(textarea).lineHeight)
      const minHeight = lineHeight * minRows
      const maxHeight = lineHeight * maxRows

      const newHeight = Math.min(Math.max(textarea.scrollHeight, minHeight), maxHeight)
      textarea.style.height = `${newHeight}px`
    }

    useEffect(() => {
      adjustHeight()
    }, [props.value])

    const handleChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
      adjustHeight()
      onChange?.(e)
    }

    return (
      <Textarea
        ref={(node) => {
          textareaRef.current = node
          if (typeof ref === 'function') ref(node)
          else if (ref) ref.current = node
        }}
        onChange={handleChange}
        className={cn('resize-none overflow-hidden', className)}
        rows={minRows}
        {...props}
      />
    )
  }
)

AutoResizeTextarea.displayName = 'AutoResizeTextarea'

// With label and error
const TextareaField = ({ label, error, errorMessage, id, ...props }) => (
  <div className="space-y-2">
    {label && (
      <label htmlFor={id} className="text-sm font-medium leading-none">
        {label}
      </label>
    )}
    <Textarea id={id} error={error} {...props} />
    {errorMessage && (
      <p className="text-sm text-destructive">{errorMessage}</p>
    )}
  </div>
)

// Usage examples
<Textarea placeholder="Type your message here…" />

<TextareaWithCount
  maxLength={280}
  placeholder="What's happening?"
  value={message}
  onChange={(e) => setMessage(e.target.value)}
/>

<AutoResizeTextarea
  placeholder="Write your comment…"
  minRows={2}
  maxRows={6}
/>

<TextareaField
  label="Description"
  placeholder="Describe your project…"
  error={!!errors.description}
  errorMessage={errors.description?.message}
/>
```
