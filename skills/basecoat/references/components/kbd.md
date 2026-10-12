# Kbd

- JavaScript: none (CSS only)

## Usage

Use `<kbd class="kbd">` for a key label. Use an inline wrapper with utilities when grouping multiple keys.

```html
<kbd class="kbd">⌘K</kbd>
```

Keyboard labels are direction-neutral. Surrounding spacing should use logical utilities when position matters.

## Examples

### Group

```html
<p class="text-muted-foreground text-sm">Use <span class="inline-flex items-center gap-1"><kbd class="kbd">Ctrl</kbd><span>+</span><kbd class="kbd">B</kbd></span> <span class="inline-flex items-center gap-1"><kbd class="kbd">Ctrl</kbd><span>+</span><kbd class="kbd">K</kbd></span> to open the command palette</p>
```

### Button

```html
<button class="btn" data-variant="outline">
  Accept
  <kbd class="kbd translate-x-0.5" data-icon="inline-end">⏎</kbd>
</button>
```

### Input Group

```html
<div class="input-group">
  <input type="search" placeholder="Search..." />
  <span data-align="start" aria-hidden="true"><svg><!-- search --></svg></span>
  <span class="inline-flex items-center gap-1" data-align="end">
    <kbd class="kbd">⌘</kbd>
    <kbd class="kbd">K</kbd>
  </span>
</div>
```

## RTL

Keyboard labels are direction-neutral. Surrounding spacing should use logical utilities when position matters.

```html
<div class="flex flex-col items-center gap-4" dir="rtl">
  <span class="inline-flex items-center gap-1">
    <kbd class="kbd">⌘</kbd>
    <kbd class="kbd">⇧</kbd>
    <kbd class="kbd">⌥</kbd>
    <kbd class="kbd">⌃</kbd>
  </span>
  <span class="inline-flex items-center gap-1">
    <kbd class="kbd">Ctrl</kbd>
    <span>+</span>
    <kbd class="kbd">B</kbd>
  </span>
</div>
```
