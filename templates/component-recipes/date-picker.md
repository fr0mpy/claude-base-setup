# Date Picker Component Recipe

## Structure
- Input field that opens a Calendar in a Popover
- Displays formatted date in the input
- Support for single date, date range, and presets
- Combines Input, Popover, Calendar, and Button components

## Tailwind Classes

### Trigger Button
```
w-full justify-start text-left font-normal
h-10 px-3 py-2 border border-border bg-background {tokens.radius}
hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary
inline-flex items-center gap-2
cursor-pointer
```

### Placeholder State
```
text-muted-foreground
```

### Calendar Icon
```
h-4 w-4 text-muted-foreground
```

### Popover Content
```
absolute z-50 mt-1 p-0 bg-background border border-border {tokens.radius} {tokens.shadow}
```

### Presets Container (Optional)
```
flex flex-col gap-2 p-3 border-r border-border
```

### Preset Button
```
justify-start font-normal px-2 py-1.5 h-auto text-sm
hover:bg-surface {tokens.radius}
cursor-pointer
```

### Date Range Display
```
flex items-center gap-2
```

### Range Separator
```
text-muted-foreground
```

## Props Interface
```typescript
interface DatePickerProps {
  value?: Date
  onChange?: (date: Date | undefined) => void
  placeholder?: string
  disabled?: boolean
  className?: string
}

interface DateRangePickerProps {
  value?: DateRange
  onChange?: (range: DateRange | undefined) => void
  placeholder?: string
  disabled?: boolean
  className?: string
}

interface DateRange {
  from: Date
  to?: Date
}

interface DatePickerWithPresetsProps extends DatePickerProps {
  presets?: Array<{
    label: string
    value: Date
  }>
}
```

## Do
- Use semantic color tokens from config
- Show clear placeholder when no date selected
- Format dates consistently
- Close popover on date selection (single mode)
- Support keyboard input for accessibility
- Use `cn()` utility for class merging

## Don't
- Hardcode colors (use tokens)
- Forget to handle empty/undefined states
- Skip the calendar icon visual indicator
- Use inconsistent date formats
- Forget mobile touch targets (min 44x44px)

