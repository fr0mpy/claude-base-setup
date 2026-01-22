# Carousel Component Recipe

## Structure
- Container with overflow hidden
- Scrollable track with items
- Previous/Next navigation buttons
- Optional pagination dots
- Support for auto-play
- Touch/swipe support

## Tailwind Classes

### Container
```
relative w-full overflow-hidden
```

### Track
```
flex transition-transform duration-300 ease-out
```

### Item
```
min-w-0 shrink-0 grow-0
```

### Item Sizes
```
full: basis-full
half: basis-1/2
third: basis-1/3
quarter: basis-1/4
```

### Navigation Buttons
```
absolute top-1/2 -translate-y-1/2 z-10
inline-flex items-center justify-center
h-10 w-10 {tokens.radius}
bg-background/80 backdrop-blur-sm border border-border
hover:bg-muted
disabled:opacity-50 disabled:pointer-events-none
transition-colors

Previous: left-2
Next: right-2
```

### Pagination Dots
```
Container: absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2
Dot: h-2 w-2 rounded-full bg-background/50 transition-colors
Dot active: bg-background
```

### With Gap
```
Track: -ml-4 (negative margin)
Item: pl-4 (padding for gap)
```

## Props Interface
```typescript
interface CarouselProps {
  children: React.ReactNode
  slidesPerView?: number | 'auto'
  spaceBetween?: number
  loop?: boolean
  autoplay?: boolean | { delay: number }
  showNavigation?: boolean
  showPagination?: boolean
  className?: string
}

interface CarouselItemProps {
  children: React.ReactNode
  className?: string
}

interface CarouselApi {
  scrollPrev: () => void
  scrollNext: () => void
  scrollTo: (index: number) => void
  canScrollPrev: boolean
  canScrollNext: boolean
  selectedIndex: number
}
```

## Do
- Use embla-carousel for robust implementation
- Support touch/swipe gestures
- Provide keyboard navigation
- Include aria labels for accessibility
- Respect reduced-motion preferences

## Don't
- Hardcode colors or dimensions
- Auto-play without user control to pause
- Forget mobile responsiveness
- Skip focus management

