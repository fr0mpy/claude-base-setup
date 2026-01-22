# Radio Component Recipe

## Structure
- Radio group container
- Individual radio items with circular indicator
- Label for each option
- Optional description per item

## Tailwind Classes

### Radio Group
```
grid gap-2
```

### Radio Item
```
aspect-square h-4 w-4 rounded-full border border-border
ring-offset-background
focus:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2
disabled:cursor-not-allowed disabled:opacity-50
data-[state=checked]:border-primary
```

### Radio Indicator (inner dot)
```
flex items-center justify-center
after:content-[''] after:block after:h-2 after:w-2 after:rounded-full after:bg-primary
```

### Radio Item Wrapper (with label)
```
flex items-center space-x-2
```

### Label
```
text-sm font-medium leading-none text-foreground
peer-disabled:cursor-not-allowed peer-disabled:opacity-70
```

### Card Style Variant (selectable cards)
```
flex cursor-pointer items-start space-x-3 {tokens.radius} border border-border p-4
hover:bg-surface
data-[state=checked]:border-primary data-[state=checked]:bg-primary/5
```

## Props Interface
```typescript
interface RadioGroupProps {
  value?: string
  onValueChange?: (value: string) => void
  disabled?: boolean
  orientation?: 'horizontal' | 'vertical'
  children: React.ReactNode
}

interface RadioGroupItemProps {
  value: string
  disabled?: boolean
  id?: string
}

interface RadioCardProps {
  value: string
  label: string
  description?: string
  disabled?: boolean
}
```

## Do
- Use Radix RadioGroup for accessibility
- Support horizontal and vertical layouts
- Include focus ring
- Animate indicator appearance
- Support card-style radio buttons

## Don't
- Hardcode colors
- Use actual `<input type="radio">` without styling
- Forget group semantics
- Skip disabled state

## Example
```tsx
import * as RadioGroupPrimitive from '@radix-ui/react-radio-group'
import { Circle } from 'lucide-react'
import { cn } from '@/lib/utils'

const RadioGroup = ({ className, ...props }) => (
  <RadioGroupPrimitive.Root className={cn('grid gap-2', className)} {...props} />
)

const RadioGroupItem = ({ className, ...props }) => (
  <RadioGroupPrimitive.Item
    className={cn(
      'aspect-square h-4 w-4 rounded-full border border-border',
      'ring-offset-background',
      'focus:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2',
      'disabled:cursor-not-allowed disabled:opacity-50',
      'data-[state=checked]:border-primary',
      className
    )}
    {...props}
  >
    <RadioGroupPrimitive.Indicator className="flex items-center justify-center">
      <Circle className="h-2 w-2 fill-primary text-primary" />
    </RadioGroupPrimitive.Indicator>
  </RadioGroupPrimitive.Item>
)

// With label
const RadioWithLabel = ({ value, label, description, id }) => (
  <div className="flex items-start space-x-2">
    <RadioGroupItem value={value} id={id} />
    <div className="grid gap-1.5 leading-none">
      <label htmlFor={id} className="text-sm font-medium text-foreground">
        {label}
      </label>
      {description && (
        <p className="text-sm text-muted-foreground">{description}</p>
      )}
    </div>
  </div>
)

// Card style variant
const RadioCard = ({ value, label, description }) => (
  <RadioGroupPrimitive.Item
    value={value}
    className={cn(
      'flex cursor-pointer items-start space-x-3 rounded-lg border border-border p-4',
      'hover:bg-surface',
      'data-[state=checked]:border-primary data-[state=checked]:bg-primary/5'
    )}
  >
    <RadioGroupPrimitive.Indicator className="mt-1">
      <Circle className="h-2 w-2 fill-primary text-primary" />
    </RadioGroupPrimitive.Indicator>
    <div>
      <p className="font-medium text-foreground">{label}</p>
      {description && <p className="text-sm text-muted-foreground">{description}</p>}
    </div>
  </RadioGroupPrimitive.Item>
)
```
