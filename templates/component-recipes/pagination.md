# Pagination Component Recipe

## Structure
- Previous/Next navigation buttons
- Page number buttons
- Ellipsis for truncated ranges
- Current page indicator
- Optional: items per page selector, total count

## Tailwind Classes

### Container
```
flex items-center justify-center space-x-1
```

### Navigation Button (Previous/Next)
```
inline-flex items-center justify-center whitespace-nowrap {tokens.radius} text-sm font-medium
h-9 px-3 gap-1
border border-border bg-transparent
hover:bg-muted hover:text-foreground
disabled:pointer-events-none disabled:opacity-50
```

### Page Button
```
inline-flex items-center justify-center whitespace-nowrap {tokens.radius} text-sm font-medium
h-9 w-9
border border-border bg-transparent
hover:bg-muted hover:text-foreground
```

### Active Page Button
```
border-primary bg-primary text-primary-foreground
hover:bg-primary/90 hover:text-primary-foreground
```

### Ellipsis
```
flex h-9 w-9 items-center justify-center
```

### With Info
```
Container: flex items-center justify-between
Info: text-sm text-muted-foreground
Controls: flex items-center space-x-6 lg:space-x-8
```

### Items Per Page Selector
```
flex items-center space-x-2
Label: text-sm font-medium
Select: h-8 w-16
```

## Props Interface
```typescript
interface PaginationProps {
  currentPage: number
  totalPages: number
  onPageChange: (page: number) => void
  siblingCount?: number // Pages shown on each side of current
  showFirstLast?: boolean
}

interface PaginationWithInfoProps extends PaginationProps {
  totalItems: number
  itemsPerPage: number
  onItemsPerPageChange?: (count: number) => void
  itemsPerPageOptions?: number[]
}
```

## Logic
```typescript
// Generate page numbers with ellipsis
function generatePagination(current, total, siblings = 1) {
  const range = (start, end) =>
    Array.from({ length: end - start + 1 }, (_, i) => start + i)

  const totalNumbers = siblings * 2 + 3 // siblings + current + first + last
  const totalBlocks = totalNumbers + 2 // + 2 ellipsis

  if (total <= totalBlocks) {
    return range(1, total)
  }

  const leftSiblingIndex = Math.max(current - siblings, 1)
  const rightSiblingIndex = Math.min(current + siblings, total)

  const showLeftEllipsis = leftSiblingIndex > 2
  const showRightEllipsis = rightSiblingIndex < total - 1

  if (!showLeftEllipsis && showRightEllipsis) {
    const leftRange = range(1, 3 + 2 * siblings)
    return [...leftRange, 'ellipsis', total]
  }

  if (showLeftEllipsis && !showRightEllipsis) {
    const rightRange = range(total - (2 + 2 * siblings), total)
    return [1, 'ellipsis', ...rightRange]
  }

  const middleRange = range(leftSiblingIndex, rightSiblingIndex)
  return [1, 'ellipsis', ...middleRange, 'ellipsis', total]
}
```

## Do
- Show current page clearly
- Disable prev on first page, next on last
- Use ellipsis for large page counts
- Keep total width manageable

## Don't
- Hardcode colors
- Show all page numbers for large sets
- Forget mobile responsiveness
- Skip keyboard navigation

## Example
```tsx
import { ChevronLeft, ChevronRight, MoreHorizontal } from 'lucide-react'
import { cn } from '@/lib/utils'
import { Button } from './Button'

const Pagination = ({
  currentPage,
  totalPages,
  onPageChange,
  siblingCount = 1,
}) => {
  const pages = generatePagination(currentPage, totalPages, siblingCount)

  return (
    <nav className="flex items-center justify-center space-x-1" aria-label="Pagination">
      <Button
        variant="outline"
        size="sm"
        onClick={() => onPageChange(currentPage - 1)}
        disabled={currentPage <= 1}
        className="gap-1"
      >
        <ChevronLeft className="h-4 w-4" />
        <span className="sr-only sm:not-sr-only">Previous</span>
      </Button>

      {pages.map((page, i) =>
        page === 'ellipsis' ? (
          <span key={`ellipsis-${i}`} className="flex h-9 w-9 items-center justify-center">
            <MoreHorizontal className="h-4 w-4" />
          </span>
        ) : (
          <Button
            key={page}
            variant={currentPage === page ? 'default' : 'outline'}
            size="sm"
            onClick={() => onPageChange(page)}
            className="h-9 w-9"
          >
            {page}
          </Button>
        )
      )}

      <Button
        variant="outline"
        size="sm"
        onClick={() => onPageChange(currentPage + 1)}
        disabled={currentPage >= totalPages}
        className="gap-1"
      >
        <span className="sr-only sm:not-sr-only">Next</span>
        <ChevronRight className="h-4 w-4" />
      </Button>
    </nav>
  )
}

// With info and items per page
const PaginationWithInfo = ({
  currentPage,
  totalPages,
  totalItems,
  itemsPerPage,
  onPageChange,
  onItemsPerPageChange,
}) => {
  const start = (currentPage - 1) * itemsPerPage + 1
  const end = Math.min(currentPage * itemsPerPage, totalItems)

  return (
    <div className="flex items-center justify-between px-2">
      <div className="text-sm text-muted-foreground">
        Showing {start} to {end} of {totalItems} results
      </div>
      <div className="flex items-center space-x-6">
        {onItemsPerPageChange && (
          <div className="flex items-center space-x-2">
            <span className="text-sm font-medium">Rows per page</span>
            <Select
              value={String(itemsPerPage)}
              onValueChange={(v) => onItemsPerPageChange(Number(v))}
            >
              {[10, 20, 50, 100].map((n) => (
                <SelectItem key={n} value={String(n)}>{n}</SelectItem>
              ))}
            </Select>
          </div>
        )}
        <Pagination
          currentPage={currentPage}
          totalPages={totalPages}
          onPageChange={onPageChange}
        />
      </div>
    </div>
  )
}
```
