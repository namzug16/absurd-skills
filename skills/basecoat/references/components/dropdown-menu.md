# Dropdown Menu

- JavaScript: required — `basecoat-css/dropdown-menu` (or the `all` bundle)
- Templates: ships a `dropdown_menu()` macro for Jinja and Nunjucks — see [templates](../templates.md)

## Usage

Basecoat dropdown menus are inline-positioned relative to the `.dropdown-menu` wrapper. This differs from shadcn/ui's portalled Base UI implementation, but keeps the markup dependency-free and matches Basecoat's current popover/select positioning model.

```html
<div id="demo-dropdown-menu" class="dropdown-menu">
  <button type="button" id="demo-dropdown-menu-trigger" aria-haspopup="menu" aria-controls="demo-dropdown-menu-menu" aria-expanded="false" class="btn" data-variant="outline">Open</button>
  <div id="demo-dropdown-menu-popover" data-popover aria-hidden="true" class="w-40">
    <div role="menu" id="demo-dropdown-menu-menu" aria-labelledby="demo-dropdown-menu-trigger">
      <div role="group" aria-labelledby="demo-dropdown-account">
        <div role="heading" id="demo-dropdown-account">My Account</div>
        <div role="menuitem">
          <span>Profile</span>
          <kbd>⇧⌘P</kbd>
        </div>
        <div role="menuitem">
          <span>Billing</span>
          <kbd>⌘B</kbd>
        </div>
        <div role="menuitem">
          <span>Settings</span>
          <kbd>⌘S</kbd>
        </div>
      </div>
      <hr role="separator" />
      <div role="group">
        <div role="menuitem">Team</div>
        <div role="menuitem">
          <span>New Team</span>
          <kbd>⌘+T</kbd>
        </div>
      </div>
      <hr role="separator" />
      <div role="group">
        <div role="menuitem">GitHub</div>
        <div role="menuitem">Support</div>
        <div role="menuitem" aria-disabled="true">API</div>
      </div>
      <hr role="separator" />
      <div role="group">
        <div role="menuitem">
          <span>Log out</span>
          <kbd>⇧⌘Q</kbd>
        </div>
      </div>
    </div>
  </div>
</div>
```

### HTML structure

- `<div class="dropdown-menu">` — Relative wrapper for the trigger and inline menu content.
  - `<button aria-haspopup="menu" aria-expanded="false">` — Trigger button. The script toggles `aria-expanded` and manages keyboard navigation.
  - `<div data-popover aria-hidden="true">` — Menu content popover. Set `data-side="top|right|bottom|left|inline-start|inline-end"` and `data-align="start|center|end"` to control placement.
    - `<div role="menu">` — Container for menu items, groups, labels, and separators.
      - `<div role="group" aria-labelledby="{ HEADING_ID }">` *(optional)* — Groups related menu items.
      - `<div role="heading" id="{ HEADING_ID }">` *(optional)* — Group heading/label.
      - `<div role="menuitem">` — Standard action item. Use `aria-disabled="true"` for disabled items.
      - `<div role="menuitemcheckbox" aria-checked="true">` — Checkbox-style item. Add a child with `data-indicator` for the checked icon.
      - `<div role="menuitemradio" aria-checked="true">` — Radio-style item. Add a child with `data-indicator` for the selected icon.
      - `<kbd>` *(optional)* — Shortcut hint aligned to the inline end of the item.
      - `<hr role="separator">` *(optional)* — Separator between groups or options.

### JavaScript API

| API | Type | Description |
| --- | --- | --- |
| `dropdown.open()` | Method | Opens the menu. |
| `dropdown.close()` | Method | Closes the menu. |
| `dropdown.toggle()` | Method | Toggles the menu. |
| `dropdown.refresh()` | Method | Rescans menu items after children change inside the existing `role="menu"` element. |

## Examples

### Basic

```html
<div id="dropdown-basic" class="dropdown-menu">
  <button type="button" id="dropdown-basic-trigger" aria-haspopup="menu" aria-controls="dropdown-basic-menu" aria-expanded="false" class="btn" data-variant="outline">Open</button>
  <div id="dropdown-basic-popover" data-popover aria-hidden="true" class="min-w-32">
    <div role="menu" id="dropdown-basic-menu" aria-labelledby="dropdown-basic-trigger">
      <div role="group" aria-labelledby="dropdown-basic-account">
        <div role="heading" id="dropdown-basic-account">My Account</div>
        <div role="menuitem">Profile</div>
        <div role="menuitem">Billing</div>
        <div role="menuitem">Settings</div>
      </div>
      <hr role="separator" />
      <div role="menuitem">GitHub</div>
      <div role="menuitem">Support</div>
      <div role="menuitem" aria-disabled="true">API</div>
    </div>
  </div>
</div>
```

