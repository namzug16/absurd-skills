/// Typed Dart interface to the Basecoat Jinja macros.
///
/// Copy this file into your app (for example `lib/basecoat/basecoat.dart`)
/// and vendor the templates from `basecoat-css/templates/jinja` into
/// `templates/basecoat/`. It depends only on `package:jinja` (^0.7.2) and
/// does not import `dart:io`.
///
/// Escaping contract, because `package:jinja` has no autoescaping:
///   * anything that lands in an HTML attribute (ids, names, values, urls,
///     placeholders, every `*Attrs` map) is escaped here;
///   * anything that lands in element content (labels, titles, triggers,
///     bodies, footers, icons) is emitted as raw HTML. Wrap untrusted text
///     in [esc].
library;

import 'dart:convert';

import 'package:jinja/jinja.dart';

/// Extra HTML attributes. `true` renders as an empty-valued attribute
/// (`disabled=""`), `false` and `null` entries are dropped.
typedef Attrs = Map<String, Object?>;

const _htmlEscape = HtmlEscape(HtmlEscapeMode.attribute);

/// Escapes text for use in HTML content or attribute values.
String esc(Object? value) => _htmlEscape.convert('${value ?? ''}');

/// An attribute value that prints escaped but compares and JSON-encodes raw,
/// so `item.value in selected` and `| tojson` keep working in the macros.
final class _AttrValue {
  const _AttrValue(this.raw);

  final String raw;

  String toJson() => raw;

  @override
  String toString() => esc(raw);

  @override
  bool operator ==(Object other) => other is _AttrValue && other.raw == raw;

  @override
  int get hashCode => raw.hashCode;
}

_AttrValue? _value(Object? value) =>
    value == null ? null : _AttrValue('$value');

Map<String, Object?>? _attrs(Attrs? attrs) {
  if (attrs == null) return null;
  return {
    for (final MapEntry(:key, :value) in attrs.entries)
      if (value != null && value != false) key: value == true ? '' : esc(value),
  };
}

Map<String, Object?> _compact(Map<String, Object?> map) =>
    map..removeWhere((_, value) => value == null);

/// An entry of a select, dropdown menu, command or sidebar.
sealed class BcNode {
  const BcNode();

  Map<String, Object?> toMap();
}

/// A leaf entry. Which fields are read depends on the component:
/// select uses [value]; dropdown menu, command and sidebar use [url] and
/// [icon]; command adds [keywords] and [disabled]; sidebar adds [current].
final class BcItem extends BcNode {
  const BcItem(
    this.label, {
    this.value,
    this.url,
    this.icon,
    this.keywords,
    this.disabled = false,
    this.current = false,
    this.attrs,
  });

  /// Raw HTML.
  final String label;
  final String? value;
  final String? url;

  /// Raw HTML, usually an inline `<svg>`.
  final String? icon;
  final String? keywords;
  final bool disabled;
  final bool current;
  final Attrs? attrs;

  @override
  Map<String, Object?> toMap() => _compact({
    'type': 'item',
    'label': label,
    'value': _value(value),
    'url': url == null ? null : esc(url),
    'icon': icon,
    'keywords': keywords == null ? null : esc(keywords),
    'disabled': disabled ? true : null,
    'current': current ? true : null,
    'attrs': _attrs(attrs),
  });
}

/// A labelled group of entries.
final class BcGroup extends BcNode {
  const BcGroup(this.label, this.items, {this.id, this.attrs});

  /// Raw HTML. May be null for an unlabelled sidebar group.
  final String? label;
  final List<BcNode> items;
  final String? id;
  final Attrs? attrs;

  @override
  Map<String, Object?> toMap() => _compact({
    'type': 'group',
    'label': label,
    'id': id == null ? null : esc(id),
    'items': [for (final item in items) item.toMap()],
    'attrs': _attrs(attrs),
  });
}

/// A collapsible sidebar submenu.
final class BcSubmenu extends BcNode {
  const BcSubmenu(
    this.label,
    this.items, {
    this.icon,
    this.open = false,
    this.attrs,
  });

