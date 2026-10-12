# Button Group

- JavaScript: none (CSS only)

## Usage

Wrap related controls in a `button-group`.

```html
<div role="group" aria-label="Message actions" class="button-group">
  <button type="button" class="btn" data-variant="outline">Archive</button>
  <button type="button" class="btn" data-variant="outline">Report</button>
</div>
```

Use `data-orientation="vertical"` to stack items. Use `<hr role="separator" />` between items when you need a visible divider, such as a split action. Use direct child `<span>`, `<label>`, or `<output>` elements for non-interactive text segments. Direct child `<div>` elements are left unstyled for custom layouts.

## Examples

### Orientation

Use `data-orientation="vertical"` to stack buttons vertically.

```html
<div role="group" aria-label="Media controls" class="button-group h-fit" data-orientation="vertical">
  <button type="button" class="btn" data-variant="outline" data-size="icon" aria-label="Zoom in"><svg><!-- plus --></svg></button>
  <button type="button" class="btn" data-variant="outline" data-size="icon" aria-label="Zoom out"><svg><!-- minus --></svg></button>
</div>
```

### Size

```html
<div class="flex flex-col items-start gap-8">
  <div role="group" class="button-group">
    <button type="button" class="btn" data-variant="outline" data-size="sm">Small</button>
    <button type="button" class="btn" data-variant="outline" data-size="sm">Button</button>
    <button type="button" class="btn" data-variant="outline" data-size="sm">Group</button>
    <button type="button" class="btn" data-variant="outline" data-size="icon-sm" aria-label="Add small item"><svg><!-- plus --></svg></button>
  </div>
  <div role="group" class="button-group">
    <button type="button" class="btn" data-variant="outline">Default</button>
    <button type="button" class="btn" data-variant="outline">Button</button>
    <button type="button" class="btn" data-variant="outline">Group</button>
    <button type="button" class="btn" data-variant="outline" data-size="icon" aria-label="Add item"><svg><!-- plus --></svg></button>
  </div>
  <div role="group" class="button-group">
    <button type="button" class="btn" data-variant="outline" data-size="lg">Large</button>
    <button type="button" class="btn" data-variant="outline" data-size="lg">Button</button>
    <button type="button" class="btn" data-variant="outline" data-size="lg">Group</button>
    <button type="button" class="btn" data-variant="outline" data-size="icon-lg" aria-label="Add large item"><svg><!-- plus --></svg></button>
  </div>
</div>
```

### Nested

Nest `button-group` components to keep controls joined within each group while adding spacing between groups.

```html
<div role="group" aria-label="Pagination controls" class="button-group">
  <div role="group" class="button-group">
    <button type="button" class="btn" data-variant="outline" data-size="sm">1</button>
    <button type="button" class="btn" data-variant="outline" data-size="sm">2</button>
    <button type="button" class="btn" data-variant="outline" data-size="sm">3</button>
    <button type="button" class="btn" data-variant="outline" data-size="sm">4</button>
    <button type="button" class="btn" data-variant="outline" data-size="sm">5</button>
  </div>
  <div role="group" class="button-group">
    <button type="button" class="btn" data-variant="outline" data-size="icon-sm" aria-label="Previous page"><svg><!-- arrow-left --></svg></button>
    <button type="button" class="btn" data-variant="outline" data-size="icon-sm" aria-label="Next page"><svg><!-- arrow-right --></svg></button>
  </div>
</div>
```

### Separator

Use `<hr role="separator" />` to visually divide buttons within a group.

```html
<div role="group" class="button-group">
  <button type="button" class="btn" data-variant="secondary" data-size="sm">Copy</button>
  <hr role="separator" />
  <button type="button" class="btn" data-variant="secondary" data-size="sm">Paste</button>
</div>
```

### Split

Use a separator to create a split action.

```html
<div role="group" class="button-group">
  <button type="button" class="btn" data-variant="secondary">Button</button>
  <hr role="separator" />
  <button type="button" class="btn" data-variant="secondary" data-size="icon" aria-label="Add"><svg><!-- plus --></svg></button>
</div>
```

### Input

```html
<div role="group" aria-label="Search" class="button-group">
  <input type="text" class="input" placeholder="Search..." />
  <button type="button" class="btn" data-variant="outline" aria-label="Search"><svg><!-- search --></svg></button>
</div>
```

### Input group

