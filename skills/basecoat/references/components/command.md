# Command

- JavaScript: required — `basecoat-css/command` (or the `all` bundle)
- Templates: ships `command()` and `command_dialog()` macros for Jinja and Nunjucks — see [templates](../templates.md)

## Usage

```html
<div id="demo-command-standalone" class="command border" aria-label="Command menu">
  <header><svg><!-- search --></svg>
    <input type="text" id="demo-command-standalone-input" placeholder="Type a command or search..." autocomplete="off" autocorrect="off" spellcheck="false" aria-autocomplete="list" role="combobox" aria-expanded="true" aria-controls="demo-command-standalone-menu" />
  </header>
  <div role="menu" id="demo-command-standalone-menu" aria-orientation="vertical" data-empty="No results found.">
    <div role="group" aria-labelledby="suggestions">
      <span role="heading" id="suggestions">Suggestions</span>
      <div role="menuitem" data-filter="Calendar" data-keywords="date event schedule"><svg><!-- calendar --></svg>
        <span>Calendar</span>
      </div>
      <div role="menuitem" data-filter="Search Emoji" data-keywords="emoji smile reaction"><svg><!-- smile --></svg>
        <span>Search Emoji</span>
      </div>
      <div role="menuitem" aria-disabled="true"><svg><!-- calculator --></svg>
        <span>Calculator</span>
      </div>
    </div>
    <hr role="separator" />
    <div role="group" aria-labelledby="settings">
      <span role="heading" id="settings">Settings</span>
      <div role="menuitem" data-filter="Profile" data-keywords="user account"><svg><!-- user --></svg>
        <span>Profile</span>
        <span data-shortcut>⌘P</span>
      </div>
      <div role="menuitem" data-filter="Billing" data-keywords="invoice payment"><svg><!-- credit-card --></svg>
        <span>Billing</span>
        <span data-shortcut>⌘B</span>
      </div>
      <div role="menuitem" data-filter="Settings" data-keywords="config preferences"><svg><!-- settings --></svg>
        <span>Settings</span>
        <span data-shortcut>⌘S</span>
      </div>
    </div>
  </div>
</div>
```

Use `<dialog class="command-dialog">` for the command palette variant.

```html
<button class="btn" data-variant="outline" onclick="document.getElementById('command-palette').showModal()">Open</button>
<dialog id="command-palette" class="command-dialog" aria-label="Command menu">
  <div class="command">
    <!-- Command content -->
  </div>
</dialog>
```

### HTML structure

The command menu can be used standalone or inside a native dialog. The structure is:

- `<dialog class="command-dialog">` *(optional)* — Dialog variant. Wraps one direct child `<div class="command">`. Add `aria-label` or `aria-labelledby` for an accessible name.
  - `<div class="command">` — Root command menu. Can also be used standalone without the dialog wrapper. Add `data-filter="manual"` when your app owns filtering, such as remote search or a local Lunr index.
    - `<header>` — Search input wrapper. The macro includes a search icon and input.
      - `<input type="text" role="combobox">` — Filter input. Use `aria-expanded="true"` and `aria-controls="{ MENU_ID }"` to point to the command list.
    - `<div role="menu" id="{ MENU_ID }">` — Command list. Set `data-empty` to customize the empty state.
      - `<div role="group" aria-labelledby="{ HEADING_ID }">` *(optional)* — Groups related command items. Hidden automatically when every item in the group is filtered out.
      - `<span role="heading" id="{ HEADING_ID }">` *(optional)* — Group heading. Use an `id` when the parent group uses `aria-labelledby`.
      - `<div role="menuitem">` or `<a role="menuitem">` — Selectable command item. Use `<a>` for navigation and `<div>` for actions. Supports `data-filter`, `data-keywords`, `data-force`, `data-keep-command-open`, `aria-disabled="true"`, and `data-disabled="true"`.
      - `<span data-shortcut>` *(optional)* — Shortcut hint aligned to the inline end of the item.
      - `<span data-indicator>` *(optional)* — Item indicator. It becomes visible with `data-checked="true"` or `aria-selected="true"`.
      - `<hr role="separator">` *(optional)* — Separator between groups/items. Hidden while filtering.

