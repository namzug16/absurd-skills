# Spinner

- JavaScript: none (CSS only)

> **No dedicated component**: There is no dedicated Spinner component in Basecoat.

## Usage

Spinners are pure HTML using the `loader-circle` Lucide icon with the `animate-spin` Tailwind utility. Add `role="status"` and `aria-label="Loading"` for accessibility.

```html
<svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg>
```

## Examples

### Size

Use the `size-*` utility class to change the size of the spinner.

```html
<div class="flex items-center gap-6"><svg aria-label="Loading" role="status" class="size-3 animate-spin"><!-- loader-circle --></svg><svg aria-label="Loading" role="status" class="size-4 animate-spin"><!-- loader-circle --></svg><svg aria-label="Loading" role="status" class="size-6 animate-spin"><!-- loader-circle --></svg><svg aria-label="Loading" role="status" class="size-8 animate-spin"><!-- loader-circle --></svg></div>
```

### Button

Add a spinner to a button to indicate a loading state. Place the spinner before or after the label; button spacing is handled automatically.

```html
<div class="flex flex-col items-center gap-4">
  <button class="btn" data-size="sm" disabled><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg>
    Loading...
  </button>
  <button class="btn" data-variant="outline" data-size="sm" disabled><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg>
    Please wait
  </button>
  <button class="btn" data-variant="secondary" data-size="sm" disabled><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg>
    Processing
  </button>
</div>
```

### Badge

Add a spinner to a badge to indicate a loading state. Place the spinner before or after the label; badge spacing is handled automatically.

```html
<div class="flex items-center gap-4">
  <span class="badge"><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg>
    Syncing
  </span>
  <span class="badge" data-variant="secondary"><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg>
    Updating
  </span>
  <span class="badge" data-variant="outline"><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg>
    Processing
  </span>
</div>
```

### Input group

```html
<div class="flex w-full max-w-md flex-col gap-4">
  <div class="input-group">
    <input placeholder="Send a message..." disabled />
    <span data-align="inline-end"><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg></span>
  </div>
  <div class="input-group">
    <textarea placeholder="Send a message..." disabled></textarea>
    <footer data-align="block-end"><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg>
      Validating...
      <button type="button" class="btn ms-auto" data-size="icon-sm"><svg><!-- arrow-up --></svg>
        <span class="sr-only">Send</span>
      </button>
    </footer>
  </div>
</div>
```

### Empty

```html
<div class="empty w-full">
  <header>
    <figure><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg></figure>
    <h3>Processing your request</h3>
    <p>Please wait while we process your request. Do not refresh the page.</p>
  </header>
  <section> <button class="btn" data-variant="outline" data-size="sm">Cancel</button></section>
</div>
```

## RTL

Spinner layout follows document direction. Use logical utilities when surrounding spacing depends on direction.

```html
<article class="item bg-muted/50 border-transparent" dir="rtl">
  <figure><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg></figure>
  <section> <h3>جاري معالجة الدفع...</h3></section>
  <aside class="tabular-nums text-sm">١٠٠.٠٠ دولار</aside>
</article>
```
