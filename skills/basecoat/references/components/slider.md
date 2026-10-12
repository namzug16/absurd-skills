# Slider

- JavaScript: required — `basecoat-css/range` (or the `all` bundle)

## Usage

Use a native `<input type="range" class="input">`. Include `range.js` so Basecoat can keep the filled track in sync with the input value.

```html
<input type="range" class="input w-full" min="0" max="100" value="50" />
```

### HTML structure

- `<input type="range" class="input">` — Native range input styled as a slider. Width utilities such as `w-full` can be added directly.


Basecoat intentionally uses the native range input. Unlike shadcn/ui's Base UI slider, it does not support multiple thumbs or vertical orientation.

## Examples

### Default

```html
<input type="range" class="input w-full" min="0" max="100" value="50" />
```

### Label

```html
<div class="grid w-full gap-1 max-w-sm">
  <div class="flex items-center justify-between gap-2">
    <label class="label" for="temperature">Temperature</label>
    <output class="text-sm text-muted-foreground" for="temperature">50</output>
  </div>
  <input
    id="temperature"
    type="range"
    class="input w-full"
    min="0"
    max="100"
    value="50"
    oninput="this.previousElementSibling.querySelector('output').value = this.value"
  />
</div>
```

### Disabled

```html
<input type="range" class="input w-full" min="0" max="100" value="50" disabled />
```