```html
<div role="group" class="button-group">
  <div role="group" class="button-group">
    <button type="button" class="btn" data-variant="outline" data-size="icon" aria-label="Add attachment"><svg><!-- plus --></svg></button>
  </div>
  <div role="group" class="button-group">
    <div class="input-group">
      <input type="text" placeholder="Send a message..." />
      <div role="group" data-align="inline-end">
        <button type="button" class="btn" data-variant="ghost" data-size="icon-xs" aria-label="Voice mode" aria-pressed="false"><svg><!-- audio-lines --></svg></button>
      </div>
    </div>
  </div>
</div>
```

### Dropdown menu

```html
<div role="group" class="button-group">
  <button type="button" class="btn" data-variant="outline">Follow</button>
  <div id="dropdown-menu-609880" class="dropdown-menu">
    <button type="button" id="dropdown-menu-609880-trigger" aria-label="More follow options" aria-haspopup="menu" aria-controls="dropdown-menu-609880-menu" aria-expanded="false" class="btn" data-variant="outline" data-size="icon"><svg><!-- chevron-down --></svg></button>
    <div id="dropdown-menu-609880-popover" data-popover aria-hidden="true" data-align="end">
      <div role="menu" id="dropdown-menu-609880-menu" aria-labelledby="dropdown-menu-609880-trigger">
        <div role="menuitem"><svg><!-- volume-off --></svg>
          Mute Conversation
        </div>
        <div role="menuitem"><svg><!-- check --></svg>
          Mark as Read
        </div>
        <div role="menuitem"><svg><!-- triangle-alert --></svg>
          Report Conversation
        </div>
        <div role="menuitem"><svg><!-- user-round-x --></svg>
          Block User
        </div>
        <div role="menuitem"><svg><!-- share --></svg>
          Share Conversation
        </div>
        <div role="menuitem"><svg><!-- copy --></svg>
          Copy Conversation
        </div>
        <hr role="separator" />
        <div role="menuitem" class="text-destructive hover:bg-destructive/10 dark:hover:bg-destructive/20 focus:bg-destructive/10 dark:focus:bg-destructive/20 focus:text-destructive [&_svg]:!text-destructive"><svg><!-- trash-2 --></svg>
          Delete Conversation
        </div>
      </div>
    </div>
  </div>
</div>
```

### Select

```html
<div class="flex items-stretch gap-2">
  <div role="group" aria-label="Currency amount" class="button-group">
    <div id="select-797405" class="select">
      <button type="button" class="[&amp;_[data-name]]:hidden" id="select-797405-trigger" aria-haspopup="listbox" aria-expanded="false" aria-controls="select-797405-listbox">
        <span class="truncate">$</span>
        <svg class="text-muted-foreground opacity-50 shrink-0"><!-- chevron-down --></svg>
      </button>
      <div id="select-797405-popover" data-popover aria-hidden="true">
        <div role="listbox" id="select-797405-listbox" aria-orientation="vertical" aria-labelledby="select-797405-trigger">
          <div role="option" data-value="$" data-label="$" aria-selected="true">
            $
            <span class="text-muted-foreground">US Dollar</span>
          </div>
          <div role="option" data-value="€" data-label="€">
            €
            <span class="text-muted-foreground">Euro</span>
          </div>
          <div role="option" data-value="£" data-label="£">
            £
            <span class="text-muted-foreground">British Pound</span>
          </div>
        </div>
      </div>
      <input type="hidden" name="select-797405-value" value="$" />
    </div>
    <input type="text" class="input" placeholder="10.00" />
  </div>
  <button type="button" class="btn" data-variant="outline" data-size="icon" aria-label="Submit amount"><svg><!-- arrow-right --></svg></button>
</div>
```

### Popover

```html
<div role="group" class="button-group">
  <button type="button" class="btn" data-variant="outline"><svg><!-- bot --></svg>
    Copilot
  </button>
  <div id="popover-788465" class="popover">
    <button id="popover-788465-trigger" type="button" aria-label="Open Popover" aria-expanded="false" aria-controls="popover-788465-popover" class="btn" data-variant="outline" data-size="icon"><svg><!-- chevron-down --></svg></button>
    <div id="popover-788465-popover" data-popover aria-hidden="true" class="w-72 text-sm" data-align="end">
      <div>
        <p class="font-medium">Start a new task with Copilot</p>
        <p class="text-muted-foreground">Describe your task in natural language.</p>
      </div>
      <textarea class="textarea min-h-16 w-full resize-none" placeholder="I need to..."></textarea>
      <p class="text-muted-foreground text-xs">Copilot will open a pull request for review.</p>
    </div>
  </div>
</div>
```
