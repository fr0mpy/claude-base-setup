# Switch Component Recipe

## Structure
- Toggle control with sliding thumb
- On/Off states with visual indication
- Optional label alongside
- Accessible with keyboard

## Tailwind Classes

### Root/Track
```
peer inline-flex h-5 w-9 shrink-0 cursor-pointer items-center {tokens.radius}
border-2 border-transparent shadow-sm transition-colors
focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2
disabled:cursor-not-allowed disabled:opacity-50
data-[state=checked]:bg-primary data-[state=unchecked]:bg-muted
```

### Thumb
```
pointer-events-none block h-4 w-4 rounded-full bg-background shadow-lg ring-0
transition-transform
data-[state=checked]:translate-x-4 data-[state=unchecked]:translate-x-0
```

### Sizes
```
sm: Track h-4 w-7, Thumb h-3 w-3, translate-x-3
md: Track h-5 w-9, Thumb h-4 w-4, translate-x-4 (default)
lg: Track h-6 w-11, Thumb h-5 w-5, translate-x-5
```

### With Label
```
flex items-center space-x-2
Label: text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70
```

## Props Interface
```typescript
interface SwitchProps {
  checked?: boolean
  onCheckedChange?: (checked: boolean) => void
  disabled?: boolean
  required?: boolean
  name?: string
  value?: string
  id?: string
}
```

## Do
- Use Radix Switch for accessibility
- Include focus ring
- Animate thumb movement smoothly
- Use semantic colors (primary for checked)

## Don't
- Hardcode colors
- Skip keyboard support (Space to toggle)
- Forget disabled state
- Use for multiple selections (use checkboxes)

## Example
```tsx
import * as SwitchPrimitive from '@radix-ui/react-switch'
import { cn } from '@/lib/utils'

const Switch = ({ className, ...props }) => (
  <SwitchPrimitive.Root
    className={cn(
      'peer inline-flex h-5 w-9 shrink-0 cursor-pointer items-center rounded-full',
      'border-2 border-transparent shadow-sm transition-colors',
      'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2',
      'disabled:cursor-not-allowed disabled:opacity-50',
      'data-[state=checked]:bg-primary data-[state=unchecked]:bg-muted',
      className
    )}
    {...props}
  >
    <SwitchPrimitive.Thumb
      className={cn(
        'pointer-events-none block h-4 w-4 rounded-full bg-background shadow-lg ring-0',
        'transition-transform data-[state=checked]:translate-x-4 data-[state=unchecked]:translate-x-0'
      )}
    />
  </SwitchPrimitive.Root>
)

// With label
const SwitchWithLabel = ({ label, id, ...props }) => (
  <div className="flex items-center space-x-2">
    <Switch id={id} {...props} />
    <label htmlFor={id} className="text-sm font-medium leading-none">
      {label}
    </label>
  </div>
)
```