  /// Raw HTML.
  final String label;
  final List<BcNode> items;
  final String? icon;
  final bool open;
  final Attrs? attrs;

  @override
  Map<String, Object?> toMap() => _compact({
    'type': 'submenu',
    'label': label,
    'icon': icon,
    'open': open ? true : null,
    'items': [for (final item in items) item.toMap()],
    'attrs': _attrs(attrs),
  });
}

final class BcSeparator extends BcNode {
  const BcSeparator();

  @override
  Map<String, Object?> toMap() => const {'type': 'separator'};
}

/// One tab and its panel. Both are raw HTML.
final class BcTab {
  const BcTab(this.tab, {this.panel, this.tabAttrs, this.panelAttrs});

  final String tab;
  final String? panel;
  final Attrs? tabAttrs;
  final Attrs? panelAttrs;

  Map<String, Object?> toMap() => _compact({
    'tab': tab,
    'panel': panel,
    'tab_attrs': _attrs(tabAttrs),
    'panel_attrs': _attrs(panelAttrs),
  });
}

/// A toast action or cancel button. With [href] it renders as a link.
final class BcToastAction {
  const BcToastAction(this.label, {this.onclick, this.href});

  /// Raw HTML.
  final String label;
  final String? onclick;
  final String? href;

  Map<String, Object?> toMap() => _compact({
    'label': label,
    'onclick': onclick == null ? null : esc(onclick),
    'href': href == null ? null : esc(href),
  });
}

enum BcToastCategory { success, error, info, warning }

/// A toast rendered inside [Basecoat.toaster] or on its own by
/// [Basecoat.toast].
final class BcToast {
  const BcToast({
    this.category = BcToastCategory.success,
    this.title = '',
    this.description = '',
    this.duration,
    this.icon,
    this.action,
    this.cancel,
    this.attrs,
  });

  final BcToastCategory category;

  /// Raw HTML.
  final String title;

  /// Raw HTML.
  final String description;

  /// Milliseconds; -1 keeps the toast open.
  final int? duration;
  final String? icon;
  final BcToastAction? action;
  final BcToastAction? cancel;
  final Attrs? attrs;

  Map<String, Object?> toMap() => _compact({
    'category': category.name,
    'title': title,
    'description': description,
    'duration': duration,
    'icon': icon,
    'action': action?.toMap(),
    'cancel': cancel?.toMap(),
    'attrs': _attrs(attrs),
  });
}

/// How select and combobox serialize their hidden input.
enum BcFormat { value, object }

/// Python-style attribute access the upstream templates rely on:
/// `map.items()`, `map.get(key, default)` and `', '.join(list)`.
Object? _pythonAttribute(String name, Object? object) {
  if (object is Map) {
    switch (name) {
      case 'items':
        return () => [
          for (final entry in object.entries) [entry.key, entry.value],
        ];
      case 'get':
        return (Object? key, [Object? fallback]) =>
            object.containsKey(key) ? object[key] : fallback;
      case 'keys':
        return () => object.keys.toList();
      case 'values':
        return () => object.values.toList();
    }
    return object[name];
  }
  if (object is String && name == 'join') {
    return (Iterable<Object?> values) => values.join(object);
  }
  // Namespace, LoopContext and friends expose `[]`; anything else throws
  // NoSuchMethodError, which jinja turns into an undefined (null) value.
  // ignore: avoid_dynamic_calls
  return (object as dynamic)[name];
}

String _attributeJson(Object? value) => esc(jsonEncode(value));

String _scriptJson(Object? value) =>
    jsonEncode(value)
        .replaceAll('<', '${_u}003c')
        .replaceAll('>', '${_u}003e')
        .replaceAll('&', '${_u}0026')
        .replaceAll("'", '${_u}0027');

/// The two characters that start a JSON unicode escape.
const _u =
    r'\'
    'u';

typedef _Macro = String Function(List<Object?>, Map<Symbol, Object?>);

