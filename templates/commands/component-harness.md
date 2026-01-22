Launch the visual component harness to preview and iterate on your design system components.

## Prerequisites
- Run `/setup-styling` first to generate styling config and component recipes
- Node.js 18+ installed

## Workflow

1. **Check for styling config**
   - If `.claude/styling-config.json` doesn't exist, prompt to run `/setup-styling` first

2. **Check if component-harness exists**
   - Look for `component-harness/` directory in project root
   - If not found, scaffold it from templates

3. **Scaffold component-harness** (if needed)
   Create the following structure:
   ```
   component-harness/
   ├── index.html
   ├── main.tsx
   ├── App.tsx
   ├── Gallery.tsx
   ├── ComponentPreview.tsx
   ├── components/           # Generated components go here
   │   ├── Button.tsx
   │   ├── Card.tsx
   │   └── ...
   ├── lib/
   │   └── utils.ts          # cn() utility
   ├── vite.config.ts
   ├── tailwind.config.ts
   ├── postcss.config.js
   ├── tsconfig.json
   └── package.json
   ```

4. **Generate components from recipes**
   - Read each `.claude/component-recipes/*.md` file
   - Generate corresponding component in `component-harness/components/`
   - Use tokens from `.claude/styling-config.json`

5. **Install dependencies** (if package.json is new)
   ```bash
   cd component-harness && npm install
   ```

6. **Start dev server**
   ```bash
   cd component-harness && npm run dev
   ```

7. **Open browser**
   - Open `http://localhost:5173` (or configured port)

## Harness Features

### Navigation
- Left/right chevron buttons to cycle through components
- Component name displayed in header
- Variant selector for components with multiple variants

### Live Preview
- Component rendered in isolated preview area
- Props can be adjusted in real-time
- Dark/light mode toggle

### Change Requests
- "Request Change" button that:
  1. Prompts user to describe desired change
  2. Claude updates the recipe and regenerates component
  3. HMR updates the preview instantly

## Generated Gallery.tsx Structure

```tsx
// Core navigation and preview
- useState for currentComponentIndex
- Array of all components with their variants
- Left/Right chevron navigation
- Component name + variant display
- Isolated preview area
- "Request Change" button
```

## package.json Dependencies

```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0",
    "lucide-react": "^0.300.0",
    "@radix-ui/react-slot": "^1.0.0"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.0.0",
    "typescript": "^5.0.0",
    "tailwindcss": "^3.4.0",
    "postcss": "^8.0.0",
    "autoprefixer": "^10.0.0"
  }
}
```

$ARGUMENTS
