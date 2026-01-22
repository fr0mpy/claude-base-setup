# Select/Dropdown Component Recipe

## Structure
- Trigger button that shows current value
- Dropdown content with scrollable list
- Option items with optional icons/checkmarks
- Support for groups and separators

## Tailwind Classes

### Trigger
```
flex h-10 w-full items-center justify-between {tokens.radius} border border-border
bg-background px-3 py-2 text-sm text-foreground
placeholder:text-muted-foreground
focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2
disabled:cursor-not-allowed disabled:opacity-50
```

### Content (Dropdown)
```
relative z-50 max-h-96 min-w-[8rem] overflow-hidden {tokens.radius}
border border-border bg-background text-foreground {tokens.shadow}
data-[state=open]:animate-in data-[state=closed]:animate-out
data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0
data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95
data-[side=bottom]:slide-in-from-top-2 data-[side=top]:slide-in-from-bottom-2
```

### Viewport (scrollable area)
```
p-1 max-h-[300px] overflow-y-auto
```

### Item
```
relative flex w-full cursor-pointer select-none items-center {tokens.radius} py-1.5 pl-8 pr-2
text-sm outline-none
focus:bg-surface focus:text-foreground
data-[disabled]:pointer-events-none data-[disabled]:opacity-50
```

### Selected Indicator
```
absolute left-2 flex h-3.5 w-3.5 items-center justify-center
```

### Separator
```
-mx-1 my-1 h-px bg-border
```

### Group Label
```
py-1.5 pl-8 pr-2 text-sm font-semibold text-foreground
```

## Props Interface
```typescript
interface SelectProps {
  value?: string
  onValueChange?: (value: string) => void
  placeholder?: string
  disabled?: boolean
  children: React.ReactNode
}

interface SelectItemProps {
  value: string
  disabled?: boolean
  children: React.ReactNode
}

interface SelectGroupProps {
  label: string
  children: React.ReactNode
}
```

## Do
- Use Radix Select for accessibility
- Show checkmark for selected item
- Include chevron icon on trigger
- Support keyboard navigation
- Handle long lists with scrolling

## Don't
- Hardcode colors
- Forget hover/focus states on items
- Skip selected state indicator
- Use custom scroll behavior

## Example
```tsx
import * as SelectPrimitive from '@radix-ui/react-select'
import { Check, ChevronDown } from 'lucide-react'
import { cn } from '@/lib/utils'

const Select = SelectPrimitive.Root

const SelectTrigger = ({ className, children, ...props }) => (
  <SelectPrimitive.Trigger
    className={cn(
      'flex h-10 w-full items-center justify-between rounded-lg border border-border',
      'bg-background px-3 py-2 text-sm',
      'focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2',
      'disabled:cursor-not-allowed disabled:opacity-50',
      className
    )}
    {...props}
  >
    {children}
    <SelectPrimitive.Icon>
      <ChevronDown className="h-4 w-4 opacity-50" />
    </SelectPrimitive.Icon>
  </SelectPrimitive.Trigger>
)

const SelectContent = ({ className, children, ...props }) => (
  <SelectPrimitive.Portal>
    <SelectPrimitive.Content
      className={cn(
        'relative z-50 max-h-96 min-w-[8rem] overflow-hidden rounded-lg',
        'border border-border bg-background shadow-md',
        className
      )}
      {...props}
    >
      <SelectPrimitive.Viewport className="p-1">
        {children}
      </SelectPrimitive.Viewport>
    </SelectPrimitive.Content>
  </SelectPrimitive.Portal>
)

const SelectItem = ({ className, children, ...props }) => (
  <SelectPrimitive.Item
    className={cn(
      'relative flex w-full cursor-pointer select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm',
      'outline-none focus:bg-surface',
      'data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
      className
    )}
    {...props}
  >
    <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <SelectPrimitive.ItemIndicator>
        <Check className="h-4 w-4" />
      </SelectPrimitive.ItemIndicator>
    </span>
    <SelectPrimitive.ItemText>{children}</SelectPrimitive.ItemText>
  </SelectPrimitive.Item>
)
```