### Shortcuts

```html
<div id="dropdown-shortcuts" class="dropdown-menu">
  <button type="button" id="dropdown-shortcuts-trigger" aria-haspopup="menu" aria-controls="dropdown-shortcuts-menu" aria-expanded="false" class="btn" data-variant="outline">Open</button>
  <div id="dropdown-shortcuts-popover" data-popover aria-hidden="true" class="min-w-46">
    <div role="menu" id="dropdown-shortcuts-menu" aria-labelledby="dropdown-shortcuts-trigger">
      <div role="group" aria-labelledby="dropdown-shortcuts-account">
        <div role="heading" id="dropdown-shortcuts-account">My Account</div>
        <div role="menuitem">
          <span>Profile</span>
          <kbd>⇧⌘P</kbd>
        </div>
        <div role="menuitem">
          <span>Billing</span>
          <kbd>⌘B</kbd>
        </div>
        <div role="menuitem">
          <span>Settings</span>
          <kbd>⌘S</kbd>
        </div>
      </div>
      <hr role="separator" />
      <div role="menuitem">
        <span>Log out</span>
        <kbd>⇧⌘Q</kbd>
      </div>
    </div>
  </div>
</div>
```

### Icons

```html
<div id="dropdown-icons" class="dropdown-menu">
  <button type="button" id="dropdown-icons-trigger" aria-haspopup="menu" aria-controls="dropdown-icons-menu" aria-expanded="false" class="btn" data-variant="outline">Open</button>
  <div id="dropdown-icons-popover" data-popover aria-hidden="true" class="min-w-32">
    <div role="menu" id="dropdown-icons-menu" aria-labelledby="dropdown-icons-trigger">
      <div role="menuitem"><svg><!-- user --></svg>
        Profile
      </div>
      <div role="menuitem"><svg><!-- credit-card --></svg>
        Billing
      </div>
      <div role="menuitem"><svg><!-- settings --></svg>
        Settings
      </div>
      <hr role="separator" />
      <div role="menuitem" data-variant="destructive"><svg><!-- log-out --></svg>
        Log out
      </div>
    </div>
  </div>
</div>
```

### Checkboxes

```html
<div id="dropdown-checkboxes" class="dropdown-menu">
  <button type="button" id="dropdown-checkboxes-trigger" aria-haspopup="menu" aria-controls="dropdown-checkboxes-menu" aria-expanded="false" class="btn" data-variant="outline">Open</button>
  <div id="dropdown-checkboxes-popover" data-popover aria-hidden="true" class="w-40">
    <div role="menu" id="dropdown-checkboxes-menu" aria-labelledby="dropdown-checkboxes-trigger">
      <div role="group" aria-labelledby="dropdown-checkboxes-label">
        <div role="heading" id="dropdown-checkboxes-label">Appearance</div>
        <div role="menuitemcheckbox" aria-checked="true">
          <span data-indicator><svg><!-- check --></svg></span>
          Status Bar
        </div>
        <div role="menuitemcheckbox" aria-checked="false" aria-disabled="true">
          <span data-indicator><svg><!-- check --></svg></span>
          Activity Bar
        </div>
        <div role="menuitemcheckbox" aria-checked="false">
          <span data-indicator><svg><!-- check --></svg></span>
          Panel
        </div>
      </div>
    </div>
  </div>
</div>
```

### Checkboxes Icons

```html
<div id="dropdown-checkboxes-icons" class="dropdown-menu">
  <button type="button" id="dropdown-checkboxes-icons-trigger" aria-haspopup="menu" aria-controls="dropdown-checkboxes-icons-menu" aria-expanded="false" class="btn" data-variant="outline">Notifications</button>
  <div id="dropdown-checkboxes-icons-popover" data-popover aria-hidden="true" class="w-48">
    <div role="menu" id="dropdown-checkboxes-icons-menu" aria-labelledby="dropdown-checkboxes-icons-trigger">
      <div role="group" aria-labelledby="dropdown-checkboxes-icons-label">
        <div role="heading" id="dropdown-checkboxes-icons-label">Notification Preferences</div>
        <div role="menuitemcheckbox" aria-checked="true">
          <span data-indicator><svg><!-- check --></svg></span>
          <svg><!-- mail --></svg>
          Email notifications
        </div>
        <div role="menuitemcheckbox" aria-checked="false">
          <span data-indicator><svg><!-- check --></svg></span>
          <svg><!-- message-square --></svg>
          SMS notifications
        </div>
        <div role="menuitemcheckbox" aria-checked="true">
          <span data-indicator><svg><!-- check --></svg></span>
          <svg><!-- bell --></svg>
          Push notifications
        </div>
      </div>
    </div>
  </div>
</div>
```

