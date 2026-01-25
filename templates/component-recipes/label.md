# Label Component Recipe

## Structure
- Text label associated with form controls
- Uses htmlFor to link to input elements
- Support for required indicator
- Support for disabled state
- Optional description/helper text

## Tailwind Classes

### Base
```
text-sm font-medium leading-none
peer-disabled:cursor-not-allowed peer-disabled:opacity-70
```

### Required Indicator
```
text-destructive ml-1
```

### Optional Indicator
```
text-muted-foreground ml-1 font-normal
```

### Description
```
text-sm text-muted-foreground
```

### With Input Group
```
Container: space-y-2
Label + Input: flex flex-col gap-1.5
Inline: flex items-center gap-2
```

### Sizes
```
sm: text-xs
md: text-sm (default)
lg: text-base
```

### Error State
```
text-destructive
```

## Props Interface
```typescript
interface LabelProps extends React.LabelHTMLAttributes<HTMLLabelElement> {
  required?: boolean
  optional?: boolean
  disabled?: boolean
  error?: boolean
  className?: string
  children: React.ReactNode
}

interface LabelWithDescriptionProps extends LabelProps {
  description?: string
}

interface FormFieldProps {
  label: string
  description?: string
  error?: string
  required?: boolean
  children: React.ReactNode
}
```

## Do
- Always use htmlFor to associate with input
- Use Radix Label primitive for accessibility
- Include required indicator for required fields
- Keep labels concise and clear

## Don't
- Hardcode colors
- Use placeholder as label substitute
- Hide labels (use sr-only if visually hidden)
- Forget to link label to input

## Example
```tsx
import * as LabelPrimitive from '@radix-ui/react-label'
import { cn } from '@/lib/utils'

const Label = ({
  className,
  required,
  optional,
  disabled,
  error,
  children,
  ...props
}: LabelProps) => (
  <LabelPrimitive.Root
    className={cn(
      'text-sm font-medium leading-none',
      'peer-disabled:cursor-not-allowed peer-disabled:opacity-70',
      disabled && 'cursor-not-allowed opacity-70',
      error && 'text-destructive',
      className
    )}
    {...props}
  >
    {children}
    {required && <span className="text-destructive ml-1" aria-hidden="true">*</span>}
    {optional && <span className="text-muted-foreground ml-1 font-normal">(optional)</span>}
  </LabelPrimitive.Root>
)

// Label with description
const LabelWithDescription = ({
  description,
  children,
  ...props
}: LabelWithDescriptionProps) => (
  <div className="space-y-1">
    <Label {...props}>{children}</Label>
    {description && (
      <p className="text-sm text-muted-foreground">{description}</p>
    )}
  </div>
)

// Complete form field wrapper
const FormField = ({
  label,
  description,
  error,
  required,
  children,
  className,
}: FormFieldProps) => {
  const id = React.useId()

  return (
    <div className={cn('space-y-2', className)}>
      <Label htmlFor={id} required={required} error={!!error}>
        {label}
      </Label>
      {description && !error && (
        <p className="text-sm text-muted-foreground">{description}</p>
      )}
      {React.cloneElement(children as React.ReactElement, { id, 'aria-invalid': !!error })}
      {error && (
        <p className="text-sm text-destructive" role="alert">{error}</p>
      )}
    </div>
  )
}

// Inline label (for checkboxes/radios)
const InlineLabel = ({ className, children, ...props }: LabelProps) => (
  <Label
    className={cn('font-normal cursor-pointer', className)}
    {...props}
  >
    {children}
  </Label>
)

// Usage examples

// Basic label with input
<div className="space-y-2">
  <Label htmlFor="email">Email address</Label>
  <Input id="email" type="email" placeholder="you@example.com" />
</div>

// Required field
<div className="space-y-2">
  <Label htmlFor="name" required>Full name</Label>
  <Input id="name" required />
</div>

// Optional field
<div className="space-y-2">
  <Label htmlFor="phone" optional>Phone number</Label>
  <Input id="phone" type="tel" />
</div>

// With description
<LabelWithDescription
  htmlFor="password"
  description="Must be at least 8 characters with one number"
>
  Password
</LabelWithDescription>
<Input id="password" type="password" />

// With error
<div className="space-y-2">
  <Label htmlFor="username" error>Username</Label>
  <Input id="username" aria-invalid className="border-destructive" />
  <p className="text-sm text-destructive">Username is already taken</p>
</div>

// Form field wrapper
<FormField
  label="Email"
  description="We'll never share your email"
  required
  error={errors.email?.message}
>
  <Input type="email" {...register('email')} />
</FormField>

// Inline with checkbox
<div className="flex items-center gap-2">
  <Checkbox id="terms" />
  <InlineLabel htmlFor="terms">
    I agree to the <a href="/terms" className="underline">terms and conditions</a>
  </InlineLabel>
</div>

// Inline with switch
<div className="flex items-center justify-between">
  <Label htmlFor="notifications" className="flex flex-col gap-1">
    <span>Email notifications</span>
    <span className="text-sm font-normal text-muted-foreground">
      Receive emails about your account activity
    </span>
  </Label>
  <Switch id="notifications" />
</div>

// Horizontal layout
<div className="grid grid-cols-4 items-center gap-4">
  <Label htmlFor="name" className="text-right">Name</Label>
  <Input id="name" className="col-span-3" />
</div>
```

## Accessibility Notes
```typescript
// Always associate label with input
<Label htmlFor="input-id">Label text</Label>
<Input id="input-id" />

// For screen readers, hidden but accessible
<Label htmlFor="search" className="sr-only">Search</Label>
<Input id="search" placeholder="Search…" />

// Required fields should have aria-required
<Label htmlFor="email" required>Email</Label>
<Input id="email" aria-required="true" required />

// Error states need aria-invalid and aria-describedby
<Label htmlFor="password">Password</Label>
<Input id="password" aria-invalid="true" aria-describedby="password-error" />
<p id="password-error" role="alert">Password is too short</p>
```
