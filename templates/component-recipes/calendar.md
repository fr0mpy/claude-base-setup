# Calendar Component Recipe

## Structure
- Grid-based date selector displaying a month view
- Navigation for previous/next month
- Support for single date, multiple dates, or date range selection
- Highlights today, selected dates, and disabled dates
- Keyboard accessible

## Tailwind Classes

### Container
```
p-3 bg-background border border-border {tokens.radius}
```

### Navigation (Header)
```
flex items-center justify-between mb-4
```

### Month/Year Title
```
text-sm font-medium
```

### Nav Buttons
```
h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100
inline-flex items-center justify-center {tokens.radius}
hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary
cursor-pointer
```

### Weekday Headers
```
grid grid-cols-7 mb-2
```

### Weekday Cell
```
text-muted-foreground text-xs font-medium text-center w-9
```

### Days Grid
```
grid grid-cols-7 gap-1
```

### Day Cell (Base)
```
h-9 w-9 p-0 font-normal text-sm
inline-flex items-center justify-center {tokens.radius}
hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary
cursor-pointer transition-colors
```

### Day Cell States
```
today:       bg-surface text-foreground font-semibold
selected:    bg-primary text-primary-foreground hover:bg-primary/90
outside:     text-muted-foreground opacity-50
disabled:    text-muted-foreground opacity-50 cursor-not-allowed hover:bg-transparent
range-start: bg-primary text-primary-foreground rounded-l-md rounded-r-none
range-end:   bg-primary text-primary-foreground rounded-r-md rounded-l-none
range-middle: bg-primary/20 text-foreground rounded-none
```

## Props Interface
```typescript
interface CalendarProps {
  mode?: 'single' | 'multiple' | 'range'
  selected?: Date | Date[] | DateRange
  onSelect?: (date: Date | Date[] | DateRange | undefined) => void
  disabled?: Date[] | ((date: Date) => boolean)
  minDate?: Date
  maxDate?: Date
  defaultMonth?: Date
  className?: string
}

interface DateRange {
  from: Date
  to?: Date
}
```

## Do
- Use semantic color tokens from config
- Support keyboard navigation (arrow keys, Enter, Escape)
- Clearly indicate today's date
- Show clear visual feedback for selected state
- Support disabled dates for validation
- Use `cn()` utility for class merging

## Don't
- Hardcode colors (use tokens)
- Forget hover states on interactive days
- Skip focus indicators for accessibility
- Allow selection of disabled dates
- Forget to handle month/year boundaries