### Radio group

```html
<div id="dropdown-radio-group" class="dropdown-menu">
  <button type="button" id="dropdown-radio-group-trigger" aria-haspopup="menu" aria-controls="dropdown-radio-group-menu" aria-expanded="false" class="btn" data-variant="outline">Open</button>
  <div id="dropdown-radio-group-popover" data-popover aria-hidden="true" class="min-w-32">
    <div role="menu" id="dropdown-radio-group-menu" aria-labelledby="dropdown-radio-group-trigger">
      <div role="group" aria-labelledby="dropdown-radio-label">
        <div role="heading" id="dropdown-radio-label">Panel Position</div>
        <div role="menuitemradio" aria-checked="false">
          <span data-indicator><svg><!-- check --></svg></span>
          Top
        </div>
        <div role="menuitemradio" aria-checked="true">
          <span data-indicator><svg><!-- check --></svg></span>
          Bottom
        </div>
        <div role="menuitemradio" aria-checked="false">
          <span data-indicator><svg><!-- check --></svg></span>
          Right
        </div>
      </div>
    </div>
  </div>
</div>
```

### Radio Icons

```html
<div id="dropdown-radio-icons" class="dropdown-menu">
  <button type="button" id="dropdown-radio-icons-trigger" aria-haspopup="menu" aria-controls="dropdown-radio-icons-menu" aria-expanded="false" class="btn" data-variant="outline">Payment Method</button>
  <div id="dropdown-radio-icons-popover" data-popover aria-hidden="true" class="min-w-56">
    <div role="menu" id="dropdown-radio-icons-menu" aria-labelledby="dropdown-radio-icons-trigger">
      <div role="group" aria-labelledby="dropdown-radio-icons-label">
        <div role="heading" id="dropdown-radio-icons-label">Select Payment Method</div>
        <div role="menuitemradio" aria-checked="true">
          <span data-indicator><svg><!-- check --></svg></span>
          <svg><!-- credit-card --></svg>
          Credit Card
        </div>
        <div role="menuitemradio" aria-checked="false">
          <span data-indicator><svg><!-- check --></svg></span>
          <svg><!-- wallet --></svg>
          PayPal
        </div>
        <div role="menuitemradio" aria-checked="false">
          <span data-indicator><svg><!-- check --></svg></span>
          <svg><!-- building-2 --></svg>
          Bank Transfer
        </div>
      </div>
    </div>
  </div>
</div>
```

### Destructive

```html
<div id="dropdown-destructive" class="dropdown-menu">
  <button type="button" id="dropdown-destructive-trigger" aria-haspopup="menu" aria-controls="dropdown-destructive-menu" aria-expanded="false" class="btn" data-variant="outline">Actions</button>
  <div id="dropdown-destructive-popover" data-popover aria-hidden="true" class="min-w-32">
    <div role="menu" id="dropdown-destructive-menu" aria-labelledby="dropdown-destructive-trigger">
      <div role="group">
        <div role="menuitem"><svg><!-- pencil --></svg>
          Edit
        </div>
        <div role="menuitem"><svg><!-- share --></svg>
          Share
        </div>
      </div>
      <hr role="separator" />
      <div role="group">
        <div role="menuitem" data-variant="destructive"><svg><!-- trash --></svg>
          Delete
        </div>
      </div>
    </div>
  </div>
</div>
```

### Avatar

```html
<div id="dropdown-avatar" class="dropdown-menu">
  <button type="button" id="dropdown-avatar-trigger" aria-haspopup="menu" aria-controls="dropdown-avatar-menu" aria-expanded="false" class="btn rounded-full" data-variant="ghost" data-size="icon">
    <span class="avatar">
      <img src="https://github.com/shadcn.png" alt="shadcn" />
      <span>LR</span>
    </span>
  </button>
  <div id="dropdown-avatar-popover" data-popover aria-hidden="true" data-align="end">
    <div role="menu" id="dropdown-avatar-menu" aria-labelledby="dropdown-avatar-trigger">
      <div role="group">
        <div role="menuitem"><svg><!-- badge-check --></svg>
          Account
        </div>
        <div role="menuitem"><svg><!-- credit-card --></svg>
          Billing
        </div>
        <div role="menuitem"><svg><!-- bell --></svg>
          Notifications
        </div>
      </div>
      <hr role="separator" />
      <div role="menuitem"><svg><!-- log-out --></svg>
        Sign Out
      </div>
    </div>
  </div>
</div>
```
