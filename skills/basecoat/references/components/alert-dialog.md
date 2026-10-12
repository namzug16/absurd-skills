# Alert Dialog

- JavaScript: none (CSS only)

A modal dialog that interrupts the user with important content and expects a response.

## Usage

Alert Dialog uses a native `<dialog class="alert-dialog">` element. Omit the close button and backdrop-click handler when the user must choose an explicit action.

```html
<button type="button" onclick="document.getElementById('demo-alert-dialog').showModal()" class="btn" data-variant="outline">Show Dialog</button>
<dialog id="demo-alert-dialog" class="alert-dialog" aria-labelledby="demo-alert-dialog-title" aria-describedby="demo-alert-dialog-description">
  <div>
    <header>
      <h2 id="demo-alert-dialog-title">Are you absolutely sure?</h2>
      <p id="demo-alert-dialog-description">This action cannot be undone. This will permanently delete your account and remove your data from our servers.</p>
    </header>
    <footer>
      <button class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
      <button class="btn" onclick="this.closest('dialog').close()">Continue</button>
    </footer>
  </div>
</dialog>
```

### HTML structure

- `<button type="button" onclick="dialog.showModal()">` *(optional)* — Trigger button. Basecoat uses the native `HTMLDialogElement.showModal()` method.
- `<dialog class="alert-dialog" id="{ DIALOG_ID }">` — Native modal dialog. Add `aria-labelledby` and `aria-describedby` when title and description are present. Use `data-size="sm"` for the compact upstream size.
  - `<div>` — Dialog content surface.
    - `<header>` — Alert dialog header.
      - `<figure>` *(optional)* — Media area for an icon or image.
      - `<h2 id="{ TITLE_ID }">` — Alert dialog title. Reference it from `aria-labelledby`.
      - `<p id="{ DESCRIPTION_ID }">` *(optional)* — Alert dialog description. Reference it from `aria-describedby`.
    - `<footer>` — Action area. Include a cancel action and the primary action.

## Examples

### Basic

A basic alert dialog with a title, description, and cancel and continue buttons.

```html
<button type="button" onclick="document.getElementById('alert-dialog-basic').showModal()" class="btn" data-variant="outline">Show Dialog</button>
<dialog id="alert-dialog-basic" class="alert-dialog" aria-labelledby="alert-dialog-basic-title" aria-describedby="alert-dialog-basic-description">
  <div>
    <header>
      <h2 id="alert-dialog-basic-title">Are you absolutely sure?</h2>
      <p id="alert-dialog-basic-description">This action cannot be undone. This will permanently delete your account and remove your data from our servers.</p>
    </header>
    <footer>
      <button class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
      <button class="btn" onclick="this.closest('dialog').close()">Continue</button>
    </footer>
  </div>
</dialog>
```

### Media

Use a `<figure>` in the header to add a media element such as an icon or image to the alert dialog.

```html
<button type="button" onclick="document.getElementById('alert-dialog-media').showModal()" class="btn" data-variant="outline">Share Project</button>
<dialog id="alert-dialog-media" class="alert-dialog" aria-labelledby="alert-dialog-media-title" aria-describedby="alert-dialog-media-description">
  <div>
    <header>
      <figure><svg><!-- circle-fading-plus --></svg></figure>
      <h2 id="alert-dialog-media-title">Share this project?</h2>
      <p id="alert-dialog-media-description">Anyone with the link will be able to view and edit this project.</p>
    </header>
    <footer>
      <button class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
      <button class="btn" onclick="this.closest('dialog').close()">Share</button>
    </footer>
  </div>
</dialog>
```

### Destructive

Use a destructive action button when the alert dialog confirms a destructive operation.

```html
<button type="button" onclick="document.getElementById('alert-dialog-destructive').showModal()" class="btn" data-variant="destructive">Delete Chat</button>
<dialog id="alert-dialog-destructive" class="alert-dialog" aria-labelledby="alert-dialog-destructive-title" aria-describedby="alert-dialog-destructive-description">
  <div>
    <header>
      <figure><svg><!-- trash-2 --></svg></figure>
      <h2 id="alert-dialog-destructive-title">Delete this chat?</h2>
      <p id="alert-dialog-destructive-description">This action cannot be undone. This will permanently delete the chat and remove it from your history.</p>
    </header>
    <footer>
      <button class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
      <button class="btn" data-variant="destructive" onclick="this.closest('dialog').close()">Delete</button>
    </footer>
  </div>
</dialog>
```

### Small

Use `data-size="sm"` for a compact alert dialog. The small size keeps media, title, and description stacked and centers the action buttons in a two-column footer.

```html
<button type="button" onclick="document.getElementById('alert-dialog-small').showModal()" class="btn" data-variant="outline">Invite Members</button>
<dialog id="alert-dialog-small" class="alert-dialog" data-size="sm" aria-labelledby="alert-dialog-small-title" aria-describedby="alert-dialog-small-description">
  <div>
    <header>
      <figure><svg><!-- users --></svg></figure>
      <h2 id="alert-dialog-small-title">Invite team members?</h2>
      <p id="alert-dialog-small-description">Send an invitation link to your selected teammates.</p>
    </header>
    <footer>
      <button class="btn" data-variant="outline" onclick="this.closest('dialog').close()">Cancel</button>
      <button class="btn" onclick="this.closest('dialog').close()">Invite</button>
    </footer>
  </div>
</dialog>
```
