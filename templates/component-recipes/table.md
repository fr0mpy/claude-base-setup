# Table Component Recipe

## Structure
- Wrapper with horizontal scroll for responsive
- Table, Header, Body, Row, Head cell, Data cell
- Support for sorting indicators
- Optional row selection/hover states

## Tailwind Classes

### Wrapper
```
relative w-full overflow-auto
```

### Table
```
w-full caption-bottom text-sm font-body
```

### Header
```
[&_tr]:border-b border-border
```

### Body
```
[&_tr:last-child]:border-0
```

### Row
```
border-b border-border transition-colors
hover:bg-muted/50
data-[state=selected]:bg-muted
```

### Head Cell (th)
```
h-10 px-2 text-left align-middle font-medium text-muted-foreground
[&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]
```

### Data Cell (td)
```
p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]
```

### Numeric Cell (for numbers, dates, prices)
```
tabular-nums text-right
```

### Caption
```
mt-4 text-sm text-muted-foreground
```

### Sortable Header
```
cursor-pointer select-none hover:text-foreground
[&_svg]:ml-2 [&_svg]:h-4 [&_svg]:w-4
```

## Props Interface
```typescript
interface TableProps extends React.HTMLAttributes<HTMLTableElement> {}

interface TableHeaderProps extends React.HTMLAttributes<HTMLTableSectionElement> {}

interface TableBodyProps extends React.HTMLAttributes<HTMLTableSectionElement> {}

interface TableRowProps extends React.HTMLAttributes<HTMLTableRowElement> {
  selected?: boolean
}

interface TableHeadProps extends React.ThHTMLAttributes<HTMLTableCellElement> {
  sortable?: boolean
  sortDirection?: 'asc' | 'desc' | null
  onSort?: () => void
}

interface TableCellProps extends React.TdHTMLAttributes<HTMLTableCellElement> {
  numeric?: boolean  // Adds tabular-nums and text-right for numbers/dates/prices
}

interface TableCaptionProps extends React.HTMLAttributes<HTMLTableCaptionElement> {}
```

## Do
- Use semantic table elements
- Include hover states for rows
- Support horizontal scroll for wide tables
- Use muted colors for headers
- Align numbers/dates right, text left
- Use `tabular-nums` class for numeric columns
- Format dates with `Intl.DateTimeFormat`, numbers with `Intl.NumberFormat`

## Don't
- Hardcode colors
- Use divs for table layout
- Forget responsive scroll wrapper
- Skip border definition

## Example
```tsx
import { cn } from '@/lib/utils'
import { ArrowUpDown, ArrowUp, ArrowDown } from 'lucide-react'

const Table = ({ className, ...props }) => (
  <div className="relative w-full overflow-auto">
    <table className={cn('w-full caption-bottom text-sm font-body', className)} {...props} />
  </div>
)

const TableHeader = ({ className, ...props }) => (
  <thead className={cn('[&_tr]:border-b border-border', className)} {...props} />
)

const TableBody = ({ className, ...props }) => (
  <tbody className={cn('[&_tr:last-child]:border-0', className)} {...props} />
)

const TableRow = ({ className, selected, ...props }) => (
  <tr
    className={cn(
      'border-b border-border transition-colors hover:bg-muted/50',
      selected && 'bg-muted',
      className
    )}
    data-state={selected ? 'selected' : undefined}
    {...props}
  />
)

const TableHead = ({ className, sortable, sortDirection, onSort, children, ...props }) => (
  <th
    className={cn(
      'h-10 px-2 text-left align-middle font-medium text-muted-foreground',
      '[&:has([role=checkbox])]:pr-0',
      sortable && 'cursor-pointer select-none hover:text-foreground',
      className
    )}
    onClick={sortable ? onSort : undefined}
    {...props}
  >
    <div className="flex items-center">
      {children}
      {sortable && (
        <span className="ml-2">
          {sortDirection === 'asc' && <ArrowUp className="h-4 w-4" />}
          {sortDirection === 'desc' && <ArrowDown className="h-4 w-4" />}
          {!sortDirection && <ArrowUpDown className="h-4 w-4 opacity-50" />}
        </span>
      )}
    </div>
  </th>
)

const TableCell = ({ className, numeric, ...props }) => (
  <td
    className={cn(
      'p-2 align-middle [&:has([role=checkbox])]:pr-0',
      numeric && 'tabular-nums text-right',
      className
    )}
    {...props}
  />
)

const TableCaption = ({ className, ...props }) => (
  <caption className={cn('mt-4 text-sm text-muted-foreground', className)} {...props} />
)
```