/// Renders Basecoat's Jinja macros from Dart.
///
/// Create one instance at startup and reuse it; templates are parsed once.
final class Basecoat {
  /// [loader] must resolve `<prefix><file>.html.jinja` for every file in
  /// [files]. On a server that is usually
  /// `FileSystemLoader(paths: ['templates'])` from
  /// `package:jinja/loaders.dart`, with [autoReload] on in development to
  /// pick up template edits. Pass `filters`, `tests` and `globals` to extend
  /// the shared [env] for your own page templates.
  ///
  /// [macroFiles] are full template paths (`ui/badge.html.jinja`) of your
  /// own macro files. Their macros get the same treatment as Basecoat's:
  /// global in every template, callable through [call], and free of the
  /// engine's sibling-macro and argument-binding limits.
  Basecoat({
    required Loader loader,
    this.prefix = 'basecoat/',
    List<String> files = defaultFiles,
    List<String> macroFiles = const [],
    Map<String, Function>? filters,
    Map<String, Function>? tests,
    Map<String, Object?>? globals,
    bool autoReload = false,
  }) : env = Environment(
         loader: loader,
         autoReload: autoReload,
         getAttribute: _pythonAttribute,
         filters: {
           'safe': (Object? value) => value,
           'tojson': _attributeJson,
           'tojson_script': _scriptJson,
           ...?filters,
         },
         tests: tests,
         globals: globals,
       ) {
    final paths = [
      for (final file in files) '$prefix$file.html.jinja',
      ...macroFiles,
    ];
    final names = <String, List<String>>{};
    for (final path in paths) {
      final source = loader.getSource(path);
      names[path] = [
        for (final match in _macroHeader.allMatches(source))
          _declare(match.group(1)!, source, match.end),
      ];
    }
    // Two gaps in `package:jinja` are closed here so the upstream templates
    // run unmodified. An imported macro runs without its sibling macros in
    // scope (`select()` cannot find `render_select_items()`), and a
    // parameter is either positional-only (no default) or keyword-only
    // (has a default). Publishing every macro as a global that rebinds its
    // arguments fixes both; a template snapshots the globals when it is
    // parsed, so they are installed before anything is parsed.
    for (final name in _params.keys) {
      String forward(List<Object?> positional, Map<Symbol, Object?> named) =>
          _invoke(name, positional, named);
      env.globals[name] = forward;
    }
    for (final MapEntry(key: path, value: list) in names.entries) {
      env
          .fromString(
            '{% from "$path" import ${list.join(', ')} %}'
            '{{ __register({${list.map((n) => '"$n": $n').join(', ')}}) }}',
          )
          .render({
            '__register': (Map<Object?, Object?> macros) {
              for (final MapEntry(:key, :value) in macros.entries) {
                _macros[key! as String] = value! as _Macro;
              }
              return '';
            },
          });
    }
  }

  /// Loads templates from memory, keyed by path
  /// (`basecoat/select.html.jinja`). Use this with a generated sources map
  /// when the deployed binary cannot read a templates folder. Add your own
  /// page templates to the same map.
  factory Basecoat.embedded(
    Map<String, String> sources, {
    String prefix = 'basecoat/',
    List<String> files = defaultFiles,
    List<String> macroFiles = const [],
    Map<String, Function>? filters,
    Map<String, Function>? tests,
    Map<String, Object?>? globals,
  }) => Basecoat(
    loader: MapLoader(sources),
    prefix: prefix,
    files: files,
    macroFiles: macroFiles,
    filters: filters,
    tests: tests,
    globals: globals,
  );

  static const defaultFiles = [
    'combobox',
    'command',
    'dialog',
    'dropdown-menu',
    'popover',
    'select',
    'sidebar',
    'tabs',
    'toast',
  ];

  static final _macroHeader = RegExp(r'\{%-?\s*macro\s+(\w+)\s*\(');

  /// The shared environment. Every Basecoat macro is a global in it, so page
  /// templates can call `{{ select(...) }}` without importing anything.
  final Environment env;

  final String prefix;

