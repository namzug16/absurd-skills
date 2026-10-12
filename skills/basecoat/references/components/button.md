# Button

- JavaScript: none (CSS only)

## Usage

```html
<button type="button" class="btn">Primary</button>
<button type="button" class="btn" data-variant="outline">Outline</button>
<button type="button" class="btn" data-variant="secondary" data-size="sm">Small secondary</button>
<button type="button" class="btn" data-variant="outline" data-size="icon" aria-label="Settings"><svg><!-- settings --></svg></button>
```

Add `class="btn"` to a `<button>` or `<a>`. Add `data-variant` and `data-size` when needed. Add `data-icon="inline-start"` or `data-icon="inline-end"` to inline icons when a text button needs icon-aware spacing.

### HTML structure

- `<button class="btn">` — Button root. Use a native `<button>` for actions and `<a>` for navigation.
- `data-variant="primary|secondary|outline|ghost|link|destructive"` *(optional)* — Visual variant. Omit it for the primary variant.
- `data-size="xs|sm|default|lg|icon|icon-xs|icon-sm|icon-lg"` *(optional)* — Button size. Omit it for the default size.

### Variants

| Variant | Markup |
| --- | --- |
| Primary | `<button class="btn">` |
| Secondary | `<button class="btn" data-variant="secondary">` |
| Outline | `<button class="btn" data-variant="outline">` |
| Ghost | `<button class="btn" data-variant="ghost">` |
| Link | `<button class="btn" data-variant="link">` |
| Destructive | `<button class="btn" data-variant="destructive">` |

### Sizes

| Size | Markup |
| --- | --- |
| Extra small | `<button class="btn" data-size="xs">` |
| Small | `<button class="btn" data-size="sm">` |
| Default | `<button class="btn">` |
| Large | `<button class="btn" data-size="lg">` |
| Icon extra small | `<button class="btn" data-size="icon-xs">` |
| Icon small | `<button class="btn" data-size="icon-sm">` |
| Icon | `<button class="btn" data-size="icon">` |
| Icon large | `<button class="btn" data-size="icon-lg">` |

Use `data-size="icon"` or one of the icon size variants for square buttons. Icon-only buttons need an accessible name, usually with `aria-label`.

Use `data-icon="inline-start"` or `data-icon="inline-end"` on inline icons when a text button needs icon-aware spacing. Use icon size variants only for icon-only buttons.

To group related buttons, use the [Button Group](./button-group.md) component.

## Examples

### Size

Use `data-size` to change the size of the button.

```html
<div class="flex flex-wrap items-center gap-2">
  <button type="button" class="btn" data-variant="outline" data-size="xs">Extra Small</button>
  <button type="button" class="btn" data-variant="outline" data-size="icon-xs" aria-label="Submit"><svg><!-- arrow-up-right --></svg></button>
  <button type="button" class="btn" data-variant="outline" data-size="sm">Small</button>
  <button type="button" class="btn" data-variant="outline" data-size="icon-sm" aria-label="Submit"><svg><!-- arrow-up-right --></svg></button>
  <button type="button" class="btn" data-variant="outline">Default</button>
  <button type="button" class="btn" data-variant="outline" data-size="icon" aria-label="Submit"><svg><!-- arrow-up-right --></svg></button>
  <button type="button" class="btn" data-variant="outline" data-size="lg">Large</button>
  <button type="button" class="btn" data-variant="outline" data-size="icon-lg" aria-label="Submit"><svg><!-- arrow-up-right --></svg></button>
</div>
```

### Default

```html
<button type="button" class="btn">Button</button>
```

### Outline

```html
<button type="button" class="btn" data-variant="outline">Outline</button>
```

### Secondary

```html
<button type="button" class="btn" data-variant="secondary">Secondary</button>
```

### Ghost

```html
<button type="button" class="btn" data-variant="ghost">Ghost</button>
```

### Destructive

```html
<button type="button" class="btn" data-variant="destructive">Destructive</button>
```

### Link

```html
<button type="button" class="btn" data-variant="link">Link</button>
```

### Icon

```html
<button type="button" class="btn" data-variant="outline" data-size="icon" aria-label="Open"><svg><!-- circle-fading-arrow-up --></svg></button>
```

### With icon

Use `data-icon="inline-start"` or `data-icon="inline-end"` on inline icons to match upstream icon-aware spacing.

```html
<button type="button" class="btn" data-variant="outline" data-size="sm"><svg data-icon="inline-start"><!-- git-branch --></svg>
  New Branch
</button>
```

### Rounded

Use the `rounded-full` class to make the button rounded.

```html
<button type="button" class="btn rounded-full" data-variant="outline" data-size="icon" aria-label="Scroll up"><svg><!-- arrow-up --></svg></button>
```

### Spinner

```html
<div class="flex flex-wrap items-center gap-2">
  <button type="button" class="btn" disabled><svg data-icon="inline-start" class="animate-spin"><!-- loader-circle --></svg>
    Generating
  </button>
  <button type="button" class="btn" data-variant="secondary" disabled>
    Downloading
    <svg data-icon="inline-end" class="animate-spin"><!-- loader-circle --></svg>
  </button>
</div>
```

### Button group

To group related buttons, use the [Button Group](./button-group.md) component.

```html
<div class="flex w-fit items-stretch gap-2">
  <button type="button" class="btn" data-variant="outline" data-size="icon" aria-label="Go back"><svg><!-- arrow-left --></svg></button>
  <div role="group" class="button-group">
    <button type="button" class="btn" data-variant="outline">Archive</button>
    <button type="button" class="btn" data-variant="outline">Report</button>
  </div>
  <div role="group" class="button-group">
    <button type="button" class="btn" data-variant="outline">Snooze</button>
    <div id="button-docs-actions" class="dropdown-menu">
      <button type="button" id="button-docs-actions-trigger" aria-label="More options" aria-haspopup="menu" aria-controls="button-docs-actions-menu" aria-expanded="false" class="btn" data-variant="outline" data-size="icon"><svg><!-- ellipsis --></svg></button>
      <div id="button-docs-actions-popover" data-popover aria-hidden="true" data-align="end">
        <div role="menu" id="button-docs-actions-menu" aria-labelledby="button-docs-actions-trigger">
          <div role="menuitem"><svg><!-- mail-check --></svg>
            Mark as Read
          </div>
          <div role="menuitem"><svg><!-- archive --></svg>
            Archive
          </div>
          <hr role="separator" />
          <div role="menuitem"><svg><!-- clock --></svg>
            Snooze
          </div>
          <div role="menuitem"><svg><!-- calendar --></svg>
            Add to Calendar
          </div>
          <div role="menuitem"><svg><!-- list-filter-plus --></svg>
            Add to List
          </div>
          <hr role="separator" />
          <div role="menuitem" class="text-destructive hover:bg-destructive/10 dark:hover:bg-destructive/20 focus:bg-destructive/10 dark:focus:bg-destructive/20 focus:text-destructive [&_svg]:!text-destructive"><svg><!-- trash-2 --></svg>
            Trash
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```
