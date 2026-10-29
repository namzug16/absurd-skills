# Lucide with htmleez

Read `htmleez-html` before editing markup. Follow the shared generator setup in [SKILL.md](../SKILL.md), selecting `--framework htmleez` only.

Generated API:

```dart
static HTML plus([List<HTML> extraContent = const []]);
```

The generator uses `svg([...defaults, ...extraContent, Raw(paths)])`. Only downloaded upstream SVG children are raw markup; never pass user-provided strings through `Raw`.

```dart
import 'package:htmleez/htmleez.dart';
import 'lucide.dart'; // Adjust to the application's generated file.

final addButton = button([
  $("type")("button"),
  Lucide.plus([$("class")("size-4"), $("aria-hidden")("true")]),
  'Add item'.t,
]);

final closeButton = button([
  $("type")("button"),
  $("aria-label")("Close"),
  Lucide.x([$("aria-hidden")("true")]),
]);

final statusIcon = Lucide.circleCheck([
  $("class")("size-5 text-green-600"),
  $("aria-hidden")("true"),
]);
```

`extraContent` can carry attributes or children such as a `<title>`. Attributes are appended after defaults. Before overriding width, height, or stroke attributes, check the installed renderer's duplicate-attribute behavior; use CSS sizing/color for ordinary icons instead of relying on duplicates.

Keep generator dependencies out of runtime UI code. Verify with `dart analyze`, the project's tests, and a rendered icon. No Lucide browser initialization is needed for these inline SVG helpers.
