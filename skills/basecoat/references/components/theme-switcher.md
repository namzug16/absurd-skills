# Theme Switcher

- JavaScript: none (CSS only)

## Usage

Add this inline script before loading your styles so the stored mode is applied before the page renders.

```html
<script>
  (() => {
    try {
      const stored = localStorage.getItem("themeMode");
      if (stored ? stored === "dark" : matchMedia("(prefers-color-scheme: dark)").matches) {
        document.documentElement.classList.add("dark");
      }
    } catch (_) {}
  })();
</script>
```

```html
<button type="button" aria-label="Toggle dark mode" data-tooltip="Toggle dark mode" data-side="bottom" onclick="window.basecoat.theme.toggle()" class="btn size-8" data-variant="outline" data-size="icon">
  <span class="hidden dark:block"><svg><!-- sun --></svg></span>
  <span class="block dark:hidden"><svg><!-- moon --></svg></span>
</button>
```

### JavaScript API

| API | Type | Description |
| --- | --- | --- |
| `window.basecoat.theme.get()` | Method | Returns `"dark"` or `"light"`. |
| `window.basecoat.theme.set(mode)` | Method | Sets the mode to `"dark"` or `"light"` and stores it in `localStorage.themeMode`. |
| `window.basecoat.theme.toggle()` | Method | Toggles between dark and light mode. |
