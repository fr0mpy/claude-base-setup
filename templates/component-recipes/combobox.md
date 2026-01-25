# Combobox Component Recipe

## Structure
- Text input for searching/filtering
- Dropdown list of options
- Support for single and multi-select
- Keyboard navigation (arrows, enter, escape)
- Option for creating new items

## Tailwind Classes

### Trigger/Input Container
```
flex h-10 w-full items-center justify-between {tokens.radius} border border-border
bg-background px-3 py-2 text-sm
focus-within:outline-none focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2
disabled:cursor-not-allowed disabled:opacity-50
```

### Input
```
flex-1 bg-transparent outline-none placeholder:text-muted-foreground
```

### Trigger Button
```
ml-2 shrink-0 opacity-50 hover:opacity-100
```

### Content (Dropdown)
```
relative z-50 max-h-96 min-w-[8rem] overflow-hidden {tokens.radius}
border border-border bg-background text-foreground {tokens.shadow}
```

### Viewport
```
p-1 max-h-[300px] overflow-y-auto
```

### Empty State
```
py-6 text-center text-sm text-muted-foreground
```

### Item
```
relative flex cursor-pointer select-none items-center {tokens.radius} py-1.5 pl-2 pr-8
text-sm outline-none
data-[highlighted]:bg-muted data-[highlighted]:text-foreground
data-[disabled]:pointer-events-none data-[disabled]:opacity-50
```

### Item Indicator (check)
```
absolute right-2 flex h-3.5 w-3.5 items-center justify-center
```

### Group
```
overflow-hidden p-1
```

### Group Label
```
px-2 py-1.5 text-xs font-medium text-muted-foreground
```

### Separator
```
-mx-1 my-1 h-px bg-border
```

## Props Interface
```typescript
interface ComboboxProps {
  value?: string | string[]
  onValueChange?: (value: string | string[]) => void
  options: { value: string; label: string; disabled?: boolean }[]
  placeholder?: string
  searchPlaceholder?: string
  emptyText?: string
  disabled?: boolean
  multiple?: boolean
  allowCreate?: boolean
  onCreate?: (value: string) => void
}
```

## Do
- Use Base UI Combobox or cmdk for accessibility
- Support type-ahead filtering
- Clear search on selection (single) or keep (multi)
- Show loading state while filtering

## Don't
- Hardcode colors
- Forget empty state message
- Skip keyboard navigation
- Load all options upfront for large lists (use virtualization)

## Example
```tsx
import { useState } from 'react'
import { Command } from 'cmdk'
import { Check, ChevronsUpDown } from 'lucide-react'
import { cn } from '@/lib/utils'
import { Popover, PopoverContent, PopoverTrigger } from './Popover'
import { Button } from './Button'

const Combobox = ({
  options,
  value,
  onValueChange,
  placeholder = 'Select option…',
  searchPlaceholder = 'Search…',
  emptyText = 'No results found.',
}) => {
  const [open, setOpen] = useState(false)
  const [search, setSearch] = useState('')

  const selected = options.find(opt => opt.value === value)

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          role="combobox"
          aria-expanded={open}
          className="w-full justify-between"
        >
          {selected?.label ?? placeholder}
          <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-full p-0">
        <Command>
          <Command.Input
            placeholder={searchPlaceholder}
            value={search}
            onValueChange={setSearch}
            className="h-9 border-b border-border px-3 outline-none"
          />
          <Command.Empty className="py-6 text-center text-sm text-muted-foreground">
            {emptyText}
          </Command.Empty>
          <Command.List className="max-h-[300px] overflow-y-auto p-1">
            {options.map(option => (
              <Command.Item
                key={option.value}
                value={option.value}
                onSelect={() => {
                  onValueChange?.(option.value)
                  setOpen(false)
                }}
                className={cn(
                  'relative flex cursor-pointer select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm',
                  'data-[highlighted]:bg-muted'
                )}
              >
                {option.label}
                {value === option.value && (
                  <Check className="absolute right-2 h-4 w-4" />
                )}
              </Command.Item>
            ))}
          </Command.List>
        </Command>
      </PopoverContent>
    </Popover>
  )
}

// Multi-select variant
const MultiCombobox = ({ options, value = [], onValueChange, ...props }) => {
  const toggleOption = (optionValue) => {
    const newValue = value.includes(optionValue)
      ? value.filter(v => v !== optionValue)
      : [...value, optionValue]
    onValueChange?.(newValue)
  }

  return (
    <Combobox
      {...props}
      options={options}
      value={value}
      onValueChange={toggleOption}
    />
  )
}
```
