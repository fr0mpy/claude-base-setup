import React from 'react'

interface ComponentPreviewProps {
  component: React.ComponentType<any>
  variant: {
    label: string
    props?: Record<string, any>
    render?: () => React.ReactNode
  }
}

export function ComponentPreview({ component: Component, variant }: ComponentPreviewProps) {
  return (
    <div className="flex items-center justify-center">
      <div className="rounded-xl border border-border bg-background p-12 shadow-sm">
        <div className="flex items-center justify-center min-h-[100px] min-w-[200px]">
          {variant.render ? (
            variant.render()
          ) : (
            <Component {...variant.props} />
          )}
        </div>
      </div>
    </div>
  )
}
