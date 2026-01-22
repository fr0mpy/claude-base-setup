# Tabs Component Recipe

## Structure
- Tab list container with tab triggers
- Tab content panels (one per tab)
- Support horizontal and vertical orientations
- Keyboard navigation between tabs

## Tailwind Classes

### Tab List
```
inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground
```

### Tab Trigger
```
inline-flex items-center justify-center whitespace-nowrap {tokens.radius} px-3 py-1
text-sm font-medium ring-offset-background
transition-all
focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2
disabled:pointer-events-none disabled:opacity-50
data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:{tokens.shadow}
```

### Tab Content
```
mt-2 ring-offset-background
focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2
```

### Alternative: Underline Style
```
Tab List:
border-b border-border

Tab Trigger:
border-b-2 border-transparent pb-3 pt-2
data-[state=active]:border-primary data-[state=active]:text-foreground
```

### Alternative: Pills Style
```
Tab List:
flex gap-2

Tab Trigger:
rounded-full px-4 py-2
data-[state=active]:bg-primary data-[state=active]:text-primary-foreground
```

## Props Interface
```typescript
interface TabsProps {
  defaultValue?: string
  value?: string
  onValueChange?: (value: string) => void
  orientation?: 'horizontal' | 'vertical'
  children: React.ReactNode
}

interface TabsListProps {
  className?: string
  children: React.ReactNode
}

interface TabsTriggerProps {
  value: string
  disabled?: boolean
  children: React.ReactNode
}

interface TabsContentProps {
  value: string
  forceMount?: boolean
  children: React.ReactNode
}
```

## Do
- Use Radix Tabs for accessibility
- Support keyboard navigation (arrow keys)
- Include focus ring for triggers
- Use subtle background for active state

## Don't
- Hardcode colors
- Skip focus indicators
- Use tabs for navigation (use nav links)
- Forget disabled state styling

## Example
```tsx
import * as TabsPrimitive from '@radix-ui/react-tabs'
import { cn } from '@/lib/utils'

const Tabs = TabsPrimitive.Root

const TabsList = ({ className, ...props }) => (
  <TabsPrimitive.List
    className={cn(
      'inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground',
      className
    )}
    {...props}
  />
)

const TabsTrigger = ({ className, ...props }) => (
  <TabsPrimitive.Trigger
    className={cn(
      'inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1',
      'text-sm font-medium ring-offset-background transition-all',
      'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2',
      'disabled:pointer-events-none disabled:opacity-50',
      'data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow-sm',
      className
    )}
    {...props}
  />
)

const TabsContent = ({ className, ...props }) => (
  <TabsPrimitive.Content
    className={cn(
      'mt-2 ring-offset-background',
      'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2',
      className
    )}
    {...props}
  />
)

// Usage
<Tabs defaultValue="account">
  <TabsList>
    <TabsTrigger value="account">Account</TabsTrigger>
    <TabsTrigger value="password">Password</TabsTrigger>
    <TabsTrigger value="team">Team</TabsTrigger>
  </TabsList>
  <TabsContent value="account">Account settings...</TabsContent>
  <TabsContent value="password">Password settings...</TabsContent>
  <TabsContent value="team">Team settings...</TabsContent>
</Tabs>
```
