# Checkbox Component Recipe

## Structure
- Clickable box with check indicator
- Optional label alongside
- Support indeterminate state
- Group wrapper for multiple checkboxes

## Tailwind Classes

### Checkbox Box
```
peer h-4 w-4 shrink-0 {tokens.radius} border border-border
ring-offset-background
focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2
disabled:cursor-not-allowed disabled:opacity-50
data-checked:bg-primary data-checked:border-primary data-checked:text-primary-foreground
data-indeterminate:bg-primary data-indeterminate:border-primary
```

### Check Icon
```
h-3.5 w-3.5 text-current
```

### Label
```
font-body text-sm font-medium leading-none text-foreground
peer-disabled:cursor-not-allowed peer-disabled:opacity-70
```

### Wrapper (checkbox + label)
```
flex items-center space-x-2
```

### Description (optional)
```
font-body text-sm text-muted-foreground
```

## Props Interface
```typescript
interface CheckboxProps {
  checked?: boolean | 'indeterminate'
  onCheckedChange?: (checked: boolean | 'indeterminate') => void
  disabled?: boolean
  id?: string
  name?: string
}

interface CheckboxWithLabelProps extends CheckboxProps {
  label: string
  description?: string
}
```

## Do
- Use `peer` class for label styling based on checkbox state
- Include focus ring for accessibility
- Support indeterminate state (for "select all" patterns)
- Use semantic color tokens
- Animate check appearance

## Don't
- Hardcode colors
- Use actual `<input type="checkbox">` without styling wrapper
- Forget disabled state styling
- Skip focus indicators

## Example
```tsx
import { Checkbox as CheckboxBase } from '@base-ui/react/checkbox'
import { Check, Minus } from 'lucide-react'
import { cn } from '@/lib/utils'

const Checkbox = ({ className, ...props }) => (
  <CheckboxBase.Root
    className={cn(
      'peer h-4 w-4 shrink-0 rounded border border-border',
      'ring-offset-background',
      'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2',
      'disabled:cursor-not-allowed disabled:opacity-50',
      'data-checked:bg-primary data-checked:border-primary data-checked:text-primary-foreground',
      'data-indeterminate:bg-primary data-indeterminate:border-primary data-indeterminate:text-primary-foreground',
      className
    )}
    {...props}
  >
    <CheckboxBase.Indicator className="flex items-center justify-center text-current">
      {props.checked === 'indeterminate' ? (
        <Minus className="h-3.5 w-3.5" />
      ) : (
        <Check className="h-3.5 w-3.5" />
      )}
    </CheckboxBase.Indicator>
  </CheckboxBase.Root>
)

// With label wrapper
const CheckboxWithLabel = ({ label, description, id, ...props }) => (
  <div className="flex items-start space-x-2">
    <Checkbox id={id} {...props} />
    <div className="grid gap-1.5 leading-none">
      <label
        htmlFor={id}
        className="font-body text-sm font-medium leading-none text-foreground peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      >
        {label}
      </label>
      {description && (
        <p className="font-body text-sm text-muted-foreground">{description}</p>
      )}
    </div>
  </div>
)
```
