# Tailwind with Jaspr

Read the applicable Jaspr skills before editing components or document configuration. Inspect the project's Jaspr mode, asset convention, and build scripts. Tailwind works independently of SSR and hydration in client, static, and server modes.

For a root-level CSS entrypoint, register application components:

```css
@import "tailwindcss";
@source "./lib/**/*.dart";
```

Add other directories only when they contain utility literals. Paths are relative to the input CSS. Keep complete class strings in component class attributes; client-side variants can switch between those strings without rebuilding CSS if all variants were included at build time.

- Generate CSS into an asset location served by the project's tooling and copied into deployed output; do not assume `public/` is correct. Reuse its existing `web/` or other asset convention.
- Load the stylesheet once through the HTML entrypoint or `Document` configuration for the selected mode, matching the deployed asset URL and base path.
- Run the shared CLI watcher alongside the Jaspr dev server and build CSS before the production asset build/copy. No Tailwind browser runtime or hydration-specific integration is required.
- Verify a class from a real component in the generated CSS, then check the configured Jaspr build and stylesheet URL.

For other DOM-based Dart client apps, the same source-scanning/static-asset pattern applies. Tailwind styles HTML elements, not Flutter widgets, even on Flutter Web.
