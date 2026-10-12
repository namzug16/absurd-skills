# Select

- JavaScript: required — `basecoat-css/select` (or the `all` bundle)
- Templates: ships a `select()` macro for Jinja and Nunjucks — see [templates](../templates.md)

## Usage

```html
<div id="select-theme" class="select" data-placeholder="Theme">
  <button type="button" class="w-[180px]" id="select-theme-trigger" aria-haspopup="listbox" aria-expanded="false" aria-controls="select-theme-listbox">
    <span class="truncate">Theme</span>
    <svg class="text-muted-foreground opacity-50 shrink-0"><!-- chevron-down --></svg>
  </button>
  <div id="select-theme-popover" data-popover aria-hidden="true">
    <div role="listbox" id="select-theme-listbox" aria-orientation="vertical" aria-labelledby="select-theme-trigger">
      <div role="option" data-value="light">Light</div>
      <div role="option" data-value="dark">Dark</div>
      <div role="option" data-value="system">System</div>
    </div>
  </div>
  <input type="hidden" name="theme" value="" />
</div>
```

### HTML structure

- `<div class="select">` — Select root. Add `data-placeholder` to show placeholder text when no value is selected. Supports `data-close-on-select="true"` for multiple select and `data-format="object"` for serialized object values.
  - `<button type="button">` — Trigger button. Use `aria-haspopup="listbox"`, `aria-expanded`, and `aria-controls`.
  - `<div data-popover aria-hidden="true">` — Popover content. Supports `data-side` and `data-align` through the shared Popover rules.
    - `<div role="listbox">` — Options container. Add `aria-multiselectable="true"` for multiple selection.
      - `<div role="option" data-value="..." data-label="...">` — Selectable option. `data-value` is submitted. `data-label` is optional and controls the selected display label and `data-format="object"` label; when omitted, Basecoat uses trimmed text content.
      - `<hr role="separator">` *(optional)* — Separator between groups or options.
      - `<div role="group">` *(optional)* — Option group. Use `aria-labelledby` to connect it to its heading.
      - `<span role="heading">` *(optional)* — Group heading.
  - `<input type="hidden">` — Submitted value. Empty value means no selection when the root has `data-placeholder`. Single select stores a string; multiple select stores a JSON array. With `data-format="object"`, values are serialized as `{ value, label }` objects.

### JavaScript API

| API | Type | Description |
| --- | --- | --- |
| `change` | Event | Dispatched on selection changes with `event.detail.value` and `event.detail.selected`. |
| `select.refresh()` | Method | Rescans options after children change inside the existing `role="listbox"` element. |

## Examples

### Groups

```html
<div id="select-groups" class="select" data-placeholder="Select a fruit">
  <button type="button" class="w-[180px]" id="select-groups-trigger" aria-haspopup="listbox" aria-expanded="false" aria-controls="select-groups-listbox">
    <span class="truncate">Select a fruit</span>
    <svg class="text-muted-foreground opacity-50 shrink-0"><!-- chevron-down --></svg>
  </button>
  <div id="select-groups-popover" data-popover aria-hidden="true">
    <div role="listbox" id="select-groups-listbox" aria-orientation="vertical" aria-labelledby="select-groups-trigger">
      <div role="group" aria-labelledby="select-groups-fruits">
        <span role="heading" id="select-groups-fruits">Fruits</span>
        <div role="option" data-value="apple">Apple</div>
        <div role="option" data-value="banana">Banana</div>
        <div role="option" data-value="blueberry">Blueberry</div>
      </div>
      <hr role="separator" />
      <div role="group" aria-labelledby="select-groups-vegetables">
        <span role="heading" id="select-groups-vegetables">Vegetables</span>
        <div role="option" data-value="carrot">Carrot</div>
        <div role="option" data-value="broccoli">Broccoli</div>
        <div role="option" data-value="spinach">Spinach</div>
      </div>
    </div>
  </div>
  <input type="hidden" name="select-groups-value" value="" />
</div>
```

### Scrollable

A select with many items that scrolls.

