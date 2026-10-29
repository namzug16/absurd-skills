# Tailwind with Absurd Templates

Read `absurd-templates` and `abs.yaml` first. Use its `input` directory as the HTML source and exclude its generated Dart `output` from Tailwind scanning. Edit the source templates, never the generated file.

For the absurd-starter layout (`input: lib/src/ui/templates`, `output: lib/generated/html.dart`) and a root-level `input.css`:

```css
@import "tailwindcss" source(none);
@source "./lib/src/ui/templates/**/*.html";
@source "./lib/**/*.dart";
@source not "./lib/generated/**";
```

Adapt these paths to the actual config and CSS location; do not blindly copy them. With `source(none)`, explicitly register every source containing class literals, including other app template directories when present. Preserve existing Basecoat imports and themes. Scan non-generated Dart because callers may compute complete class strings there; do not depend on generated Dart to discover template utilities.

## Templates and computed classes

- Write full utility names directly in template `class` attributes, or compute complete alternatives in scanned Dart and pass them as props.
- Absurd permits variable/getter access, not expressions: compute conditional class strings in Dart rather than placing a ternary inside `{{ }}`. A plain `class` and conditional `class` attribute cannot coexist on one tag; use one combined value.
- Put the stylesheet link in the shared layout template, not each HTMX fragment. Match the served asset URL and deployment base path.

## Build and check

Use the shared CLI build/watch commands from [SKILL.md](../SKILL.md). Keep template generation and CSS generation as separate build steps: Tailwind reads HTML source directly, so it does not need `abs` to run first. Production packaging needs both fresh generated Dart before compilation and fresh CSS before asset copying.

After template changes, run `abs check`, then `abs` (or the project's vendored commands), and its analysis/tests. Rebuild CSS and confirm a utility appearing only in an HTML template exists in the output. Verify the layout loads that stylesheet and a swapped fragment is styled without extra asset tags. The Tailwind watcher does not regenerate Absurd templates or restart the server; preserve the project's existing development workflow.
