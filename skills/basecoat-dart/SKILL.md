---
name: basecoat-dart
description: Use Basecoat (basecoat-css) from server-rendered Dart - Jaspr, htmleez, Shelf, Dart Frog, Relic, or any Dart app that returns HTML. Covers vendoring Basecoat's Jinja macro templates into a Dart project, rendering them with the `jinja` pub package, and calling them through a typed Dart interface (`bc.select(...)`, `bc.dialog(...)`, `bc.dropdownMenu(...)`, `bc.sidebar(...)`, `bc.tabs(...)`, `bc.toast(...)`, ...). Use this skill whenever a Dart project (a `pubspec.yaml` is present) uses or should use Basecoat, whenever `.jinja` templates are rendered from Dart, and whenever the user asks for a Basecoat select, combobox, command palette, dialog, dropdown menu, popover, sidebar, tabs or toast in Dart, Jaspr or htmleez. Read it before writing any of that, even if you know Jinja well - the upstream templates do not run on Dart's `jinja` package without the bundled shim, and the package silently differs from Python Jinja (no autoescaping, different macro argument rules).
metadata:
  basecoat: 1.0.x
  jinja: ^0.7.2
  jaspr: ^0.23.5
  htmleez: ^1.0.0
---

# Basecoat for Dart

Basecoat ships Jinja macros for its nine largest components. This skill makes them usable from Dart: the templates are vendored into the project unmodified, rendered by the [`jinja`](https://pub.dev/packages/jinja) package, and called through a typed Dart class that returns HTML strings. Those strings drop into Jaspr with `RawText(...)`, into htmleez with `Raw(...)`, or straight into a response body.

This skill covers only the Dart side. What the markup means, which components exist, variants, theming and the JavaScript API belong to the **`basecoat` skill** (`../basecoat/SKILL.md` when installed next to this one). Read it as well: most Basecoat components (button, card, field, input, badge, table, alert, ...) have no macro and are written as plain markup in whatever the project uses to produce HTML.

## What is bundled

| File | Purpose |
| --- | --- |
| [assets/basecoat.dart](./assets/basecoat.dart) | The typed interface. Copy it into the app; it is app-owned code, like the templates. Depends only on `jinja`, no `dart:io`. |
| [assets/basecoat_test.dart](./assets/basecoat_test.dart) | Smoke test that renders every macro. Copy to `test/`. |
| [scripts/vendor_templates.dart](./scripts/vendor_templates.dart) | Copies the templates from `node_modules/basecoat-css` (or downloads the matching version) and can embed them in a Dart file. |

Copy `basecoat.dart` rather than rewriting it. Getting the upstream templates to run on Dart's engine took several non-obvious workarounds, all of which live in that file and are covered by the test; see [references/jinja-dart.md](./references/jinja-dart.md) for what they are.

## Setup

1. **Check what exists.** Look for `templates/basecoat/`, a `basecoat.dart`, and `jinja` in `pubspec.yaml`. If they are there, use them and skip to usage. Check how the project gets its CSS and JavaScript (`package.json` with `basecoat-css`, a Tailwind entry file, or CDN tags); if Basecoat itself is not installed, follow the `basecoat` skill's installation reference first.
2. **Add the dependency:** `dart pub add jinja` (the interface is written against `^0.7.2`; the package is pre-1.0, so keep the caret constraint).
3. **Vendor the templates** from the project root:

   ```bash
   dart run <this-skill>/scripts/vendor_templates.dart
   ```

   This writes `templates/basecoat/*.html.jinja` plus a `.basecoat-version` marker. It prefers `node_modules/basecoat-css` so the templates match the CSS and JavaScript the app ships; a mismatch produces markup the stylesheet or scripts do not expect. Leave the templates unmodified so the next upgrade is a re-run.
4. **Copy the interface** to `lib/basecoat/basecoat.dart` (or wherever the project keeps server-side UI code) and the test to `test/basecoat_test.dart`, fixing its import. Run `dart test` once.
5. **Create one instance** and reuse it; construction parses the templates.

   ```dart
   import 'package:jinja/loaders.dart';
   import 'basecoat/basecoat.dart';

   final bc = Basecoat(
     loader: FileSystemLoader(paths: ['templates']),
     autoReload: isDevelopment, // re-read edited templates
   );
   ```

6. **Make sure Tailwind scans `templates/` and `lib/`.** The macros emit utility classes (`truncate`, `shrink-0`, `text-muted-foreground`) and so will your Dart code. Tailwind v4 picks both up automatically when it runs from the project root; add `@source "../templates";` and `@source "../lib";` to the CSS entry file if it does not.
7. **Load Basecoat's JavaScript.** Every macro except `dialog` needs it. Dart projects usually have no JS bundler, so serve `node_modules/basecoat-css/dist/js/all.min.js` from the static folder (`web/` in Jaspr) or use the CDN tag from the `basecoat` skill.

`FileSystemLoader` resolves `templates` against the working directory. If the app is deployed as a compiled binary or a container that will not contain that folder, see [Deployment](#deployment).

## Using the interface

Each macro is a method that returns an HTML `String`. Parameters mirror the upstream macro props in camelCase; `*_attrs` props become `Map<String, Object?>` named `*Attrs`; item lists use small typed classes.

```dart
final html = bc.select(
  id: 'role',
  name: 'role',
  selected: user.role,
  triggerAttrs: {'class': 'w-full'},
  items: const [
    BcItem('Admin', value: 'admin'),
    BcItem('Member', value: 'member'),
    BcSeparator(),
    BcGroup('Limited', [BcItem('Viewer', value: 'viewer')]),
  ],
);
```

| Method | Macro | Slots |
| --- | --- | --- |
| `bc.select(...)` | `select()` | `items` or `body` |
| `bc.combobox(...)` | `combobox()` | `body` (option markup, required) |
| `bc.command(...)`, `bc.commandDialog(...)` | `command()`, `command_dialog()` | `items` or `body` |
| `bc.dialog(...)` | `dialog()` | `trigger`, `title`, `description`, `body`, `footer` |
| `bc.dropdownMenu(...)` | `dropdown_menu()` | `trigger`, `items` or `body` |
| `bc.popover(...)` | `popover()` | `trigger`, `body` |
| `bc.sidebar(...)` | `sidebar()` | `header`, `footer`, `menu` or `body` |
| `bc.tabs(...)` | `tabs()` | `tabsets` |
| `bc.toaster(...)`, `bc.toast(...)` | `toaster()`, `toast()` | `toasts`, `body` |

Full signatures, the item classes and per-method notes are in [references/macros.md](./references/macros.md). Read it before calling a method for the first time; a few props behave in ways the names do not reveal (the `dialog` trigger button is unstyled unless you pass `triggerAttrs: {'class': 'btn'}`, a `select` field label points at `<id>-trigger`).

### The escaping rule

Dart's `jinja` package has no autoescaping, so the upstream templates, written for Flask, would emit everything raw. The interface draws one line and holds it everywhere:

- **Attribute positions are escaped for you**: ids, names, values, urls, placeholders, keywords, and every value in an `*Attrs` map. Pass raw strings, including JSON for `hx-vals` or text with quotes.
- **Content positions are raw HTML**: labels, titles, descriptions, triggers, bodies, headers, footers, icons, tab and panel content. This is what lets a label carry an icon or a body carry a form. Wrap anything that came from a user or a database in `esc(...)`, or build it with a library that escapes text (`'...'.t` in htmleez).

```dart
BcItem(esc(member.name), value: member.id)   // name is user data
bc.dialog(title: 'Delete ${esc(project.name)}?', body: formHtml)
```

Forgetting `esc` on user data is an XSS hole, and it is the easiest mistake to make here because the same code in Flask would have been safe.

### Rules of thumb

- **Always pass an `id`.** Without one the macro generates a random id, which changes on every render: it breaks `<label for>`, HTMX targets, tests, and Jaspr hydration. In a loop, derive it from the row (`'member-${m.id}-menu'`).
- **Slots are HTML strings, not components.** A macro renders in one pass, so `body`, `trigger`, `footer` and friends must already be strings. Produce them with htmleez (`node.toHtml()`), another `bc.*` call, or a string literal.
- **Use the macro for the big structures, plain markup for the small ones.** `select`, `combobox`, `command`, `dropdownMenu`, `sidebar` and `tabs` generate a lot of wired-up ARIA and ids and are worth the indirection. A `dialog` or `popover` is a few lines of markup; write it directly when its content needs to be live framework components rather than a string.
- **Overlays are not portalled.** A select or dropdown inside `.card` or `.table-container` is clipped; see the `basecoat` skill.
- **Extra attributes:** `true` renders a boolean attribute, `false` and `null` drop the entry. `{'class': ...}` on a root is appended to the component class.

## Where the HTML goes

| Stack | Read | Bridge |
| --- | --- | --- |
| Jaspr | [references/jaspr.md](./references/jaspr.md) | `RawText(bc.select(...))`, server-rendered components only |
| htmleez, with Shelf / Dart Frog / Relic | [references/htmleez.md](./references/htmleez.md) | `Raw(bc.select(...))`; slots via `node.toHtml()` |
| Jinja page templates rendered from Dart | [references/jinja-dart.md](./references/jinja-dart.md) | `bc.render('pages/x.html.jinja', data)`; macros are globals |

For anything else that produces HTML strings, interpolate the result directly.

## Deployment

The templates are read at startup, so they have to exist wherever the server runs.

- **Ship the folder.** Copy `templates/` next to the binary (a `COPY templates ./templates` line in the Dockerfile) and start the server with that working directory, or pass an absolute path to `FileSystemLoader`.
- **Or embed them.** Generate a Dart map and load from memory; nothing is read from disk, which suits `dart compile exe`, serverless targets and Jaspr static builds:

  ```bash
  dart run <this-skill>/scripts/vendor_templates.dart --embed lib/basecoat/templates.g.dart
  ```

  ```dart
  import 'basecoat/templates.g.dart';

  final bc = Basecoat.embedded(templateSources);
  ```

  The file embeds everything under `templates/`, including your own page templates, and must be regenerated when any of them change (`--embed-only` skips the download). In development keep `FileSystemLoader` for live reload and switch on a build flag.

## Upgrading Basecoat

Bump `basecoat-css`, re-run the vendor script, run `dart test`. The smoke test exists for this moment: the templates are written for Python Jinja, and a construct the Dart engine does not support will fail there rather than in production. If it does fail, fix it in the shim in `basecoat.dart` (see [references/jinja-dart.md](./references/jinja-dart.md)) in preference to editing the vendored templates, so the next upgrade stays a re-run.
