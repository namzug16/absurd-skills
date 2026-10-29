---
name: dart-lucide-icons
description: Add and maintain Lucide icons in Dart web apps using Jaspr, htmleez, or absurd_templates (Absurd Templates / abs). Use whenever adding icons, generating SVG helpers, maintaining a pinned Lucide browser asset, or upgrading an icon set. Includes all-icon Dart generation for Jaspr/htmleez and template markup with browser initialization for Absurd; not Flutter icon widgets.
---

# Lucide icons for Dart

Use the **project's chosen Lucide release** and existing icon strategy. This skill does not prescribe a version or migrate working icon integrations. Record the exact release in the project's asset or generation command and preserve the upstream ISC license notice with redistributed code/assets.

## Choose the renderer first

Inspect `abs.yaml`, `pubspec.yaml`, UI sources, existing icon helpers, browser initialization, and build commands. Absurd generates self-contained Dart, so the absence of a runtime dependency in `pubspec.yaml` does not rule it out. In mixed projects, follow the renderer used by the markup being changed.

| Renderer | Read | Integration |
| --- | --- | --- |
| Jaspr | [references/jaspr.md](./references/jaspr.md) | Generated `Component` helpers |
| htmleez | [references/htmleez.md](./references/htmleez.md) | Generated `HTML` helpers |
| absurd_templates | [references/absurd-templates.md](./references/absurd-templates.md) | Template markup and pinned browser JS, or existing static SVG templates |

Read only the relevant reference and the renderer's specialized skill before editing markup. The generator below supports **only Jaspr and htmleez**; skip it for Absurd. Do not add another renderer just to render icons.

For generated Dart helpers, use one `Lucide` class, lowerCamelCase methods, 24×24 SVGs, `currentColor`, and a default stroke width of 2. At runtime these helpers render inline SVG without Lucide JavaScript, CDN requests, or generator dependencies. These guarantees do not describe the browser-JS integration.

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

## Dart helper setup (Jaspr / htmleez only)

1. After choosing the renderer above, inspect existing icon helpers and `bin/`. Reuse an existing compatible generator/API; do not overwrite hand-written UI code.
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

## Styling and accessibility

- SVG stroke inherits `currentColor`: use ordinary CSS `color` or utility classes.
- Icons are 24×24 by default; `size-4`/`size-5` examples assume Tailwind. With plain CSS, set `width` and `height` on a class instead.
- Decorative icons beside text get `aria-hidden="true"`.
- For an icon-only button, label the **button** with `aria-label` and hide the SVG from assistive technology.
- For a standalone meaningful icon, use `role="img"` plus `aria-label` on the SVG instead of `aria-hidden`.
- Keep Tailwind scanning the application Dart or HTML template sources where utility class strings appear; see `dart-tailwind`.

## Upgrades and failures

Change the pinned version and rerun the existing generation or asset-download command. Never patch generated SVG paths or vendored browser JS by hand. Review icon renames/removals and the diff before updating callers. For browser icons, verify both initial page rendering and newly swapped HTMX content.

An HTTP 404 usually means the requested tag or release asset is unavailable; check the exact upstream release rather than silently falling back to `latest`. Parsing or duplicate-name failures should be investigated at the archive/generator boundary, not papered over by skipping icons. The output is built completely before it is written, so download/parse failures leave the existing generated source untouched.
