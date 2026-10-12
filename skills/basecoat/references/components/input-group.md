# Input Group

- JavaScript: none (CSS only)

## Usage

```html
<div class="input-group">
  <input type="text" placeholder="Search..." />
  <span data-align="start" aria-hidden="true"> <!-- icon --></span>
  <span data-align="end">12 results</span>
</div>
```

Add `class="input-group"` to the root. Native controls stay semantic and become borderless children inside that shell.

- `<div class="input-group">` — The root shell. Add `role="group"` and an accessible label only when the group itself needs to be named.
  - `<input>`, `<textarea>`, `<select>` — The native control. Use `aria-invalid="true"` for invalid state and `disabled` for disabled state.
  - `<span>`, `<svg>`, `<kbd>` — Decorative or helper content. Use `aria-hidden="true"` for decorative icons.
  - `<button>`, `<div role="group">` — Interactive actions. Use `role="group"` with an accessible label when multiple related actions share one side of the input.
  - `<header>`, `<footer>` — Header or footer addon rows for vertically oriented input groups.
  - `data-align="start|end"` — Optional visual placement. Values use logical direction, so start/end automatically flip in RTL. Use `data-orientation="vertical"` on the root for header/footer layouts.
  - `[data-control]` — Escape hatch for custom controls that are not native `input`, `textarea`, or `select`.

## Examples

Use `data-align="start|end"` on addon wrappers to position them inline. Use `data-orientation="vertical"` with `header` or `footer` for block placement.

### Inline start

```html
<div class="field">
  <label for="inline-start-input">Input</label>
  <div class="input-group">
    <input id="inline-start-input" type="text" placeholder="Search..." />
    <span role="group" data-align="start" aria-hidden="true"><svg class="text-muted-foreground"><!-- search --></svg></span>
  </div>
  <p>Icon positioned at the start.</p>
</div>
```

### Inline end

```html
<div class="field">
  <label for="inline-end-input">Input</label>
  <div class="input-group">
    <input id="inline-end-input" type="password" placeholder="Enter password" />
    <span role="group" data-align="end" aria-hidden="true"><svg><!-- eye-off --></svg></span>
  </div>
  <p>Icon positioned at the end.</p>
</div>
```

### Block start

```html
<div role="group" aria-label="Block start input group examples" class="fieldset">
  <div class="field">
    <label for="block-start-input">Input</label>
    <div class="input-group" data-orientation="vertical">
      <input id="block-start-input" type="text" placeholder="Enter your name" />
      <header data-align="start">
        <span>Full Name</span>
      </header>
    </div>
    <p>Header positioned above the input.</p>
  </div>
  <div class="field">
    <label for="block-start-textarea">Textarea</label>
    <div class="input-group" data-orientation="vertical">
      <textarea id="block-start-textarea" class="font-mono text-sm" placeholder="console.log('Hello, world!');"></textarea>
      <header data-align="start"><svg class="text-muted-foreground"><!-- file-code --></svg>
        <span class="font-mono">script.js</span>
        <button type="button" class="btn ml-auto size-6" data-variant="ghost" data-size="icon-sm" aria-label="Copy"><svg><!-- copy --></svg></button>
      </header>
    </div>
    <p>Header positioned above the textarea.</p>
  </div>
</div>
```

### Block end

```html
<div role="group" aria-label="Block end input group examples" class="fieldset">
  <div class="field">
    <label for="block-end-input">Input</label>
    <div class="input-group" data-orientation="vertical">
      <input id="block-end-input" type="text" placeholder="Enter amount" />
      <footer data-align="end">
        <span>USD</span>
      </footer>
    </div>
    <p>Footer positioned below the input.</p>
  </div>
  <div class="field">
    <label for="block-end-textarea">Textarea</label>
    <div class="input-group" data-orientation="vertical">
      <textarea id="block-end-textarea" placeholder="Write a comment..."></textarea>
      <footer data-align="end">
        <span>0/280</span>
        <button type="button" class="btn ml-auto" data-size="sm">Post</button>
      </footer>
    </div>
    <p>Footer positioned below the textarea.</p>
  </div>
</div>
```

### Icon

```html
<div class="grid gap-6">
  <div class="input-group">
    <input type="text" placeholder="Search..." />
    <span data-align="start" aria-hidden="true"><svg><!-- search --></svg></span>
  </div>
  <div class="input-group">
    <input type="email" placeholder="Enter your email" />
    <span data-align="start" aria-hidden="true"><svg><!-- mail --></svg></span>
  </div>
  <div class="input-group">
    <input type="text" placeholder="Card number" />
    <span data-align="start" aria-hidden="true"><svg><!-- credit-card --></svg></span>
    <span data-align="end" aria-hidden="true"><svg><!-- check --></svg></span>
  </div>
  <div class="input-group">
    <input type="text" placeholder="Card number" />
    <span data-align="end" aria-hidden="true"><svg><!-- star --></svg><svg><!-- info --></svg></span>
  </div>
</div>
```

### Text

```html
<div class="grid gap-6">
  <div class="input-group">
    <input type="text" placeholder="0.00" />
    <span data-align="start">$</span>
    <span data-align="end">USD</span>
  </div>
  <div class="input-group">
    <input type="text" placeholder="example.com" />
    <span data-align="start">https://</span>
    <span data-align="end">.com</span>
  </div>
  <div class="input-group">
    <input type="text" placeholder="Enter your username" />
    <span data-align="end">@company.com</span>
  </div>
  <div class="input-group" data-orientation="vertical">
    <textarea placeholder="Enter your message"></textarea>
    <footer data-align="end">
      <span class="text-xs text-muted-foreground">120 characters left</span>
    </footer>
  </div>
</div>
```