## Example
```tsx
import { useState, useRef, useEffect } from 'react'
import { Calendar as CalendarIcon } from 'lucide-react'
import { cn } from '@/lib/utils'
import { Calendar } from '@/components/ui/calendar'

// Helper function to format dates
const formatDate = (date: Date, format: 'short' | 'long' = 'long') => {
  if (format === 'short') {
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
  }
  return date.toLocaleDateString('en-US', { weekday: 'short', month: 'long', day: 'numeric', year: 'numeric' })
}

// Single Date Picker
const DatePicker = ({
  value,
  onChange,
  placeholder = 'Pick a date',
  disabled,
  className,
}) => {
  const [open, setOpen] = useState(false)
  const containerRef = useRef<HTMLDivElement>(null)

  // Close on outside click
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Close on Escape
  useEffect(() => {
    const handleEscape = (event: KeyboardEvent) => {
      if (event.key === 'Escape') setOpen(false)
    }
    document.addEventListener('keydown', handleEscape)
    return () => document.removeEventListener('keydown', handleEscape)
  }, [])

  const handleSelect = (date: Date | undefined) => {
    onChange?.(date)
    setOpen(false)
  }

  return (
    <div ref={containerRef} className="relative">
      <button
        type="button"
        disabled={disabled}
        onClick={() => setOpen(!open)}
        className={cn(
          'w-full justify-start text-left font-normal',
          'h-10 px-3 py-2 border border-border bg-background rounded-md',
          'hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary',
          'inline-flex items-center gap-2 cursor-pointer',
          'disabled:opacity-50 disabled:cursor-not-allowed',
          !value && 'text-muted-foreground',
          className
        )}
      >
        <CalendarIcon className="h-4 w-4 text-muted-foreground" />
        {value ? formatDate(value) : placeholder}
      </button>

      {open && (
        <div className="absolute z-50 mt-1 bg-background border border-border rounded-lg shadow-lg">
          <Calendar
            mode="single"
            selected={value}
            onSelect={handleSelect}
          />
        </div>
      )}
    </div>
  )
}

// Date Range Picker
const DateRangePicker = ({
  value,
  onChange,
  placeholder = 'Pick a date range',
  disabled,
  className,
}) => {
  const [open, setOpen] = useState(false)
  const containerRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  useEffect(() => {
    const handleEscape = (event: KeyboardEvent) => {
      if (event.key === 'Escape') setOpen(false)
    }
    document.addEventListener('keydown', handleEscape)
    return () => document.removeEventListener('keydown', handleEscape)
  }, [])

  const handleSelect = (range: DateRange | undefined) => {
    onChange?.(range)
    // Close when both dates are selected
    if (range?.from && range?.to) {
      setOpen(false)
    }
  }

  return (
    <div ref={containerRef} className="relative">
      <button
        type="button"
        disabled={disabled}
        onClick={() => setOpen(!open)}
        className={cn(
          'w-full justify-start text-left font-normal',
          'h-10 px-3 py-2 border border-border bg-background rounded-md',
          'hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary',
          'inline-flex items-center gap-2 cursor-pointer',
          'disabled:opacity-50 disabled:cursor-not-allowed',
          !value && 'text-muted-foreground',
          className
        )}
      >
        <CalendarIcon className="h-4 w-4 text-muted-foreground" />
        {value?.from ? (
          value.to ? (
            <>
              {formatDate(value.from, 'short')} - {formatDate(value.to, 'short')}
            </>
          ) : (
            formatDate(value.from, 'short')
          )
        ) : (
          placeholder
        )}
      </button>

      {open && (
        <div className="absolute z-50 mt-1 bg-background border border-border rounded-lg shadow-lg">
          <Calendar
            mode="range"
            selected={value}
            onSelect={handleSelect}
          />
        </div>
      )}
    </div>
  )
}

// Date Picker with Presets
const DatePickerWithPresets = ({
  value,
  onChange,
  presets,
  placeholder = 'Pick a date',
  className,
}) => {
  const [open, setOpen] = useState(false)
  const containerRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  useEffect(() => {
    const handleEscape = (event: KeyboardEvent) => {
      if (event.key === 'Escape') setOpen(false)
    }
    document.addEventListener('keydown', handleEscape)
    return () => document.removeEventListener('keydown', handleEscape)
  }, [])

  const handleSelect = (date: Date | undefined) => {
    onChange?.(date)
    setOpen(false)
  }

  const handlePresetClick = (presetValue: Date) => {
    onChange?.(presetValue)
    setOpen(false)
  }

  return (
    <div ref={containerRef} className="relative">
      <button
        type="button"
        onClick={() => setOpen(!open)}
        className={cn(
          'w-full justify-start text-left font-normal',
          'h-10 px-3 py-2 border border-border bg-background rounded-md',
          'hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary',
          'inline-flex items-center gap-2 cursor-pointer',
          !value && 'text-muted-foreground',
          className
        )}
      >
        <CalendarIcon className="h-4 w-4 text-muted-foreground" />
        {value ? formatDate(value) : placeholder}
      </button>

      {open && (
        <div className="absolute z-50 mt-1 flex bg-background border border-border rounded-lg shadow-lg">
          {presets && presets.length > 0 && (
            <div className="flex flex-col gap-1 p-3 border-r border-border">
              {presets.map((preset) => (
                <button
                  key={preset.label}
                  type="button"
                  onClick={() => handlePresetClick(preset.value)}
                  className={cn(
                    'justify-start font-normal px-3 py-1.5 text-sm text-left',
                    'hover:bg-surface rounded-md cursor-pointer',
                    'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary'
                  )}
                >
                  {preset.label}
                </button>
              ))}
            </div>
          )}
          <Calendar
            mode="single"
            selected={value}
            onSelect={handleSelect}
          />
        </div>
      )}
    </div>
  )
}

// Usage - Single date
const [date, setDate] = useState<Date>()

<DatePicker value={date} onChange={setDate} />

// Usage - Date range
const [dateRange, setDateRange] = useState<DateRange>()

<DateRangePicker
  value={dateRange}
  onChange={setDateRange}
/>

// Usage - With presets
const presets = [
  { label: 'Today', value: new Date() },
  { label: 'Tomorrow', value: new Date(Date.now() + 86400000) },
  { label: 'In a week', value: new Date(Date.now() + 7 * 86400000) },
  { label: 'In a month', value: new Date(Date.now() + 30 * 86400000) },
]

<DatePickerWithPresets
  value={date}
  onChange={setDate}
  presets={presets}
/>

// Usage - In a form
<form onSubmit={handleSubmit}>
  <div className="space-y-4">
    <div className="space-y-2">
      <Label htmlFor="start-date">Start Date</Label>
      <DatePicker
        value={startDate}
        onChange={setStartDate}
        placeholder="Select start date"
      />
    </div>
    <div className="space-y-2">
      <Label htmlFor="end-date">End Date</Label>
      <DatePicker
        value={endDate}
        onChange={setEndDate}
        placeholder="Select end date"
        disabled={!startDate}
      />
    </div>
    <Button type="submit">Submit</Button>
  </div>
</form>
```

## Accessibility
- Trigger button is focusable and keyboard accessible
- Calendar supports full keyboard navigation
- Escape closes the popover
- Click outside closes the popover
- Screen readers announce selected date via button text
