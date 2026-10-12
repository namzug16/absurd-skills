# Badge

- JavaScript: none (CSS only)

## Usage

Add `class="badge"` to an inline element. Add `data-variant` when the badge is not the default primary variant.

Inline SVG icons are spaced automatically by the badge gap.

```html
<span class="badge">Default</span>
<span class="badge" data-variant="secondary">Secondary</span>
<span class="badge" data-variant="destructive">Destructive</span>
<span class="badge" data-variant="outline">Outline</span>
<span class="badge" data-variant="ghost">Ghost</span>
```

Badges support right-to-left layouts through native text flow. Flip directional icons explicitly.

## Examples

### Variants

Use `data-variant` to change the badge variant.

```html
<div class="flex flex-wrap gap-2">
  <span class="badge">Default</span>
  <span class="badge" data-variant="secondary">Secondary</span>
  <span class="badge" data-variant="destructive">Destructive</span>
  <span class="badge" data-variant="outline">Outline</span>
  <span class="badge" data-variant="ghost">Ghost</span>
</div>
```

### With icon

Use `data-icon="inline-start"` or `data-icon="inline-end"` on the icon for icon-aware spacing.

```html
<div class="flex flex-wrap gap-2">
  <span class="badge"><svg data-icon="inline-start"><!-- badge-check --></svg>
    Verified
  </span>
  <span class="badge" data-variant="secondary">
    Bookmark
    <svg data-icon="inline-end"><!-- bookmark --></svg>
  </span>
</div>
```

### With spinner

Use an inline loading icon with `data-icon="inline-start"` or `data-icon="inline-end"`.

```html
<div class="flex flex-wrap gap-2">
  <span class="badge" data-variant="destructive"><svg aria-label="Loading" role="status" data-icon="inline-start" class="animate-spin"><!-- loader-circle --></svg>
    Deleting
  </span>
  <span class="badge" data-variant="secondary">
    Generating
    <svg aria-label="Loading" role="status" data-icon="inline-end" class="animate-spin"><!-- loader-circle --></svg>
  </span>
</div>
```

### Link

```html
<a href="#" class="badge">
  Open Link
  <svg data-icon="inline-end"><!-- arrow-up-right --></svg>
</a>
```

### Custom colors

```html
<div class="flex flex-wrap gap-2">
  <span class="badge bg-blue-50 text-blue-700 dark:bg-blue-950 dark:text-blue-300">Blue</span>
  <span class="badge bg-green-50 text-green-700 dark:bg-green-950 dark:text-green-300">Green</span>
  <span class="badge bg-sky-50 text-sky-700 dark:bg-sky-950 dark:text-sky-300">Sky</span>
  <span class="badge bg-purple-50 text-purple-700 dark:bg-purple-950 dark:text-purple-300">Purple</span>
  <span class="badge bg-red-50 text-red-700 dark:bg-red-950 dark:text-red-300">Red</span>
</div>
```
