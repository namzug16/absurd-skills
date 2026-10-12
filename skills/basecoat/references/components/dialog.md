# Dialog

- JavaScript: none (CSS only)
- Templates: ships a `dialog()` macro for Jinja and Nunjucks — see [templates](../templates.md)

## Usage

Basecoat uses the native `<dialog>` element and `showModal()`. This differs from shadcn/ui's portalled Base UI implementation, but preserves native modality, focus handling, and inert page content without component JavaScript.

```html
<button type="button" onclick="document.getElementById('demo-dialog-edit-profile').showModal()" class="btn" data-variant="outline">Open Dialog</button>
<dialog id="demo-dialog-edit-profile" class="dialog" aria-labelledby="demo-dialog-edit-profile-title" aria-describedby="demo-dialog-edit-profile-description" onclick="if (event.target === this) this.close()">
  <div class="sm:max-w-sm">
    <header>
      <h2 id="demo-dialog-edit-profile-title">Edit profile</h2>
      <p id="demo-dialog-edit-profile-description">Make changes to your profile here. Click save when you're done.</p>
    </header>
    <section>
      <form class="grid gap-4">
        <div class="grid gap-3">
          <label class="label" for="demo-dialog-edit-profile-name">Name</label>
          <input class="input" type="text" value="Pedro Duarte" id="demo-dialog-edit-profile-name" autofocus />
        </div>
        <div class="grid gap-3">
          <label class="label" for="demo-dialog-edit-profile-username">Username</label>
          <input class="input" type="text" value="@peduarte" id="demo-dialog-edit-profile-username" />
        </div>
      </form>
    </section>
    <footer>
      <button class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
      <button class="btn" onclick="this.closest('dialog').close()">Save changes</button>
    </footer>
    <button type="button" class="btn" data-variant="ghost" data-size="icon-sm" aria-label="Close dialog" onclick="this.closest('dialog').close()"><svg><!-- x --></svg></button>
  </div>
</dialog>
```

### HTML structure

- `<button type="button" onclick="dialog.showModal()">` *(optional)* — Trigger button. Basecoat intentionally uses the native `HTMLDialogElement.showModal()` method.
- `<dialog class="dialog" id="{ DIALOG_ID }">` — Native modal dialog. Add `aria-labelledby="{ TITLE_ID }"` and `aria-describedby="{ DESCRIPTION_ID }"` when title and description are present. Add width utilities to the inner `<div>` when a dialog needs a custom size. The macro also adds backdrop-click close handling.
  - `<div>` — Dialog content surface.
    - `<header>` *(optional)* — Dialog header.
      - `<h2 id="{ TITLE_ID }">` — Dialog title. Reference it from `aria-labelledby`.
      - `<p id="{ DESCRIPTION_ID }">` *(optional)* — Dialog description. Reference it from `aria-describedby`.
    - `<section>` *(optional)* — Dialog body/content area. Add overflow utilities when the body should scroll.
    - `<footer>` *(optional)* — Action area. It stacks actions on small screens and aligns them to the end on larger screens.
    - `<button type="button" onclick="this.closest('dialog').close()">` *(optional)* — Close button. You can also wrap a button in `<form method="dialog">`.

## Examples

### Custom close button

```html
<button type="button" onclick="document.getElementById('dialog-custom-close').showModal()" class="btn" data-variant="outline">Share</button>
<dialog id="dialog-custom-close" class="dialog" aria-labelledby="dialog-custom-close-title" aria-describedby="dialog-custom-close-description" onclick="if (event.target === this) this.close()">
  <div class="sm:max-w-md">
    <header>
      <h2 id="dialog-custom-close-title">Share link</h2>
      <p id="dialog-custom-close-description">Anyone who has this link will be able to view this.</p>
    </header>
    <section class="flex items-center gap-2">
      <div class="grid flex-1 gap-2">
        <label class="label sr-only" for="dialog-custom-close-link">Link</label>
        <input class="input" id="dialog-custom-close-link" value="https://basecoatui.com/installation/" readonly />
      </div>
    </section>
    <footer class="sm:justify-start">
      <button class="btn" onclick="this.closest('dialog').close()">Close</button>
    </footer>
  </div>
</dialog>
```

### No close button

```html
<button type="button" onclick="document.getElementById('dialog-no-close').showModal()" class="btn" data-variant="outline">No Close Button</button>
<dialog id="dialog-no-close" class="dialog" aria-labelledby="dialog-no-close-title" aria-describedby="dialog-no-close-description" onclick="if (event.target === this) this.close()">
  <div>
    <header>
      <h2 id="dialog-no-close-title">No Close Button</h2>
      <p id="dialog-no-close-description">This dialog doesn't have a close button in the top-right corner.</p>
    </header>
  </div>
</dialog>
```

### Sticky footer

```html
<button type="button" onclick="document.getElementById('dialog-sticky-footer').showModal()" class="btn" data-variant="outline">Sticky Footer</button>
<dialog id="dialog-sticky-footer" class="dialog" aria-labelledby="dialog-sticky-footer-title" aria-describedby="dialog-sticky-footer-description" onclick="if (event.target === this) this.close()">
  <div>
    <header>
      <h2 id="dialog-sticky-footer-title">Sticky Footer</h2>
      <p id="dialog-sticky-footer-description">This dialog has a sticky footer that stays visible while the content scrolls.</p>
    </header>
    <section class="-mx-4 max-h-[50vh] overflow-y-auto px-4 scrollbar">
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      <p class="mb-4 leading-normal">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      <p class="mb-4 leading-normal">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      <p class="mb-4 leading-normal">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      <p class="mb-4 leading-normal">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      <p class="mb-4 leading-normal">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
    </section>
    <footer>
      <button class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Close</button>
    </footer>
    <button type="button" class="btn" data-variant="ghost" data-size="icon-sm" aria-label="Close dialog" onclick="this.closest('dialog').close()"><svg><!-- x --></svg></button>
  </div>
</dialog>
```

### Scrollable content

```html
<button type="button" onclick="document.getElementById('dialog-scrollable').showModal()" class="btn" data-variant="outline">Scrollable Content</button>
<dialog id="dialog-scrollable" class="dialog" aria-labelledby="dialog-scrollable-title" aria-describedby="dialog-scrollable-description" onclick="if (event.target === this) this.close()">
  <div>
    <header>
      <h2 id="dialog-scrollable-title">Scrollable Content</h2>
      <p id="dialog-scrollable-description">This is a dialog with scrollable content.</p>
    </header>
    <section class="-mx-4 max-h-[50vh] overflow-y-auto px-4 scrollbar">
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      <p class="mb-4 leading-normal">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      <p class="mb-4 leading-normal">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      <p class="mb-4 leading-normal">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      <p class="mb-4 leading-normal">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      <p class="mb-4 leading-normal">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      <p class="mb-4 leading-normal">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      <p class="mb-4 leading-normal">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
    </section>
    <button type="button" class="btn" data-variant="ghost" data-size="icon-sm" aria-label="Close dialog" onclick="this.closest('dialog').close()"><svg><!-- x --></svg></button>
  </div>
</dialog>
```
