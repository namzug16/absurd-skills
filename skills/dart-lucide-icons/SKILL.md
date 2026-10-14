---
name: dart-lucide-icons
description: Generate app-owned Lucide SVG icon helpers for Dart applications using the project's chosen Lucide release and UI framework. Use this skill whenever adding or using Lucide icons in a Dart web app, creating a bin/generate_lucide.dart downloader, generating SVG components, or upgrading an existing Dart Lucide icon set. Covers all-icon generation for htmleez or Jaspr, generating only the selected framework; not Flutter icon widgets or JavaScript Lucide packages.
---

# Lucide icons for Dart

Use a small app-owned generator in `bin/` to download the **project's chosen Lucide release** and generate **every icon** as a Dart helper for **only the UI framework the application uses**. This skill does not prescribe a Lucide version. Record the chosen release in the project's generation command for reproducibility. Commit the generated source. At runtime, the application renders inline SVG: no Lucide JavaScript, CDN requests, icon font, or generator dependencies are needed.

Use one `Lucide` class, lowerCamelCase methods, 24×24 SVGs, `currentColor`, and a default stroke width of 2. The bundled generator supports htmleez or Jaspr from the same archive; these are alternative outputs, not components to generate together.

## Bundled generator

[scripts/generate_lucide.dart](./scripts/generate_lucide.dart) is a standalone, framework-selectable example generator, kept separate from these instructions. **Copy it to `bin/generate_lucide.dart` in the target application** and adapt it to the project's conventions, rather than requiring the skill to be installed on the production host. It is intentionally a single file for this small project maintenance task.

- Downloads `https://github.com/lucide-icons/lucide/releases/download/<version>/lucide-icons-<version>.zip`.
- Requires `--version` and `--framework`; there is no hardcoded release or default framework. `--help` works without either.
- Emits only the selected framework's import and helpers. Jaspr output contains no htmleez components, and vice versa; the other framework is not a required dependency.
- Generates all SVG icons, sorted by Dart method name, into `lib/src/ui/lucide.dart` by default.
- Does not unpack archive paths to disk. Parses SVG at generation time with `xml`.
- Rejects invalid SVG, empty releases, and duplicate Dart names before writing output.
- Converts `arrow-right` → `arrowRight` and `circle-check` → `circleCheck`. Prefixes numeric or reserved names with `icon`, e.g. `123` → `icon123`.
- Records the Lucide version in the generated header. Uses `// dart format off` to keep one method per icon.

## Setup workflow

1. Inspect `pubspec.yaml`, existing icon helpers, and `bin/` before changing anything. Reuse an existing compatible generator/API; do not overwrite hand-written UI code. Determine whether the application uses htmleez or Jaspr.
2. Copy the bundled generator into the application. Keep the framework-specific UI library the project already uses; do not add the other library or generate its components. If specializing the copied generator for one framework, remove the unused emitter and framework switch, keeping only the project's renderer.
3. Add generator-only dependencies as **dev dependencies**, even in a server application:

   ```bash
   dart pub add --dev args archive http path xml
   ```

   The generator uses `archive` 4.x and the typed `ArgResults.option/flag` API from `args` 2.5+. Resolve compatible versions for the project's SDK instead of importing transitive dependencies without declaring them.

4. Reuse the project's existing Lucide release unless an upgrade is requested. For a new setup without a chosen version, check upstream releases and select a suitable available release. Record that exact tag and the detected framework in the project's Makefile or documented generation command. Do not copy a historical version from an example or silently resolve `latest` on every run.
5. Run from the **application root**:

   ```bash
    # Set LUCIDE_VERSION to the exact release tag chosen for this project.
    # htmleez projects: run only this command.
    dart run bin/generate_lucide.dart --version "$LUCIDE_VERSION" --framework htmleez

    # Jaspr projects: run only this alternative command.
    dart run bin/generate_lucide.dart --version "$LUCIDE_VERSION" --framework jaspr
   ```

   Use `--output lib/ui/lucide.dart` to match the application's structure. The default output file is replaced on successful generation, so choose a generated-only destination. Do not generate both variants into the same file in an application using both frameworks.

