# Breadcrumb Component Recipe

## Structure
- Ordered list of navigation links
- Separator between items (chevron or slash)
- Current page indicator (not a link)
- Optional: collapsible for long paths
- Support for icons

## Tailwind Classes

### Nav Container
```
<nav aria-label="Breadcrumb">
```

### List
```
flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground
sm:gap-2.5
```

### Item
```
inline-flex items-center gap-1.5
```

### Link
```
transition-colors hover:text-foreground
```

### Current Page (not a link)
```
font-normal text-foreground
```

### Separator
```
[&>svg]:h-3.5 [&>svg]:w-3.5
text-muted-foreground
```

### Ellipsis (collapsed items)
```
flex h-9 w-9 items-center justify-center
```

### With Icons
```
[&>svg]:mr-1.5 [&>svg]:h-4 [&>svg]:w-4
```

## Props Interface
```typescript
interface BreadcrumbProps {
  children: React.ReactNode
  separator?: React.ReactNode
  className?: string
}

interface BreadcrumbItemProps {
  href?: string
  current?: boolean
  children: React.ReactNode
}

interface BreadcrumbListProps {
  children: React.ReactNode
  className?: string
}

interface BreadcrumbLinkProps {
  href: string
  asChild?: boolean
  children: React.ReactNode
}

interface BreadcrumbPageProps {
  children: React.ReactNode
}

interface BreadcrumbSeparatorProps {
  children?: React.ReactNode
}

interface BreadcrumbEllipsisProps {
  className?: string
}
```

## Accessibility
- Use `<nav aria-label="Breadcrumb">`
- Use `<ol>` for ordered list semantics
- Mark current page with `aria-current="page"`
- Last item should not be a link

## Do
- Keep breadcrumb trails short (collapse if needed)
- Use consistent separator throughout
- Make all items except current clickable
- Include home/root as first item

## Don't
- Hardcode colors
- Make current page a link
- Use for non-hierarchical navigation
- Show breadcrumbs on home page

## Example
```tsx
import { ChevronRight, MoreHorizontal } from 'lucide-react'
import { Slot } from '@radix-ui/react-slot'
import { cn } from '@/lib/utils'

const Breadcrumb = ({ children, ...props }) => (
  <nav aria-label="breadcrumb" {...props}>
    {children}
  </nav>
)

const BreadcrumbList = ({ className, ...props }) => (
  <ol
    className={cn(
      'flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5',
      className
    )}
    {...props}
  />
)

const BreadcrumbItem = ({ className, ...props }) => (
  <li className={cn('inline-flex items-center gap-1.5', className)} {...props} />
)

const BreadcrumbLink = ({ asChild, className, ...props }) => {
  const Comp = asChild ? Slot : 'a'
  return (
    <Comp
      className={cn('transition-colors hover:text-foreground', className)}
      {...props}
    />
  )
}

const BreadcrumbPage = ({ className, ...props }) => (
  <span
    role="link"
    aria-disabled="true"
    aria-current="page"
    className={cn('font-normal text-foreground', className)}
    {...props}
  />
)

const BreadcrumbSeparator = ({ children, className, ...props }) => (
  <li
    role="presentation"
    aria-hidden="true"
    className={cn('[&>svg]:h-3.5 [&>svg]:w-3.5', className)}
    {...props}
  >
    {children ?? <ChevronRight />}
  </li>
)

const BreadcrumbEllipsis = ({ className, ...props }) => (
  <span
    role="presentation"
    aria-hidden="true"
    className={cn('flex h-9 w-9 items-center justify-center', className)}
    {...props}
  >
    <MoreHorizontal className="h-4 w-4" />
    <span className="sr-only">More</span>
  </span>
)

// Usage
<Breadcrumb>
  <BreadcrumbList>
    <BreadcrumbItem>
      <BreadcrumbLink href="/">Home</BreadcrumbLink>
    </BreadcrumbItem>
    <BreadcrumbSeparator />
    <BreadcrumbItem>
      <BreadcrumbLink href="/products">Products</BreadcrumbLink>
    </BreadcrumbItem>
    <BreadcrumbSeparator />
    <BreadcrumbItem>
      <BreadcrumbPage>Current Product</BreadcrumbPage>
    </BreadcrumbItem>
  </BreadcrumbList>
</Breadcrumb>

// With collapsed items
<Breadcrumb>
  <BreadcrumbList>
    <BreadcrumbItem>
      <BreadcrumbLink href="/">Home</BreadcrumbLink>
    </BreadcrumbItem>
    <BreadcrumbSeparator />
    <BreadcrumbItem>
      <DropdownMenu>
        <DropdownMenuTrigger>
          <BreadcrumbEllipsis />
        </DropdownMenuTrigger>
        <DropdownMenuContent>
          <DropdownMenuItem>Products</DropdownMenuItem>
          <DropdownMenuItem>Category</DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </BreadcrumbItem>
    <BreadcrumbSeparator />
    <BreadcrumbItem>
      <BreadcrumbPage>Item</BreadcrumbPage>
    </BreadcrumbItem>
  </BreadcrumbList>
</Breadcrumb>
```
