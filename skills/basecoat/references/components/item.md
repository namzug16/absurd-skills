# Item

- JavaScript: none (CSS only)

## Usage

Add `class="item"` to a semantic element such as `<article>` or `<a>`. Use `class="item-group"` when listing multiple items.

```html
<article class="item" data-variant="outline">
  <section>
    <h3>Basic Item</h3>
    <p>A simple item with title and description.</p>
  </section>
  <aside>
    <button class="btn" data-variant="outline" data-size="sm">Action</button>
  </aside>
</article>
```

### HTML structure

- `<article class="item">` or `<a class="item">` — The item root. Use `data-variant="outline|muted"` and `data-size="sm|xs"` when needed.
  - `<figure>` *(optional)* — Media: icon, avatar, or image.
  - `<section>` — Primary content. Headings and paragraphs are styled automatically.
    - `<h2>`, `<h3>`, or `<h4>` — The item title.
    - `<p>` *(optional)* — The item description.
  - `<aside>` *(optional)* — Actions or trailing metadata.
  - `<header>`, `<footer>` *(optional)* — Full-width item regions.
- `<div class="item-group" role="list">` *(optional)* — Groups related items. Use `role="listitem"` on child items when they are not native list items.

### Item vs Field

Use `field` for form controls and validation. Use `item` for display content, actions, and navigation rows.

### Variant

### Size

## Examples

### Icon

```html
<div class="flex w-full flex-col gap-6">
  <article class="item" data-variant="outline">
    <figure><svg><!-- shield-alert --></svg></figure>
    <section>
      <h3>Security Alert</h3>
      <p>New login detected from unknown device.</p>
    </section>
    <aside><button class="btn" data-variant="outline" data-size="sm">Review</button></aside>
  </article>
</div>
```

### Avatar

```html
<div class="flex w-full flex-col gap-6">
  <article class="item" data-variant="outline">
    <figure>
      <span class="avatar" data-size="lg"><img src="https://github.com/evilrabbit.png" alt="Evil Rabbit" /></span>
    </figure>
    <section>
      <h3>Evil Rabbit</h3>
      <p>Last seen 5 months ago</p>
    </section>
    <aside>
      <button class="btn rounded-full" data-variant="outline" data-size="icon-sm" aria-label="Invite Evil Rabbit"><svg><!-- plus --></svg></button>
    </aside>
  </article>
  <article class="item" data-variant="outline">
    <figure>
      <span class="avatar-group">
        <span class="avatar hidden sm:flex"><img class="grayscale" src="https://github.com/shadcn.png" alt="@shadcn" /></span>
        <span class="avatar hidden sm:flex"><img class="grayscale" src="https://github.com/maxleiter.png" alt="@maxleiter" /></span>
        <span class="avatar"><img class="grayscale" src="https://github.com/evilrabbit.png" alt="@evilrabbit" /></span>
      </span>
    </figure>
    <section>
      <h3>No Team Members</h3>
      <p>Invite your team to collaborate on this project.</p>
    </section>
    <aside><button class="btn" data-variant="outline" data-size="sm">Invite</button></aside>
  </article>
</div>
```

### Image

```html
<div class="item-group gap-4" role="list">
  <a href="#" class="item" data-variant="outline" role="listitem">
    <figure><img class="grayscale" src="https://avatar.vercel.sh/Midnight City Lights" alt="Midnight City Lights" /></figure>
    <section><h3>Midnight City Lights - <span class="text-muted-foreground">Electric Nights</span></h3><p>Neon Dreams</p></section>
    <section><p>3:45</p></section>
  </a>
  <a href="#" class="item" data-variant="outline" role="listitem">
    <figure><img class="grayscale" src="https://avatar.vercel.sh/Coffee Shop Conversations" alt="Coffee Shop Conversations" /></figure>
    <section><h3>Coffee Shop Conversations - <span class="text-muted-foreground">Urban Stories</span></h3><p>The Morning Brew</p></section>
    <section><p>4:05</p></section>
  </a>
  <a href="#" class="item" data-variant="outline" role="listitem">
    <figure><img class="grayscale" src="https://avatar.vercel.sh/Digital Rain" alt="Digital Rain" /></figure>
    <section><h3>Digital Rain - <span class="text-muted-foreground">Binary Beats</span></h3><p>Cyber Symphony</p></section>
    <section><p>3:30</p></section>
  </a>
</div>
```

### Group

