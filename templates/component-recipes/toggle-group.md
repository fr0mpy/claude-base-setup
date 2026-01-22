# Toggle Group Component Recipe

## Structure
- Group of toggle buttons
- Single or multiple selection modes
- Mutually exclusive options (single) or multi-select (multiple)
- Often used for view switchers, formatting options, filters

## Tailwind Classes

### Container
```
inline-flex items-center justify-center {tokens.radius} bg-muted p-1
```

### Item (Base)
```
inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1.5
text-sm font-medium ring-offset-background transition-all
focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2
disabled:pointer-events-none disabled:opacity-50
```

### Item States
```
Default: text-muted-foreground hover:bg-background/50 hover:text-foreground
Active: bg-background text-foreground shadow-sm
```

### Variant: Outline
```
Container: inline-flex items-center rounded-lg border border-border
Item: border-r border-border last:border-r-0
Item Active: bg-muted
```

### Sizes
```
sm: h-8 px-2.5 text-xs
md: h-9 px-3 text-sm (default)
lg: h-10 px-4 text-sm
```

### With Icons
```
Item: gap-2
Icon: h-4 w-4
```

### Full Width
```
Container: flex w-full
Item: flex-1
```

## Props Interface
```typescript
interface ToggleGroupProps {
  type: 'single' | 'multiple'
  value?: string | string[]
  defaultValue?: string | string[]
  onValueChange?: (value: string | string[]) => void
  disabled?: boolean
  className?: string
  children: React.ReactNode
}

interface ToggleGroupItemProps {
  value: string
  disabled?: boolean
  className?: string
  children: React.ReactNode
}

// Single selection
interface ToggleGroupSingleProps {
  type: 'single'
  value?: string
  defaultValue?: string
  onValueChange?: (value: string) => void
}

// Multiple selection
interface ToggleGroupMultipleProps {
  type: 'multiple'
  value?: string[]
  defaultValue?: string[]
  onValueChange?: (value: string[]) => void
}
```

## Do
- Use Radix ToggleGroup primitive
- Clearly indicate selected state
- Support keyboard navigation
- Include proper ARIA attributes
- Group related options logically

## Don't
- Hardcode colors or dimensions
- Mix toggle group with regular buttons
- Use for navigation (use tabs or nav)
- Forget disabled states

## Example
```tsx
import * as ToggleGroupPrimitive from '@radix-ui/react-toggle-group'
import { cn } from '@/lib/utils'

const ToggleGroup = ({ className, variant = 'default', size = 'md', ...props }) => (
  <ToggleGroupPrimitive.Root
    className={cn(
      'inline-flex items-center justify-center rounded-lg',
      variant === 'default' && 'bg-muted p-1',
      variant === 'outline' && 'border border-border',
      className
    )}
    {...props}
  />
)

const toggleGroupItemSizes = {
  sm: 'h-8 px-2.5 text-xs',
  md: 'h-9 px-3 text-sm',
  lg: 'h-10 px-4 text-sm',
}

const ToggleGroupItem = ({ className, variant = 'default', size = 'md', ...props }) => (
  <ToggleGroupPrimitive.Item
    className={cn(
      'inline-flex items-center justify-center whitespace-nowrap rounded-md',
      'font-medium ring-offset-background transition-all',
      'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2',
      'disabled:pointer-events-none disabled:opacity-50',
      variant === 'default' && [
        'text-muted-foreground hover:bg-background/50 hover:text-foreground',
        'data-[state=on]:bg-background data-[state=on]:text-foreground data-[state=on]:shadow-sm',
      ],
      variant === 'outline' && [
        'border-r border-border last:border-r-0',
        'text-muted-foreground hover:bg-muted hover:text-foreground',
        'data-[state=on]:bg-muted data-[state=on]:text-foreground',
      ],
      toggleGroupItemSizes[size],
      className
    )}
    {...props}
  />
)

// Usage examples

// View switcher (single selection)
import { LayoutGrid, List, Rows } from 'lucide-react'

const ViewToggle = ({ value, onChange }) => (
  <ToggleGroup type="single" value={value} onValueChange={onChange}>
    <ToggleGroupItem value="grid" aria-label="Grid view">
      <LayoutGrid className="h-4 w-4" />
    </ToggleGroupItem>
    <ToggleGroupItem value="list" aria-label="List view">
      <List className="h-4 w-4" />
    </ToggleGroupItem>
    <ToggleGroupItem value="rows" aria-label="Rows view">
      <Rows className="h-4 w-4" />
    </ToggleGroupItem>
  </ToggleGroup>
)

// Text formatting (multiple selection)
import { Bold, Italic, Underline, Strikethrough } from 'lucide-react'

const TextFormatting = ({ value, onChange }) => (
  <ToggleGroup type="multiple" value={value} onValueChange={onChange}>
    <ToggleGroupItem value="bold" aria-label="Bold">
      <Bold className="h-4 w-4" />
    </ToggleGroupItem>
    <ToggleGroupItem value="italic" aria-label="Italic">
      <Italic className="h-4 w-4" />
    </ToggleGroupItem>
    <ToggleGroupItem value="underline" aria-label="Underline">
      <Underline className="h-4 w-4" />
    </ToggleGroupItem>
    <ToggleGroupItem value="strikethrough" aria-label="Strikethrough">
      <Strikethrough className="h-4 w-4" />
    </ToggleGroupItem>
  </ToggleGroup>
)

// Filter options with text
const FilterToggle = ({ value, onChange }) => (
  <ToggleGroup type="single" value={value} onValueChange={onChange} variant="outline">
    <ToggleGroupItem value="all">All</ToggleGroupItem>
    <ToggleGroupItem value="active">Active</ToggleGroupItem>
    <ToggleGroupItem value="completed">Completed</ToggleGroupItem>
  </ToggleGroup>
)

// Full width toggle
const PlanToggle = ({ value, onChange }) => (
  <ToggleGroup type="single" value={value} onValueChange={onChange} className="w-full">
    <ToggleGroupItem value="monthly" className="flex-1">Monthly</ToggleGroupItem>
    <ToggleGroupItem value="yearly" className="flex-1">
      Yearly
      <span className="ml-1 text-xs text-primary">Save 20%</span>
    </ToggleGroupItem>
  </ToggleGroup>
)

// With controlled state
const [view, setView] = useState('grid')
const [formatting, setFormatting] = useState<string[]>([])

<ViewToggle value={view} onChange={setView} />
<TextFormatting value={formatting} onChange={setFormatting} />
```
