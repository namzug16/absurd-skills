# Textarea

- JavaScript: none (CSS only)

## Usage

Add `class="textarea"` to a `<textarea>` element. Textareas inside a `class="field"` container also receive the same styling automatically.

Use native HTML attributes for behavior: `disabled` for disabled textareas and `aria-invalid="true"` for invalid state styling.

```html
<textarea class="textarea" placeholder="Type your message here"></textarea>
```

Textareas support right-to-left layouts through native browser direction handling.

## Examples

### Field

Use `field` with a label and description to create an accessible textarea.

```html
<div role="group" class="field">
  <label for="textarea-field">Message</label>
  <textarea id="textarea-field" placeholder="Type your message here"></textarea>
  <p>Write a short message.</p>
</div>
```

### Disabled

```html
<textarea class="textarea" placeholder="Type your message here" disabled></textarea>
```

### Invalid

```html
<div role="group" class="field w-full max-w-xs">
  <label for="textarea-invalid">Message</label>
  <textarea class="textarea" id="textarea-invalid" placeholder="Type your message here" aria-invalid="true"></textarea>
  <p>Message is required.</p>
</div>
```

### Button

```html
<div class="grid w-full max-w-xs gap-3">
  <textarea class="textarea" placeholder="Type your message here"></textarea>
  <button type="submit" class="btn">Submit</button>
</div>
```

### Form

```html
<form class="w-full max-w-sm space-y-6">
  <div role="group" class="field">
    <label for="textarea-form">Bio</label>
    <textarea id="textarea-form" placeholder="Tell us a bit about yourself"></textarea>
    <p>You can @mention other users and organizations.</p>
  </div>
  <button type="submit" class="btn">Submit</button>
</form>
```
