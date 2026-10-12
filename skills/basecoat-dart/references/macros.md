# Dart interface reference

Everything here is defined in `basecoat.dart` ([source](../assets/basecoat.dart)). All methods return an HTML `String`, trimmed. Null arguments are omitted so the macro's own default applies.

- [Conventions](#conventions)
- [Item classes](#item-classes)
- [select](#select) · [combobox](#combobox) · [command, commandDialog](#command-commanddialog) · [dialog](#dialog) · [dropdownMenu](#dropdownmenu) · [popover](#popover) · [sidebar](#sidebar) · [tabs](#tabs) · [toaster, toast](#toaster-toast)
- [Escape hatches](#escape-hatches)

## Conventions

| Marker | Meaning |
| --- | --- |
| *attr* | Lands in an HTML attribute. Escaped by the interface; pass the raw value. |
| *html* | Lands in element content. Emitted as-is; wrap untrusted text in `esc(...)`. |
| `Attrs` | `Map<String, Object?>`. Values are escaped. `true` renders `name=""`, `false`/`null` drop the entry. |

`body` is the macro's `{% call %}` content: markup placed inside the component when no structured data is given. Where a method takes both `items` (or `menu`) and `body`, the macro uses the structured data when it is non-empty and ignores `body`.

Markup for a hand-written `body` (option, menu item and sidebar structures) is documented per component in the `basecoat` skill.

`esc(Object? value)` escapes `& < > " '` and is safe for both content and attributes.

## Item classes

One small hierarchy serves select, dropdown menu, command and sidebar. Each component reads only the fields it knows.

```dart
BcItem(label, {value, url, icon, keywords, disabled, current, attrs})
BcGroup(label, items, {id, attrs})
BcSubmenu(label, items, {icon, open, attrs})   // sidebar only
BcSeparator()
```

| Field | Kind | select | dropdownMenu | command | sidebar |
| --- | --- | --- | --- | --- | --- |
| `label` | *html* | option content | item content | item content (searched) | link text |
| `value` | *attr* | `data-value`, form value | | | |
| `url` | *attr* | | renders `<a href>` | renders `<a href>` | link `href` (default `#`) |
| `icon` | *html* | | before the label | before the label | before the label |
| `keywords` | *attr* | | | extra search terms | |
| `disabled` | bool | | | `aria-disabled="true"` | |
| `current` | bool | | | | `aria-current="page"` |
| `attrs` | `Attrs` | on the option | on the item | on the item | on the link |

For a disabled select option or menu item use `attrs: {'aria-disabled': 'true'}`. A destructive menu item is `attrs: {'data-variant': 'destructive'}`. Because `attrs` goes on the item element, HTMX and event attributes work there: `attrs: {'hx-delete': '/members/7', 'hx-confirm': 'Remove?'}`.

Element ids are derived from the component id and position (`<id>-items-1`, `<id>-items-2-1` inside a group), which is one more reason to pass a stable `id`.

Other classes:

```dart
BcTab(tab, {panel, tabAttrs, panelAttrs})              // tab and panel are html
BcToast({category, title, description, duration, icon, action, cancel, attrs})
BcToastAction(label, {onclick, href})                  // label html; onclick/href attr
enum BcToastCategory { success, error, info, warning }
enum BcFormat { value, object }
```

## select

```dart
String select({
  String? id, String? name,
  Object? selected,              // a value, or a List of values when multiple
  List<BcNode>? items, String? body,
  bool multiple = false,
  String? placeholder,
  bool closeOnSelect = false,    // multiple mode: close after each pick
  BcFormat format = BcFormat.value,
  Attrs? mainAttrs, triggerAttrs, popoverAttrs, listboxAttrs, inputAttrs,
})
```

- Renders `div.select` with a trigger button `#<id>-trigger`, a listbox `#<id>-listbox` and a hidden input. A field label targets the trigger: `<label for="<id>-trigger">`.
- `name` defaults to `<id>-value`; set it explicitly for forms.
- With no `selected` and no `placeholder`, the first option is selected, as a native `<select>` would. Pass `placeholder` to start empty.
- The trigger is content-width by default; `triggerAttrs: {'class': 'w-full'}` stretches it.
- `multiple` submits a JSON array in the hidden input (`["a","b"]`); `format: BcFormat.object` submits `{value, label}` objects. Decode with `jsonDecode` on the server.
- In multiple mode the trigger label is empty in the server-rendered HTML and filled in by Basecoat's JavaScript on load. This matches upstream.
- Needs Basecoat JavaScript (`select`).

## combobox

```dart
String combobox({
  required String body,          // <div role="option" data-value="...">...</div>
  String? id, String? name,
  Object? selected,              // value, List of values, or {'value':..,'label':..} maps
  bool multiple = false,         // chips
  String? placeholder,
  bool closeOnSelect = false, bool clear = false, bool autoHighlight = false,
  BcFormat format = BcFormat.value,
  Attrs? mainAttrs, inputAttrs, popoverAttrs, listboxAttrs, hiddenInputAttrs,
})
```

- The combobox macro has no `items` prop; options are always markup. Build them in a loop and remember that option values and labels are yours to escape:

  ```dart
  final options = [
    for (final c in countries)
      '<div role="option" data-value="${esc(c.code)}">${esc(c.name)}</div>',
  ].join();
  ```

- Needs Basecoat JavaScript (`combobox`).

## command, commandDialog

```dart
String command({
  String? id, List<BcNode>? items, String? body,
  String? placeholder,           // default "Type a command or search..."
  String? emptyText,             // default "No results found."
  Attrs? mainAttrs, inputAttrs, menuAttrs,
})

String commandDialog({
  String? id, List<BcNode>? items, String? body,
  String? placeholder, String? emptyText,
  bool open = false,
  Attrs? dialogAttrs, inputAttrs, menuAttrs,
})
```

- `command` is inline; `commandDialog` wraps it in a native `<dialog class="command-dialog">`. Open it with `document.getElementById('<id>').showModal()`, typically from a button and a ⌘K listener.
- Items with a `url` render as links, so navigation works without JavaScript handlers. For actions, put the handler in `attrs` (`onclick`, `hx-post`, ...).
- Needs Basecoat JavaScript (`command`).

## dialog

```dart
String dialog({
  String? id,
  String? trigger,               // html; when set, renders a button that opens the dialog
  String? title, String? description,   // html
  String? body, String? footer,          // html
  bool open = false,
  bool closeButton = true,
  bool closeOnOverlayClick = true,
  Attrs? dialogAttrs, triggerAttrs, headerAttrs, bodyAttrs, footerAttrs,
})
```

- The generated trigger is a bare `<button>`. Style it: `triggerAttrs: {'class': 'btn', 'data-variant': 'outline'}`.
- Omit `trigger` to render only the `<dialog>` and open it from elsewhere with `document.getElementById('<id>').showModal()`.
- Hand-written 1.0 dialogs put width utilities on the inner `<div>`, and the macro has no attrs for that element. If the default width does not fit, target it from the root with a child variant, `dialogAttrs: {'class': '*:sm:max-w-md'}`, and check the result in a browser, or write the dialog by hand.
- For an alert dialog (no overlay close, no close button, explicit choice) pass `closeButton: false, closeOnOverlayClick: false` and put both buttons in `footer`; the root class stays `dialog`. If you need the `alert-dialog` class itself, write the markup from the `basecoat` skill by hand.
- A form whose submit button sits in the footer needs `form="<form-id>"` on the button, because the body and footer are sibling elements.
- No Basecoat JavaScript needed.

## dropdownMenu

```dart
String dropdownMenu({
  required String trigger,       // html: content of the trigger button
  String? id, List<BcNode>? items, String? body,
  Attrs? mainAttrs, triggerAttrs, popoverAttrs, menuAttrs,
})
```

- The trigger button is unstyled: `triggerAttrs: {'class': 'btn', 'data-variant': 'ghost', 'data-size': 'icon', 'aria-label': 'Actions'}` for an icon button.
- Alignment and side go on the popover: `popoverAttrs: {'data-align': 'end'}`.
- For checkbox or radio items, shortcuts and other markup the item classes do not model, pass `body` instead of `items`.
- Needs Basecoat JavaScript (`dropdown-menu`).

## popover

```dart
String popover({
  required String trigger,       // html
  required String body,          // html
  String? id,
  Attrs? mainAttrs, triggerAttrs, popoverAttrs,
})
```

- `popoverAttrs: {'class': 'w-80', 'data-align': 'start'}` for size and alignment.
- Needs Basecoat JavaScript (`popover`).

## sidebar

```dart
String sidebar({
  String? id,
  String? label,                 // attr: aria-label, default "Sidebar navigation"
  bool open = true,
  bool right = false,
  String? header, String? footer,       // html
  List<BcNode>? menu, String? body,
  Attrs? mainAttrs, headerAttrs, contentAttrs, footerAttrs,
})
```

- `menu` takes `BcGroup`, `BcItem`, `BcSubmenu` and `BcSeparator`. Top-level entries are normally groups; a group with a null label renders without a heading.
- Mark the active page per request: `BcItem('Members', url: '/members', current: path == '/members')`.
- The sidebar must be immediately followed by the page's `<main>`. Toggle it with `document.getElementById('<id>').toggle()`; the rest of the layout is described in the `basecoat` skill.
- Needs Basecoat JavaScript (`sidebar`).

## tabs

```dart
String tabs({
  required List<BcTab> tabsets,
  String? id,
  int defaultTabIndex = 1,       // one-based
  Attrs? mainAttrs, tablistAttrs,
})
```

- Variants go on the tablist: `tablistAttrs: {'data-variant': 'line'}` or `{'aria-orientation': 'vertical'}`.
- A tab without a `panel` renders only the button, for tabs whose content is loaded elsewhere.
- `BcTab('Billing', tabAttrs: {'disabled': true})` disables a tab.
- Needs Basecoat JavaScript (`tabs`).

## toaster, toast

```dart
String toaster({
  String? id,                    // default "toaster"
  List<BcToast> toasts = const [],
  String? body,
  Attrs? attrs,
})

String toast(BcToast toast)
```

- Render `bc.toaster()` once per page, at the end of `<body>`. `toasts` are shown on load, which is how a flash message survives a redirect.
- `attrs: {'data-align': 'start'}` (or `center`) moves the stack.
- `bc.toast(...)` renders one toast on its own, for example as an HTMX out-of-band swap:

  ```dart
  '<div id="toaster" hx-swap-oob="beforeend">${bc.toast(BcToast(title: 'Saved'))}</div>'
  ```

- From the client, skip the macro and call `document.getElementById('toaster').toast({...})`; see the `basecoat` skill for the config object.
- `title` and `description` are content positions: `BcToast(title: 'Removed ${esc(name)}')`.
- Needs Basecoat JavaScript (`toast`).

## Escape hatches

```dart
bc.env                      // the jinja Environment, for your own templates
bc.render(path, data)       // env.getTemplate(path).render(data)
bc.call('macro_name', positional: [...], named: {...}, body: '...')
```

`bc.call` invokes any registered macro by its Jinja name with no escaping or type mapping. Use it for a prop a typed method does not expose yet, or for your own macro files registered through `Basecoat(macroFiles: ['ui/badge.html.jinja'])`.

When upstream adds a macro, add its file name to `files`, call it through `bc.call`, and add a typed method next to the others once the shape is clear.