```html
<div class="flex w-full flex-col gap-6">
  <div class="item-group" role="list">
    <article class="item" role="listitem">
      <figure><span class="avatar"><img class="grayscale" src="https://github.com/shadcn.png" alt="@shadcn" /></span></figure>
      <section><h3>shadcn</h3><p>shadcn@vercel.com</p></section>
      <aside>
        <button class="btn rounded-full" data-variant="ghost" data-size="icon" aria-label="Add shadcn"><svg><!-- plus --></svg></button>
      </aside>
    </article>
    <article class="item" role="listitem">
      <figure><span class="avatar"><img class="grayscale" src="https://github.com/maxleiter.png" alt="@maxleiter" /></span></figure>
      <section><h3>maxleiter</h3><p>maxleiter@vercel.com</p></section>
      <aside>
        <button class="btn rounded-full" data-variant="ghost" data-size="icon" aria-label="Add maxleiter"><svg><!-- plus --></svg></button>
      </aside>
    </article>
    <article class="item" role="listitem">
      <figure><span class="avatar"><img class="grayscale" src="https://github.com/evilrabbit.png" alt="@evilrabbit" /></span></figure>
      <section><h3>evilrabbit</h3><p>evilrabbit@vercel.com</p></section>
      <aside>
        <button class="btn rounded-full" data-variant="ghost" data-size="icon" aria-label="Add evilrabbit"><svg><!-- plus --></svg></button>
      </aside>
    </article>
  </div>
</div>
```

### Header

```html
<div class="item-group grid grid-cols-1 gap-4 sm:grid-cols-3" role="list">
  <article class="item" data-variant="outline" role="listitem">
    <header><img class="aspect-square w-full rounded-sm object-cover grayscale" src="https://images.unsplash.com/photo-1650804068570-7fb2e3dbf888?q=80&w=640&auto=format&fit=crop" alt="v0-1.5-sm" /></header>
    <section><h3>v0-1.5-sm</h3><p>Everyday tasks and UI generation.</p></section>
  </article>
  <article class="item" data-variant="outline" role="listitem">
    <header><img class="aspect-square w-full rounded-sm object-cover grayscale" src="https://images.unsplash.com/photo-1610280777472-54133d004c8c?q=80&w=640&auto=format&fit=crop" alt="v0-1.5-lg" /></header>
    <section><h3>v0-1.5-lg</h3><p>Advanced thinking or reasoning.</p></section>
  </article>
  <article class="item" data-variant="outline" role="listitem">
    <header><img class="aspect-square w-full rounded-sm object-cover grayscale" src="https://images.unsplash.com/photo-1602146057681-08560aee8cde?q=80&w=640&auto=format&fit=crop" alt="v0-2.0-mini" /></header>
    <section><h3>v0-2.0-mini</h3><p>Open Source model for everyone.</p></section>
  </article>
</div>
```

### Link

```html
<div class="flex w-full flex-col gap-4">
  <a href="#" class="item">
    <section>
      <h3>Visit our documentation</h3>
      <p>Learn how to get started with our components.</p>
    </section>
    <aside><svg class="size-4"><!-- chevron-right --></svg></aside>
  </a>
  <a href="#" target="_blank" rel="noopener noreferrer" class="item" data-variant="outline">
    <section>
      <h3>External resource</h3>
      <p>Opens in a new tab with security attributes.</p>
    </section>
    <aside><svg class="size-4"><!-- external-link --></svg></aside>
  </a>
</div>
```

### Dropdown

```html
<div class="flex min-h-64 w-full items-center justify-center">
  <div id="item-dropdown" class="dropdown-menu">
    <button type="button" id="item-dropdown-trigger" aria-haspopup="menu" aria-controls="item-dropdown-menu" aria-expanded="false" class="btn w-fit" data-variant="outline">
      Select
      <svg data-icon="inline-end"><!-- chevron-down --></svg>
    </button>
    <div id="item-dropdown-popover" data-popover data-align="end" aria-hidden="true" class="w-48">
      <div role="menu" id="item-dropdown-menu" aria-labelledby="item-dropdown-trigger">
        <button type="button" role="menuitem">
          <span class="item border-0 p-0 shadow-none" data-size="xs">
            <figure>
              <span class="avatar" data-size="sm">
                <img class="grayscale" src="https://github.com/shadcn.png" alt="@shadcn" />
              </span>
            </figure>
            <section class="gap-0">
              <h3>shadcn</h3>
              <p class="leading-none" aria-label="shadcn@vercel.com">shadcn<span aria-hidden="true">@</span>vercel.com</p>
            </section>
          </span>
        </button>
        <button type="button" role="menuitem">
          <span class="item border-0 p-0 shadow-none" data-size="xs">
            <figure>
              <span class="avatar" data-size="sm">
                <img class="grayscale" src="https://github.com/maxleiter.png" alt="@maxleiter" />
              </span>
            </figure>
            <section class="gap-0">
              <h3>maxleiter</h3>
              <p class="leading-none" aria-label="maxleiter@vercel.com">maxleiter<span aria-hidden="true">@</span>vercel.com</p>
            </section>
          </span>
        </button>
        <button type="button" role="menuitem">
          <span class="item border-0 p-0 shadow-none" data-size="xs">
            <figure>
              <span class="avatar" data-size="sm">
                <img class="grayscale" src="https://github.com/evilrabbit.png" alt="@evilrabbit" />
              </span>
            </figure>
            <section class="gap-0">
              <h3>evilrabbit</h3>
              <p class="leading-none" aria-label="evilrabbit@vercel.com">evilrabbit<span aria-hidden="true">@</span>vercel.com</p>
            </section>
          </span>
        </button>
      </div>
    </div>
  </div>
</div>
```