  final Map<String, _Macro> _macros = {};

  /// Parameter names per macro, in order, with whether each has a default.
  final Map<String, List<(String, bool)>> _params = {};

  /// Reads the parameter list of macro [name] that opens at [start].
  String _declare(String name, String source, int start) {
    final params = <(String, bool)>[];
    final current = StringBuffer();
    var depth = 0;
    String? quote;
    void flush() {
      final text = current.toString().trim();
      current.clear();
      if (text.isEmpty) return;
      final equals = text.indexOf('=');
      params.add(
        equals < 0 ? (text, false) : (text.substring(0, equals).trim(), true),
      );
    }

    for (var i = start; i < source.length; i++) {
      final char = source[i];
      if (quote != null) {
        if (char == quote) quote = null;
      } else if (char == '"' || char == "'") {
        quote = char;
      } else if (char == '(' || char == '[' || char == '{') {
        depth++;
      } else if (char == ')' && depth == 0) {
        break;
      } else if (char == ')' || char == ']' || char == '}') {
        depth--;
      } else if (char == ',' && depth == 0) {
        flush();
        continue;
      }
      current.write(char);
    }
    flush();
    _params[name] = params;
    return name;
  }

  /// Calls macro [name], moving arguments between positional and named so
  /// they land where `package:jinja` expects them.
  String _invoke(
    String name,
    List<Object?> positional,
    Map<Symbol, Object?> named,
  ) {
    final params = _params[name]!;
    final args = <Object?>[];
    final kwargs = {...named};
    // Some call sites arrive pre-packed as `[positional, named]`.
    if (positional case [
      final List<Object?> list,
      final Map<Object?, Object?> map,
    ]) {
      positional = list;
      for (final MapEntry(:key, :value) in map.entries) {
        kwargs[Symbol(key! as String)] = value;
      }
    }
    for (var i = 0; i < params.length; i++) {
      final (param, hasDefault) = params[i];
      final symbol = Symbol(param);
      if (hasDefault) {
        if (i < positional.length) kwargs[symbol] = positional[i];
      } else {
        args.add(i < positional.length ? positional[i] : kwargs.remove(symbol));
      }
    }
    return _macros[name]!(args, kwargs);
  }

  /// Renders one of your own templates through the shared [env].
  String render(String path, [Map<String, Object?>? data]) =>
      env.getTemplate(path).render(data);

  /// Calls any registered macro by name. Null arguments are omitted so the
  /// macro's own defaults apply. [body] becomes the `{% call %}` content.
  String call(
    String macro, {
    List<Object?> positional = const [],
    Map<String, Object?> named = const {},
    String? body,
  }) {
    if (!_macros.containsKey(macro)) {
      throw ArgumentError.value(macro, 'macro', 'Unknown macro');
    }
    return _invoke(macro, positional, {
      for (final MapEntry(:key, :value) in named.entries)
        if (value != null) Symbol(key): value,
      if (body != null)
        #caller: (List<Object?> positional, Map<Symbol, Object?> named) => body,
    }).trim();
  }

  static List<Map<String, Object?>>? _nodes(List<BcNode>? items) =>
      items == null ? null : [for (final item in items) item.toMap()];

  static Object? _selected(Object? selected) => switch (selected) {
    null => null,
    Iterable<Object?>() => [for (final value in selected) _value(value)],
    _ => _value(selected),
  };

  /// Custom select. Give either [items] or [body] (raw option markup).
  /// [selected] is a value, or a list of values when [multiple].
  String select({
    String? id,
    String? name,
    Object? selected,
    List<BcNode>? items,
    String? body,
    bool multiple = false,
    String? placeholder,
    bool closeOnSelect = false,
    BcFormat format = BcFormat.value,
    Attrs? mainAttrs,
    Attrs? triggerAttrs,
    Attrs? popoverAttrs,
    Attrs? listboxAttrs,
    Attrs? inputAttrs,
  }) => call(
    'select',
    named: {
      'id': id == null ? null : esc(id),
      'name': name == null ? null : esc(name),
      'selected': _selected(selected),
      'items': _nodes(items),
      'multiple': multiple,
      'placeholder': placeholder == null ? null : esc(placeholder),
      'close_on_select': closeOnSelect,
      'format': format.name,
      'main_attrs': _attrs(mainAttrs),
      'trigger_attrs': _attrs(triggerAttrs),
      'popover_attrs': _attrs(popoverAttrs),
      'listbox_attrs': _attrs(listboxAttrs),
      'input_attrs': _attrs(inputAttrs),
    },
    body: body,
  );