## Example
```tsx
import { useCallback, useEffect, useState } from 'react'
import useEmblaCarousel from 'embla-carousel-react'
import { ChevronLeft, ChevronRight } from 'lucide-react'
import { cn } from '@/lib/utils'

const Carousel = ({
  children,
  showNavigation = true,
  showPagination = true,
  loop = false,
  className,
  ...options
}) => {
  const [emblaRef, emblaApi] = useEmblaCarousel({ loop, ...options })
  const [canScrollPrev, setCanScrollPrev] = useState(false)
  const [canScrollNext, setCanScrollNext] = useState(false)
  const [selectedIndex, setSelectedIndex] = useState(0)
  const [scrollSnaps, setScrollSnaps] = useState<number[]>([])

  const scrollPrev = useCallback(() => emblaApi?.scrollPrev(), [emblaApi])
  const scrollNext = useCallback(() => emblaApi?.scrollNext(), [emblaApi])
  const scrollTo = useCallback((index: number) => emblaApi?.scrollTo(index), [emblaApi])

  const onSelect = useCallback(() => {
    if (!emblaApi) return
    setSelectedIndex(emblaApi.selectedScrollSnap())
    setCanScrollPrev(emblaApi.canScrollPrev())
    setCanScrollNext(emblaApi.canScrollNext())
  }, [emblaApi])

  useEffect(() => {
    if (!emblaApi) return
    setScrollSnaps(emblaApi.scrollSnapList())
    onSelect()
    emblaApi.on('select', onSelect)
    emblaApi.on('reInit', onSelect)
    return () => {
      emblaApi.off('select', onSelect)
      emblaApi.off('reInit', onSelect)
    }
  }, [emblaApi, onSelect])

  return (
    <div className={cn('relative w-full', className)} aria-roledescription="carousel">
      <div ref={emblaRef} className="overflow-hidden">
        <div className="flex -ml-4">
          {children}
        </div>
      </div>

      {showNavigation && (
        <>
          <button
            onClick={scrollPrev}
            disabled={!canScrollPrev}
            className={cn(
              'absolute left-2 top-1/2 -translate-y-1/2 z-10',
              'inline-flex items-center justify-center h-10 w-10 rounded-full',
              'bg-background/80 backdrop-blur-sm border border-border',
              'hover:bg-muted transition-colors',
              'disabled:opacity-50 disabled:pointer-events-none'
            )}
            aria-label="Previous slide"
          >
            <ChevronLeft className="h-5 w-5" />
          </button>
          <button
            onClick={scrollNext}
            disabled={!canScrollNext}
            className={cn(
              'absolute right-2 top-1/2 -translate-y-1/2 z-10',
              'inline-flex items-center justify-center h-10 w-10 rounded-full',
              'bg-background/80 backdrop-blur-sm border border-border',
              'hover:bg-muted transition-colors',
              'disabled:opacity-50 disabled:pointer-events-none'
            )}
            aria-label="Next slide"
          >
            <ChevronRight className="h-5 w-5" />
          </button>
        </>
      )}

      {showPagination && scrollSnaps.length > 1 && (
        <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2">
          {scrollSnaps.map((_, index) => (
            <button
              key={index}
              onClick={() => scrollTo(index)}
              className={cn(
                'h-2 w-2 rounded-full transition-colors',
                index === selectedIndex
                  ? 'bg-primary'
                  : 'bg-primary/30 hover:bg-primary/50'
              )}
              aria-label={`Go to slide ${index + 1}`}
              aria-current={index === selectedIndex ? 'true' : undefined}
            />
          ))}
        </div>
      )}
    </div>
  )
}

const CarouselItem = ({ children, className }) => (
  <div
    className={cn('min-w-0 shrink-0 grow-0 basis-full pl-4', className)}
    role="group"
    aria-roledescription="slide"
  >
    {children}
  </div>
)

// With autoplay
const AutoplayCarousel = ({ children, delay = 4000, ...props }) => {
  const [emblaRef, emblaApi] = useEmblaCarousel({ loop: true })
  const [isPaused, setIsPaused] = useState(false)

  useEffect(() => {
    if (!emblaApi || isPaused) return
    const interval = setInterval(() => emblaApi.scrollNext(), delay)
    return () => clearInterval(interval)
  }, [emblaApi, delay, isPaused])

  return (
    <div
      onMouseEnter={() => setIsPaused(true)}
      onMouseLeave={() => setIsPaused(false)}
    >
      <Carousel {...props}>{children}</Carousel>
    </div>
  )
}

// Usage examples
<Carousel>
  <CarouselItem>
    <img src="/slide-1.jpg" alt="Slide 1" className="w-full aspect-video object-cover rounded-lg" />
  </CarouselItem>
  <CarouselItem>
    <img src="/slide-2.jpg" alt="Slide 2" className="w-full aspect-video object-cover rounded-lg" />
  </CarouselItem>
  <CarouselItem>
    <img src="/slide-3.jpg" alt="Slide 3" className="w-full aspect-video object-cover rounded-lg" />
  </CarouselItem>
</Carousel>

// Multiple slides visible
<Carousel slidesPerView={3}>
  {products.map((product) => (
    <CarouselItem key={product.id} className="basis-1/3">
      <ProductCard product={product} />
    </CarouselItem>
  ))}
</Carousel>

// Card carousel
<Carousel showPagination={false}>
  {testimonials.map((t) => (
    <CarouselItem key={t.id}>
      <Card className="mx-4">
        <CardContent className="p-6">
          <p className="text-muted-foreground">{t.quote}</p>
          <p className="mt-4 font-medium">{t.author}</p>
        </CardContent>
      </Card>
    </CarouselItem>
  ))}
</Carousel>
```
