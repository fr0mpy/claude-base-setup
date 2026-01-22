# Card Component Recipe

## Structure
- Container with `<div>` element
- Optional subcomponents: CardHeader, CardTitle, CardDescription, CardContent, CardFooter
- Composable pattern - each part is optional

## Tailwind Classes

### Card (Container)
```
{tokens.radius} border border-border bg-surface {tokens.shadow}
```

### CardHeader
```
flex flex-col space-y-1.5 p-{tokens.spacing.normal}
```

### CardTitle
```
{tokens.typography.heading} text-lg text-foreground
```

### CardDescription
```
text-sm text-muted-foreground
```

### CardContent
```
p-{tokens.spacing.normal} pt-0
```

### CardFooter
```
flex items-center p-{tokens.spacing.normal} pt-0
```

## Props Interface
```typescript
interface CardProps {
  className?: string
  children: React.ReactNode
}

interface CardHeaderProps {
  className?: string
  children: React.ReactNode
}

interface CardTitleProps {
  className?: string
  children: React.ReactNode
}

interface CardDescriptionProps {
  className?: string
  children: React.ReactNode
}

interface CardContentProps {
  className?: string
  children: React.ReactNode
}

interface CardFooterProps {
  className?: string
  children: React.ReactNode
}
```

## Do
- Use composable pattern (Card.Header, Card.Title, etc.)
- Apply shadow from `{tokens.shadow}`
- Use `bg-surface` for background (not `bg-white`)
- Support flexible content layouts

## Don't
- Hardcode padding values
- Use `bg-white` (use `bg-surface` for theme support)
- Forget border for definition
- Apply heavy shadows unless config specifies

## Example
```tsx
import { cn } from '@/lib/utils'

const Card = ({ className, children, ...props }) => (
  <div
    className={cn(
      'rounded-lg border border-border bg-surface shadow-sm',
      className
    )}
    {...props}
  >
    {children}
  </div>
)

const CardHeader = ({ className, children, ...props }) => (
  <div className={cn('flex flex-col space-y-1.5 p-4', className)} {...props}>
    {children}
  </div>
)

const CardTitle = ({ className, children, ...props }) => (
  <h3 className={cn('font-semibold text-lg text-foreground', className)} {...props}>
    {children}
  </h3>
)

const CardDescription = ({ className, children, ...props }) => (
  <p className={cn('text-sm text-muted-foreground', className)} {...props}>
    {children}
  </p>
)

const CardContent = ({ className, children, ...props }) => (
  <div className={cn('p-4 pt-0', className)} {...props}>
    {children}
  </div>
)

const CardFooter = ({ className, children, ...props }) => (
  <div className={cn('flex items-center p-4 pt-0', className)} {...props}>
    {children}
  </div>
)
```
