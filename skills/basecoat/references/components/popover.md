# Popover

- JavaScript: required — `basecoat-css/popover` (or the `all` bundle)
- Templates: ships a `popover()` macro for Jinja and Nunjucks — see [templates](../templates.md)

## Usage

Basecoat popovers are inline-positioned relative to the `.popover` wrapper. This differs from shadcn/ui's portalled Base UI implementation, but keeps the markup dependency-free and works with Basecoat's existing dropdown/select positioning model.

```html
<div id="demo-popover" class="popover">
  <button id="demo-popover-trigger" type="button" aria-expanded="false" aria-controls="demo-popover-popover" class="btn" data-variant="outline">Open popover</button>
  <div id="demo-popover-popover" data-popover aria-hidden="true" class="w-72">
    <header>
      <h4>Dimensions</h4>
      <p>Set the dimensions for the layer.</p>
    </header>
    <form class="grid gap-2" onsubmit="event.preventDefault()">
      <div class="grid grid-cols-3 items-center gap-4">
        <label for="demo-popover-width">Width</label>
        <input type="text" id="demo-popover-width" value="100%" class="input col-span-2 h-8" autofocus />
      </div>
      <div class="grid grid-cols-3 items-center gap-4">
        <label for="demo-popover-max-width">Max. width</label>
        <input type="text" id="demo-popover-max-width" value="300px" class="input col-span-2 h-8" />
      </div>
      <div class="grid grid-cols-3 items-center gap-4">
        <label for="demo-popover-height">Height</label>
        <input type="text" id="demo-popover-height" value="25px" class="input col-span-2 h-8" />
      </div>
      <div class="grid grid-cols-3 items-center gap-4">
        <label for="demo-popover-max-height">Max. height</label>
        <input type="text" id="demo-popover-max-height" value="none" class="input col-span-2 h-8" />
      </div>
    </form>
  </div>
</div>
```

### HTML structure

- `<div class="popover">` — Relative wrapper for the trigger and inline popover content.
  - `<button type="button" aria-expanded="false" aria-controls="{ POPOVER_ID }">` — Trigger button. The script toggles `aria-expanded` and opens or closes the content.
  - `<div data-popover id="{ POPOVER_ID }" aria-hidden="true">` — Popover content. Supports `data-side="top|right|bottom|left|inline-start|inline-end"` and `data-align="start|center|end"`.

## Examples

### Basic

```html
<div id="popover-basic" class="popover">
  <button id="popover-basic-trigger" type="button" aria-expanded="false" aria-controls="popover-basic-popover" class="btn" data-variant="outline">Open</button>
  <div id="popover-basic-popover" data-popover aria-hidden="true" class="w-72">
    <header>
      <h4>Title</h4>
      <p>Description text here.</p>
    </header>
  </div>
</div>
```

### Align

```html
<div class="flex flex-wrap gap-3">
  <div id="popover-align-start" class="popover">
    <button id="popover-align-start-trigger" type="button" aria-expanded="false" aria-controls="popover-align-start-popover" class="btn" data-variant="outline">Start</button>
    <div id="popover-align-start-popover" data-popover aria-hidden="true" class="w-56" data-align="start">
      <p>Aligned to start.</p>
    </div>
  </div>
  <div id="popover-align-center" class="popover">
    <button id="popover-align-center-trigger" type="button" aria-expanded="false" aria-controls="popover-align-center-popover" class="btn" data-variant="outline">Center</button>
    <div id="popover-align-center-popover" data-popover aria-hidden="true" class="w-56" data-align="center">
      <p>Aligned to center.</p>
    </div>
  </div>
  <div id="popover-align-end" class="popover">
    <button id="popover-align-end-trigger" type="button" aria-expanded="false" aria-controls="popover-align-end-popover" class="btn" data-variant="outline">End</button>
    <div id="popover-align-end-popover" data-popover aria-hidden="true" class="w-56" data-align="end">
      <p>Aligned to end.</p>
    </div>
  </div>
</div>
```