  /// Filterable select. Options are always [body] markup:
  /// `<div role="option" data-value="...">`.
  String combobox({
    required String body,
    String? id,
    String? name,
    Object? selected,
    bool multiple = false,
    String? placeholder,
    bool closeOnSelect = false,
    bool clear = false,
    bool autoHighlight = false,
    BcFormat format = BcFormat.value,
    Attrs? mainAttrs,
    Attrs? inputAttrs,
    Attrs? popoverAttrs,
    Attrs? listboxAttrs,
    Attrs? hiddenInputAttrs,
  }) => call(
    'combobox',
    named: {
      'id': id == null ? null : esc(id),
      'name': name == null ? null : esc(name),
      'selected': _selected(selected),
      'multiple': multiple,
      'placeholder': placeholder == null ? null : esc(placeholder),
      'close_on_select': closeOnSelect,
      'clear': clear,
      'auto_highlight': autoHighlight,
      'format': format.name,
      'main_attrs': _attrs(mainAttrs),
      'input_attrs': _attrs(inputAttrs),
      'popover_attrs': _attrs(popoverAttrs),
      'listbox_attrs': _attrs(listboxAttrs),
      'hidden_input_attrs': _attrs(hiddenInputAttrs),
    },
    body: body,
  );

  /// Inline command menu. Give either [items] or [body].
  String command({
    String? id,
    List<BcNode>? items,
    String? body,
    String? placeholder,
    String? emptyText,
    Attrs? mainAttrs,
    Attrs? inputAttrs,
    Attrs? menuAttrs,
  }) => call(
    'command',
    named: {
      'id': id == null ? null : esc(id),
      'items': _nodes(items),
      'placeholder': placeholder == null ? null : esc(placeholder),
      'empty_text': emptyText == null ? null : esc(emptyText),
      'main_attrs': _attrs(mainAttrs),
      'input_attrs': _attrs(inputAttrs),
      'menu_attrs': _attrs(menuAttrs),
    },
    body: body,
  );

  /// Command palette in a native dialog. Open it with
  /// `document.getElementById(id).showModal()`.
  String commandDialog({
    String? id,
    List<BcNode>? items,
    String? body,
    String? placeholder,
    String? emptyText,
    bool open = false,
    Attrs? dialogAttrs,
    Attrs? inputAttrs,
    Attrs? menuAttrs,
  }) => call(
    'command_dialog',
    named: {
      'id': id == null ? null : esc(id),
      'items': _nodes(items),
      'placeholder': placeholder == null ? null : esc(placeholder),
      'empty_text': emptyText == null ? null : esc(emptyText),
      'open': open,
      'dialog_attrs': _attrs(dialogAttrs),
      'input_attrs': _attrs(inputAttrs),
      'menu_attrs': _attrs(menuAttrs),
    },
    body: body,
  );

  /// Modal dialog. [trigger], when given, renders a button that opens it;
  /// style that button through [triggerAttrs] (`{'class': 'btn'}`).
  String dialog({
    String? id,
    String? trigger,
    String? title,
    String? description,
    String? body,
    String? footer,
    bool open = false,
    bool closeButton = true,
    bool closeOnOverlayClick = true,
    Attrs? dialogAttrs,
    Attrs? triggerAttrs,
    Attrs? headerAttrs,
    Attrs? bodyAttrs,
    Attrs? footerAttrs,
  }) => call(
    'dialog',
    named: {
      'id': id == null ? null : esc(id),
      'trigger': trigger,
      'title': title,
      'description': description,
      'footer': footer,
      'open': open,
      'close_button': closeButton,
      'close_on_overlay_click': closeOnOverlayClick,
      'dialog_attrs': _attrs(dialogAttrs),
      'trigger_attrs': _attrs(triggerAttrs),
      'header_attrs': _attrs(headerAttrs),
      'body_attrs': _attrs(bodyAttrs),
      'footer_attrs': _attrs(footerAttrs),
    },
    body: body,
  );

