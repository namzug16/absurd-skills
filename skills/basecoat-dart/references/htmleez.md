# Basecoat macros with htmleez

Read `htmleez-html` before editing markup. Use the optional Jinja macro setup in [SKILL.md](../SKILL.md) when this integration is selected; preserve direct htmleez markup in projects that already use it.

[htmleez](https://pub.dev/packages/htmleez) builds HTML from Dart functions: tags are callables taking a list of children and attributes, `'text'.t` is escaped text, `Raw(...)` is unescaped content, and `.toHtml()` renders to a string. It pairs well with the macros because both directions are one call.

| Direction | Code |
| --- | --- |
| Macro output into an htmleez tree | `Raw(bc.select(...))` |
| htmleez tree into a macro slot | `bc.dialog(body: form.toHtml())` |

A small extension keeps call sites readable:

```dart
extension BasecoatHtml on String {
  /// Macro output as an htmleez node.
  HTML get html => Raw(this);
}
```

htmleez API reminders that matter here:

- `$('name')('value')` is an escaped attribute, `$('disabled')()` a boolean one, `raw$('onclick')('...')` an unescaped one for static JavaScript.
- `main` and `var` are `mainTag` and `varTag`.
- `Raw` and text nodes render only inside a tag or fragment. `Raw(x).toHtml()` on its own throws; use the string directly, or `[tagA, tagB].toHtml()` for several sibling tags.
- An `html([...])` root emits `<!DOCTYPE html>` itself.

## Example: Shelf app

The same code works with Dart Frog, Relic or anything else that returns a string body.

```dart
import 'dart:io';

import 'package:htmleez/htmleez.dart';
import 'package:jinja/loaders.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'basecoat/basecoat.dart';

final bc = Basecoat(
  loader: FileSystemLoader(paths: ['templates']),
  autoReload: Platform.environment['ENV'] != 'production',
);

extension BasecoatHtml on String {
  HTML get html => Raw(this);
}

HTML page(String title, List<HTML> content) => html([
  $('lang')('en'),
  head([
    meta([$('charset')('utf-8')]),
    Tag('title')([title.t]),
    link([$('rel')('stylesheet'), $('href')('/assets/app.css')]),
    script([$('src')('/assets/basecoat/all.min.js'), $('defer')()]),
  ]),
  body([...content, bc.toaster().html]),
]);

typedef Member = ({int id, String name, String role});

HTML membersPage(List<Member> members) => page('Members', [
  mainTag([
    $('class')('mx-auto max-w-3xl p-6 flex flex-col gap-6'),
    header([
      $('class')('flex items-center justify-between'),
      h1([$('class')('text-2xl font-semibold'), 'Members'.t]),
      inviteDialog().html,
    ]),
    // No .table-container: it scrolls, and would clip the row menus.
    table([
      $('class')('table'),
      tbody([for (final member in members) memberRow(member)]),
    ]),
  ]),
]);

HTML memberRow(Member member) => tr([
  td([member.name.t]),
  td([member.role.t]),
  td([
    $('class')('text-right'),
    bc
        .dropdownMenu(
          id: 'member-${member.id}-menu',
          trigger: 'Actions',
          triggerAttrs: {
            'class': 'btn',
            'data-variant': 'ghost',
            'data-size': 'sm',
          },
          popoverAttrs: {'data-align': 'end'},
          items: [
            BcItem('Edit', url: '/members/${member.id}/edit'),
            const BcSeparator(),
            BcItem(
              'Remove',
              attrs: {
                'data-variant': 'destructive',
                'hx-delete': '/members/${member.id}',
                'hx-confirm': 'Remove ${member.name}?',
              },
            ),
          ],
        )
        .html,
  ]),
]);

String inviteDialog() => bc.dialog(
  id: 'invite',
  trigger: 'Invite member',
  triggerAttrs: {'class': 'btn'},
  title: 'Invite member',
  description: 'They will get an email with a sign-in link.',
  body: inviteForm().toHtml(),
  footer: [
    button([
      $('type')('button'),
      $('class')('btn'),
      $('data-variant')('outline'),
      raw$('onclick')("this.closest('dialog').close()"),
      'Cancel'.t,
    ]),
    // The footer is outside the form, so the button names its form.
    button([$('class')('btn'), $('form')('invite-form'), 'Send invite'.t]),
  ].toHtml(),
);

HTML inviteForm() => form([
  $('id')('invite-form'),
  $('method')('post'),
  $('action')('/members'),
  $('class')('grid gap-4'),
  div([
    $('role')('group'),
    $('class')('field'),
    label([$('for')('invite-email'), 'Email'.t]),
    input([$('id')('invite-email'), $('name')('email'), $('type')('email')]),
  ]),
  div([
    $('role')('group'),
    $('class')('field'),
    label([$('for')('invite-role-trigger'), 'Role'.t]),
    bc
        .select(
          id: 'invite-role',
          name: 'role',
          selected: 'member',
          triggerAttrs: {'class': 'w-full'},
          items: const [
            BcItem('Admin', value: 'admin'),
            BcItem('Member', value: 'member'),
            BcItem('Viewer', value: 'viewer'),
          ],
        )
        .html,
  ]),
]);

Response htmlResponse(String body) =>
    Response.ok(body, headers: {'content-type': 'text/html; charset=utf-8'});

void main() async {
  final router = Router()
    ..get('/members', (Request request) {
      final members = <Member>[(id: 1, name: 'Ada Lovelace', role: 'Admin')];
      return htmlResponse(membersPage(members).toHtml());
    })
    ..delete('/members/<id>', (Request request, String id) {
      // HTMX appends the toast to the toaster out of band.
      final toast = bc.toast(const BcToast(title: 'Member removed'));
      return htmlResponse(
        '<div id="toaster" hx-swap-oob="beforeend">$toast</div>',
      );
    });
  await io.serve(router.call, 'localhost', 8080);
}
```

What to take from it:

- **Who escapes what.** `member.name.t` is escaped by htmleez. `'Remove ${member.name}?'` sits in an `attrs` map, so the interface escapes it. A name inside a *label*, title or body is content and needs `esc`: `BcItem(esc(member.name), ...)`, or render it through htmleez first: `span([member.name.t]).toHtml()`.
- **Labels with icons** are content, so compose them: `trigger: [svgIcon('ellipsis'), span(['Actions'.t])].toHtml()`, where `svgIcon` returns a tag wrapping a `Raw` SVG body.
- **Components without a macro** are plain htmleez following the `basecoat` skill: the `field` wrappers, `table`, and buttons above. Variants are attributes (`$('data-variant')('outline')`).
- **Partials are just strings.** An HTMX endpoint returns `bc.toast(...)`, `bc.select(...)` or `someNode.toHtml()` directly. Basecoat initializes swapped-in components on its own.
- **Ids come from data** (`member-${member.id}-menu`) so each row's trigger, popover and items are wired uniquely.

## Wrapping macros as htmleez components

When a macro is used in more than one place, give it an htmleez-shaped function so the rest of the code never sees strings:

```dart
HTML roleSelect({required String id, String? selected}) => Raw(
  bc.select(
    id: id,
    name: 'role',
    selected: selected,
    triggerAttrs: {'class': 'w-full'},
    items: const [
      BcItem('Admin', value: 'admin'),
      BcItem('Member', value: 'member'),
    ],
  ),
);

HTML modal({
  required String id,
  required String title,
  required List<HTML> body,
  List<HTML> footer = const [],
}) => Raw(
  bc.dialog(
    id: id,
    title: esc(title),
    body: HtmlComponent.fragment(body).toHtml(),
    footer: footer.isEmpty ? null : HtmlComponent.fragment(footer).toHtml(),
  ),
);
```

`HtmlComponent.fragment(children).toHtml()` renders a list that may contain text or `Raw` nodes; a bare `children.toHtml()` accepts only tags and fragments at the top level.
