# Progress

- JavaScript: none (CSS only)

## Usage

Add `class="progress"` and `role="progressbar"` to the root. Use one child `<span>` as the visual indicator.

```html
<div class="progress" role="progressbar" aria-label="Loading" aria-valuenow="66" aria-valuemin="0" aria-valuemax="100">
  <span style="width: 66%"></span>
</div>
```

### HTML structure

- `<div class="progress" role="progressbar">` — Progress root. Set `aria-label` or `aria-labelledby`, plus `aria-valuenow`, `aria-valuemin`, and `aria-valuemax`.
- `<span style="width: ...">` — Visual indicator. Its width should match the current value.

## Examples

### Label

```html
<div class="field">
  <div class="flex items-center gap-3 text-sm">
    <label id="progress-label">Upload progress</label>
    <output class="ms-auto tabular-nums">66%</output>
  </div>
  <div class="progress" role="progressbar" aria-labelledby="progress-label" aria-valuenow="66" aria-valuemin="0" aria-valuemax="100">
    <span style="width: 66%"></span>
  </div>
</div>
```