  /// Dropdown menu. [trigger] is the content of the trigger button; give
  /// either [items] or [body] (`role="menuitem"` markup).
  String dropdownMenu({
    required String trigger,
    String? id,
    List<BcNode>? items,
    String? body,
    Attrs? mainAttrs,
    Attrs? triggerAttrs,
    Attrs? popoverAttrs,
    Attrs? menuAttrs,
  }) => call(
    'dropdown_menu',
    positional: [trigger],
    named: {
      'id': id == null ? null : esc(id),
      'items': _nodes(items),
      'main_attrs': _attrs(mainAttrs),
      'trigger_attrs': _attrs(triggerAttrs),
      'popover_attrs': _attrs(popoverAttrs),
      'menu_attrs': _attrs(menuAttrs),
    },
    body: body,
  );

  /// Popover with arbitrary [body] content.
  String popover({
    required String trigger,
    required String body,
    String? id,
    Attrs? mainAttrs,
    Attrs? triggerAttrs,
    Attrs? popoverAttrs,
  }) => call(
    'popover',
    positional: [trigger],
    named: {
      'id': id == null ? null : esc(id),
      'main_attrs': _attrs(mainAttrs),
      'trigger_attrs': _attrs(triggerAttrs),
      'popover_attrs': _attrs(popoverAttrs),
    },
    body: body,
  );

  /// App sidebar. Give either [menu] or [body].
  String sidebar({
    String? id,
    String? label,
    bool open = true,
    bool right = false,
    String? header,
    String? footer,
    List<BcNode>? menu,
    String? body,
    Attrs? mainAttrs,
    Attrs? headerAttrs,
    Attrs? contentAttrs,
    Attrs? footerAttrs,
  }) => call(
    'sidebar',
    named: {
      'id': id == null ? null : esc(id),
      'label': label == null ? null : esc(label),
      'open': open,
      'side': right ? 'right' : null,
      'header': header,
      'footer': footer,
      'menu': _nodes(menu),
      'main_attrs': _attrs(mainAttrs),
      'header_attrs': _attrs(headerAttrs),
      'content_attrs': _attrs(contentAttrs),
      'footer_attrs': _attrs(footerAttrs),
    },
    body: body,
  );

  /// Tabs. [defaultTabIndex] is one-based. Put `data-variant="line"` or
  /// `aria-orientation="vertical"` in [tablistAttrs].
  String tabs({
    required List<BcTab> tabsets,
    String? id,
    int defaultTabIndex = 1,
    Attrs? mainAttrs,
    Attrs? tablistAttrs,
  }) => call(
    'tabs',
    named: {
      'id': id == null ? null : esc(id),
      'tabsets': [for (final tab in tabsets) tab.toMap()],
      'default_tab_index': defaultTabIndex,
      'main_attrs': _attrs(mainAttrs),
      'tablist_attrs': _attrs(tablistAttrs),
    },
  );

  /// The toast container. Render it once per page, usually at the end of
  /// `<body>`. [toasts] are shown on load.
  String toaster({
    String? id,
    List<BcToast> toasts = const [],
    String? body,
    Attrs? attrs,
  }) => call(
    'toaster',
    named: {
      'id': id == null ? null : esc(id),
      'toasts': [for (final toast in toasts) toast.toMap()],
      'attrs': _attrs(attrs),
    },
    body: body,
  );

  /// A single toast, for example as an HTMX out-of-band swap into the
  /// toaster.
  String toast(BcToast toast) => call('toast', named: toast.toMap());
}