### Button

```html
<div class="grid gap-6">
  <div class="input-group">
    <input type="text" readonly placeholder="https://x.com/shadcn" />
    <button type="button" class="btn" data-variant="ghost" data-size="icon-xs" data-align="end" aria-label="Copy" title="Copy"><svg><!-- copy --></svg></button>
  </div>
  <div class="input-group [--radius:9999px]">
    <button type="button" class="btn" data-variant="secondary" data-size="icon-xs" data-align="start" aria-label="Connection information"><svg><!-- info --></svg></button>
    <span data-align="start" class="text-muted-foreground">https://</span>
    <input type="text" id="input-secure-19" />
    <button type="button" class="btn" data-variant="ghost" data-size="icon-xs" data-align="end" aria-label="Favorite"><svg><!-- star --></svg></button>
  </div>
  <div class="input-group">
    <input type="text" placeholder="Type to search..." />
    <button type="button" class="btn" data-size="xs" data-variant="secondary" data-align="end">Search</button>
  </div>
</div>
```

### Kbd

```html
<div class="input-group">
  <input type="text" placeholder="Search..." />
  <span data-align="start" aria-hidden="true"><svg><!-- search --></svg></span>
  <span data-align="end"><kbd class="kbd">⌘K</kbd></span>
</div>
```

### Dropdown

```html
<div class="grid gap-6">
  <div class="input-group">
    <input type="text" placeholder="Enter file name" />
    <div id="dropdown-menu-601971" class="dropdown-menu" data-align="end">
      <button type="button" id="dropdown-menu-601971-trigger" aria-haspopup="menu" aria-controls="dropdown-menu-601971-menu" aria-expanded="false" class="btn" data-variant="ghost" data-size="icon-xs" aria-label="Open file actions"><svg><!-- ellipsis --></svg></button>
      <div id="dropdown-menu-601971-popover" data-popover aria-hidden="true" data-align="end" class="min-w-32">
        <div role="menu" id="dropdown-menu-601971-menu" aria-labelledby="dropdown-menu-601971-trigger">
          <div id="dropdown-menu-601971-items-1" role="menuitem">Settings</div>
          <div id="dropdown-menu-601971-items-2" role="menuitem">Copy path</div>
          <div id="dropdown-menu-601971-items-3" role="menuitem">Open location</div>
        </div>
      </div>
    </div>
  </div>
  <div class="input-group [--radius:1rem]">
    <input type="text" placeholder="Enter search query" />
    <div id="dropdown-menu-689868" class="dropdown-menu" data-align="end">
      <button type="button" id="dropdown-menu-689868-trigger" aria-haspopup="menu" aria-controls="dropdown-menu-689868-menu" aria-expanded="false" class="btn pr-1.5! text-xs" data-variant="ghost" data-size="xs">
        Search In...
        <svg class="size-3"><!-- chevron-down --></svg>
      </button>
      <div id="dropdown-menu-689868-popover" data-popover aria-hidden="true" data-align="end" class="min-w-32 [--radius:0.95rem]">
        <div role="menu" id="dropdown-menu-689868-menu" aria-labelledby="dropdown-menu-689868-trigger">
          <div id="dropdown-menu-689868-items-1" role="menuitem">Documentation</div>
          <div id="dropdown-menu-689868-items-2" role="menuitem">Blog Posts</div>
          <div id="dropdown-menu-689868-items-3" role="menuitem">Changelog</div>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Spinner

```html
<div class="grid gap-6">
  <div class="input-group">
    <input type="text" placeholder="Searching..." />
    <span data-align="end"><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg></span>
  </div>
  <div class="input-group">
    <input type="text" placeholder="Processing..." />
    <span data-align="start"><svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg></span>
  </div>
  <div class="input-group">
    <input type="text" placeholder="Saving changes..." />
    <span data-align="end">
      Saving...
      <svg aria-label="Loading" role="status" class="animate-spin"><!-- loader-circle --></svg>
    </span>
  </div>
  <div class="input-group">
    <input type="text" placeholder="Refreshing data..." />
    <span data-align="start" aria-hidden="true"><svg class="animate-spin"><!-- loader --></svg></span>
    <span data-align="end" class="text-muted-foreground">Please wait...</span>
  </div>
</div>
```

### Textarea

```html
<div class="input-group min-h-[200px]" data-orientation="vertical">
  <textarea placeholder="console.log('Hello, world!');"></textarea>
  <footer data-align="end" class="border-t">
    <span>Line 1, Column 1</span>
    <button type="button" class="btn ml-auto" data-size="sm">
      Run
      <svg><!-- corner-down-left --></svg>
    </button>
  </footer>
  <header data-align="start" class="border-b"><svg class="text-muted-foreground"><!-- file-code --></svg>
    <span>script.js</span>
    <div role="group" aria-label="File actions" class="ml-auto flex gap-1">
      <button type="button" class="btn" data-variant="ghost" data-size="icon-xs" aria-label="Refresh file"><svg><!-- refresh-ccw --></svg></button>
      <button type="button" class="btn" data-variant="ghost" data-size="icon-xs" aria-label="Copy file"><svg><!-- copy --></svg></button>
    </div>
  </header>
</div>
```

### Custom input

```html
<div class="input-group" data-orientation="vertical">
  <textarea data-control placeholder="Autoresize textarea..." class="field-sizing-content min-h-16 resize-none"></textarea>
  <footer data-align="end">
    <button type="button" class="btn ml-auto" data-size="sm">Submit</button>
  </footer>
</div>
```
