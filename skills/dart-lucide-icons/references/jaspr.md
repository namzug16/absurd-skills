# Lucide with Jaspr

Read the applicable Jaspr skills before editing components. Follow the shared generator setup in [SKILL.md](../SKILL.md), selecting `--framework jaspr` only.

Generated API:

```dart
static Component plus({
  String? classes,
  Map<String, String> attributes = const {},
});
```

The generator emits `Component.element(tag: 'svg', ...)` and native shape elements. No `RawText`, server-only HTML injection, or runtime XML parser is needed; the helpers work as component trees rather than injected strings.

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'lucide.dart'; // Adjust to the application's generated file.

class AddButton extends StatelessComponent {
  const AddButton({super.key});

  @override
  Component build(BuildContext context) => button(
    attributes: {'type': 'button'},
    [
      Lucide.plus(classes: 'size-4', attributes: {'aria-hidden': 'true'}),
      Component.text('Add item'),
    ],
  );
}

final closeButton = button(
  attributes: {'type': 'button', 'aria-label': 'Close'},
  [Lucide.x(attributes: {'aria-hidden': 'true'})],
);

final statusIcon = Lucide.circleCheck(
  classes: 'text-green-600',
  attributes: {
    'width': '20',
    'height': '20',
    'stroke-width': '1.5',
    'aria-hidden': 'true',
  },
);
```

Custom attributes are spread after defaults in a single map, so overrides produce no duplicate SVG attributes. Use `classes` for CSS classes, not a competing `class` key in `attributes`.

These examples use the Jaspr 0.23-style API: `StatelessComponent.build` returns one `Component`, not `Iterable<Component>`/`sync*`. Check the installed version before adapting older code. Keep generator imports out of client-compiled UI. Verify with the project's analysis, tests, and Jaspr build for its configured mode.

- [Component system and Component.element](https://docs.jaspr.site/concepts/components)
- [HTML components and dom.dart](https://docs.jaspr.site/concepts/html)
