# Accordion Component Recipe

## Structure
- Root container with multiple items
- Each item has trigger (header) and content
- Chevron indicator that rotates on open
- Support single or multiple items open

## Tailwind Classes

### Item
```
border-b border-border
```

### Trigger
```
flex flex-1 items-center justify-between py-4 font-body text-sm font-medium
transition-all hover:underline
[&[data-open]>svg]:rotate-180
```

### Chevron Icon
```
h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200
```

### Content
```
overflow-hidden font-body text-sm
data-closed:animate-accordion-up
data-open:animate-accordion-down
```

### Content Inner
```
pb-4 pt-0
```

## Animations (add to tailwind.config.js)
```js
keyframes: {
  'accordion-down': {
    from: { height: '0' },
    to: { height: 'var(--accordion-content-height)' },
  },
  'accordion-up': {
    from: { height: 'var(--accordion-content-height)' },
    to: { height: '0' },
  },
},
animation: {
  'accordion-down': 'accordion-down 0.2s ease-out',
  'accordion-up': 'accordion-up 0.2s ease-out',
},
```

## Props Interface
```typescript
interface AccordionProps {
  type?: 'single' | 'multiple'
  defaultValue?: string | string[]
  value?: string | string[]
  onValueChange?: (value: string | string[]) => void
  collapsible?: boolean // only for type="single"
  children: React.ReactNode
}

interface AccordionItemProps {
  value: string
  disabled?: boolean
  children: React.ReactNode
}

interface AccordionTriggerProps {
  className?: string
  children: React.ReactNode
}

interface AccordionContentProps {
  className?: string
  children: React.ReactNode
}
```

## Do
- Use Base UI Accordion for accessibility
- Animate height changes smoothly
- Rotate chevron on open
- Support both single and multiple modes

## Don't
- Hardcode colors
- Skip keyboard accessibility
- Use abrupt open/close (animate it)
- Forget border between items

## Example
```tsx
import { Accordion } from '@base-ui-components/react/accordion'
import { ChevronDown } from 'lucide-react'
import { cn } from '@/lib/utils'

const AccordionRoot = Accordion.Root

const AccordionItem = ({ className, ...props }) => (
  <Accordion.Item
    className={cn('border-b border-border', className)}
    {...props}
  />
)

const AccordionTrigger = ({ className, children, ...props }) => (
  <Accordion.Header className="flex">
    <Accordion.Trigger
      className={cn(
        'flex flex-1 items-center justify-between py-4 font-body text-sm font-medium',
        'transition-all hover:underline [&[data-open]>svg]:rotate-180',
        className
      )}
      {...props}
    >
      {children}
      <ChevronDown className="h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200" />
    </Accordion.Trigger>
  </Accordion.Header>
)

const AccordionContent = ({ className, children, ...props }) => (
  <Accordion.Panel
    className="overflow-hidden font-body text-sm data-closed:animate-accordion-up data-open:animate-accordion-down"
    {...props}
  >
    <div className={cn('pb-4 pt-0', className)}>{children}</div>
  </Accordion.Panel>
)

// Usage
<AccordionRoot type="single" collapsible>
  <AccordionItem value="item-1">
    <AccordionTrigger>Is it accessible?</AccordionTrigger>
    <AccordionContent>
      Yes. It adheres to the WAI-ARIA design pattern.
    </AccordionContent>
  </AccordionItem>
  <AccordionItem value="item-2">
    <AccordionTrigger>Is it styled?</AccordionTrigger>
    <AccordionContent>
      Yes. It comes with default styles that match your design system.
    </AccordionContent>
  </AccordionItem>
</AccordionRoot>
```