### JavaScript API

| API | Type | Description |
| --- | --- | --- |
| `command.refresh()` | Method | Rescans command items after children change inside the existing `role="menu"` list. |

## Examples

### Basic

A simple command menu in a dialog.

```html
<button type="button" class="btn" data-variant="outline" onclick="document.getElementById('command-basic').showModal()">Open Menu</button>
<dialog id="command-basic" class="command-dialog" aria-label="Command menu" onclick="if (event.target === this) this.close()">
  <div class="command">
    <header><svg><!-- search --></svg>
      <input type="text" id="command-basic-input" placeholder="Type a command or search..." autocomplete="off" autocorrect="off" spellcheck="false" aria-autocomplete="list" role="combobox" aria-expanded="true" aria-controls="command-basic-menu" />
    </header>
    <div role="menu" id="command-basic-menu" aria-orientation="vertical" data-empty="No results found.">
      <div role="group" aria-labelledby="command-basic-suggestions">
        <span role="heading" id="command-basic-suggestions">Suggestions</span>
        <div role="menuitem" data-filter="Calendar">Calendar</div>
        <div role="menuitem" data-filter="Search Emoji">Search Emoji</div>
        <div role="menuitem" data-filter="Calculator">Calculator</div>
      </div>
    </div>
  </div>
</dialog>
```

### Shortcuts

```html
<button type="button" class="btn" data-variant="outline" onclick="document.getElementById('command-shortcuts-dialog').showModal()">Open Menu</button>
<dialog id="command-shortcuts-dialog" class="command-dialog" aria-label="Command menu" onclick="if (event.target === this) this.close()">
  <div class="command">
    <header><svg><!-- search --></svg>
      <input type="text" id="command-shortcuts-input" placeholder="Type a command or search..." autocomplete="off" autocorrect="off" spellcheck="false" aria-autocomplete="list" role="combobox" aria-expanded="true" aria-controls="command-shortcuts-menu" />
    </header>
    <div role="menu" id="command-shortcuts-menu" aria-orientation="vertical" data-empty="No results found.">
      <div role="group" aria-labelledby="command-shortcuts-settings">
        <span role="heading" id="command-shortcuts-settings">Settings</span>
        <div role="menuitem" data-filter="Profile" data-keywords="user account"><svg><!-- user --></svg>
          <span>Profile</span>
          <span data-shortcut>⌘P</span>
        </div>
        <div role="menuitem" data-filter="Billing" data-keywords="invoice payment"><svg><!-- credit-card --></svg>
          <span>Billing</span>
          <span data-shortcut>⌘B</span>
        </div>
        <div role="menuitem" data-filter="Settings" data-keywords="config preferences"><svg><!-- settings --></svg>
          <span>Settings</span>
          <span data-shortcut>⌘S</span>
        </div>
      </div>
    </div>
  </div>
</dialog>
```

### Groups

