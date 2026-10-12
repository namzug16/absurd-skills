# Avatar

- JavaScript: none (CSS only)

## Usage

Add `class="avatar"` to a small inline container. Add `data-size="sm"` or `data-size="lg"` when needed. Put the image first and a fallback `<span>` after it. Add `.avatar-badge` for a status badge or badge icon.

```html
<span class="avatar">
  <img src="https://github.com/shadcn.png" alt="@shadcn" />
  <span>CN</span>
</span>
```

### HTML structure

- `<div class="avatar-group">` *(optional)* — Optional parent that groups avatars with overlap.
  - `<span class="avatar">` — Avatar root. Use it standalone or as a direct child of `.avatar-group`. Add `data-size="sm"` or `data-size="lg"` for alternate sizes.
    - `<img>` *(optional)* — The avatar image. Provide meaningful `alt` text.
    - `<span>` — Fallback initials or icon.
    - `<span class="avatar-badge">` *(optional)* — Status badge positioned at the block-end inline-end corner. It can be empty or contain an icon.
  - `<span data-count>` *(optional)* — Count or icon indicator displayed at the end of the group.

## Examples

### Basic

```html
<span class="avatar">
  <img src="https://github.com/shadcn.png" alt="@shadcn" />
  <span>CN</span>
</span>
```

### Badge

```html
<span class="avatar">
  <img src="https://github.com/shadcn.png" alt="@shadcn" />
  <span>CN</span>
  <span class="avatar-badge bg-green-600 dark:bg-green-800"></span>
</span>
```

### Badge with icon

```html
<span class="avatar">
  <img src="https://github.com/pranathip.png" alt="@pranathip" />
  <span>PP</span>
  <span class="avatar-badge"><svg><!-- plus --></svg></span>
</span>
```

### Avatar group

```html
<div class="avatar-group">
  <span class="avatar"><img src="https://github.com/shadcn.png" alt="@shadcn" /><span>CN</span></span>
  <span class="avatar"><img src="https://github.com/maxleiter.png" alt="@maxleiter" /><span>LR</span></span>
  <span class="avatar"><img src="https://github.com/evilrabbit.png" alt="@evilrabbit" /><span>ER</span></span>
</div>
```

### Avatar group count

```html
<div class="avatar-group">
  <span class="avatar"><img src="https://github.com/shadcn.png" alt="@shadcn" /><span>CN</span></span>
  <span class="avatar"><img src="https://github.com/maxleiter.png" alt="@maxleiter" /><span>LR</span></span>
  <span class="avatar"><img src="https://github.com/evilrabbit.png" alt="@evilrabbit" /><span>ER</span></span>
  <span data-count>+3</span>
</div>
```

### Avatar group with icon

```html
<div class="avatar-group">
  <span class="avatar"><img src="https://github.com/shadcn.png" alt="@shadcn" /><span>CN</span></span>
  <span class="avatar"><img src="https://github.com/maxleiter.png" alt="@maxleiter" /><span>LR</span></span>
  <span class="avatar"><img src="https://github.com/evilrabbit.png" alt="@evilrabbit" /><span>ER</span></span>
  <span data-count aria-label="Additional avatars"><svg><!-- plus --></svg></span>
</div>
```

### Sizes

```html
<div class="grid gap-2">
  <div class="flex flex-wrap items-center gap-2">
    <span class="avatar" data-size="sm">
      <img src="https://github.com/shadcn.png" alt="@shadcn" />
      <span>CN</span>
    </span>
    <span class="avatar">
      <img src="https://github.com/shadcn.png" alt="@shadcn" />
      <span>CN</span>
    </span>
    <span class="avatar" data-size="lg">
      <img src="https://github.com/shadcn.png" alt="@shadcn" />
      <span>CN</span>
    </span>
  </div>
  <div class="flex flex-wrap items-center gap-2">
    <span class="avatar" data-size="sm"><span>CN</span></span>
    <span class="avatar"><span>CN</span></span>
    <span class="avatar" data-size="lg"><span>CN</span></span>
  </div>
</div>
```

### Dropdown

```html
<div class="dropdown-menu">
  <button type="button" id="avatar-dropdown-trigger" aria-label="Open user menu" aria-haspopup="menu" aria-controls="avatar-dropdown-menu" aria-expanded="false" class="btn rounded-full" data-variant="ghost" data-size="icon">
    <span class="avatar">
      <img src="https://github.com/shadcn.png" alt="@shadcn" />
      <span>CN</span>
    </span>
  </button>
  <div data-popover aria-hidden="true" class="w-32">
    <div role="menu" id="avatar-dropdown-menu" aria-labelledby="avatar-dropdown-trigger">
      <div role="menuitem">Profile</div>
      <div role="menuitem">Billing</div>
      <div role="menuitem">Settings</div>
      <hr role="separator" />
      <div role="menuitem" data-variant="destructive">Log out</div>
    </div>
  </div>
</div>
```
