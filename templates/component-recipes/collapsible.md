# Collapsible Component Recipe

## Structure
- Trigger element to toggle
- Content area that expands/collapses
- Smooth height animation
- Optional chevron indicator

## Tailwind Classes

### Root
```
w-full
```

### Trigger
```
flex items-center justify-between w-full [&[data-open]>svg]:rotate-180
```

### Trigger with default styling
```
flex items-center justify-between w-full py-2 font-body font-medium
transition-all hover:underline
```

### Chevron Icon
```
h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200
```

### Content
```
overflow-hidden
data-closed:animate-collapsible-up
data-open:animate-collapsible-down
```

### Content Inner (for padding)
```
pt-2 pb-4
```

## Animations (add to tailwind.config.js)
```js
keyframes: {
  'collapsible-down': {
    from: { height: '0' },
    to: { height: 'var(--collapsible-content-height)' },
  },
  'collapsible-up': {
    from: { height: 'var(--collapsible-content-height)' },
    to: { height: '0' },
  },
},
animation: {
  'collapsible-down': 'collapsible-down 0.2s ease-out',
  'collapsible-up': 'collapsible-up 0.2s ease-out',
},
```

## Props Interface
```typescript
interface CollapsibleProps {
  open?: boolean
  onOpenChange?: (open: boolean) => void
  defaultOpen?: boolean
  disabled?: boolean
  children: React.ReactNode
}

interface CollapsibleTriggerProps {
  asChild?: boolean
  children: React.ReactNode
}

interface CollapsibleContentProps {
  forceMount?: boolean
  className?: string
  children: React.ReactNode
}
```

## Use Cases
- FAQ sections
- Sidebar navigation groups
- Settings panels
- Advanced options sections
- Code snippets with preview

## Do
- Use Base UI Collapsible for accessibility
- Animate height smoothly
- Include visual indicator of state (chevron)
- Support keyboard toggle (Enter/Space)

## Don't
- Hardcode colors
- Use abrupt show/hide (animate it)
- Nest collapsibles too deeply
- Use for primary content that should always be visible

## Example
```tsx
import { Collapsible } from '@base-ui-components/react/collapsible'
import { ChevronDown } from 'lucide-react'
import { cn } from '@/lib/utils'

const CollapsibleRoot = Collapsible.Root

const CollapsibleTrigger = Collapsible.Trigger

const CollapsibleContent = ({ className, children, ...props }) => (
  <Collapsible.Panel
    className={cn(
      'overflow-hidden',
      'data-closed:animate-collapsible-up',
      'data-open:animate-collapsible-down',
      className
    )}
    {...props}
  >
    {children}
  </Collapsible.Panel>
)

// Simple usage
const SimpleCollapsible = ({ title, children }) => (
  <CollapsibleRoot>
    <CollapsibleTrigger className="flex items-center justify-between w-full py-2 font-body font-medium hover:underline [&[data-open]>svg]:rotate-180">
      {title}
      <ChevronDown className="h-4 w-4 shrink-0 transition-transform duration-200" />
    </CollapsibleTrigger>
    <CollapsibleContent>
      <div className="pt-2 pb-4 font-body">{children}</div>
    </CollapsibleContent>
  </CollapsibleRoot>
)

// With border styling
const CollapsibleCard = ({ title, defaultOpen = false, children }) => (
  <CollapsibleRoot defaultOpen={defaultOpen} className="rounded-lg border border-border">
    <CollapsibleTrigger className="flex items-center justify-between w-full p-4 font-body font-medium [&[data-open]>svg]:rotate-180">
      {title}
      <ChevronDown className="h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200" />
    </CollapsibleTrigger>
    <CollapsibleContent>
      <div className="px-4 pb-4 pt-0 border-t border-border font-body">
        {children}
      </div>
    </CollapsibleContent>
  </CollapsibleRoot>
)

// Sidebar navigation example
const SidebarGroup = ({ label, items, defaultOpen = true }) => (
  <CollapsibleRoot defaultOpen={defaultOpen} className="space-y-2">
    <CollapsibleTrigger className="flex items-center justify-between w-full px-2 py-1.5 text-sm font-semibold text-muted-foreground hover:text-foreground [&[data-open]>svg]:rotate-180">
      {label}
      <ChevronDown className="h-4 w-4 shrink-0 transition-transform duration-200" />
    </CollapsibleTrigger>
    <CollapsibleContent>
      <div className="space-y-1">
        {items.map((item) => (
          <a
            key={item.href}
            href={item.href}
            className="block rounded-md px-2 py-1.5 text-sm hover:bg-muted"
          >
            {item.label}
          </a>
        ))}
      </div>
    </CollapsibleContent>
  </CollapsibleRoot>
)

// Code preview with expand
const CodePreview = ({ preview, code }) => {
  const [open, setOpen] = useState(false)

  return (
    <CollapsibleRoot open={open} onOpenChange={setOpen}>
      <div className="rounded-lg border border-border">
        <div className="p-4">{preview}</div>
        <div className="border-t border-border">
          <CollapsibleTrigger className="flex items-center justify-center w-full py-2 text-sm text-muted-foreground hover:text-foreground">
            {open ? 'Hide code' : 'Show code'}
            <ChevronDown className={cn('ml-1 h-4 w-4 transition-transform', open && 'rotate-180')} />
          </CollapsibleTrigger>
        </div>
        <CollapsibleContent>
          <pre className="p-4 bg-muted text-sm overflow-x-auto">
            <code>{code}</code>
          </pre>
        </CollapsibleContent>
      </div>
    </CollapsibleRoot>
  )
}
```
