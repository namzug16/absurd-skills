# Jinja on Dart

The [`jinja`](https://pub.dev/packages/jinja) package (0.7.x) is a port of Jinja for Dart, and it is close enough to Python Jinja that templates look portable and then fail at render time. This file lists the differences that matter, what `basecoat.dart` does about them, and how to write your own page templates.

- [What the shim fixes](#what-the-shim-fixes)
- [Writing page templates](#writing-page-templates)
- [Calling Basecoat macros from a template](#calling-basecoat-macros-from-a-template)
- [Differences from Python Jinja](#differences-from-python-jinja)
- [Your own macro files](#your-own-macro-files)
- [Debugging](#debugging)

## What the shim fixes

Rendering an unmodified Basecoat template with a plain `Environment` fails for every macro. `Basecoat(...)` builds an `Environment` with these additions, and nothing else is needed to run the upstream files as shipped:

| Upstream template does | Plain `jinja` package | Fix in `basecoat.dart` |
| --- | --- | --- |
| `attrs.items()`, `item.get('items', [])`, `', '.join(labels)` | Attribute access on a map is a key lookup, so these are `null` and calling them throws `The getter 'call' was called on null`. | A custom `getAttribute` that provides `items`, `get`, `keys`, `values` on maps and `join` on strings. |
| `{{ label \| safe }}` | No `safe` filter: `No filter named 'safe'`. | `safe` registered as a pass-through. |
| `select()` calls its helper `render_select_items()`; `toaster()` calls `toast()` | An imported macro runs without the other macros of its file in scope. | Every macro is published as an environment global. |
| `render_select_items(items, selected, prefix)`, `popover(trigger="...")` | A parameter without a default is positional-only, one with a default is keyword-only. | The globals rebind arguments by parameter name before calling the macro. |
| `value="{{ selected \| tojson }}"` | Output contains raw `"` and breaks the attribute. | `tojson` is replaced with an attribute-safe version; the original behavior is available as `tojson_script`. |
| Relies on Flask autoescaping | There is no autoescaping at all. | The typed methods escape attribute values before they reach the template. |

If an upgrade of `basecoat-css` introduces a construct that fails, this table is the pattern: add the missing method, filter or test to the environment in `basecoat.dart` and leave the vendored file alone.

## Writing page templates

Use the same environment for your own templates so they can call the macros. Templates are looked up relative to the loader root, next to `basecoat/`:

```
templates/
  basecoat/            vendored, do not edit
  layout.html.jinja
  pages/members.html.jinja
```

```jinja
{# templates/layout.html.jinja #}
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>{% block title %}App{% endblock %}</title>
  <link rel="stylesheet" href="/assets/app.css">
  <script src="/assets/basecoat/all.min.js" defer></script>
</head>
<body>
  {% block content %}{% endblock %}
  {{ toaster() }}
</body>
</html>
```

```jinja
{# templates/pages/members.html.jinja #}
{% extends "layout.html.jinja" %}
{% from "basecoat/dialog.html.jinja" import dialog %}
{% block title %}Members{% endblock %}
{% block content %}
  <h1 class="text-2xl font-semibold">{{ title | e }}</h1>
  {% for m in members %}
    <p>
      {{ m.name | e }}
      {{ dropdown_menu("Actions", id="member-" ~ m.id ~ "-menu",
           trigger_attrs={"class": "btn", "data-variant": "ghost", "data-size": "sm"},
           items=[{"label": "Edit", "url": "/members/" ~ m.id}]) }}
    </p>
  {% else %}
    <p class="text-muted-foreground">No members yet.</p>
  {% endfor %}

  {% call dialog(id="invite", trigger="Invite", title="Invite member",
                 trigger_attrs={"class": "btn"}) %}
    {{ select(id="role", name="role", selected="member", items=roles) }}
  {% endcall %}
{% endblock %}
```

```dart
final html = bc.render('pages/members.html.jinja', {
  'title': 'Members',
  'members': [for (final m in members) {'id': m.id, 'name': m.name}],
  'roles': [
    {'value': 'admin', 'label': 'Admin'},
    {'value': 'member', 'label': 'Member'},
  ],
});
```

Pass data as maps, lists and primitives. A Dart object's fields are not reachable from a template (`{{ user.name }}` on a class instance resolves to nothing) unless the environment is given a reflection-based `getAttribute`, which needs `dart:mirrors` and so does not work in AOT-compiled binaries. Give models a `toMap()`.

**Escape by hand.** Nothing is escaped unless the template says so: `{{ m.name | e }}`. This applies to every value interpolated into your own markup and to values you pass into macro props from a template (`title=project.name | e`). The typed Dart methods escape attribute positions for you; a macro called from a template gets no such help, so data from a template reaches attributes like `data-value` raw. When a value may contain quotes or angle brackets, escape it at the call site or build that component from Dart and pass the HTML in as data.

## Calling Basecoat macros from a template

- **Expression calls need no import.** `{{ select(...) }}`, `{{ dropdown_menu(...) }}`, `{{ tabs(...) }}`, `{{ toaster() }}` work anywhere because the macros are globals. Positional and keyword arguments both work, as in the upstream docs.
- **`{% call %}` blocks need the macro imported in that template**: `{% from "basecoat/dialog.html.jinja" import dialog %}`. The engine only accepts a call block on a name it saw imported or defined in the same file; on a global it fails with `Bad state: Pattern matching error`.
- **Inside a call block, pass `trigger` positionally.** An imported name bypasses the argument rebinding, so the engine's own rule applies: `{% call popover("Open", id="p") %}` works, `{% call popover(trigger="Open") %}` throws a `RangeError`. This affects `popover` and `dropdown_menu`, the two macros with a required parameter.
- Item data uses the upstream dictionary shapes (`{"type": "group", "label": ..., "items": [...]}`); they are documented in the `basecoat` skill's templates reference. From Dart, `BcItem(...).toMap()` produces the same shape with attribute fields already escaped.

## Differences from Python Jinja

All verified against `jinja` 0.7.2.

| Topic | Behavior on Dart |
| --- | --- |
| Autoescaping | None, and no setting to enable it. Use `\| e`. |
| Undefined | An unknown variable is `null` and prints as an empty string. `is defined` means "is not null". Attribute access on a null (`{{ missing.field }}`) throws. |
| Macro parameters | No default: positional-only. With a default: keyword-only. `{{ badge("New", "outline") }}` throws a `TypeError` if the second parameter has a default; write `variant="outline"`. |
| Python methods | Not available: `"x".upper()`, `.startswith()`, `.format()`, `.append()`. Use filters (`\| upper`, `\| replace`) and tests. The shim adds only `items`, `get`, `keys`, `values` on maps and `join` on strings. |
| Map keys named like methods | With the shim, `m.items`, `m.get`, `m.keys`, `m.values` are always the methods, as in Python. Read such keys with `m["items"]`. |
| Indexing | No negative indexes (`list[-1]` throws); use `\| last`. No string slices. |
| Globals | `range`, `namespace`, `list`, `print`. No `dict()`; use a literal `{...}`. |
| Missing filters | `safe` (added by the shim), `urlencode`, `xmlattr`, `selectattr`, `rejectattr`, `groupby`, `unique`, `sort`. Do the work in Dart and pass the result in, or register a filter: `Basecoat(filters: {'money': formatMoney}, ...)`. |
| `tojson` | In this environment it is attribute-safe (`"` becomes `&quot;`). Inside a `<script>` use `\| tojson_script`. |
| Supported as expected | `extends`, `block`, `super()`, `include`, `import`, `from ... import`, `for ... else`, `loop.*`, `set`, `namespace()`, `if`, inline `a if c else b`, `~` concatenation, `in`, whitespace control. |

## Your own macro files

A macro file of your own hits the same engine limits: a macro cannot see its siblings when imported, and defaulted parameters are keyword-only. Either register the file so it gets the Basecoat treatment,

```dart
final bc = Basecoat(
  loader: FileSystemLoader(paths: ['templates']),
  macroFiles: ['ui/badge.html.jinja'],
);

bc.call('badge', positional: ['New', 'outline']);   // from Dart
```

```jinja
{{ badge("New", "outline") }}   {# from any template, no import #}
```

or import with context and name every macro the file uses internally:

```jinja
{% from "ui/badge.html.jinja" import badges, badge with context %}
```

Registered macro names share one global namespace with Basecoat's (`select`, `dialog`, `tabs`, `toast`, ...), so pick names that do not collide.

## Debugging

Errors surface as Dart exceptions from inside the renderer, usually without a template line number. The message identifies the cause more reliably than the stack:

| Message | Usual cause |
| --- | --- |
| `The getter 'call' was called on null` | Calling something that does not exist: a Python method, a macro that is not in scope, a missing global. |
| `No filter named '...'` / `No test named '...'` | Not ported; register one or restructure. |
| `Instance of 'TypeError'` from `getMacroFunction` | Too many positional arguments, or an unknown keyword argument, for a macro. |
| `RangeError (length)` from `getMacroFunction` | A required (positional-only) macro parameter was passed by keyword or omitted. |
| `Bad state: Pattern matching error` in `visitCallBlock` | `{% call %}` on a macro that was not imported in this template. |
| `The method '[]' was called on null` | Attribute access on an undefined value. |
| `TemplateNotFound` | Path is relative to the loader root, not to the current template. |

To bisect, render the suspect fragment with `bc.env.fromString('...').render(data)` in a test.
