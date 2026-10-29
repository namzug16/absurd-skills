# Basecoat with Absurd Templates

Read the `absurd-templates` and `basecoat` skills first. Read `abs.yaml` to find the HTML source directory, generated Dart output, and entry class. Edit templates, never generated Dart.

## Direct markup, not Jinja

Write Basecoat HTML directly in `.html` templates, following the relevant component reference for semantic children, `data-variant` / `data-size`, ARIA, and ids. This applies to large interactive components too: start from their documented HTML, not guessed structures.

Do not install `jinja`, copy `assets/basecoat.dart`, vendor Jinja macros, or add Jaspr/htmleez for this integration. Existing unrelated Jinja code can remain; do not migrate it as part of a component change.

For example, a reusable card template:

```html
<x-props title="String" body="Fragment" footer="Fragment?" hasFooter="bool"></x-props>
<div class="card">
  <header><h2>{{ title }}</h2></header>
  <section>{{ body }}</section>
  <x-if case="hasFooter">
    <footer>{{ footer }}</footer>
  </x-if>
</div>
```

Absurd conditions accept variables/getters, not expressions. Compute `hasFooter: footer != null` in Dart. Keep all formatting, comparisons, URLs, and derived ids in Dart, then pass the typed values to templates.

Use `<x-fragment>` with `<x-slot>` when templates compose fixed structures; use generated `Fragment` props when Dart selects the content. A `String` is escaped by `{{ value }}`; neither `bc.dialog(...)` nor any other macro HTML string can become raw markup that way. Do not invent raw-HTML constructors or edit generated fragment internals.

## Assets and behavior

- Reuse the existing Basecoat CSS/JS version and asset commands. Basecoat is a CSS/JS dependency here, not a Dart wrapper layer.
- Load CSS and required browser scripts once in the layout template. Preserve the app's shared initializer and Basecoat's documented handling of inserted markup.
- Give each interactive instance stable, unique ids and match its label, trigger, panel, and form relationships. Derive repeated ids in Dart.
- Keep dialog lifecycle code in shared browser JS. If the project uses temporary dialogs, reuse that convention instead of embedding scripts in fragments.
- Icons follow the project's existing Lucide integration; read `dart-lucide-icons` and its Absurd reference.
- Tailwind must scan HTML under the configured input directory and any Dart sources containing full class strings, excluding generated Dart; see `dart-tailwind`.

## Verification and deployment

Run `abs check` on changed templates, then `abs`, `dart analyze`, and the project's tests (or configured vendored equivalents). Check rendering and interaction after HTMX swaps when available. Do not use the Jinja smoke test as an Absurd test.

Generate Dart before compilation and build CSS before packaging. Ship browser assets through the existing deployment pipeline. Compiled Absurd templates need no runtime template loader, Jinja package, or template directory.