```html
<button type="button" class="btn" data-variant="outline" onclick="document.getElementById('command-groups-dialog').showModal()">Open Menu</button>
<dialog id="command-groups-dialog" class="command-dialog" aria-label="Command menu" onclick="if (event.target === this) this.close()">
  <div class="command">
    <header><svg><!-- search --></svg>
      <input type="text" id="command-groups-input" placeholder="Type a command or search..." autocomplete="off" autocorrect="off" spellcheck="false" aria-autocomplete="list" role="combobox" aria-expanded="true" aria-controls="command-groups-menu" />
    </header>
    <div role="menu" id="command-groups-menu" aria-orientation="vertical" data-empty="No results found.">
      <div role="group" aria-labelledby="command-groups-suggestions">
        <span role="heading" id="command-groups-suggestions">Suggestions</span>
        <div role="menuitem" data-filter="Calendar" data-keywords="date event schedule"><svg><!-- calendar --></svg>
          <span>Calendar</span>
        </div>
        <div role="menuitem" data-filter="Search Emoji" data-keywords="emoji smile reaction"><svg><!-- smile --></svg>
          <span>Search Emoji</span>
        </div>
        <div role="menuitem" data-filter="Calculator"><svg><!-- calculator --></svg>
          <span>Calculator</span>
        </div>
      </div>
      <hr role="separator" />
      <div role="group" aria-labelledby="command-groups-settings">
        <span role="heading" id="command-groups-settings">Settings</span>
        <div role="menuitem" data-filter="Profile" data-keywords="user account"><svg><!-- user --></svg>
          <span>Profile</span>
          <span data-shortcut>⌘P</span>
        </div>
        <div role="menuitem" data-filter="Billing" data-keywords="invoice payment"><svg><!-- credit-card --></svg>
          <span>Billing</span>
          <span data-shortcut>⌘B</span>
        </div>
        <div role="menuitem" data-filter="Settings" data-keywords="config preferences"><svg><!-- settings --></svg>
          <span>Settings</span>
          <span data-shortcut>⌘S</span>
        </div>
      </div>
    </div>
  </div>
</dialog>
```

### Scrollable

```html
<button type="button" class="btn" data-variant="outline" onclick="document.getElementById('command-scrollable-dialog').showModal()">Open Menu</button>
<dialog id="command-scrollable-dialog" class="command-dialog" aria-label="Command menu" onclick="if (event.target === this) this.close()">
  <div class="command">
    <header><svg><!-- search --></svg>
      <input type="text" id="command-scrollable-input" placeholder="Type a command or search..." autocomplete="off" autocorrect="off" spellcheck="false" aria-autocomplete="list" role="combobox" aria-expanded="true" aria-controls="command-scrollable-menu" />
    </header>
    <div role="menu" id="command-scrollable-menu" aria-orientation="vertical" data-empty="No results found.">
      <div role="group" aria-labelledby="command-scrollable-navigation">
        <span role="heading" id="command-scrollable-navigation">Navigation</span>
        <div role="menuitem" data-filter="Home"><svg><!-- home --></svg><span>Home</span><span data-shortcut>⌘H</span></div>
        <div role="menuitem" data-filter="Inbox"><svg><!-- inbox --></svg><span>Inbox</span><span data-shortcut>⌘I</span></div>
        <div role="menuitem" data-filter="Documents"><svg><!-- file-text --></svg><span>Documents</span><span data-shortcut>⌘D</span></div>
        <div role="menuitem" data-filter="Folders"><svg><!-- folder --></svg><span>Folders</span><span data-shortcut>⌘F</span></div>
      </div>
      <hr role="separator" />
      <div role="group" aria-labelledby="command-scrollable-actions">
        <span role="heading" id="command-scrollable-actions">Actions</span>
        <div role="menuitem" data-filter="New File"><svg><!-- plus --></svg><span>New File</span><span data-shortcut>⌘N</span></div>
        <div role="menuitem" data-filter="New Folder"><svg><!-- folder-plus --></svg><span>New Folder</span><span data-shortcut>⇧⌘N</span></div>
        <div role="menuitem" data-filter="Copy"><svg><!-- copy --></svg><span>Copy</span><span data-shortcut>⌘C</span></div>
        <div role="menuitem" data-filter="Cut"><svg><!-- scissors --></svg><span>Cut</span><span data-shortcut>⌘X</span></div>
        <div role="menuitem" data-filter="Paste"><svg><!-- clipboard-paste --></svg><span>Paste</span><span data-shortcut>⌘V</span></div>
        <div role="menuitem" data-filter="Delete"><svg><!-- trash --></svg><span>Delete</span><span data-shortcut>⌫</span></div>
      </div>
      <hr role="separator" />
      <div role="group" aria-labelledby="command-scrollable-view">
        <span role="heading" id="command-scrollable-view">View</span>
        <div role="menuitem" data-filter="Grid View"><svg><!-- layout-grid --></svg><span>Grid View</span></div>
        <div role="menuitem" data-filter="List View"><svg><!-- list --></svg><span>List View</span></div>
        <div role="menuitem" data-filter="Zoom In"><svg><!-- zoom-in --></svg><span>Zoom In</span><span data-shortcut>⌘+</span></div>
        <div role="menuitem" data-filter="Zoom Out"><svg><!-- zoom-out --></svg><span>Zoom Out</span><span data-shortcut>⌘-</span></div>
      </div>
      <hr role="separator" />
      <div role="group" aria-labelledby="command-scrollable-account">
        <span role="heading" id="command-scrollable-account">Account</span>
        <div role="menuitem" data-filter="Profile"><svg><!-- user --></svg><span>Profile</span><span data-shortcut>⌘P</span></div>
        <div role="menuitem" data-filter="Billing"><svg><!-- credit-card --></svg><span>Billing</span><span data-shortcut>⌘B</span></div>
        <div role="menuitem" data-filter="Settings"><svg><!-- settings --></svg><span>Settings</span><span data-shortcut>⌘S</span></div>
        <div role="menuitem" data-filter="Notifications"><svg><!-- bell --></svg><span>Notifications</span></div>
        <div role="menuitem" data-filter="Help & Support"><svg><!-- circle-help --></svg><span>Help &amp; Support</span></div>
      </div>
      <hr role="separator" />
      <div role="group" aria-labelledby="command-scrollable-tools">
        <span role="heading" id="command-scrollable-tools">Tools</span>
        <div role="menuitem" data-filter="Calculator"><svg><!-- calculator --></svg><span>Calculator</span></div>
        <div role="menuitem" data-filter="Calendar"><svg><!-- calendar --></svg><span>Calendar</span></div>
        <div role="menuitem" data-filter="Image Editor"><svg><!-- image --></svg><span>Image Editor</span></div>
        <div role="menuitem" data-filter="Code Editor"><svg><!-- code --></svg><span>Code Editor</span></div>
      </div>
    </div>
  </div>
</dialog>
```