6. Import the generated file where icons are needed. Keep `dart:io`, HTTP, archive, and XML imports in the generator, not in runtime UI code. Commit the generator, generated file, and dependency lockfile. Preserve the upstream Lucide ISC license notice with redistributed icon code/assets; obtain the notice from the pinned upstream release/repository rather than inventing its text.

There is no need for an icon allowlist, usage scanner, `build_runner`, a runtime registry, or a published Dart icon package.

## htmleez

Generated API:

```dart
static HTML plus([List<HTML> extraContent = const []]);
```

The generator uses `svg([...defaults, ...extraContent, Raw(paths)])`, matching the reference application. Only the downloaded upstream SVG children are inserted as raw markup. Do not insert user-provided strings through `Raw`.

```dart
import 'package:htmleez/htmleez.dart';
import 'lucide.dart'; // Adjust to the project's location.

final addButton = button([
  $("type")("button"),
  Lucide.plus([
    $("class")("size-4"),
    $("aria-hidden")("true"),
  ]),
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

`extraContent` can carry attributes or children, such as a `<title>`. Attributes are appended after defaults, as in the starter. If overriding default width, height, or stroke attributes, check the installed htmleez renderer's duplicate-attribute behavior; use CSS sizing/color for ordinary icons rather than relying on duplicate HTML attributes.

## Jaspr

Generated API:

```dart
static Component plus({
  String? classes,
  Map<String, String> attributes = const {},
});
```

The generator emits `Component.element(tag: 'svg', ...)` and native child elements (`path`, `circle`, etc.). This low-level API is useful for generated SVG tags and avoids depending on whether each SVG shape has a convenience constructor. No `RawText`, server-only HTML injection, or XML parser is needed at runtime.

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'lucide.dart'; // Adjust to the project's location.

class AddButton extends StatelessComponent {
  const AddButton({super.key});

  @override
  Component build(BuildContext context) => button(
    attributes: {'type': 'button'},
    [
      Lucide.plus(
        classes: 'size-4',
        attributes: {'aria-hidden': 'true'},
      ),
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

Custom attributes are spread after defaults in a single map, so overrides are explicit and produce no duplicate SVG attributes. Use `classes` for CSS classes, not a competing `class` key in `attributes`.

The examples follow current Jaspr documentation reviewed in October 2026: `StatelessComponent.build` returns one `Component`, not the older `Iterable<Component>`/`sync*` API. Check the installed Jaspr version before adapting an older application.

- [Component system and Component.element](https://docs.jaspr.site/concepts/components)
- [HTML components and dom.dart](https://docs.jaspr.site/concepts/html)

## Styling and accessibility

- SVG stroke inherits `currentColor`: use ordinary CSS `color` or utility classes.
- Icons are 24×24 by default; `size-4`/`size-5` examples assume Tailwind. With plain CSS, set `width` and `height` on a class instead.
- Decorative icons beside text get `aria-hidden="true"`.
- For an icon-only button, label the **button** with `aria-label` and hide the SVG from assistive technology.
- For a standalone meaningful icon, use `role="img"` plus `aria-label` on the SVG instead of `aria-hidden`.
- Keep Tailwind scanning application Dart source where utility class strings appear.

## Upgrades and failures

Change the pinned version and rerun the same framework's generation command. Never patch paths inside the generated file by hand; the next run replaces them. Review API renames/removals and the generated diff before updating callers.

An HTTP 404 usually means the requested tag or release asset is unavailable; check the exact upstream release rather than silently falling back to `latest`. Parsing or duplicate-name failures should be investigated at the archive/generator boundary, not papered over by skipping icons. The output is built completely before it is written, so download/parse failures leave the existing generated source untouched.
