# Slider Component Recipe

## Structure
- Track with filled range indicator
- Draggable thumb(s)
- Support single value or range (two thumbs)
- Optional step markers and value display

## Tailwind Classes

### Root Container
```
relative flex w-full touch-none select-none items-center
```

### Track
```
relative h-1.5 w-full grow overflow-hidden rounded-full bg-muted
```

### Range (filled portion)
```
absolute h-full bg-primary
```

### Thumb
```
block h-4 w-4 rounded-full border border-primary/50 bg-background shadow
transition-colors
focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary
disabled:pointer-events-none disabled:opacity-50
hover:border-primary
```

### Sizes
```
sm: Track h-1, Thumb h-3 w-3
md: Track h-1.5, Thumb h-4 w-4 (default)
lg: Track h-2, Thumb h-5 w-5
```

### With Value Display
```
Value label: absolute -top-7 left-1/2 -translate-x-1/2 text-xs font-medium
```

## Props Interface
```typescript
interface SliderProps {
  value?: number[]
  defaultValue?: number[]
  onValueChange?: (value: number[]) => void
  min?: number
  max?: number
  step?: number
  disabled?: boolean
  orientation?: 'horizontal' | 'vertical'
  inverted?: boolean
  minStepsBetweenThumbs?: number
}
```

## Do
- Use Radix Slider for accessibility
- Support keyboard navigation (arrows, Home, End)
- Show current value on drag (tooltip or label)
- Support both single and range modes

## Don't
- Hardcode colors
- Forget touch support
- Skip min/max/step configuration
- Use for non-numeric values

## Example
```tsx
import * as SliderPrimitive from '@radix-ui/react-slider'
import { cn } from '@/lib/utils'

const Slider = ({ className, ...props }) => (
  <SliderPrimitive.Root
    className={cn(
      'relative flex w-full touch-none select-none items-center',
      className
    )}
    {...props}
  >
    <SliderPrimitive.Track className="relative h-1.5 w-full grow overflow-hidden rounded-full bg-muted">
      <SliderPrimitive.Range className="absolute h-full bg-primary" />
    </SliderPrimitive.Track>
    <SliderPrimitive.Thumb
      className={cn(
        'block h-4 w-4 rounded-full border border-primary/50 bg-background shadow',
        'transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary',
        'disabled:pointer-events-none disabled:opacity-50 hover:border-primary'
      )}
    />
  </SliderPrimitive.Root>
)

// With value display
const SliderWithValue = ({ value, onValueChange, ...props }) => (
  <div className="space-y-2">
    <div className="flex justify-between text-sm">
      <span className="text-muted-foreground">Value</span>
      <span className="font-medium">{value?.[0] ?? 0}</span>
    </div>
    <Slider value={value} onValueChange={onValueChange} {...props} />
  </div>
)

// Range slider (two thumbs)
<Slider defaultValue={[25, 75]} max={100} step={1} />
```
