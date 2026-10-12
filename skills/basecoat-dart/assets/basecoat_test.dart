// Smoke test for the vendored Basecoat templates.
//
// Copy to `test/basecoat_test.dart` and fix the import. Run it after every
// `basecoat-css` upgrade: the templates are rendered by `package:jinja`,
// not by the Python engine they were written for, so a new upstream
// construct shows up here first.

import 'package:jinja/loaders.dart';
import 'package:test/test.dart';

import 'package:your_app/basecoat/basecoat.dart';

void main() {
  final bc = Basecoat(loader: FileSystemLoader(paths: ['templates']));

  test('select renders nested items and the selected value', () {
    final html = bc.select(
      id: 'fruit',
      name: 'fruit',
      selected: 'kiwi',
      items: const [
        BcGroup('Fruits', [
          BcItem('Apple', value: 'apple'),
          BcItem('Kiwi', value: 'kiwi'),
        ]),
        BcSeparator(),
        BcItem('Other', value: 'other'),
      ],
    );
    expect(html, contains('class="select '));
    expect(html, contains('id="fruit-items-1-2"'));
    expect(html, contains('aria-selected="true"'));
    expect(html, contains('name="fruit"'));
    expect(html, contains('value="kiwi"'));
  });

  test('attribute values are escaped, JSON payloads stay parseable', () {
    final html = bc.select(
      id: 'tags',
      multiple: true,
      selected: ['a"b'],
      items: const [
        BcItem('Quoted', value: 'a"b', attrs: {'data-note': '<"x">'}),
      ],
    );
    expect(html, contains('data-value="a&quot;b"'));
    expect(html, contains('data-note="&lt;&quot;x&quot;&gt;"'));
    expect(html, contains(r'value="[&quot;a\&quot;b&quot;]"'));
  });

  test('every macro renders', () {
    const option = '<div role="option" data-value="x">X</div>';
    const items = [BcItem('Edit', url: '/edit'), BcItem('Delete')];
    final rendered = {
      'combobox': bc.combobox(id: 'c', body: option),
      'command': bc.command(id: 'k', items: items),
      'command-dialog': bc.commandDialog(id: 'kd', items: items),
      'dialog': bc.dialog(id: 'd', title: 'Title', body: '<p>Body</p>'),
      'dropdown-menu': bc.dropdownMenu(trigger: 'Menu', id: 'm', items: items),
      'popover': bc.popover(trigger: 'Open', id: 'p', body: '<p>Body</p>'),
      'sidebar': bc.sidebar(
        id: 's',
        menu: const [
          BcGroup('Main', [
            BcItem('Home', url: '/', current: true),
            BcSubmenu('More', [BcItem('Docs', url: '/docs')]),
          ]),
        ],
      ),
      'tabs': bc.tabs(
        id: 't',
        tabsets: const [
          BcTab('One', panel: '<p>1</p>'),
          BcTab('Two', panel: '<p>2</p>'),
        ],
      ),
      'toaster': bc.toaster(toasts: const [BcToast(title: 'Saved')]),
      'toast': bc.toast(const BcToast(title: 'Saved')),
    };
    for (final MapEntry(:key, :value) in rendered.entries) {
      expect(value, isNotEmpty, reason: key);
      expect(value, isNot(contains('{{')), reason: key);
    }
    expect(rendered['dialog'], contains('<p>Body</p>'));
    expect(rendered['sidebar'], contains('aria-current="page"'));
    expect(rendered['toaster'], contains('class="toast '));
  });

  test('macros are callable from page templates', () {
    final page = bc.env.fromString(
      '{% from "basecoat/dialog.html.jinja" import dialog %}'
      '{{ select(id="s", items=[{"value": "a", "label": "A"}]) }}'
      '{% call dialog(id="d", title="Hi") %}<p>Body</p>{% endcall %}',
    );
    final html = page.render();
    expect(html, contains('data-value="a"'));
    expect(html, contains('<p>Body</p>'));
  });
}
