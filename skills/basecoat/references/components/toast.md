# Toast

- JavaScript: required — `basecoat-css/toast` (or the `all` bundle)
- Templates: ships `toaster()` and `toast()` macros for Jinja and Nunjucks — see [templates](../templates.md)

## Usage

Add one toaster near the end of your page body:

```html
<div id="toaster" class="toaster"></div>
```

Set `data-align="start"`, `data-align="center"`, or `data-align="end"` on the toaster to change placement.

Append server-rendered toast markup to the toaster, or create one from JavaScript with `toaster.toast(config)`.

```html
<div id="toaster" class="toaster">
  <div class="toast" role="status" aria-atomic="true" aria-hidden="false" data-category="success">
    <div class="toast-content"><svg aria-hidden="true"><!-- icon --></svg>
      <section>
        <h2>Success</h2>
        <p>A success toast called from the front-end.</p>
      </section>
      <footer>
        <button type="button" class="btn" data-toast-action>Dismiss</button>
      </footer>
    </div>
  </div>
</div>
```

```html
<button
  class="btn" data-variant="outline"
  onclick="document.getElementById('toaster').toast({
    category: 'success',
    title: 'Success',
    description: 'A success toast called from the front-end.',
    cancel: {
      label: 'Dismiss'
    }
  })">Toast from front-end</button>
```

### HTML structure

- `<div id="toaster" class="toaster">` — Toast container. Optional `data-align` values are `start`, `center`, and `end`.
- `<div class="toast">` — Toast item. Use `data-category="success|info|warning|error"` for category styling and `data-duration` to override the timeout in milliseconds. Use `data-duration="-1"` to keep it open.
  - `<div class="toast-content">` — Content wrapper.
    - `<svg aria-hidden="true">` *(optional)* — Icon.
    - `<section>` — Message region.
      - `<h2>` — Title.
      - `<p>` *(optional)* — Description.
    - `<footer>` *(optional)* — Action buttons or links. Clicking a footer button or link closes the toast.

### JavaScript API

| API | Type | Description |
| --- | --- | --- |
| `toaster.toast(config)` | Method | Creates a toast from a config object and returns the inserted `.toast` element. See "Config object" below. |
| `toaster.closeAll()` | Method | Closes every toast inside the toaster. |
| `toast.close()` | Method | Closes one initialized toast element. |

### Config object

- `duration` *(optional)* — Timeout in milliseconds. Defaults to `3000`, or `5000` for error toasts. Use `-1` to keep it open.
- `category` *(optional)* — Category of the toast, either `success`, `info`, `warning`, or `error`.
- `title` — The title of the toast.
- `description` *(optional)* — The description of the toast.
- `action` *(optional)* — Primary action. Supports `label` with either `href` or `onclick`.
- `cancel` *(optional)* — Secondary action. Supports `label` and optional `onclick`.
