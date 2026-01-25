# Context Menu Component Recipe

## Structure
- Right-click triggered menu
- Same item types as Dropdown Menu
- Support for submenus
- Keyboard shortcuts display
- Checkboxes and radio items

## Tailwind Classes

### Trigger (wrapper around target element)
```
(invisible wrapper, no styles)
```

### Content
```
z-50 min-w-[8rem] overflow-hidden {tokens.radius} border border-border
bg-background p-1 text-foreground {tokens.shadow}
animate-in fade-in-80
data-open:animate-in data-closed:animate-out
data-closed:fade-out-0 data-open:fade-in-0
data-closed:zoom-out-95 data-open:zoom-in-95
data-[side=bottom]:slide-in-from-top-2
data-[side=left]:slide-in-from-right-2
data-[side=right]:slide-in-from-left-2
data-[side=top]:slide-in-from-bottom-2
```

### Item
```
relative flex cursor-pointer select-none items-center {tokens.radius} px-2 py-1.5
text-sm outline-none
focus:bg-muted focus:text-foreground
data-disabled:pointer-events-none data-disabled:opacity-50
```

### Item with Inset (for alignment with checkbox items)
```
pl-8
```

### Checkbox Item
```
relative flex cursor-pointer select-none items-center {tokens.radius} py-1.5 pl-8 pr-2
text-sm outline-none
focus:bg-muted focus:text-foreground
data-disabled:pointer-events-none data-disabled:opacity-50
```

### Radio Item
```
relative flex cursor-pointer select-none items-center {tokens.radius} py-1.5 pl-8 pr-2
text-sm outline-none
focus:bg-muted focus:text-foreground
data-disabled:pointer-events-none data-disabled:opacity-50
```

### Item Indicator
```
absolute left-2 flex h-3.5 w-3.5 items-center justify-center
```

### Label
```
px-2 py-1.5 font-heading text-sm font-semibold text-foreground
```

### Separator
```
-mx-1 my-1 h-px bg-border
```

### Shortcut
```
ml-auto text-xs tracking-widest text-muted-foreground
```

### Sub Trigger
```
flex cursor-pointer select-none items-center {tokens.radius} px-2 py-1.5
text-sm outline-none
focus:bg-muted
data-open:bg-muted
```

### Sub Content
```
z-50 min-w-[8rem] overflow-hidden {tokens.radius} border border-border
bg-background p-1 {tokens.shadow}
data-open:animate-in data-closed:animate-out
```

## Props Interface
```typescript
interface ContextMenuProps {
  children: React.ReactNode
  onOpenChange?: (open: boolean) => void
}

interface ContextMenuTriggerProps {
  children: React.ReactNode
  disabled?: boolean
  asChild?: boolean
}

interface ContextMenuContentProps {
  className?: string
  alignOffset?: number
  children: React.ReactNode
}

interface ContextMenuItemProps {
  inset?: boolean
  disabled?: boolean
  onSelect?: () => void
  children: React.ReactNode
}

// Same as DropdownMenu for CheckboxItem, RadioGroup, RadioItem, etc.
```

## Do
- Use Base UI ContextMenu for accessibility
- Support all item types (checkbox, radio, sub-menus)
- Show keyboard shortcuts
- Handle touch devices (long-press)

## Don't
- Hardcode colors
- Use for primary navigation
- Forget disabled states
- Skip keyboard navigation

## Example
```tsx
import { Menu as ContextMenuPrimitive } from '@base-ui/react/menu'
import { Check, ChevronRight, Circle } from 'lucide-react'
import { cn } from '@/lib/utils'

const ContextMenu = ContextMenuPrimitive.Root
const ContextMenuTrigger = ContextMenuPrimitive.Trigger
const ContextMenuGroup = ContextMenuPrimitive.Group
const ContextMenuPortal = ContextMenuPrimitive.Portal
const ContextMenuSub = ContextMenuPrimitive.Sub
const ContextMenuRadioGroup = ContextMenuPrimitive.RadioGroup

const ContextMenuContent = ({ className, ...props }) => (
  <ContextMenuPrimitive.Portal>
    <ContextMenuPrimitive.Content
      className={cn(
        'z-50 min-w-[8rem] overflow-hidden rounded-md border border-border bg-background p-1 shadow-md',
        'animate-in fade-in-80',
        'data-open:animate-in data-closed:animate-out',
        'data-closed:fade-out-0 data-open:fade-in-0',
        'data-closed:zoom-out-95 data-open:zoom-in-95',
        'data-[side=bottom]:slide-in-from-top-2',
        className
      )}
      {...props}
    />
  </ContextMenuPrimitive.Portal>
)

const ContextMenuItem = ({ className, inset, ...props }) => (
  <ContextMenuPrimitive.Item
    className={cn(
      'relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none',
      'focus:bg-muted focus:text-foreground',
      'data-disabled:pointer-events-none data-disabled:opacity-50',
      inset && 'pl-8',
      className
    )}
    {...props}
  />
)

const ContextMenuCheckboxItem = ({ className, checked, children, ...props }) => (
  <ContextMenuPrimitive.CheckboxItem
    className={cn(
      'relative flex cursor-pointer select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none',
      'focus:bg-muted focus:text-foreground',
      'data-disabled:pointer-events-none data-disabled:opacity-50',
      className
    )}
    checked={checked}
    {...props}
  >
    <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <ContextMenuPrimitive.ItemIndicator>
        <Check className="h-4 w-4" />
      </ContextMenuPrimitive.ItemIndicator>
    </span>
    {children}
  </ContextMenuPrimitive.CheckboxItem>
)

const ContextMenuRadioItem = ({ className, children, ...props }) => (
  <ContextMenuPrimitive.RadioItem
    className={cn(
      'relative flex cursor-pointer select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none',
      'focus:bg-muted focus:text-foreground',
      'data-disabled:pointer-events-none data-disabled:opacity-50',
      className
    )}
    {...props}
  >
    <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <ContextMenuPrimitive.ItemIndicator>
        <Circle className="h-2 w-2 fill-current" />
      </ContextMenuPrimitive.ItemIndicator>
    </span>
    {children}
  </ContextMenuPrimitive.RadioItem>
)

const ContextMenuLabel = ({ className, inset, ...props }) => (
  <ContextMenuPrimitive.Label
    className={cn('px-2 py-1.5 text-sm font-semibold text-foreground', inset && 'pl-8', className)}
    {...props}
  />
)

const ContextMenuSeparator = ({ className, ...props }) => (
  <ContextMenuPrimitive.Separator className={cn('-mx-1 my-1 h-px bg-border', className)} {...props} />
)

const ContextMenuShortcut = ({ className, ...props }) => (
  <span className={cn('ml-auto text-xs tracking-widest text-muted-foreground', className)} {...props} />
)

// Usage
<ContextMenu>
  <ContextMenuTrigger className="flex h-32 w-full items-center justify-center rounded-md border border-dashed">
    Right click here
  </ContextMenuTrigger>
  <ContextMenuContent className="w-64">
    <ContextMenuItem>
      Back
      <ContextMenuShortcut>⌘[</ContextMenuShortcut>
    </ContextMenuItem>
    <ContextMenuItem disabled>
      Forward
      <ContextMenuShortcut>⌘]</ContextMenuShortcut>
    </ContextMenuItem>
    <ContextMenuSeparator />
    <ContextMenuCheckboxItem checked>
      Show Bookmarks
      <ContextMenuShortcut>⌘⇧B</ContextMenuShortcut>
    </ContextMenuCheckboxItem>
  </ContextMenuContent>
</ContextMenu>
```
