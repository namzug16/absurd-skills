# Basecoat macros in Jaspr

Written against Jaspr 0.23 (`Component build(BuildContext)`, `package:jaspr/dom.dart`, `RawText`). In older versions `RawText` is `raw(...)` and `build` returns an `Iterable<Component>`; match what the project uses.

## The bridge

A macro returns an HTML string. `RawText` renders a string as raw HTML:

```dart
RawText(bc.select(id: 'timezone', name: 'timezone', items: zones))
```

That is the whole integration. The rest of this file is about where it is valid.

## Server-side only

Macros belong in components that render on the server and are never hydrated: pages and layout in `static` or `server` mode, outside any `@client` component. Three reasons:

- The templates are loaded by the server process. A `@client` component is compiled to JavaScript and would need the template engine and every template in the browser bundle.
- Basecoat's own JavaScript owns the interactive behavior of these components. It opens the popover, moves `aria-selected`, updates the hidden input. A hydrated Jaspr component would re-render over DOM that Basecoat has already changed.
- The output is a string, so Jaspr cannot attach event handlers inside it.

So the pattern is: Jaspr renders the page, the macro contributes inert markup, Basecoat's script makes it interactive, and state leaves the component through the DOM (a form post, HTMX, or a `change` event).

Keep the `Basecoat` instance in a file that only server code imports. `basecoat.dart` itself has no `dart:io` dependency, but `FileSystemLoader` (from `package:jinja/loaders.dart`) does, and importing that from code that ends up in the client bundle breaks the web build.

```dart
// lib/basecoat/bc.dart - import from server-rendered components only
import 'package:jinja/loaders.dart';

import 'basecoat.dart';

export 'basecoat.dart';

final bc = Basecoat(loader: FileSystemLoader(paths: ['templates']));
```

`jaspr serve` and `jaspr build` run with the project root as working directory, so `templates/` resolves. For static site generation and deployed server builds see the Deployment section of SKILL.md; embedding the templates removes the question.

## Example

```dart
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'basecoat/bc.dart';

void main() {
  Jaspr.initializeApp();
  runApp(
    Document(
      title: 'Settings',
      head: [
        link(rel: 'stylesheet', href: '/styles.css'),
        script(src: '/basecoat/all.min.js', defer: true),
      ],
      body: const SettingsPage(),
    ),
  );
}

class SettingsPage extends StatelessComponent {
  const SettingsPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'mx-auto max-w-xl p-6 flex flex-col gap-6', [
      h1(classes: 'text-2xl font-semibold', [.text('Settings')]),
      // overflow-visible: the select popover extends past the card edge.
      div(classes: 'card overflow-visible', [
        header([
          h2([.text('Profile')]),
        ]),
        section([
          div(classes: 'field', attributes: {'role': 'group'}, [
            label(htmlFor: 'timezone-trigger', [.text('Timezone')]),
            const TimezoneSelect(selected: 'Europe/Madrid'),
          ]),
        ]),
        footer([
          button(classes: 'btn', [.text('Save')]),
        ]),
      ]),
      RawText(bc.toaster()),
    ]);
  }
}

class TimezoneSelect extends StatelessComponent {
  const TimezoneSelect({this.selected, super.key});

  final String? selected;

  @override
  Component build(BuildContext context) {
    return RawText(
      bc.select(
        id: 'timezone',
        name: 'timezone',
        selected: selected,
        triggerAttrs: {'class': 'w-full'},
        items: const [
          BcGroup('Europe', [
            BcItem('Madrid', value: 'Europe/Madrid'),
            BcItem('Berlin', value: 'Europe/Berlin'),
          ]),
          BcGroup('Americas', [
            BcItem('New York', value: 'America/New_York'),
            BcItem('Bogotá', value: 'America/Bogota'),
          ]),
        ],
      ),
    );
  }
}
```

Things this example shows:

- **Wrap each macro in a small component** (`TimezoneSelect`) with typed props. Call sites stay idiomatic Jaspr, and the `RawText` and the id live in one place.
- **Everything without a macro is ordinary Jaspr markup** following the `basecoat` skill: `card`, `field`, `btn` are class names and element structure. Variants are attributes: `button(classes: 'btn', attributes: {'data-variant': 'outline'}, [...])`.
- **`RawText` adds no wrapper element**, so the macro's root lands directly inside the `field`, where Basecoat's CSS expects it.
- **The script is loaded once in `Document.head`.** Serve `all.min.js` from `web/`, or use the CDN URL.

## Slots

Macro slots (`body`, `trigger`, `footer`, `header`, tab panels) are HTML strings, and a Jaspr component cannot be turned into a string in the middle of a synchronous `build`. Choose by what the slot contains:

| Slot content | Do this |
| --- | --- |
| Static or data-driven markup | Build the string: a literal, another `bc.*` call, or htmleez (`node.toHtml()`, see [htmleez.md](./htmleez.md)). htmleez is a good fit here because it escapes text by default and nests naturally. |
| Jaspr components, especially `@client` ones | Skip the macro and write the component's markup as Jaspr elements, following the structure in the `basecoat` skill. `dialog` and `popover` are short. This keeps the children as real components. |

A dialog written directly, with live children:

```dart
Component settingsDialog(List<Component> children) {
  return dialog(
    id: 'settings',
    classes: 'dialog',
    attributes: {
      'aria-labelledby': 'settings-title',
      'onclick': 'if (event.target === this) this.close()',
    },
    [
      div([
        header([
          h2(id: 'settings-title', [.text('Settings')]),
        ]),
        section(children),
      ]),
    ],
  );
}
```

For the components with heavy generated structure (`select`, `combobox`, `command`, `dropdownMenu`, `sidebar`, `tabs`) the macro is nearly always the better trade, because their slots are data rather than component trees.

## Reading values and reacting to changes

- **Forms.** `select` and `combobox` write to a hidden input, so a normal form post or HTMX request carries the value under `name`.
- **Client-side reactions.** Basecoat dispatches a `change` event on the component root when the value changes. Listen from a small script or from a `@client` component that looks the element up by id; do not try to pass a Dart callback into the macro.
- **Re-rendering with new data.** Navigate, or swap a server-rendered fragment into the page. Basecoat initializes inserted markup automatically.

## Checklist

- [ ] `bc` is imported only by server-rendered code.
- [ ] Every macro call has a stable `id`.
- [ ] User data in labels, titles and bodies goes through `esc(...)`; `RawText` does not escape.
- [ ] Basecoat JavaScript is in `Document.head`.
- [ ] No macro output sits inside a `@client` component.
