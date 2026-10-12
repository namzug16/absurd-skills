# Switch

- JavaScript: none (CSS only)

## Usage

Add `class="input"` and `role="switch"` to a native checkbox. Use a native `<label>` or `aria-label` for accessible naming.

```html
<input type="checkbox" role="switch" class="input" />
```

### HTML structure

- `<input type="checkbox" role="switch" class="input">` — The switch control. Use native checkbox state: add `checked` for an initially enabled switch, `disabled` for a disabled switch, and `aria-invalid="true"` for invalid state.
- `data-size="sm"` *(optional)* — Renders the smaller switch size.

## Examples

### Description

```html
<div role="group" class="field" data-orientation="horizontal">
  <section>
    <label for="switch-focus-mode">Share across devices</label>
    <p id="switch-focus-mode-description">Focus is shared across devices, and turns off when you leave the app.</p>
  </section>
  <input type="checkbox" id="switch-focus-mode" role="switch" class="input" aria-describedby="switch-focus-mode-description" />
</div>
```

### Choice card

Use a wrapping `<label>` when the whole card should toggle the switch.

```html
<div role="group" class="grid w-full gap-3" aria-label="Focus settings">
  <label>
    <div role="group" class="field" data-orientation="horizontal">
      <section>
        <h3>Share across devices</h3>
        <p>Focus is shared across devices, and turns off when you leave the app.</p>
      </section>
      <input type="checkbox" role="switch" class="input" />
    </div>
  </label>
  <label>
    <div role="group" class="field" data-orientation="horizontal">
      <section>
        <h3>Enable notifications</h3>
        <p>Receive notifications when focus mode changes.</p>
      </section>
      <input type="checkbox" role="switch" class="input" checked />
    </div>
  </label>
</div>
```

### Disabled

Add `disabled` to the switch and `data-disabled="true"` to the field wrapper when the surrounding field should use disabled styling.

```html
<div role="group" class="field" data-orientation="horizontal" data-disabled="true">
  <input type="checkbox" id="switch-disabled-unchecked" role="switch" class="input" disabled />
  <label for="switch-disabled-unchecked">Disabled</label>
</div>
```

### Invalid

Add `aria-invalid="true"` to the switch and `data-invalid="true"` to the field wrapper.

```html
<div role="group" class="field" data-orientation="horizontal" data-invalid="true">
  <section>
    <label for="switch-invalid">Accept terms and conditions.</label>
    <p>You must accept the terms and conditions to continue.</p>
  </section>
  <input type="checkbox" id="switch-invalid" role="switch" class="input" aria-invalid="true" />
</div>
```

### Size

Use `data-size="sm"` to render the smaller switch size.

```html
<div role="group" class="grid w-full gap-4" aria-label="Switch sizes">
  <div role="group" class="field" data-orientation="horizontal">
    <input type="checkbox" id="switch-size-sm" role="switch" class="input" data-size="sm" />
    <label for="switch-size-sm">Small</label>
  </div>
  <div role="group" class="field" data-orientation="horizontal">
    <input type="checkbox" id="switch-size-default" role="switch" class="input" />
    <label for="switch-size-default">Default</label>
  </div>
</div>
```

## RTL

Switch field layout uses document direction. Set `dir="rtl"` on the field or an ancestor.

```html
<div dir="rtl" role="group" class="field" data-orientation="horizontal">
  <section>
    <label for="switch-rtl">المشاركة عبر الأجهزة</label>
    <p id="switch-rtl-description">يتم مشاركة التركيز عبر الأجهزة، ويتم إيقاف تشغيله عند مغادرة التطبيق.</p>
  </section>
  <input type="checkbox" id="switch-rtl" role="switch" class="input" aria-describedby="switch-rtl-description" checked />
</div>
```
