# Tailwind with htmleez

Read `htmleez-html` before editing markup. Keep utilities directly on htmleez attributes, for example `$("class")("flex gap-4")`; no styling wrapper or Tailwind Dart dependency is needed.

For a root-level CSS entrypoint:

```css
@import "tailwindcss";
@source "./lib/**/*.dart";
```

Add `bin/` or other UI directories only when they contain class literals. Preserve complete utility names in Dart branches/maps rather than building strings such as `'bg-$color-600'`. Paths are relative to the input CSS.

Load the compiled stylesheet once in the shared document's `head`:

```dart
link([$("rel")("stylesheet"), $("href")("/index.css")])
```

Match the existing static asset URL; do not assume the application is hosted at the root. HTMX partials reuse the document stylesheet and should not return new links.

Use the shared CLI/build workflow from [SKILL.md](../SKILL.md). Serve CSS through the backend's existing static handler (Shelf, Relic, Dart Frog, or otherwise), without exposing source directories. Build CSS before packaging the static assets; compiling Dart does not rebuild it. Verify a real component utility, response status/content type, and rendered styling.