## RTL

Add `dir="rtl"` to the command root or an ancestor.

```html
<div dir="rtl">
  <div id="command-rtl" class="command border" aria-label="Command menu">
    <header><svg><!-- search --></svg>
      <input type="text" id="command-rtl-input" placeholder="اكتب أمرًا أو ابحث..." autocomplete="off" autocorrect="off" spellcheck="false" aria-autocomplete="list" role="combobox" aria-expanded="true" aria-controls="command-rtl-menu" />
    </header>
    <div role="menu" id="command-rtl-menu" aria-orientation="vertical" data-empty="لم يتم العثور على نتائج.">
      <div role="group" aria-labelledby="command-rtl-suggestions">
        <span role="heading" id="command-rtl-suggestions">اقتراحات</span>
        <div role="menuitem" data-filter="Calendar"><svg><!-- calendar --></svg>
          <span>التقويم</span>
          <span data-shortcut>⌘K</span>
        </div>
        <div role="menuitem" data-filter="Search Emoji"><svg><!-- smile --></svg>
          <span>البحث عن الرموز التعبيرية</span>
        </div>
        <div role="menuitem" aria-disabled="true" data-filter="Calculator"><svg><!-- calculator --></svg>
          <span>الآلة الحاسبة</span>
        </div>
      </div>
      <hr role="separator" />
      <div role="group" aria-labelledby="command-rtl-settings">
        <span role="heading" id="command-rtl-settings">الإعدادات</span>
        <div role="menuitem" data-filter="Profile"><svg><!-- user --></svg>
          <span>الملف الشخصي</span>
          <span data-shortcut>⌘P</span>
        </div>
        <div role="menuitem" data-filter="Billing"><svg><!-- credit-card --></svg>
          <span>الفوترة</span>
          <span data-shortcut>⌘B</span>
        </div>
        <div role="menuitem" data-filter="Settings"><svg><!-- settings --></svg>
          <span>الإعدادات</span>
          <span data-shortcut>⌘S</span>
        </div>
      </div>
    </div>
  </div>
</div>
```
