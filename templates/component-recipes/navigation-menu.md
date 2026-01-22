# Navigation Menu Component Recipe

## Structure
- Horizontal navigation bar
- Support for dropdown menus with content panels
- Trigger items with optional indicators
- Content areas for mega-menu style layouts
- Animated transitions for open/close

## Tailwind Classes

### Root
```
relative z-10 flex max-w-max flex-1 items-center justify-center
```

### List
```
group flex flex-1 list-none items-center justify-center space-x-1
```

### Trigger
```
group inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2
text-sm font-medium transition-colors
hover:bg-muted hover:text-foreground
focus:bg-muted focus:text-foreground focus:outline-none
disabled:pointer-events-none disabled:opacity-50
data-[state=open]:bg-muted/50
```

### Trigger Indicator (Chevron)
```
relative top-[1px] ml-1 h-3 w-3 transition duration-300
group-data-[state=open]:rotate-180
```

### Content
```
left-0 top-0 w-full
data-[motion^=from-]:animate-in data-[motion^=to-]:animate-out
data-[motion^=from-]:fade-in data-[motion^=to-]:fade-out
data-[motion=from-end]:slide-in-from-right-52
data-[motion=from-start]:slide-in-from-left-52
data-[motion=to-end]:slide-out-to-right-52
data-[motion=to-start]:slide-out-to-left-52
md:absolute md:w-auto
```

### Viewport
```
origin-top-center relative mt-1.5 h-[var(--radix-navigation-menu-viewport-height)]
w-full overflow-hidden rounded-lg border border-border bg-popover text-popover-foreground shadow-lg
data-[state=open]:animate-in data-[state=closed]:animate-out
data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-90
md:w-[var(--radix-navigation-menu-viewport-width)]
```

### Link
```
block select-none space-y-1 rounded-md p-3 leading-none no-underline outline-none
transition-colors hover:bg-muted hover:text-foreground focus:bg-muted focus:text-foreground
```

### Link Title
```
text-sm font-medium leading-none
```

### Link Description
```
line-clamp-2 text-sm leading-snug text-muted-foreground
```

### Indicator
```
top-full z-[1] flex h-1.5 items-end justify-center overflow-hidden
data-[state=visible]:animate-in data-[state=hidden]:animate-out
data-[state=hidden]:fade-out data-[state=visible]:fade-in
```

### Indicator Arrow
```
relative top-[60%] h-2 w-2 rotate-45 rounded-tl-sm bg-border shadow-md
```

## Props Interface
```typescript
interface NavigationMenuProps {
  children: React.ReactNode
  className?: string
  orientation?: 'horizontal' | 'vertical'
  delayDuration?: number
  skipDelayDuration?: number
}

interface NavigationMenuListProps {
  children: React.ReactNode
  className?: string
}

interface NavigationMenuItemProps {
  children: React.ReactNode
  value?: string
}

interface NavigationMenuTriggerProps {
  children: React.ReactNode
  className?: string
}

interface NavigationMenuContentProps {
  children: React.ReactNode
  className?: string
}

interface NavigationMenuLinkProps {
  href: string
  children: React.ReactNode
  className?: string
  active?: boolean
}
```

## Do
- Use Radix NavigationMenu primitive
- Support keyboard navigation (arrow keys)
- Include proper ARIA attributes
- Allow for mega-menu content layouts
- Handle hover/focus delays appropriately

## Don't
- Hardcode colors or sizes
- Nest navigation menus
- Skip focus management
- Forget mobile responsiveness (consider hamburger on small screens)

