import { useState } from 'react'
import { ChevronLeft, ChevronRight, MessageSquare } from 'lucide-react'
import { ComponentPreview } from './ComponentPreview'

// Import all components - these will be generated from recipes
import * as Components from './components'

// Component registry with variants
const componentRegistry = [
  {
    name: 'Button',
    component: Components.Button,
    variants: [
      { label: 'Primary', props: { variant: 'primary', children: 'Primary Button' } },
      { label: 'Secondary', props: { variant: 'secondary', children: 'Secondary Button' } },
      { label: 'Outline', props: { variant: 'outline', children: 'Outline Button' } },
      { label: 'Ghost', props: { variant: 'ghost', children: 'Ghost Button' } },
      { label: 'Destructive', props: { variant: 'destructive', children: 'Destructive' } },
      { label: 'Small', props: { variant: 'primary', size: 'sm', children: 'Small' } },
      { label: 'Large', props: { variant: 'primary', size: 'lg', children: 'Large' } },
      { label: 'Disabled', props: { variant: 'primary', disabled: true, children: 'Disabled' } },
    ],
  },
  {
    name: 'Card',
    component: Components.Card,
    variants: [
      {
        label: 'Default',
        props: {},
        render: () => (
          <Components.Card>
            <Components.CardHeader>
              <Components.CardTitle>Card Title</Components.CardTitle>
              <Components.CardDescription>Card description goes here.</Components.CardDescription>
            </Components.CardHeader>
            <Components.CardContent>
              <p>Card content with some text.</p>
            </Components.CardContent>
          </Components.Card>
        ),
      },
    ],
  },
  {
    name: 'Input',
    component: Components.Input,
    variants: [
      { label: 'Default', props: { placeholder: 'Enter text...' } },
      { label: 'With value', props: { defaultValue: 'Hello world' } },
      { label: 'Error', props: { placeholder: 'Error state', error: true } },
      { label: 'Disabled', props: { placeholder: 'Disabled', disabled: true } },
    ],
  },
  {
    name: 'Badge',
    component: Components.Badge,
    variants: [
      { label: 'Default', props: { children: 'Badge' } },
      { label: 'Secondary', props: { variant: 'secondary', children: 'Secondary' } },
      { label: 'Outline', props: { variant: 'outline', children: 'Outline' } },
      { label: 'Destructive', props: { variant: 'destructive', children: 'Destructive' } },
    ],
  },
  // Add more components as they are generated...
]

export function Gallery() {
  const [currentIndex, setCurrentIndex] = useState(0)
  const [variantIndex, setVariantIndex] = useState(0)

  const currentComponent = componentRegistry[currentIndex]
  const currentVariant = currentComponent?.variants[variantIndex]

  const goNext = () => {
    if (variantIndex < currentComponent.variants.length - 1) {
      setVariantIndex(variantIndex + 1)
    } else if (currentIndex < componentRegistry.length - 1) {
      setCurrentIndex(currentIndex + 1)
      setVariantIndex(0)
    }
  }

  const goPrev = () => {
    if (variantIndex > 0) {
      setVariantIndex(variantIndex - 1)
    } else if (currentIndex > 0) {
      setCurrentIndex(currentIndex - 1)
      setVariantIndex(componentRegistry[currentIndex - 1].variants.length - 1)
    }
  }

  const canGoNext =
    variantIndex < currentComponent.variants.length - 1 ||
    currentIndex < componentRegistry.length - 1
  const canGoPrev = variantIndex > 0 || currentIndex > 0

  const handleRequestChange = () => {
    const change = prompt(
      `Describe the change you want for ${currentComponent.name} (${currentVariant.label}):`
    )
    if (change) {
      // This would trigger Claude to update the recipe
      console.log('Change requested:', change)
      alert(
        `Change request sent to Claude:\n\n"${change}"\n\nRun the harness command again after Claude updates the recipe.`
      )
    }
  }

  if (!currentComponent) {
    return (
      <div className="flex h-[calc(100vh-80px)] items-center justify-center">
        <p className="text-muted-foreground">No components found. Run /setup-styling first.</p>
      </div>
    )
  }

  return (
    <div className="flex h-[calc(100vh-80px)] flex-col">
      {/* Component info bar */}
      <div className="border-b border-border bg-surface px-6 py-3">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-lg font-medium">{currentComponent.name}</h2>
            <p className="text-sm text-muted-foreground">
              Variant: {currentVariant.label} ({variantIndex + 1}/
              {currentComponent.variants.length})
            </p>
          </div>
          <div className="flex items-center gap-2">
            <span className="text-sm text-muted-foreground">
              {currentIndex + 1} / {componentRegistry.length} components
            </span>
          </div>
        </div>
      </div>

      {/* Preview area */}
      <div className="flex-1 overflow-auto p-8">
        <ComponentPreview
          component={currentComponent.component}
          variant={currentVariant}
        />
      </div>

      {/* Controls */}
      <div className="border-t border-border bg-surface px-6 py-4">
        <div className="flex items-center justify-between">
          <button
            onClick={goPrev}
            disabled={!canGoPrev}
            className="flex items-center gap-2 rounded-lg border border-border px-4 py-2 text-sm font-medium transition-colors hover:bg-muted disabled:cursor-not-allowed disabled:opacity-50"
          >
            <ChevronLeft className="h-4 w-4" />
            Previous
          </button>

          <button
            onClick={handleRequestChange}
            className="flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
          >
            <MessageSquare className="h-4 w-4" />
            Request Change
          </button>

          <button
            onClick={goNext}
            disabled={!canGoNext}
            className="flex items-center gap-2 rounded-lg border border-border px-4 py-2 text-sm font-medium transition-colors hover:bg-muted disabled:cursor-not-allowed disabled:opacity-50"
          >
            Next
            <ChevronRight className="h-4 w-4" />
          </button>
        </div>
      </div>
    </div>
  )
}