```html
<div id="select-scrollable" class="select" data-placeholder="Select a timezone">
  <button type="button" class="w-[280px]" id="select-scrollable-trigger" aria-haspopup="listbox" aria-expanded="false" aria-controls="select-scrollable-listbox">
    <span class="truncate">Select a timezone</span>
    <svg class="text-muted-foreground opacity-50 shrink-0"><!-- chevron-down --></svg>
  </button>
  <div id="select-scrollable-popover" data-popover aria-hidden="true">
    <div role="listbox" id="select-scrollable-listbox" class="scrollbar-sm max-h-70 overflow-y-auto" aria-orientation="vertical" aria-labelledby="select-scrollable-trigger">
      <div role="group" aria-labelledby="select-scrollable-north-america">
        <span role="heading" id="select-scrollable-north-america">North America</span>
        <div role="option" data-value="est">Eastern Standard Time (EST)</div>
        <div role="option" data-value="cst">Central Standard Time (CST)</div>
        <div role="option" data-value="mst">Mountain Standard Time (MST)</div>
        <div role="option" data-value="pst">Pacific Standard Time (PST)</div>
        <div role="option" data-value="akst">Alaska Standard Time (AKST)</div>
        <div role="option" data-value="hst">Hawaii Standard Time (HST)</div>
      </div>
      <div role="group" aria-labelledby="select-scrollable-europe-africa">
        <span role="heading" id="select-scrollable-europe-africa">Europe &amp; Africa</span>
        <div role="option" data-value="gmt">Greenwich Mean Time (GMT)</div>
        <div role="option" data-value="cet">Central European Time (CET)</div>
        <div role="option" data-value="eet">Eastern European Time (EET)</div>
        <div role="option" data-value="west">Western European Summer Time (WEST)</div>
        <div role="option" data-value="cat">Central Africa Time (CAT)</div>
        <div role="option" data-value="eat">East Africa Time (EAT)</div>
      </div>
      <div role="group" aria-labelledby="select-scrollable-asia">
        <span role="heading" id="select-scrollable-asia">Asia</span>
        <div role="option" data-value="msk">Moscow Time (MSK)</div>
        <div role="option" data-value="ist">India Standard Time (IST)</div>
        <div role="option" data-value="cst_china">China Standard Time (CST)</div>
        <div role="option" data-value="jst">Japan Standard Time (JST)</div>
        <div role="option" data-value="kst">Korea Standard Time (KST)</div>
        <div role="option" data-value="ist_indonesia">Indonesia Central Standard Time (WITA)</div>
      </div>
      <div role="group" aria-labelledby="select-scrollable-australia-pacific">
        <span role="heading" id="select-scrollable-australia-pacific">Australia &amp; Pacific</span>
        <div role="option" data-value="awst">Australian Western Standard Time (AWST)</div>
        <div role="option" data-value="acst">Australian Central Standard Time (ACST)</div>
        <div role="option" data-value="aest">Australian Eastern Standard Time (AEST)</div>
        <div role="option" data-value="nzst">New Zealand Standard Time (NZST)</div>
        <div role="option" data-value="fjt">Fiji Time (FJT)</div>
      </div>
      <div role="group" aria-labelledby="select-scrollable-south-america">
        <span role="heading" id="select-scrollable-south-america">South America</span>
        <div role="option" data-value="art">Argentina Time (ART)</div>
        <div role="option" data-value="bot">Bolivia Time (BOT)</div>
        <div role="option" data-value="brt">Brasilia Time (BRT)</div>
        <div role="option" data-value="clt">Chile Standard Time (CLT)</div>
      </div>
    </div>
  </div>
  <input type="hidden" name="select-scrollable-value" value="" />
</div>
```

### Disabled

```html
<div id="select-disabled" class="select" data-placeholder="Select a fruit">
  <button type="button" class="w-[180px]" id="select-disabled-trigger" aria-haspopup="listbox" aria-expanded="false" aria-controls="select-disabled-listbox" disabled>
    <span class="truncate">Select a fruit</span>
    <svg class="text-muted-foreground opacity-50 shrink-0"><!-- chevron-down --></svg>
  </button>
  <div id="select-disabled-popover" data-popover aria-hidden="true">
    <div role="listbox" id="select-disabled-listbox" aria-orientation="vertical" aria-labelledby="select-disabled-trigger">
      <div role="option" data-value="apple">Apple</div>
      <div role="option" data-value="banana">Banana</div>
      <div role="option" data-value="blueberry">Blueberry</div>
      <div role="option" data-value="grapes" aria-disabled="true">Grapes</div>
      <div role="option" data-value="pineapple">Pineapple</div>
    </div>
  </div>
  <input type="hidden" name="select-disabled-value" value="" />
</div>
```

### Invalid

```html
<div class="field" data-invalid="true">
  <label for="select-invalid-trigger">Fruit</label>
  <div id="select-invalid" class="select" data-placeholder="Select a fruit">
    <button type="button" class="w-[180px]" id="select-invalid-trigger" aria-haspopup="listbox" aria-expanded="false" aria-controls="select-invalid-listbox" aria-invalid="true">
      <span class="truncate">Select a fruit</span>
      <svg class="text-muted-foreground opacity-50 shrink-0"><!-- chevron-down --></svg>
    </button>
    <div id="select-invalid-popover" data-popover aria-hidden="true">
      <div role="listbox" id="select-invalid-listbox" aria-orientation="vertical" aria-labelledby="select-invalid-trigger">
        <div role="option" data-value="apple">Apple</div>
        <div role="option" data-value="banana">Banana</div>
        <div role="option" data-value="blueberry">Blueberry</div>
        <div role="option" data-value="grapes">Grapes</div>
        <div role="option" data-value="pineapple">Pineapple</div>
      </div>
    </div>
    <input type="hidden" name="fruit" value="" />
  </div>
  <p role="alert">Please select a valid fruit.</p>
</div>
```
