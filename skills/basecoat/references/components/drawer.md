# Drawer

- JavaScript: required — `basecoat-css/drawer` (or the `all` bundle)

## Usage

Basecoat maps shadcn/ui's Vaul Drawer to a native `<dialog>` element. This keeps modality, focus handling, and inert page content in the browser platform. The Drawer script adds safe backdrop-click close and lets the exit animation finish before calling the native close. Drag gestures, snap points, and the drag handle are intentionally not included.

```html
<button type="button" class="btn" data-variant="outline" onclick="document.getElementById('demo-drawer').showModal()">Open Drawer</button>
<dialog id="demo-drawer" class="drawer" aria-labelledby="demo-drawer-title" aria-describedby="demo-drawer-description">
  <article>
    <header class="mx-auto w-full max-w-sm">
      <h2 id="demo-drawer-title">Move Goal</h2>
      <p id="demo-drawer-description">Set your daily activity goal.</p>
    </header>
    <section class="px-4">
      <div class="mx-auto w-full max-w-sm">
        <div class="flex items-center justify-center gap-6">
          <button type="button" class="btn rounded-full" data-variant="outline" data-size="icon-sm" aria-label="Decrease">...</button>
          <div class="text-center">
            <div class="text-7xl font-bold">350</div>
            <div class="text-muted-foreground text-xs uppercase">Calories/day</div>
          </div>
          <button type="button" class="btn rounded-full" data-variant="outline" data-size="icon-sm" aria-label="Increase">...</button>
        </div>
      </div>
    </section>
    <footer class="mx-auto w-full max-w-sm">
      <button type="button" class="btn" onclick="this.closest('dialog').close()">Submit</button>
      <button type="button" class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
    </footer>
  </article>
</dialog>
```

### HTML structure

> **No drag handle**: Basecoat does not implement Vaul's drag-to-close gesture, snap points, or drag handle. Drawers close with outside click, Escape, or explicit close controls.

- `<button type="button" onclick="drawer.showModal()">` *(optional)* — Trigger button. Basecoat intentionally uses the native `HTMLDialogElement.showModal()` method.
- `<dialog class="drawer" data-side="bottom|top|left|right">` — Native modal drawer. Omit `data-side` for the default bottom drawer. Add `aria-labelledby` and `aria-describedby` when title and description are present. JavaScript adds the `data-drawer-initialized` flag and manages animated close behavior.
  - `<article>` — Drawer content surface.
    - `<header>` *(optional)* — Drawer header with a title and optional description.
    - `<section>` *(optional)* — Scrollable body/content area.
    - `<footer>` *(optional)* — Action area pinned after the drawer body.

## Examples

### Sides

Use `data-side` to set the viewport side. Available values are `top`, `right`, `bottom`, and `left`.

```html
<div class="flex flex-wrap gap-2">
  <button type="button" class="btn" data-variant="outline" onclick="document.getElementById('drawer-side-top').showModal()">Top</button>
  <button type="button" class="btn" data-variant="outline" onclick="document.getElementById('drawer-side-right').showModal()">Right</button>
  <button type="button" class="btn" data-variant="outline" onclick="document.getElementById('drawer-side-bottom').showModal()">Bottom</button>
  <button type="button" class="btn" data-variant="outline" onclick="document.getElementById('drawer-side-left').showModal()">Left</button>
</div>
<dialog id="drawer-side-top" class="drawer" data-side="top" aria-labelledby="drawer-side-top-title" aria-describedby="drawer-side-top-description">
  <article class="max-h-[50vh]">
    <header>
      <h2 id="drawer-side-top-title">Move Goal</h2>
      <p id="drawer-side-top-description">Set your daily activity goal.</p>
    </header>
    <section class="px-4">
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      <!-- ...repeated 9 more times -->
    </section>
    <footer>
      <button type="button" class="btn" onclick="this.closest('dialog').close()">Submit</button>
      <button type="button" class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
    </footer>
  </article>
</dialog>
<dialog id="drawer-side-right" class="drawer" data-side="right" aria-labelledby="drawer-side-right-title" aria-describedby="drawer-side-right-description">
  <article>
    <header>
      <h2 id="drawer-side-right-title">Move Goal</h2>
      <p id="drawer-side-right-description">Set your daily activity goal.</p>
    </header>
    <section class="px-4">
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      <!-- ...repeated 9 more times -->
    </section>
    <footer>
      <button type="button" class="btn" onclick="this.closest('dialog').close()">Submit</button>
      <button type="button" class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
    </footer>
  </article>
</dialog>
<dialog id="drawer-side-bottom" class="drawer" data-side="bottom" aria-labelledby="drawer-side-bottom-title" aria-describedby="drawer-side-bottom-description">
  <article class="max-h-[50vh]">
    <header>
      <h2 id="drawer-side-bottom-title">Move Goal</h2>
      <p id="drawer-side-bottom-description">Set your daily activity goal.</p>
    </header>
    <section class="px-4">
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      <!-- ...repeated 9 more times -->
    </section>
    <footer>
      <button type="button" class="btn" onclick="this.closest('dialog').close()">Submit</button>
      <button type="button" class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
    </footer>
  </article>
</dialog>
<dialog id="drawer-side-left" class="drawer" data-side="left" aria-labelledby="drawer-side-left-title" aria-describedby="drawer-side-left-description">
  <article>
    <header>
      <h2 id="drawer-side-left-title">Move Goal</h2>
      <p id="drawer-side-left-description">Set your daily activity goal.</p>
    </header>
    <section class="px-4">
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      <!-- ...repeated 9 more times -->
    </section>
    <footer>
      <button type="button" class="btn" onclick="this.closest('dialog').close()">Submit</button>
      <button type="button" class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
    </footer>
  </article>
</dialog>
```

### Scrollable content

Keep actions visible while the drawer body scrolls.

```html
<button type="button" class="btn" data-variant="outline" onclick="document.getElementById('drawer-scrollable').showModal()">Scrollable Content</button>
<dialog id="drawer-scrollable" class="drawer" data-side="right" aria-labelledby="drawer-scrollable-title" aria-describedby="drawer-scrollable-description">
  <article>
    <header>
      <h2 id="drawer-scrollable-title">Move Goal</h2>
      <p id="drawer-scrollable-description">Set your daily activity goal.</p>
    </header>
    <section class="px-4">
      <p class="mb-4 leading-normal">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      <!-- ...repeated 9 more times -->
    </section>
    <footer>
      <button type="button" class="btn" onclick="this.closest('dialog').close()">Submit</button>
      <button type="button" class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
    </footer>
  </article>
</dialog>
```
