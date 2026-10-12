# Card

- JavaScript: none (CSS only)

## Usage

```html
<div class="card">
  <header>
    <h2>Card Title</h2>
    <p>Card Description</p>
    <div class="card-action">Card Action</div>
  </header>
  <section> <p>Card Content</p></section>
  <footer>
    <p>Card Footer</p>
  </footer>
</div>
```

## HTML structure

- `<div class="card">` — The card container. Use `data-size="sm"` for a denser layout.
  - `<header>` — The card header.
    - `<h2>` or `<h3>` — The card title.
    - `<p>` *(optional)* — The card description.
    - `<div class="card-action">` *(optional)* — Action or metadata placed in the top-right of the header. Use `<menu class="card-action">` when the content is a list of commands.
  - `<section>` — The main card content.
  - `<footer>` *(optional)* — Footer actions or secondary content at the bottom of the card.

## Examples

### Size

Use `data-size="sm"` to set the size of the card to small. The small size variant uses smaller spacing.

```html
<div class="card" data-size="sm">
  <header>
    <h2>Small Card</h2>
    <p>This card uses the small size variant.</p>
    <div class="card-action">
      <button type="button" class="btn" data-size="sm" data-variant="outline">Action</button>
    </div>
  </header>
  <section> <p>The card component supports a size attribute that can be set to <code>sm</code> for a more compact appearance.</p></section>
</div>
```

### Image

Add an image before the card header to create a card with an image.

```html
<div class="card">
  <img
    alt="Event cover"
    class="aspect-video w-full object-cover"
    src="https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=1200&auto=format&fit=crop&q=80"
  />
  <header>
    <h2>Design systems meetup</h2>
    <p>A practical talk on component APIs, accessibility, and shipping faster.</p>
    <div class="card-action">
      <span class="badge" data-variant="secondary">Featured</span>
    </div>
  </header>
  <footer>
    <button type="button" class="btn w-full">View Event</button>
  </footer>
</div>
```

## RTL

Add `dir="rtl"` to the card or an ancestor.

```html
<div class="card" dir="rtl">
  <header>
    <h2>تسجيل الدخول إلى حسابك</h2>
    <p>أدخل بريدك الإلكتروني أدناه لتسجيل الدخول إلى حسابك</p>
    <div class="card-action">
      <button type="button" class="btn" data-variant="link">إنشاء حساب</button>
    </div>
  </header>
  <section>
    <form class="grid gap-6">
      <div class="grid gap-2">
        <label class="label" for="demo-card-rtl-email">البريد الإلكتروني</label>
        <input class="input" type="email" id="demo-card-rtl-email" placeholder="m@example.com" required />
      </div>
      <div class="grid gap-2">
        <div class="flex items-center">
          <label class="label" for="demo-card-rtl-password">كلمة المرور</label>
          <a href="#" class="ms-auto inline-block text-sm underline-offset-4 hover:underline">نسيت كلمة المرور؟</a>
        </div>
        <input class="input" type="password" id="demo-card-rtl-password" required />
      </div>
    </form>
  </section>
  <footer class="flex-col gap-2">
    <button type="button" class="btn w-full">تسجيل الدخول</button>
    <button type="button" class="btn w-full" data-variant="outline">تسجيل الدخول باستخدام Google</button>
  </footer>
</div>
```
