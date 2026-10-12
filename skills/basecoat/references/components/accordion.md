# Accordion

- JavaScript: required — `basecoat-css/accordion` (or the `all` bundle)

A vertically stacked set of interactive headings that each reveal a section of content.

## Usage

```html
<section class="accordion">
  <details open>
    <summary>
      Is it accessible?
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>Yes. It uses native disclosure semantics.</section>
  </details>
</section>
```

Basecoat uses native `<details>` and `<summary>` elements for disclosure semantics. The accordion JavaScript only enforces single-item behavior by default and prevents disabled items from toggling. Add `data-multiple` to the root when more than one item can be open at a time.

### HTML structure

- `<section class="accordion">` — Root accordion container. Add `data-multiple` to allow multiple open items.
  - `<details open>` — Accordion item. Use the native `open` attribute for the default expanded item. Add `aria-disabled="true"` when an item should not toggle.
    - `<summary>` — Accordion trigger. Keep the trigger text visible and add an optional trailing icon.
    - `<section>` — Accordion content. Use any semantic element that fits your content.

### JavaScript API

Accordion does not expose custom methods or events. Programmatically open or close an item with the native `details.open` boolean.

```js
document.querySelector("#billing").open = true
```

## Examples

### Basic

A basic accordion that shows one item at a time. The first item is open by default.

```html
<section class="accordion">
  <details open>
    <summary>
      How do I reset my password?
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>Click on 'Forgot Password' on the login page, enter your email address, and we'll send you a link to reset your password. The link will expire in 24 hours.</section>
  </details>
  <details>
    <summary>
      Can I change my subscription plan?
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>Yes. You can upgrade or downgrade your plan from the billing settings page.</section>
  </details>
  <details>
    <summary>
      What payment methods do you accept?
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>We accept all major credit cards, PayPal, and bank transfers for annual plans.</section>
  </details>
</section>
```

### Multiple

Use `data-multiple` to allow multiple items to be open at the same time.

```html
<section class="accordion" data-multiple>
  <details open>
    <summary>
      Notification Settings
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>Manage how you receive notifications. You can enable email alerts for updates or push notifications for mobile devices.</section>
  </details>
  <details>
    <summary>
      Privacy & Security
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>Control account security, session history, and privacy preferences.</section>
  </details>
  <details>
    <summary>
      Billing & Subscription
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>Review invoices, change plans, and update payment methods.</section>
  </details>
</section>
```

### Disabled

Use `aria-disabled="true"` on an item to disable it.

```html
<section class="accordion">
  <details open>
    <summary>
      Can I access my account history?
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>Yes. Your account history is available from the activity page.</section>
  </details>
  <details aria-disabled="true">
    <summary>
      Premium feature information
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>This item is disabled.</section>
  </details>
  <details>
    <summary>
      How do I update my email address?
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>Go to account settings, update your email, then confirm the change from your inbox.</section>
  </details>
</section>
```

### Borders

Add horizontal padding to the rows when using a bordered root.

```html
<section class="accordion rounded-md border [&>details>summary]:px-4 [&>details>:not(summary)]:px-4">
  <details id="billing" open>
    <summary>
      How does billing work?
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>We offer monthly and annual subscription plans. Billing is charged at the beginning of each cycle, and you can cancel anytime. All plans include automatic backups, 24/7 support, and unlimited team members.</section>
  </details>
  <details>
    <summary>
      Is my data secure?
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>Data is encrypted in transit and at rest.</section>
  </details>
  <details>
    <summary>
      What integrations do you support?
      <svg><!-- chevron-down --></svg>
    </summary>
    <section>We support Slack, GitHub, Google Workspace, and webhooks.</section>
  </details>
</section>
```

### Card

Wrap the accordion in a card for grouped support or billing content.

```html
<div class="card">
  <header>
    <h2>Subscription & Billing</h2>
    <p>Common questions about your account, plans, payments and cancellations.</p>
  </header>
  <section>
    <section class="accordion">
      <details open>
        <summary>
          What subscription plans do you offer?
          <svg><!-- chevron-down --></svg>
        </summary>
        <section>We offer three subscription tiers: Starter ($9/month), Professional ($29/month), and Enterprise ($99/month). Each plan includes increasing storage limits, API access, priority support, and team collaboration features.</section>
      </details>
      <details>
        <summary>
          How does billing work?
          <svg><!-- chevron-down --></svg>
        </summary>
        <section>Billing is charged at the beginning of each cycle.</section>
      </details>
      <details>
        <summary>
          How do I cancel my subscription?
          <svg><!-- chevron-down --></svg>
        </summary>
        <section>Cancel from billing settings. Your plan remains active until the end of the current cycle.</section>
      </details>
    </section>
  </section>
</div>
```
