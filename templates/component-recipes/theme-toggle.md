# Theme Toggle Component Recipe

## Structure
- Button that toggles between light and dark mode
- Uses Sun/Moon icons with animated transitions
- Persists preference to localStorage
- Respects system preference on first load
- Adds/removes `dark` class on document root

## Tailwind Classes

### Button
```
h-9 w-9 rounded-md
inline-flex items-center justify-center
border border-border bg-background
hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring
transition-colors
cursor-pointer
```

### Icon (Sun - Light Mode)
```
h-4 w-4 transition-all
Light mode: scale-100 rotate-0
Dark mode: scale-0 rotate-90
```

### Icon (Moon - Dark Mode)
```
absolute h-4 w-4 transition-all
Light mode: scale-0 -rotate-90
Dark mode: scale-100 rotate-0
```

## Props Interface
```typescript
interface ThemeToggleProps {
  className?: string
}
```

## Do
- Use semantic color tokens from config
- Persist theme preference to localStorage
- Check system preference on initial load
- Use smooth icon transitions
- Include proper aria-label for accessibility
- Use `cn()` utility for class merging

## Don't
- Hardcode colors (use tokens)
- Forget to handle SSR (check for window)
- Skip the system preference check
- Use abrupt transitions

## Example
```tsx
import { useState, useEffect } from 'react'
import { Moon, Sun } from 'lucide-react'
import { cn } from '@/lib/utils'

type Theme = 'light' | 'dark'

const ThemeToggle = ({ className }: ThemeToggleProps) => {
  const [theme, setTheme] = useState<Theme>(() => {
    // Check localStorage first
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem('theme') as Theme | null
      if (stored) return stored
      // Fall back to system preference
      return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
    }
    return 'light'
  })

  useEffect(() => {
    const root = document.documentElement
    if (theme === 'dark') {
      root.classList.add('dark')
    } else {
      root.classList.remove('dark')
    }
    localStorage.setItem('theme', theme)
  }, [theme])

  const toggle = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light')
  }

  return (
    <button
      type="button"
      onClick={toggle}
      className={cn(
        'relative h-9 w-9 rounded-md',
        'inline-flex items-center justify-center',
        'border border-border bg-background',
        'hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
        'transition-colors',
        className
      )}
      aria-label={`Switch to ${theme === 'light' ? 'dark' : 'light'} mode`}
    >
      <Sun className={cn(
        'h-4 w-4 transition-all',
        theme === 'dark' ? 'scale-0 rotate-90' : 'scale-100 rotate-0'
      )} />
      <Moon className={cn(
        'absolute h-4 w-4 transition-all',
        theme === 'dark' ? 'scale-100 rotate-0' : 'scale-0 -rotate-90'
      )} />
    </button>
  )
}

// Usage
<ThemeToggle />

// Usage with custom className
<ThemeToggle className="ml-auto" />
```

## CSS Setup Required

For the toggle to work, your CSS must define light and dark mode variables:

```css
:root {
  /* Light mode variables */
  --background: 210 20% 98%;
  --foreground: 220 14% 10%;
  /* ... other variables */
}

.dark {
  /* Dark mode variables */
  --background: 224 71% 4%;
  --foreground: 210 20% 98%;
  /* ... other variables */
}
```

## Accessibility
- Uses `aria-label` to announce current action
- Button is keyboard accessible
- Focus ring visible on keyboard navigation
- Icons have implicit presentation role (decorative)