## Example
```tsx
import * as NavigationMenuPrimitive from '@radix-ui/react-navigation-menu'
import { ChevronDown } from 'lucide-react'
import { cn } from '@/lib/utils'

const NavigationMenu = ({ className, children, ...props }) => (
  <NavigationMenuPrimitive.Root
    className={cn(
      'relative z-10 flex max-w-max flex-1 items-center justify-center',
      className
    )}
    {...props}
  >
    {children}
    <NavigationMenuViewport />
  </NavigationMenuPrimitive.Root>
)

const NavigationMenuList = ({ className, ...props }) => (
  <NavigationMenuPrimitive.List
    className={cn(
      'group flex flex-1 list-none items-center justify-center space-x-1',
      className
    )}
    {...props}
  />
)

const NavigationMenuItem = NavigationMenuPrimitive.Item

const NavigationMenuTrigger = ({ className, children, ...props }) => (
  <NavigationMenuPrimitive.Trigger
    className={cn(
      'group inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2',
      'text-sm font-medium transition-colors',
      'hover:bg-muted hover:text-foreground',
      'focus:bg-muted focus:text-foreground focus:outline-none',
      'disabled:pointer-events-none disabled:opacity-50',
      'data-[state=open]:bg-muted/50',
      className
    )}
    {...props}
  >
    {children}
    <ChevronDown
      className="relative top-[1px] ml-1 h-3 w-3 transition duration-300 group-data-[state=open]:rotate-180"
      aria-hidden="true"
    />
  </NavigationMenuPrimitive.Trigger>
)

const NavigationMenuContent = ({ className, ...props }) => (
  <NavigationMenuPrimitive.Content
    className={cn(
      'left-0 top-0 w-full',
      'data-[motion^=from-]:animate-in data-[motion^=to-]:animate-out',
      'data-[motion^=from-]:fade-in data-[motion^=to-]:fade-out',
      'data-[motion=from-end]:slide-in-from-right-52',
      'data-[motion=from-start]:slide-in-from-left-52',
      'data-[motion=to-end]:slide-out-to-right-52',
      'data-[motion=to-start]:slide-out-to-left-52',
      'md:absolute md:w-auto',
      className
    )}
    {...props}
  />
)

const NavigationMenuLink = NavigationMenuPrimitive.Link

const NavigationMenuViewport = ({ className, ...props }) => (
  <div className="absolute left-0 top-full flex justify-center">
    <NavigationMenuPrimitive.Viewport
      className={cn(
        'origin-top-center relative mt-1.5',
        'h-[var(--radix-navigation-menu-viewport-height)]',
        'w-full overflow-hidden rounded-lg border border-border',
        'bg-popover text-popover-foreground shadow-lg',
        'data-[state=open]:animate-in data-[state=closed]:animate-out',
        'data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-90',
        'md:w-[var(--radix-navigation-menu-viewport-width)]',
        className
      )}
      {...props}
    />
  </div>
)

const NavigationMenuIndicator = ({ className, ...props }) => (
  <NavigationMenuPrimitive.Indicator
    className={cn(
      'top-full z-[1] flex h-1.5 items-end justify-center overflow-hidden',
      'data-[state=visible]:animate-in data-[state=hidden]:animate-out',
      'data-[state=hidden]:fade-out data-[state=visible]:fade-in',
      className
    )}
    {...props}
  >
    <div className="relative top-[60%] h-2 w-2 rotate-45 rounded-tl-sm bg-border shadow-md" />
  </NavigationMenuPrimitive.Indicator>
)

// List item component for content
const ListItem = ({ className, title, children, href, ...props }) => (
  <li>
    <NavigationMenuLink asChild>
      <a
        href={href}
        className={cn(
          'block select-none space-y-1 rounded-md p-3 leading-none no-underline outline-none',
          'transition-colors hover:bg-muted hover:text-foreground focus:bg-muted focus:text-foreground',
          className
        )}
        {...props}
      >
        <div className="text-sm font-medium leading-none">{title}</div>
        <p className="line-clamp-2 text-sm leading-snug text-muted-foreground">
          {children}
        </p>
      </a>
    </NavigationMenuLink>
  </li>
)

// Usage example
<NavigationMenu>
  <NavigationMenuList>
    <NavigationMenuItem>
      <NavigationMenuTrigger>Products</NavigationMenuTrigger>
      <NavigationMenuContent>
        <ul className="grid gap-3 p-6 md:w-[400px] lg:w-[500px] lg:grid-cols-2">
          <ListItem href="/products/analytics" title="Analytics">
            Track user behavior and measure performance.
          </ListItem>
          <ListItem href="/products/automation" title="Automation">
            Automate workflows and save time.
          </ListItem>
          <ListItem href="/products/security" title="Security">
            Protect your data with enterprise-grade security.
          </ListItem>
          <ListItem href="/products/integrations" title="Integrations">
            Connect with your favorite tools.
          </ListItem>
        </ul>
      </NavigationMenuContent>
    </NavigationMenuItem>

    <NavigationMenuItem>
      <NavigationMenuTrigger>Resources</NavigationMenuTrigger>
      <NavigationMenuContent>
        <ul className="grid w-[400px] gap-3 p-4 md:w-[500px] md:grid-cols-2">
          <ListItem href="/docs" title="Documentation">
            Learn how to use our platform.
          </ListItem>
          <ListItem href="/blog" title="Blog">
            Read the latest updates and tutorials.
          </ListItem>
        </ul>
      </NavigationMenuContent>
    </NavigationMenuItem>

    <NavigationMenuItem>
      <NavigationMenuLink
        href="/pricing"
        className="inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2 text-sm font-medium transition-colors hover:bg-muted"
      >
        Pricing
      </NavigationMenuLink>
    </NavigationMenuItem>
  </NavigationMenuList>
</NavigationMenu>
```
