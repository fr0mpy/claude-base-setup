import { useState } from 'react'
import { Gallery } from './Gallery'
import { Moon, Sun } from 'lucide-react'

function App() {
  const [darkMode, setDarkMode] = useState(false)

  return (
    <div className={darkMode ? 'dark' : ''}>
      <div className="min-h-screen bg-background text-foreground">
        {/* Header */}
        <header className="border-b border-border bg-surface px-6 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-xl font-semibold">Component Harness</h1>
              <p className="text-sm text-muted-foreground">
                Preview and iterate on your design system
              </p>
            </div>
            <button
              onClick={() => setDarkMode(!darkMode)}
              className="rounded-lg border border-border p-2 hover:bg-muted transition-colors"
              aria-label="Toggle dark mode"
            >
              {darkMode ? <Sun className="h-5 w-5" /> : <Moon className="h-5 w-5" />}
            </button>
          </div>
        </header>

        {/* Gallery */}
        <Gallery />
      </div>
    </div>
  )
}

export default App