### Sides

```html
<div class="flex flex-wrap gap-3">
  <div id="popover-side-inline-start" class="popover">
    <button id="popover-side-inline-start-trigger" type="button" aria-expanded="false" aria-controls="popover-side-inline-start-popover" class="btn" data-variant="outline">Inline start</button>
    <div id="popover-side-inline-start-popover" data-popover aria-hidden="true" data-side="inline-start" data-align="center" class="w-40">
      <p>Inline start side.</p>
    </div>
  </div>
  <div id="popover-side-top" class="popover">
    <button id="popover-side-top-trigger" type="button" aria-expanded="false" aria-controls="popover-side-top-popover" class="btn" data-variant="outline">Top</button>
    <div id="popover-side-top-popover" data-popover aria-hidden="true" data-side="top" data-align="center" class="w-40">
      <p>Top side.</p>
    </div>
  </div>
  <div id="popover-side-right" class="popover">
    <button id="popover-side-right-trigger" type="button" aria-expanded="false" aria-controls="popover-side-right-popover" class="btn" data-variant="outline">Right</button>
    <div id="popover-side-right-popover" data-popover aria-hidden="true" data-side="right" data-align="center" class="w-40">
      <p>Right side.</p>
    </div>
  </div>
  <div id="popover-side-bottom" class="popover">
    <button id="popover-side-bottom-trigger" type="button" aria-expanded="false" aria-controls="popover-side-bottom-popover" class="btn" data-variant="outline">Bottom</button>
    <div id="popover-side-bottom-popover" data-popover aria-hidden="true" data-side="bottom" data-align="center" class="w-40">
      <p>Bottom side.</p>
    </div>
  </div>
  <div id="popover-side-left" class="popover">
    <button id="popover-side-left-trigger" type="button" aria-expanded="false" aria-controls="popover-side-left-popover" class="btn" data-variant="outline">Left</button>
    <div id="popover-side-left-popover" data-popover aria-hidden="true" data-side="left" data-align="center" class="w-40">
      <p>Left side.</p>
    </div>
  </div>
  <div id="popover-side-inline-end" class="popover">
    <button id="popover-side-inline-end-trigger" type="button" aria-expanded="false" aria-controls="popover-side-inline-end-popover" class="btn" data-variant="outline">Inline end</button>
    <div id="popover-side-inline-end-popover" data-popover aria-hidden="true" data-side="inline-end" data-align="center" class="w-40">
      <p>Inline end side.</p>
    </div>
  </div>
</div>
```

### With form

```html
<div id="popover-form" class="popover">
  <button id="popover-form-trigger" type="button" aria-expanded="false" aria-controls="popover-form-popover" class="btn" data-variant="outline">Open popover</button>
  <div id="popover-form-popover" data-popover aria-hidden="true" class="w-72">
    <header>
      <h4>Dimensions</h4>
      <p>Set the dimensions for the layer.</p>
    </header>
    <form class="grid gap-2" onsubmit="event.preventDefault()">
      <div class="grid grid-cols-3 items-center gap-4">
        <label for="popover-form-width">Width</label>
        <input type="text" id="popover-form-width" value="100%" class="input col-span-2 h-8" autofocus />
      </div>
      <div class="grid grid-cols-3 items-center gap-4">
        <label for="popover-form-max-width">Max. width</label>
        <input type="text" id="popover-form-max-width" value="300px" class="input col-span-2 h-8" />
      </div>
      <div class="grid grid-cols-3 items-center gap-4">
        <label for="popover-form-height">Height</label>
        <input type="text" id="popover-form-height" value="25px" class="input col-span-2 h-8" />
      </div>
      <div class="grid grid-cols-3 items-center gap-4">
        <label for="popover-form-max-height">Max. height</label>
        <input type="text" id="popover-form-max-height" value="none" class="input col-span-2 h-8" />
      </div>
    </form>
  </div>
</div>
```
