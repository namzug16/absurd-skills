# Input

- JavaScript: none (CSS only)

## Usage

Add `class="input"` to supported `<input>` elements. Inputs inside a `class="field"` container also receive the same styling automatically for common text-like input types.

Use native HTML attributes for behavior: `disabled` for disabled inputs, `required` for required fields, and `aria-invalid="true"` for invalid state styling.

```html
<input class="input" type="email" placeholder="Email" />
```

## Examples

### Basic

```html
<input class="input" type="email" placeholder="Email" />
```

### Field

Use `field` with a label and description to create an accessible field.

```html
<div role="group" class="field">
  <label for="input-field">Email</label>
  <input id="input-field" type="email" placeholder="m@example.com" />
  <p>Enter your email address.</p>
</div>
```

### Field group

```html
<div class="grid gap-4">
  <div role="group" class="field">
    <label for="input-first-name">First name</label>
    <input id="input-first-name" type="text" placeholder="Jane" />
  </div>
  <div role="group" class="field">
    <label for="input-last-name">Last name</label>
    <input id="input-last-name" type="text" placeholder="Doe" />
  </div>
</div>
```

### Disabled

```html
<input class="input" type="email" placeholder="Email" disabled />
```

### Invalid

```html
<input class="input" type="email" placeholder="Email" aria-invalid="true" />
```

### File

```html
<input class="input" type="file" />
```

### Inline

```html
<div class="flex items-center gap-2">
  <input class="input" type="search" placeholder="Search..." />
  <button type="submit" class="btn">Search</button>
</div>
```

### Grid

```html
<div class="grid gap-4 md:grid-cols-2">
  <input class="input" type="text" placeholder="First name" />
  <input class="input" type="text" placeholder="Last name" />
  <input class="input md:col-span-2" type="email" placeholder="Email" />
</div>
```

### Required

```html
<div role="group" class="field">
  <label for="input-required">Username <span class="text-destructive">*</span></label>
  <input id="input-required" type="text" placeholder="hunvreus" required />
</div>
```

### Badge

```html
<div role="group" class="field">
  <label for="input-badge" class="flex w-full items-center gap-2">
    Email
    <span class="badge ml-auto" data-variant="secondary">Recommended</span>
  </label>
  <input id="input-badge" type="email" placeholder="m@example.com" />
</div>
```

### Input group

Use the [Input Group](./input-group.md) patterns to add icons, text, or buttons inside an input.

```html
<div class="relative">
  <input class="input ps-9" type="search" placeholder="Search..." />
  <div class="pointer-events-none absolute start-3 top-1/2 -translate-y-1/2 text-muted-foreground [&>svg]:size-4"><svg><!-- search --></svg>
  </div>
</div>
```

### Button group

Use [Button Group](./button-group.md) when an input should be grouped with adjacent buttons.

```html
<div role="group" aria-label="Search" class="button-group">
  <input class="input" type="search" placeholder="Search..." />
  <button type="submit" class="btn" data-variant="outline" data-size="icon" aria-label="Search"><svg><!-- search --></svg></button>
</div>
```

### Form

```html
<form class="space-y-6">
  <div role="group" class="field">
    <label for="input-form-username">Username</label>
    <input id="input-form-username" type="text" placeholder="hunvreus" required />
    <p>This is your public display name.</p>
  </div>
  <div role="group" class="field">
    <label for="input-form-email">Email</label>
    <input id="input-form-email" type="email" placeholder="m@example.com" required />
  </div>
  <button type="submit" class="btn">Submit</button>
</form>
```
