# Alert

- JavaScript: none (CSS only)

## Usage

Use `alert` for default styling. Add `data-variant="destructive"` for error states. Add a direct child `<footer>` for an inline-end action region.

```html
<div class="alert"><svg><!-- info --></svg>
  <h2>Heads up!</h2>
  <section>You can add components and dependencies to your app.</section>
  <footer>
    <button type="button" class="btn" data-variant="outline">Enable</button>
  </footer>
</div>
```

### HTML structure

- `<div class="alert">` — Main container. Use `data-variant="destructive"` for error states.
  - `<svg>` *(optional)* — The icon.
  - `<h2>` — The title.
  - `<section>` *(optional)* — The description.
  - `<footer>` *(optional)* — The action region, aligned to the inline end of the alert. Put the action element inside it, such as a button or link.

## Examples

### Basic

A basic alert with an icon, title and description.

```html
<div class="alert"><svg><!-- circle-check --></svg>
  <h2>Account updated successfully</h2>
  <section>Your profile information has been saved. Changes will be reflected immediately.</section>
</div>
```

### Destructive

Use `data-variant="destructive"` to create a destructive alert.

```html
<div class="alert" data-variant="destructive"><svg><!-- circle-alert --></svg>
  <h2>Payment failed</h2>
  <section>Your payment could not be processed. Please check your payment method and try again.</section>
</div>
```

### Action

Use `<footer>` to add a button or other action element to the alert.

```html
<div class="alert">
  <h2>Dark mode is now available</h2>
  <section>Enable it under your profile settings to get started.</section>
  <footer>
    <button type="button" class="btn" data-size="xs">Enable</button>
  </footer>
</div>
```

### Custom colors

You can customize the alert colors by adding custom classes such as `bg-amber-50 dark:bg-amber-950` to the alert.

```html
<div class="alert border-amber-200 bg-amber-50 text-amber-900 dark:border-amber-900 dark:bg-amber-950 dark:text-amber-50"><svg><!-- triangle-alert --></svg>
  <h2>Your subscription will expire in 3 days.</h2>
  <section>Renew now to avoid service interruption or upgrade to a paid plan to continue using the service.</section>
</div>
```