## Example
```tsx
import { ChevronLeft, ChevronRight } from 'lucide-react'
import { cn } from '@/lib/utils'

const DAYS = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
const MONTHS = ['January', 'February', 'March', 'April', 'May', 'June',
                'July', 'August', 'September', 'October', 'November', 'December']

const Calendar = ({
  mode = 'single',
  selected,
  onSelect,
  disabled,
  minDate,
  maxDate,
  defaultMonth,
  className,
}) => {
  const [currentMonth, setCurrentMonth] = useState(() => {
    return defaultMonth || (selected instanceof Date ? selected : new Date())
  })

  const today = new Date()
  today.setHours(0, 0, 0, 0)

  const getDaysInMonth = (date: Date) => {
    const year = date.getFullYear()
    const month = date.getMonth()
    const firstDay = new Date(year, month, 1)
    const lastDay = new Date(year, month + 1, 0)
    const daysInMonth = lastDay.getDate()
    const startingDay = firstDay.getDay()
    return { daysInMonth, startingDay, year, month }
  }

  const { daysInMonth, startingDay, year, month } = getDaysInMonth(currentMonth)

  const isDateDisabled = (date: Date) => {
    if (minDate && date < minDate) return true
    if (maxDate && date > maxDate) return true
    if (Array.isArray(disabled)) {
      return disabled.some(d => d.getTime() === date.getTime())
    }
    if (typeof disabled === 'function') {
      return disabled(date)
    }
    return false
  }

  const isSelected = (date: Date) => {
    if (!selected) return false
    if (mode === 'single' && selected instanceof Date) {
      return date.getTime() === selected.getTime()
    }
    if (mode === 'multiple' && Array.isArray(selected)) {
      return selected.some(d => d.getTime() === date.getTime())
    }
    if (mode === 'range' && selected?.from) {
      if (!selected.to) return date.getTime() === selected.from.getTime()
      return date >= selected.from && date <= selected.to
    }
    return false
  }

  const isRangeStart = (date: Date) => {
    if (mode !== 'range' || !selected?.from) return false
    return date.getTime() === selected.from.getTime()
  }

  const isRangeEnd = (date: Date) => {
    if (mode !== 'range' || !selected?.to) return false
    return date.getTime() === selected.to.getTime()
  }

  const isRangeMiddle = (date: Date) => {
    if (mode !== 'range' || !selected?.from || !selected?.to) return false
    return date > selected.from && date < selected.to
  }

  const handleDayClick = (date: Date) => {
    if (isDateDisabled(date)) return

    if (mode === 'single') {
      onSelect?.(date)
    } else if (mode === 'multiple') {
      const current = (selected as Date[]) || []
      const exists = current.find(d => d.getTime() === date.getTime())
      if (exists) {
        onSelect?.(current.filter(d => d.getTime() !== date.getTime()))
      } else {
        onSelect?.([...current, date])
      }
    } else if (mode === 'range') {
      const range = selected as DateRange | undefined
      if (!range?.from || range.to) {
        onSelect?.({ from: date, to: undefined })
      } else {
        if (date < range.from) {
          onSelect?.({ from: date, to: range.from })
        } else {
          onSelect?.({ from: range.from, to: date })
        }
      }
    }
  }

  const prevMonth = () => {
    setCurrentMonth(new Date(year, month - 1, 1))
  }

  const nextMonth = () => {
    setCurrentMonth(new Date(year, month + 1, 1))
  }

  const days = []
  // Empty cells for days before the first of the month
  for (let i = 0; i < startingDay; i++) {
    days.push(<div key={`empty-${i}`} className="h-9 w-9" />)
  }
  // Actual days
  for (let day = 1; day <= daysInMonth; day++) {
    const date = new Date(year, month, day)
    const isToday = date.getTime() === today.getTime()
    const isDisabled = isDateDisabled(date)
    const selected = isSelected(date)
    const rangeStart = isRangeStart(date)
    const rangeEnd = isRangeEnd(date)
    const rangeMiddle = isRangeMiddle(date)

    days.push(
      <button
        key={day}
        type="button"
        disabled={isDisabled}
        onClick={() => handleDayClick(date)}
        className={cn(
          'h-9 w-9 p-0 font-normal text-sm',
          'inline-flex items-center justify-center rounded-md',
          'hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary',
          'cursor-pointer transition-colors',
          isToday && 'bg-surface font-semibold',
          selected && !rangeMiddle && 'bg-primary text-primary-foreground hover:bg-primary/90',
          rangeStart && 'rounded-r-none',
          rangeEnd && 'rounded-l-none',
          rangeMiddle && 'bg-primary/20 rounded-none',
          isDisabled && 'text-muted-foreground opacity-50 cursor-not-allowed hover:bg-transparent'
        )}
      >
        {day}
      </button>
    )
  }

  return (
    <div className={cn('p-3 bg-background border border-border rounded-lg', className)}>
      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <button
          type="button"
          onClick={prevMonth}
          className={cn(
            'h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100',
            'inline-flex items-center justify-center rounded-md',
            'hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary'
          )}
        >
          <ChevronLeft className="h-4 w-4" />
        </button>
        <span className="text-sm font-medium">
          {MONTHS[month]} {year}
        </span>
        <button
          type="button"
          onClick={nextMonth}
          className={cn(
            'h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100',
            'inline-flex items-center justify-center rounded-md',
            'hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary'
          )}
        >
          <ChevronRight className="h-4 w-4" />
        </button>
      </div>

      {/* Weekday headers */}
      <div className="grid grid-cols-7 mb-2">
        {DAYS.map(day => (
          <div key={day} className="text-muted-foreground text-xs font-medium text-center w-9">
            {day}
          </div>
        ))}
      </div>

      {/* Days grid */}
      <div className="grid grid-cols-7 gap-1">
        {days}
      </div>
    </div>
  )
}

// Usage - Single date selection
const [date, setDate] = useState<Date | undefined>(new Date())

<Calendar
  mode="single"
  selected={date}
  onSelect={setDate}
/>

// Usage - Date range selection
const [dateRange, setDateRange] = useState<DateRange | undefined>()

<Calendar
  mode="range"
  selected={dateRange}
  onSelect={setDateRange}
/>

// Usage - With disabled dates
<Calendar
  mode="single"
  selected={date}
  onSelect={setDate}
  disabled={(date) => date.getDay() === 0 || date.getDay() === 6}
/>

// Usage - Limited date range
<Calendar
  mode="single"
  selected={date}
  onSelect={setDate}
  minDate={new Date()}
  maxDate={new Date(Date.now() + 90 * 24 * 60 * 60 * 1000)}
/>
```
